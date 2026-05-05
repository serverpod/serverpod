import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/native_assets_builder.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/migrations/cli_migration_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Runs code generation for the given affected file paths.
///
/// The function should update analyzer contexts and generate code as needed.
/// Returns a [GenerateResult] with success status and the set of files
/// written by code generation.
typedef GenerateAction =
    Future<GenerateResult> Function(
      Set<String> affectedPaths,
      GenerationRequirements requirements,
    );

/// Creates a new server process, starts it, connects VM service,
/// and returns it ready for use.
///
/// [dillPath] is the compiled kernel file to boot from. Pass `null`
/// when no Frontend Server is configured; the factory then starts the
/// server via `dart run` and the VM's own kernel service drives reloads.
typedef ServerProcessFactory = Future<ServerProcess> Function(String? dillPath);

/// The lifecycle state of a [WatchSession].
///
/// Used to suppress spurious crash detection during intentional server
/// restarts and to guard against reentrancy.
enum SessionState {
  /// Normal operation. Server exit in this state is treated as a crash.
  idle,

  /// The server is being restarted due to a hot reload failure.
  restarting,

  /// Migrations are being applied against the live database.
  applyingMigration,

  /// The session has been disposed. No further operations are expected.
  disposed,
}

/// Decides whether a source `.dart` file change may have altered the protocol
/// (endpoint or future call class). Used by [WatchSession] to skip generation
/// when the change is in a pure helper file.
typedef ProtocolChangeClassifier = Future<bool> Function(String path);

/// Default classifier. Reads the file and looks for endpoint / future-call
/// class declarations.
///
/// Conservative: missing files and I/O errors default to `true` so a deleted
/// endpoint file still triggers regen to drop stale generated code.
Future<bool> defaultProtocolChangeClassifier(String path) async {
  try {
    final file = File(path);
    if (!await file.exists()) return true;
    final contents = await file.readAsString();
    return _endpointOrFutureCallRegex.hasMatch(contents);
  } catch (_) {
    return true;
  }
}

/// Matches `extends X` where `X` is any `*Endpoint` class or `FutureCall`/
/// `FutureCall<...>`-shaped base. Covers user-defined bases like
/// `BaseEndpoint` so subclassing hierarchies still regen correctly.
final _endpointOrFutureCallRegex = RegExp(
  r'\bextends\s+(?:\w*Endpoint|FutureCall)\b',
);

/// Action invoked by [WatchSession.applyMigration].
///
/// Runs migrations against the live database without restarting the
/// pod. Returns the list of versions applied (empty if already up to
/// date). Throws on failure.
typedef ApplyMigrationsAction = Future<List<String>> Function();

/// Orchestrates the watch-mode reload cycle.
///
/// Handles file change events by determining whether code generation,
/// compilation (incremental or full restart), and hot reload or server
/// restart are needed.
///
/// Generated directory paths ([generatedDirPaths]) are used to split
/// incoming `.dart` file changes into source files (which trigger generation)
/// and generated files (which only need compilation). This ensures the
/// incremental compiler sees all `.dart` changes, including those produced
/// by code generation.
///
/// When [compiler] is `null`, the session runs code generation and triggers
/// VM service reloads via the VM's built-in kernel service rather than the
/// Frontend Server. Static file change handling is unaffected.
class WatchSession {
  final KernelCompiler? _compiler;
  final NativeAssetsBuilder? _nativeAssetsBuilder;
  final GenerateAction _generate;
  final ServerProcessFactory? _createServer;
  final Set<String> _generatedDirPaths;
  final ProtocolChangeClassifier _classifyProtocolChange;
  final ApplyMigrationsAction _applyMigrationsAction;

  final Completer<int> _done = Completer<int>();

  /// Dart file paths from prior compile cycles that were rejected.
  /// These must be re-invalidated on the next compile attempt since the FES
  /// rolled back to its last accepted state and no longer knows about them.
  final Set<String> _pendingPaths = {};

  ServerProcess _server;

  SessionState _state = SessionState.idle;

  /// Serializes restart and migration operations. Each operation chains onto
  /// the previous one via [_pending], so concurrent calls execute in order.
  /// Always use [_chain] to update.
  Future<void> _pending = Future.value();

  /// Queues [body] behind [_pending].
  Future<void> _chain(Future<void> Function() body) {
    final task = _pending.then((_) => body());
    _pending = task.catchError((_) {}); // ensure errors don't block queue..
    return task; // .. but raise to caller
  }

  final StreamController<void> _vmServiceUriChangesController =
      StreamController<void>.broadcast();

  WatchSession({
    KernelCompiler? compiler,
    NativeAssetsBuilder? nativeAssetsBuilder,
    required GenerateAction generate,
    ServerProcessFactory? createServer,
    required ServerProcess initialServer,
    required Set<String> generatedDirPaths,
    ProtocolChangeClassifier classifyProtocolChange =
        defaultProtocolChangeClassifier,
    required ApplyMigrationsAction applyMigrationsAction,
  }) : _compiler = compiler,
       _nativeAssetsBuilder = nativeAssetsBuilder,
       _generate = generate,
       _createServer = createServer,
       _server = initialServer,
       _generatedDirPaths = generatedDirPaths,
       _classifyProtocolChange = classifyProtocolChange,
       _applyMigrationsAction = applyMigrationsAction {
    assert(
      nativeAssetsBuilder == null || compiler != null,
      'nativeAssetsBuilder requires a compiler.',
    );
    _monitorExit(initialServer);
    _trackVmServiceUri(initialServer);
  }

  /// Completes when the server exits unexpectedly (crash).
  Future<int> get done => _done.future;

  /// Returns `true` if the server is currently running.
  bool get isRunning => !_done.isCompleted;

  /// The current HTTP VM service URI of the running server, or `null` if not
  /// yet available.
  String? get vmServiceUri => _server.vmServiceUri;

  /// Fires each time a new server process publishes its VM service URI. The
  /// URI itself is read via [vmServiceUri]; the stream just signals "changed".
  Stream<void> get vmServiceUriChanges => _vmServiceUriChangesController.stream;

  /// Processes a single (merged) file change event.
  Future<void> handleFileChange(FileChangeEvent event) async {
    final hasDartChanges =
        event.dartFiles.isNotEmpty ||
        event.modelFiles.isNotEmpty ||
        event.packageConfigChanged;

    // Static-only changes (HTML, JS, CSS, templates): no compilation needed.
    if (!hasDartChanges) {
      await _handleStaticChange();
      return;
    }

    // Split .dart files into source (triggers generation) and generated
    // (only needs compilation).
    final sourceDartFiles = <String>{};
    final generatedDartFiles = <String>{};
    for (final f in event.dartFiles) {
      if (_isGenerated(f)) {
        generatedDartFiles.add(f);
      } else {
        sourceDartFiles.add(f);
      }
    }

    log.info('\nFiles changed, reloading server...');
    if (sourceDartFiles.isNotEmpty) log.debug('  .dart: $sourceDartFiles');
    if (generatedDartFiles.isNotEmpty) {
      log.debug('  .dart (generated): $generatedDartFiles');
    }
    if (event.modelFiles.isNotEmpty) log.debug('  .spy: ${event.modelFiles}');
    if (event.packageConfigChanged) log.debug('  package_config.json changed');

    // Narrow source files to those that may affect the generated protocol.
    // Helper files and pure business logic that don't declare endpoints or
    // future calls can skip the regen step - compile alone picks up their
    // changes.
    final protocolSourceFiles = <String>{};
    for (final f in sourceDartFiles) {
      if (await _classifyProtocolChange(f)) protocolSourceFiles.add(f);
    }

    final needsGeneration =
        protocolSourceFiles.isNotEmpty || event.modelFiles.isNotEmpty;

    Set<String> genOutputFiles = const {};
    if (needsGeneration) {
      final affectedPaths = {
        ...protocolSourceFiles,
        ...event.modelFiles,
      };

      final genRequirements = GenerationRequirements(
        generateModels: event.modelFiles.isNotEmpty,
        generateProtocol:
            protocolSourceFiles.isNotEmpty || event.modelFiles.isNotEmpty,
      );

      final genResult = await _generate(affectedPaths, genRequirements);
      if (!genResult.success) {
        log.error('Code generation failed. Server not reloaded.');
        return;
      }
      genOutputFiles = genResult.generatedFiles;
    }

    // Without a compiler, drive a reload through the VM's own kernel
    // service instead of the FES pipeline.
    if (_compiler == null) {
      await _reloadOrRestart(null);
      return;
    }

    // Merge all .dart paths for the compiler: source files, generated files
    // from generation output, and generated files detected by the watcher.
    final allDartChanges = {
      ...sourceDartFiles,
      ...genOutputFiles,
      ...generatedDartFiles,
    };

    await _compileAndReload(
      dartFiles: allDartChanges,
      packageConfigChanged: event.packageConfigChanged,
    );
  }

  /// Returns `true` if [path] is inside a generated directory.
  bool _isGenerated(String path) =>
      _generatedDirPaths.any((prefix) => p.isWithin(prefix, path));

  /// Notifies the server of static file changes for browser refresh.
  Future<void> _handleStaticChange() async {
    if (_server.isVmServiceConnected) {
      log.debug('Static files changed, notifying server.');
      await _server.notifyStaticChange();
      log.info('Browser refresh triggered.');
    }
  }

  /// Compiles changed files and hot-reloads or restarts the server.
  Future<void> _compileAndReload({
    required Set<String> dartFiles,
    required bool packageConfigChanged,
    bool forceFullCompile = false,
  }) async {
    final compiler = _compiler!;

    // Compile changes. Merge any paths carried over from prior rejected
    // compiles so the FES re-invalidates them (reject rolls back its state).
    final changedPaths = {..._pendingPaths, ...dartFiles};

    // 1. Run native build hooks (if configured). The hook runner caches on
    //    input hashes, so this is cheap when nothing changed. A manifest
    //    content change requires a fresh FES because `--native-assets` is
    //    only read at startup; the apply step restarts in that case and
    //    reports back so we don't double-restart below.
    var compilerRestartedByHooks = false;
    final builder = _nativeAssetsBuilder;
    if (builder != null) {
      if (packageConfigChanged) builder.reset();
      switch (await builder.applyTo(compiler)) {
        case NativeAssetsApplyFailure(:final message):
          log.error('$message Server not reloaded.');
          if (changedPaths.isNotEmpty) _pendingPaths.addAll(changedPaths);
          return;
        case NativeAssetsApplySuccess(:final restarted):
          if (restarted) {
            compilerRestartedByHooks = true;
            _pendingPaths.clear();
          }
      }
    }

    // 2. Bring the FES into the right state for this cycle.
    CompileResult? result;
    if (forceFullCompile) {
      _pendingPaths.clear();
      if (!compilerRestartedByHooks) await compiler.reset();
      result = await compileWithProgress(
        'Compiling server',
        compiler,
        rejectOnFailure: true,
      );
    } else if (packageConfigChanged) {
      // FES reads package_config.json only at startup - must restart it.
      // After restart the FES is in initial state, so we do a full compile.
      _pendingPaths.clear();
      if (!compilerRestartedByHooks) await compiler.restart();
      result = await compileWithProgress(
        'Compiling server',
        compiler,
        rejectOnFailure: true,
      );
    } else if (changedPaths.isNotEmpty || compilerRestartedByHooks) {
      result = await compileWithProgress(
        'Compiling server',
        compiler,
        changedPaths: changedPaths,
        rejectOnFailure: true,
      );
    } else {
      // No changes to compile.
      return;
    }

    if (result == null) {
      // Compilation failed - remember which paths need re-invalidation.
      _pendingPaths.addAll(changedPaths);
      return;
    }

    _pendingPaths.clear();
    compiler.accept();

    await _reloadOrRestart(result);
  }

  /// Attempts hot reload; falls back to a server restart if reload fails.
  ///
  /// With a [KernelCompiler], the fallback resets the compiler and produces a
  /// fresh full dill to boot the new pod. Without one, the new pod is spawned
  /// via `dart run` and the VM's kernel service compiles on the next reload.
  Future<void> _reloadOrRestart(CompileResult? result) async {
    if (await _reload(result?.dillOutput)) return;

    // Fall back to restart. With a compiler, produce a full dill (incremental
    // dills only contain deltas, so they can't boot a new process). Without
    // one, restart via `dart run` and let the VM's kernel service take over.
    String? dillPath;
    final compiler = _compiler;
    if (compiler != null) {
      await compiler.reset();
      final fullResult = await compileWithProgress(
        'Compiling server',
        compiler,
        rejectOnFailure: true,
      );
      if (fullResult == null) return;
      compiler.accept();
      dillPath = fullResult.dillOutput!;
    }

    switch (_state) {
      case SessionState.idle:
        break; // proceed
      case SessionState.restarting:
      case SessionState.applyingMigration:
      case SessionState.disposed:
        return;
    }

    await _restartServer(dillPath);
  }

  /// Forces a hot reload.
  ///
  /// Forces a full recompile and hot reload (or restart).
  ///
  /// Useful when the user explicitly requests a reload via a button press.
  Future<void> forceReload() {
    if (_state == SessionState.disposed) {
      throw StateError('Session has been disposed.');
    }
    if (_compiler == null) {
      return _chain(() => _reload(null));
    }
    return _chain(
      () => _compileAndReload(
        dartFiles: const {},
        packageConfigChanged: false,
        forceFullCompile: true,
      ),
    );
  }

  /// Applies pending database migrations.
  ///
  /// Migrations are applied via the [ApplyMigrationsAction] supplied at
  /// construction time (typically a CLI-side runner that connects to
  /// the database directly), and the running pod is left in place -
  /// hot reload covers any model code changes.
  ///
  /// If another restart or migration is in progress, this call waits
  /// for it to finish before proceeding. Throws a [StateError] if the
  /// session has been disposed.
  Future<void> applyMigration() {
    if (_state == SessionState.disposed) {
      throw StateError('Session has been disposed.');
    }
    return _chain(() async {
      // The session may have been disposed while this call was queued.
      if (_state == SessionState.disposed) {
        throw StateError('Session has been disposed.');
      }
      _state = SessionState.applyingMigration;
      try {
        final applied = await _applyMigrationsAction();
        log.info(formatAppliedMigrations(applied));
      } finally {
        if (_state == SessionState.applyingMigration) {
          _state = SessionState.idle;
        }
      }
    });
  }

  /// Hot-reloads via `vmService.reloadSources`. With a non-null [dillPath],
  /// the VM loads the pre-compiled dill; with `null`, the VM's own kernel
  /// service compiles changed sources. Logs success or failure.
  ///
  /// Returns `true` on success, `false` if the VM service is not connected
  /// or the reload itself reports failure.
  Future<bool> _reload(String? dillPath) async {
    if (!_server.isVmServiceConnected) {
      log.warning('Cannot reload: VM service not connected.');
      return false;
    }
    final reloaded = await _server.reload(dillPath);
    if (reloaded) {
      log.info(serverReloaded);
    } else {
      log.warning('Hot reload failed.');
    }
    return reloaded;
  }

  Future<void> _restartServer(String? dillPath) async {
    _state = SessionState.restarting;
    try {
      await _server.stop();
      _server = await _createServer!(dillPath);
      _monitorExit(_server);
      _trackVmServiceUri(_server);
      log.info(serverRestarted);
    } finally {
      if (_state == SessionState.restarting) {
        _state = SessionState.idle;
      }
    }
  }

  /// Disposes the session: stops server and disposes compiler.
  Future<void> dispose() async {
    _state = SessionState.disposed;
    await _vmServiceUriChangesController.close();
    await _server.stop();
    await _compiler?.dispose();
  }

  void _monitorExit(ServerProcess server) {
    unawaited(
      server.exitCode.then((code) {
        if (_state == SessionState.idle && !_done.isCompleted) {
          _done.complete(code);
        }
      }),
    );
  }

  void _trackVmServiceUri(ServerProcess server) {
    unawaited(
      server.vmServiceReady.then((_) {
        if (_server == server && !_vmServiceUriChangesController.isClosed) {
          _vmServiceUriChangesController.add(null);
        }
      }),
    );
  }
}
