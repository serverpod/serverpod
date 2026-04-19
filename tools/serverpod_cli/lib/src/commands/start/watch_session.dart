import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
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
/// [extraArgs] are appended to the server args for this invocation only
/// (e.g. `--apply-migrations` for a one-shot migration).
typedef ServerProcessFactory =
    Future<ServerProcess> Function(
      String dillPath, {
      List<String> extraArgs,
    });

/// The lifecycle state of a [WatchSession].
///
/// Used to suppress spurious crash detection during intentional server
/// restarts and to guard against reentrancy.
enum SessionState {
  /// Normal operation. Server exit in this state is treated as a crash.
  idle,

  /// The server is being restarted due to a hot reload failure.
  restarting,

  /// The server is being restarted with `--apply-migrations`.
  applyingMigration,

  /// The session has been disposed. No further operations are expected.
  disposed,
}

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
/// When [compiler] is `null` (--no-fes mode), the session still runs code
/// generation and triggers VM service reloads for static file changes, but
/// leaves compilation and hot reload to the IDE.
class WatchSession {
  final KernelCompiler? _compiler;
  final GenerateAction _generate;
  final ServerProcessFactory? _createServer;
  final Set<String> _generatedDirPaths;

  final Completer<int> _done = Completer<int>();

  /// Dart file paths from prior compile cycles that were rejected.
  /// These must be re-invalidated on the next compile attempt since the FES
  /// rolled back to its last accepted state and no longer knows about them.
  final Set<String> _pendingPaths = {};

  ServerProcess _server;
  SessionState _state = SessionState.idle;

  /// Serializes restart and migration operations. Each operation chains onto
  /// the previous one via [_pending], so concurrent calls execute in order.
  Future<void> _pending = Future.value();

  WatchSession({
    KernelCompiler? compiler,
    required GenerateAction generate,
    ServerProcessFactory? createServer,
    required ServerProcess initialServer,
    required Set<String> generatedDirPaths,
  }) : _compiler = compiler,
       _generate = generate,
       _createServer = createServer,
       _server = initialServer,
       _generatedDirPaths = generatedDirPaths {
    assert(
      (compiler == null) == (createServer == null),
      'compiler and createServer must both be provided or both be null.',
    );
    _monitorExit(initialServer);
  }

  /// Completes when the server exits unexpectedly (crash).
  Future<int> get done => _done.future;

  /// Returns `true` if the server is currently running.
  bool get isRunning => !_done.isCompleted;

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

    // Only source files and model files trigger generation. Generated files
    // from the watcher are just forwarded to the compiler.
    final needsGeneration =
        sourceDartFiles.isNotEmpty || event.modelFiles.isNotEmpty;

    Set<String> genOutputFiles = const {};
    if (needsGeneration) {
      final affectedPaths = {
        ...sourceDartFiles,
        ...event.modelFiles,
      };

      final genRequirements = GenerationRequirements(
        generateModels: event.modelFiles.isNotEmpty,
        generateProtocol:
            sourceDartFiles.isNotEmpty || event.modelFiles.isNotEmpty,
      );

      final genResult = await _generate(affectedPaths, genRequirements);
      if (!genResult.success) {
        log.error('Code generation failed. Server not reloaded.');
        return;
      }
      genOutputFiles = genResult.generatedFiles;
    }

    // Without a compiler (--no-fes), the IDE handles compilation and reload.
    if (_compiler == null) return;

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

    CompileResult? result;
    if (forceFullCompile) {
      _pendingPaths.clear();
      await compiler.reset();
      result = await compileWithProgress(
        'Compiling server',
        compiler,
        rejectOnFailure: true,
      );
    } else if (packageConfigChanged) {
      // FES reads package_config.json only at startup - must restart it.
      // After restart the FES is in initial state, so we do a full compile.
      _pendingPaths.clear();
      await compiler.restart();
      result = await compileWithProgress(
        'Compiling server',
        compiler,
        rejectOnFailure: true,
      );
    } else if (changedPaths.isNotEmpty) {
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

  /// Attempts hot reload; falls back to full server restart if reload fails.
  Future<void> _reloadOrRestart(CompileResult result) async {
    if (_server.isVmServiceConnected) {
      final reloaded = await _server.reload(result.dillOutput!);
      if (reloaded) {
        log.info(serverReloaded);
        return;
      }
      log.warning('Hot reload failed, falling back to restart.');
    }

    // Fall back to restart: need a full dill to boot a new process.
    // The incremental dill only contains deltas. Reset the compiler
    // so the next compile produces a complete kernel.
    final compiler = _compiler!;
    await compiler.reset();
    final fullResult = await compileWithProgress(
      'Compiling server',
      compiler,
      rejectOnFailure: true,
    );
    if (fullResult == null) {
      return;
    }
    compiler.accept();

    switch (_state) {
      case SessionState.idle:
        break; // proceed
      case SessionState.restarting:
      case SessionState.applyingMigration:
      case SessionState.disposed:
        return;
    }

    await _restartServer(fullResult.dillOutput!);
  }

  /// Forces a full recompile and hot reload (or restart).
  ///
  /// Useful when the user explicitly requests a reload via a button press.
  Future<void> forceReload() {
    if (_state == SessionState.disposed) {
      throw StateError('Session has been disposed.');
    }
    final compiler = _compiler;
    if (compiler == null) {
      throw StateError('Cannot force reload in --no-fes mode.');
    }
    _pending = _pending.then(
      (_) => _compileAndReload(
        dartFiles: const {},
        packageConfigChanged: false,
        forceFullCompile: true,
      ),
    );
    return _pending;
  }

  /// Restarts the server with `--apply-migrations` (one-shot).
  ///
  /// If another restart or migration is in progress, this call waits for it
  /// to finish before proceeding. Throws a [StateError] if the session has
  /// been disposed or the compiler is not available (--no-fes mode). Throws
  /// on compilation failure so the caller (MCP server) can report the error.
  Future<void> applyMigration() {
    if (_state == SessionState.disposed) {
      throw StateError('Session has been disposed.');
    }

    final createServer = _createServer;
    final compiler = _compiler;
    if (compiler == null || createServer == null) {
      throw StateError(
        'Cannot apply migrations in --no-fes mode. '
        'Restart the server manually with --apply-migrations.',
      );
    }

    _pending = _pending.then((_) => _applyMigration(compiler, createServer));
    return _pending;
  }

  Future<void> _applyMigration(
    KernelCompiler compiler,
    ServerProcessFactory createServer,
  ) async {
    if (_state == SessionState.disposed) {
      throw StateError('Session has been disposed.');
    }

    _state = SessionState.applyingMigration;
    try {
      // Full compile so we have a complete kernel for the new process.
      await compiler.reset();
      final result = await compileWithProgress(
        'Compiling server',
        compiler,
        rejectOnFailure: true,
      );
      if (result == null) {
        throw StateError('Compilation failed. Migration not applied.');
      }
      compiler.accept();

      await _server.stop();
      _server = await createServer(
        result.dillOutput!,
        extraArgs: ['--apply-migrations'],
      );
      _monitorExit(_server);
      log.info('Server restarted with --apply-migrations.');
    } finally {
      _state = SessionState.idle;
    }
  }

  Future<void> _restartServer(String dillPath) async {
    _state = SessionState.restarting;
    try {
      await _server.stop();
      _server = await _createServer!(dillPath);
      _monitorExit(_server);
      log.info(serverRestarted);
    } finally {
      _state = SessionState.idle;
    }
  }

  /// Disposes the session: stops server and disposes compiler.
  Future<void> dispose() async {
    _state = SessionState.disposed;
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
}
