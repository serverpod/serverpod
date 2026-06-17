import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/flutter_app_manager.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/native_assets_builder.dart';
import 'package:serverpod_cli/src/commands/start/package_dependency_tracker.dart';
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
/// [dillPath] is the compiled kernel file to boot from. Pass `null`
/// when no Frontend Server is configured; the factory then starts the
/// server via `dart run` and the VM's own kernel service drives reloads.
typedef ServerProcessFactory = Future<ServerProcess> Function(String? dillPath);

/// Runs a full code generation across the whole project (not just the changed
/// paths), returning the result.
///
/// Used to recover from a degraded start via [WatchSession.retryStart], where
/// there is no incremental change event to drive generation.
typedef FullGenerateAction = Future<GenerateResult> Function();

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
typedef ApplyMigrationsAction = Future<void> Function();

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
///
/// When [initialServer] is `null`, the session starts in a *degraded* state:
/// the project failed to generate or compile at launch, so no server is
/// running yet. The session keeps watching; the first file change that makes
/// generation and compilation succeed boots the server (in watch mode), and
/// [retryStart] does the same on demand (used by `--no-watch`, which has no
/// file watcher to recover automatically).
class WatchSession {
  final KernelCompiler? _compiler;
  final NativeAssetsApplier? _nativeAssetsBuilder;
  final GenerateAction _generate;
  final FullGenerateAction? _fullGenerate;
  final ServerProcessFactory? _createServer;
  final Set<String> _generatedDirPaths;
  final ProtocolChangeClassifier _classifyProtocolChange;
  final ApplyMigrationsAction _applyMigrationsAction;

  /// Tracks the server package's own dependency closure so a shared-resolution
  /// (workspace) `package_config.json` change only drives a server reload when
  /// the server's closure actually changed. `null` disables the gate (no
  /// compiler / unresolved resolution), preserving the always-reload behavior.
  final PackageDependencyTracker? _serverDependencyTracker;

  final FlutterAppManager? _flutterManager;

  /// Whether a Flutter app process is currently running. Used e.g. to label
  /// the Ctrl+R action as a start or a restart.
  bool get isFlutterAppRunning =>
      _flutterManager?.runningAppIds.isNotEmpty ?? false;

  final Completer<int> _done = Completer<int>();

  /// Dart file paths from prior compile cycles that were rejected.
  /// These must be re-invalidated on the next compile attempt since the FES
  /// rolled back to its last accepted state and no longer knows about them.
  final Set<String> _pendingPaths = {};

  /// Whether a prior `package_config.json` change still needs to be invalidated
  /// because the compile that carried it failed (and was rolled back). Without
  /// this, a dependency change that races a transient compile error would be
  /// dropped, and the new package would stay unresolved until the next
  /// `package_config.json` write.
  bool _pendingPackageConfig = false;

  /// The running server, or `null` while the session is degraded (no server
  /// has booted yet because the project failed to build at launch).
  ServerProcess? _server;

  SessionState _state = SessionState.idle;

  /// Serializes restart and migration operations. Each operation chains onto
  /// the previous one via [_pending], so concurrent calls execute in order.
  /// Always use [_chain] to update.
  Future<void> _pending = Future.value();

  /// Queues [body] behind [_pending].
  Future<T> _chain<T>(Future<T> Function() body) {
    final task = _pending.then((_) => body());
    _pending = task.then((_) {}, onError: (_) {}); // errors don't block queue
    return task; // .. but raise to caller
  }

  /// Queues [body] via [_chain], guarding the disposed state on both edges:
  /// throws a [StateError] synchronously if the session is already disposed
  /// when called, and - because the session may be disposed while the call
  /// sits queued - returns [whenDisposed] without running [body] if disposal
  /// happens before it reaches the front of the queue.
  Future<T> _chainGuarded<T>(
    Future<T> Function() body, {
    required T Function() whenDisposed,
  }) {
    if (_state == SessionState.disposed) {
      throw StateError('Session has been disposed.');
    }
    return _chain(() async {
      if (_state == SessionState.disposed) return whenDisposed();
      return body();
    });
  }

  final StreamController<void> _vmServiceUriChangesController =
      StreamController<void>.broadcast();

  WatchSession({
    KernelCompiler? compiler,
    NativeAssetsApplier? nativeAssetsBuilder,
    required GenerateAction generate,
    FullGenerateAction? fullGenerate,
    ServerProcessFactory? createServer,
    ServerProcess? initialServer,
    required Set<String> generatedDirPaths,
    ProtocolChangeClassifier classifyProtocolChange =
        defaultProtocolChangeClassifier,
    required ApplyMigrationsAction applyMigrationsAction,
    PackageDependencyTracker? serverDependencyTracker,
    FlutterAppManager? flutterManager,
  }) : _compiler = compiler,
       _nativeAssetsBuilder = nativeAssetsBuilder,
       _generate = generate,
       _fullGenerate = fullGenerate,
       _createServer = createServer,
       _server = initialServer,
       _generatedDirPaths = generatedDirPaths,
       _classifyProtocolChange = classifyProtocolChange,
       _applyMigrationsAction = applyMigrationsAction,
       _serverDependencyTracker = serverDependencyTracker,
       _flutterManager = flutterManager {
    assert(
      nativeAssetsBuilder == null || compiler != null,
      'nativeAssetsBuilder requires a compiler.',
    );
    assert(
      initialServer != null || createServer != null,
      'A degraded session (null initialServer) needs a createServer to boot.',
    );
    if (initialServer != null) {
      _monitorExit(initialServer);
      _trackVmServiceUri(initialServer);
    }
  }

  /// Completes when the server exits unexpectedly (crash).
  Future<int> get done => _done.future;

  /// Returns `true` if a server process is currently running. `false` while the
  /// session is degraded (no server booted yet) or after it has shut down.
  bool get isRunning => _server != null && !_done.isCompleted;

  /// The current HTTP VM service URI of the running server, or `null` if not
  /// yet available (including while degraded).
  String? get vmServiceUri => _server?.vmServiceUri;

  /// Fires each time a new server process publishes its VM service URI. The
  /// URI itself is read via [vmServiceUri]; the stream just signals "changed".
  Stream<void> get vmServiceUriChanges => _vmServiceUriChangesController.stream;

  /// Processes a single (merged) file change event.
  Future<void> handleFileChange(FileChangeEvent event) =>
      _chain(() => _handleFileChange(event));

  Future<void> _handleFileChange(FileChangeEvent event) async {
    // Scope a package_config.json change to the SERVER's own dependency closure.
    // In a pub workspace the resolution is shared, so a Flutter-only (or
    // dev/test-only) dependency change rewrites package_config.json without
    // touching the server's closure - and must not reload the server. Always
    // call refreshClosure() when the file changed so the tracker's baseline
    // advances even when we suppress; only a `none` result downgrades, and a
    // pending invalidation from a prior failed compile still rides along
    // independently (see _pendingPackageConfig in _compileAndReload).
    var serverDepsChanged = event.packageConfigChanged;
    if (event.packageConfigChanged &&
        _serverDependencyTracker?.refreshClosure() ==
            PackageDependencyChange.none) {
      serverDepsChanged = false;
    }

    final hasDartChanges =
        event.dartFiles.isNotEmpty ||
        event.modelFiles.isNotEmpty ||
        serverDepsChanged;

    // Static-only changes (HTML, JS, CSS, templates) and dependency-only
    // changes: no compilation needed. The browser refresh is tied to static
    // files specifically - a dependency-only change doesn't affect
    // server-rendered pages.
    if (!hasDartChanges) {
      if (event.flutterDependenciesChanged || event.flutterPubspecChanged) {
        await _reloadOrRestartFlutterApps(changedPaths: const []);
      }
      if (event.staticFilesChanged) await _notifyBrowserRefresh();
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

    log.info('Files changed');
    if (sourceDartFiles.isNotEmpty) log.debug('  .dart: $sourceDartFiles');
    if (generatedDartFiles.isNotEmpty) {
      log.debug('  .dart (generated): $generatedDartFiles');
    }
    if (event.modelFiles.isNotEmpty) log.debug('  .spy: ${event.modelFiles}');
    if (serverDepsChanged) log.debug('  package_config.json changed');

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

    // Degraded start: no server is running yet because the project failed to
    // build at launch. Generation just succeeded (or was unnecessary), so try
    // a full compile and boot the server from scratch. A still-failing compile
    // leaves the session degraded for the next change to retry.
    if (_server == null) {
      if (await _fullCompileAndRestart()) {
        await _restartAllFlutterApps();
        await _notifyBrowserRefresh();
      }
      return;
    }

    // Without a compiler, drive a reload through the VM's own kernel
    // service instead of the FES pipeline.
    if (_compiler == null) {
      final reloaded = await _reloadOrRestart(null);
      await _reloadOrRestartFlutterApps(
        changedPaths: {...sourceDartFiles, ...generatedDartFiles},
      );
      if (reloaded) await _notifyBrowserRefresh();
      return;
    }

    // Merge all .dart paths for the compiler: source files, generated files
    // from generation output, and generated files detected by the watcher.
    final allDartChanges = {
      ...sourceDartFiles,
      ...genOutputFiles,
      ...generatedDartFiles,
    };

    final reloaded = await _compileAndReload(
      dartFiles: allDartChanges,
      packageConfigChanged: serverDepsChanged,
    );
    // Always refresh Flutter: flutter/lib-only changes short-circuit the server
    // compile but still need a Flutter refresh (escalated when dependencies
    // changed, otherwise a hot reload).
    await _reloadOrRestartFlutterApps(changedPaths: allDartChanges);
    if (reloaded) await _notifyBrowserRefresh();
  }

  /// Refreshes affected running Flutter apps after a file change.
  Future<void> _reloadOrRestartFlutterApps({
    required Iterable<String> changedPaths,
  }) async {
    final manager = _flutterManager;
    if (manager == null) return;

    final appIds = manager.appIdsForChangedPaths(changedPaths);
    await appIds.map((appId) async {
      final change = manager.checkDependencyChange(appId);
      if (changedPaths.isEmpty && change == PackageDependencyChange.none) {
        return;
      }
      await _reloadOrRestartFlutterApp(change, appId: appId);
    }).wait;
  }

  /// Refreshes a Flutter app after a file change with the lightest step that
  /// picks the change up: a hot reload by default, a hot restart when
  /// pure-Dart dependencies changed, or a full process relaunch when native
  /// code changed. The relaunch calls the action directly rather than via
  /// [restartFlutterApp] since we are already running inside [_chain].
  Future<void> _reloadOrRestartFlutterApp(
    PackageDependencyChange change, {
    required String appId,
  }) async {
    switch (change) {
      case PackageDependencyChange.assets:
        log.info(flutterAssetsFontsChanged);
        await _flutterManager?.restart(appId);
      case PackageDependencyChange.native:
        log.info(flutterDependenciesChangedNative);
        await _flutterManager!.restart(appId);
      case PackageDependencyChange.dartOnly:
        log.info(flutterDependenciesChangedDart);
        await _restartFlutter(appId);
      case PackageDependencyChange.none:
        await _reloadFlutter(appId);
    }
  }

  /// Returns `true` if [path] is inside a generated directory.
  bool _isGenerated(String path) =>
      _generatedDirPaths.any((prefix) => p.isWithin(prefix, path));

  /// Triggers a refresh of any connected browsers by bumping the server's
  /// static change counter, which the dev auto-refresh script polls. Called
  /// both for static file changes and after the server reloads new Dart code,
  /// so server-rendered web pages stay in sync.
  Future<void> _notifyBrowserRefresh() async {
    final server = _server;
    if (server == null || !server.isVmServiceConnected) {
      log.debug('Server VM service not connected; skipping browser refresh.');
      return;
    }
    try {
      await server.notifyStaticChange();
      log.info(browserRefreshTriggered);
    } catch (e) {
      log.warning('Browser refresh failed: $e');
    }
  }

  /// Compiles changed files and hot-reloads or restarts the server.
  ///
  /// Returns `true` if the server is now running the new code, `false` if
  /// generation, native build hooks, or compilation failed (or there was
  /// nothing to compile).
  Future<bool> _compileAndReload({
    required Set<String> dartFiles,
    required bool packageConfigChanged,
    bool forceFullCompile = false,
  }) async {
    final compiler = _compiler!;

    // Compile changes. Merge any paths carried over from prior rejected
    // compiles so the FES re-invalidates them (reject rolls back its state).
    final changedPaths = {..._pendingPaths, ...dartFiles};
    // Likewise carry a package_config change forward if a prior compile that
    // should have invalidated it failed.
    final invalidatePackageConfig =
        packageConfigChanged || _pendingPackageConfig;

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
          if (invalidatePackageConfig) _pendingPackageConfig = true;
          return false;
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
    } else if (changedPaths.isNotEmpty ||
        invalidatePackageConfig ||
        compilerRestartedByHooks) {
      // A package_config.json change is picked up incrementally: passing its
      // URI in the invalidated set makes the Frontend Server reload the
      // package map in place, so no process restart is needed. (When the
      // hooks already restarted the FES it's in initial state, so the next
      // compile is full and reads package_config.json fresh anyway.)
      result = await compileWithProgress(
        'Compiling server',
        compiler,
        changedPaths: changedPaths,
        invalidatePackageConfig: invalidatePackageConfig,
        rejectOnFailure: true,
      );
    } else {
      // No changes to compile.
      return false;
    }

    if (result == null) {
      // Compilation failed - remember what needs re-invalidation next time.
      _pendingPaths.addAll(changedPaths);
      if (invalidatePackageConfig) _pendingPackageConfig = true;
      return false;
    }

    _pendingPaths.clear();
    _pendingPackageConfig = false;
    await compiler.accept();

    if (compilerRestartedByHooks) {
      // The FES restart inside applyTo put it back in initial state, so the
      // compile above was a FULL one (see the `|| compilerRestartedByHooks`
      // branch) and result.dillOutput is a bootable full kernel here - unlike a
      // normal accepted increment. The running isolate linked the OLD native
      // assets at startup, and a hot reload never re-resolves them, so the pod
      // must be process-restarted to pick up the rebuilt dylibs. Mirrors the
      // Flutter `native` -> relaunch escalation.
      if (_state == SessionState.disposed) return false;
      log.info(serverNativeAssetsChanged);
      await _restartServer(result.dillOutput!);
      return true;
    }

    return _reloadOrRestart(result);
  }

  /// Attempts hot reload; falls back to a server restart if reload fails.
  ///
  /// Returns `true` if the server is now running the new code (via a
  /// successful hot reload or restart), `false` otherwise.
  Future<bool> _reloadOrRestart(CompileResult? result) async {
    if (await _reload(result?.dillOutput)) return true;
    return _fullCompileAndRestart();
  }

  /// Resets the compiler, produces a fresh full dill, and restarts the server.
  ///
  /// The full compile is required because the FES `outputDill` after accepted
  /// increments is not generally bootable.
  ///
  /// Returns `true` if the server was restarted, `false` if compile failed or
  /// the session was disposed before restart.
  Future<bool> _fullCompileAndRestart() async {
    String? dillPath;
    final compiler = _compiler;
    if (compiler != null) {
      _pendingPaths.clear();
      _pendingPackageConfig = false;
      await compiler.reset();
      final fullResult = await compileWithProgress(
        'Compiling server',
        compiler,
        rejectOnFailure: true,
      );
      if (fullResult == null) return false;
      await compiler.accept();
      dillPath = fullResult.dillOutput!;
    }

    // dispose() isn't queued onto [_chain], so it can race the compile above.
    if (_state == SessionState.disposed) return false;

    await _restartServer(dillPath);
    return true;
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
    return _chain(() async {
      final bool reloaded;
      if (_compiler == null) {
        // forceReload doesn't fall through to restart; the file-change
        // path does (via _reloadOrRestart). Different intents.
        reloaded = await _reload(null);
      } else {
        reloaded = await _compileAndReload(
          dartFiles: const {},
          packageConfigChanged: false,
          forceFullCompile: true,
        );
      }
      await _reloadAllFlutterApps();
      if (reloaded) await _notifyBrowserRefresh();
    });
  }

  /// Forces a full server process restart (clears singletons, pools, and
  /// caches that survive a hot reload). More expensive than [forceReload];
  /// recompiles from scratch. Hot-restarts the Flutter app afterwards so it
  /// reconnects to the fresh server. To fully relaunch the Flutter process
  /// (e.g. to pick up new dependencies), use [restartFlutterApp].
  Future<void> forceRestart() {
    if (_state == SessionState.disposed) {
      throw StateError('Session has been disposed.');
    }
    if (_createServer == null) {
      throw StateError('Restart is not supported in this session.');
    }
    return _chain(() async {
      if (await _fullCompileAndRestart()) {
        await _restartAllFlutterApps();
        await _notifyBrowserRefresh();
      }
    });
  }

  /// Launches [appId] when not already running. Returns `true` when the app
  /// was already running (no launch attempted), `false` when a launch was
  /// attempted. Serialized behind any in-flight reload, restart, or migration
  /// via [_chainGuarded] (which also reports `true` if the session is disposed
  /// while queued). Throws a [StateError] if the session has been disposed.
  Future<bool> spawnFlutterApp(String appId) {
    return _chainGuarded(() async {
      final manager = _flutterManager;
      if (manager == null) return false;

      final alreadyRunning = manager.isRunning(appId);
      if (!alreadyRunning) await manager.launch(appId);
      return alreadyRunning;
    }, whenDisposed: () => true);
  }

  /// Relaunches [appId]: stops and restarts when running, launches when
  /// stopped. Serialized via [_chainGuarded]. Throws a [StateError] if the
  /// session has been disposed.
  Future<void> relaunchFlutterApp(String appId) {
    return _chainGuarded(() async {
      final manager = _flutterManager;
      if (manager == null) return;

      if (manager.isRunning(appId)) {
        await manager.restart(appId);
      } else {
        await manager.launch(appId);
      }
    }, whenDisposed: () {});
  }

  /// Stops [appId] without relaunching. No-op when [appId] is unknown or not
  /// running. Serialized via [_chainGuarded]. Throws a [StateError] if the
  /// session has been disposed.
  Future<void> stopFlutterApp(String appId) {
    return _chainGuarded(() async {
      final manager = _flutterManager;
      if (manager == null) return;
      if (!manager.isRunning(appId)) return;
      await manager.stop(appId);
    }, whenDisposed: () {});
  }

  /// Recovers from a degraded start: re-runs a full code generation and, on
  /// success, compiles and boots the server.
  ///
  /// This is the manual counterpart to the automatic recovery that the file
  /// watcher drives in watch mode — it is the recovery path for `--no-watch`,
  /// where no watcher exists. A no-op if a server is already running (use
  /// [forceRestart] then). Throws a [StateError] if the session has been
  /// disposed.
  Future<void> retryStart() {
    if (_state == SessionState.disposed) {
      throw StateError('Session has been disposed.');
    }
    if (_createServer == null) {
      throw StateError('Restart is not supported in this session.');
    }
    return _chain(() async {
      // The session may have been disposed while this call was queued, or a
      // concurrent change may have already booted the server.
      if (_state == SessionState.disposed || _server != null) return;

      final fullGenerate = _fullGenerate;
      if (fullGenerate != null) {
        final genResult = await fullGenerate();
        if (!genResult.success) {
          log.error('Code generation failed. Server not started.');
          return;
        }
      }

      if (await _fullCompileAndRestart()) {
        await _restartAllFlutterApps();
        await _notifyBrowserRefresh();
      }
    });
  }

  /// Fully (re)launches the Flutter app: kills the running `flutter run`
  /// process (if any) and launches a fresh one - including launching it from
  /// scratch when none is running, e.g. after a `--no-flutter` start. Unlike
  /// the Flutter hot restart bundled into [forceRestart], this only drives the
  /// Flutter process and is independent of the server's compiler, so it works
  /// in both watch and non-watch mode.
  ///
  /// No-op when the project has no Flutter package. Serialized behind any
  /// in-flight reload, restart, or migration via [_chainGuarded]. Throws a
  /// [StateError] if the session has been disposed. If disposal happens while
  /// the call is queued it bails without respawning a process we'd leak.
  Future<void> restartFlutterApp() {
    return _chainGuarded(() async {
      final manager = _flutterManager;
      if (manager == null) return;

      final running = manager.runningAppIds.toList();
      if (running.isEmpty) {
        if (manager.apps.isNotEmpty) {
          await manager.launch(manager.apps.first.id);
        }
        return;
      }
      await running.map(manager.restart).wait;
    }, whenDisposed: () {});
  }

  /// Applies pending database migrations.
  ///
  /// Migrations are applied via the [ApplyMigrationsAction] supplied at
  /// construction time (typically a CLI-side runner that connects to
  /// the database directly).
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
        await _applyMigrationsAction();
        // Migrations regen the client lib; refresh Flutter.
        await _reloadAllFlutterApps();
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
    final server = _server;
    if (server == null || !server.isVmServiceConnected) {
      log.warning('Cannot reload: VM service not connected.');
      return false;
    }
    final reloaded = await server.reload(dillPath);
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
      // Null while degraded: this is the first boot, not a restart.
      final wasRunning = _server != null;
      await _server?.stop();
      final server = await _createServer!(dillPath);
      _server = server;
      _monitorExit(server);
      _trackVmServiceUri(server);
      log.info(wasRunning ? serverRestarted : serverStarted);
    } finally {
      if (_state == SessionState.restarting) {
        _state = SessionState.idle;
      }
    }
  }

  /// Stops server + Flutter, disposes compiler. Completes [done].
  Future<void> dispose() async {
    _state = SessionState.disposed;
    await _vmServiceUriChangesController.close();
    // `_server` is null when disposing a degraded session that never booted.
    final code = await _server?.stop() ?? 0;
    // Stop Flutter after the server: an in-flight Flutter reload
    // mustn't see a half-shut-down server VM service.
    await _flutterManager?.stopAll();
    await _compiler?.dispose();
    if (!_done.isCompleted) _done.complete(code);
  }

  Future<void> _restartAllFlutterApps() async {
    await _flutterManager?.runningAppIds.map(_restartFlutter).wait;
  }

  Future<void> _reloadAllFlutterApps() async {
    await _flutterManager?.runningAppIds.map(_reloadFlutter).wait;
  }

  /// Reloads a Flutter app and logs the outcome. Never throws.
  Future<void> _reloadFlutter(String appId) async {
    final flutter = _flutterManager?.processFor(appId);
    if (flutter == null) return;
    if (!flutter.isVmServiceConnected) {
      log.debug('Flutter app $appId not ready; skipping reload.');
      return;
    }
    final ok = await flutter.reload();
    if (ok) {
      log.info(flutterAppReloaded);
    } else {
      log.warning('Flutter app $appId reload failed.');
    }
  }

  /// Hot-restarts a Flutter app and logs the outcome. Never throws.
  Future<void> _restartFlutter(String appId) async {
    final flutter = _flutterManager?.processFor(appId);
    if (flutter == null) return;
    if (!flutter.isVmServiceConnected) {
      log.debug('Flutter app $appId not ready; skipping restart.');
      return;
    }
    final ok = await flutter.restart();
    if (ok) {
      log.info(flutterAppRestarted);
    } else {
      log.warning('Flutter app $appId restart failed.');
    }
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
