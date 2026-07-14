import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:meta/meta.dart' show visibleForTesting;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/flutter_app_manager.dart';
import 'package:serverpod_cli/src/commands/start/flutter_process.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/mcp_server.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/commands/start/native_assets_builder.dart';
import 'package:serverpod_cli/src/commands/start/package_dependency_tracker.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/event_handler.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/watch_loop.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/commands/watcher.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/config_info/config_info.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/isolated_analyzers.dart';
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:serverpod_cli/src/migrations/cli_migration_runner.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:serverpod_cli/src/migrations/create_repair_migration_action.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';
import 'package:serverpod_cli/src/vm_proxy/serverpod_hooks.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/serverpod_shared.dart' hide ExitException;
import 'package:serverpod_tui/serverpod_tui.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:vm_service/vm_service_io.dart';

/// Options for the `start` command.
enum StartOption<V> implements OptionDefinition<V> {
  watch(
    FlagOption(
      argName: 'watch',
      argAbbrev: 'w',
      defaultsTo: true,
      negatable: true,
      helpText:
          'Watch files and use the Frontend Server for fast incremental compilation. '
          'With --no-watch, the server is started via `dart run`.',
    ),
  ),
  directory(
    StringOption(
      argName: 'directory',
      argAbbrev: 'd',
      defaultsTo: '',
      helpText:
          'The server directory (defaults to auto-detect from current directory).',
    ),
  ),
  docker(
    FlagOption(
      argName: 'docker',
      defaultsTo: false,
      helpText:
          'Start Docker Compose services if a docker-compose.yaml exists. '
          'Default off; pass --docker to opt in to compose-managed services '
          '(typically Redis when running PostgreSQL separately).',
    ),
  ),
  tui(
    FlagOption(
      argName: 'tui',
      defaultsTo: true,
      helpText: 'Show interactive terminal UI.',
    ),
  ),
  flutter(
    FlagOption(
      argName: 'flutter',
      defaultsTo: true,
      helpText:
          'Auto-launch the companion Flutter apps as configured on the server '
          'pubspec.yaml with `auto_launch: true`. Use --no-flutter to disable '
          'auto-launch. Apps can still be started on demand from the TUI.',
    ),
  ),
  ;

  const StartOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Command to generate code, start the server, and optionally watch for
/// changes.
class StartCommand extends ServerpodCommand<StartOption> {
  @override
  final name = 'start';

  @override
  final description =
      'Start the full development stack with hot reload: generates code, '
      'runs the server, and launches the companion Flutter apps in an '
      'interactive terminal UI.';

  @override
  String get invocation => 'serverpod start [-- <server-args>]';

  StartCommand() : super(options: StartOption.values);

  @override
  Configuration<StartOption> resolveConfiguration(ArgResults? argResults) {
    return Configuration.resolveNoExcept(
      options: options,
      argResults: argResults,
      env: envVariables,
      ignoreUnexpectedPositionalArgs: true,
    );
  }

  @override
  Future<void> runWithConfig(
    Configuration<StartOption> commandConfig,
  ) async {
    final watch = commandConfig.value(StartOption.watch);
    final useTui = commandConfig.value(StartOption.tui) && stdout.hasTerminal;
    final launchFlutterApp = commandConfig.value(StartOption.flutter);

    // In TUI mode, start the UI immediately and do all setup in onReady.
    // This avoids a visible delay from config loading and Docker checks.
    if (useTui) {
      // When no `--directory` is given, resolve the server root (including an
      // interactive multi-project choice) *before* the TUI starts. Otherwise
      // `findOrPrompt` runs after nocterm has switched the terminal to raw
      // mode, which breaks the CLI `select` prompt used for that choice.
      final config = await GeneratorConfig.load(
        serverRootDir: commandConfig.value(StartOption.directory),
        interactive: serverpodRunner.globalConfiguration.optionalValue(
          GlobalOption.interactive,
        ),
      );

      // Bail before the TUI takes over the terminal
      if (await _detectExistingInstance(config)) return;

      final exitCode = await _runWithTui(
        commandConfig: commandConfig,
        watch: watch,
        launchFlutterApp: launchFlutterApp,
        serverArgs: argResults?.rest ?? [],
        config: config,
      );
      if (exitCode != 0) throw ExitException(exitCode);
      return;
    }

    final directory = commandConfig.value(StartOption.directory);

    // Get interactive flag from global configuration.
    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

    // Load generator config (also resolves server directory).
    late final GeneratorConfig config;
    try {
      await log.progress('Loading project configuration', () async {
        config = await GeneratorConfig.load(
          serverRootDir: directory,
          interactive: interactive,
        );
        return true;
      });
    } catch (e) {
      log.error('$e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    if (await _detectExistingInstance(config)) return;

    final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
    final docker = commandConfig.value(StartOption.docker);

    // Listen for termination signals before starting any services so that
    // a SIGINT at any point triggers graceful shutdown (including Docker
    // cleanup) rather than killing the process.
    final shutdown = _ShutdownSignal();

    try {
      // Extract passthrough args (everything after '--'). _setupWatchLoop
      // mutates the ref's value if the in-process migration apply has
      // to defer to the pod's `--apply-migrations`.
      final serverArgs = ServerArgsRef(argResults?.rest ?? []);

      final result = await _setupWatchLoop(
        config: config,
        serverDir: serverDir,
        serverArgs: serverArgs,
        watch: watch,
        docker: docker,
        // No TUI here, so the only recovery from a broken project is the file
        // watcher (watch mode). Without it there is nothing to wait for.
        keepOpenOnFailure: watch,
        launchFlutterApp: launchFlutterApp,
        shutdown: shutdown,
      );
      switch (result) {
        case WatchLoopAborted(:final exitCode):
          if (exitCode != 0) throw ExitException(exitCode);
          return;
        case WatchLoopReady(:final ctx):
          if (ctx.session.isRunning) log.info(serverRunning);
          final exitCode = await shutdown.future;
          log.info('Server stopped (exitCode: $exitCode).');
          await ctx.dispose();
          if (exitCode != 0) throw ExitException(exitCode);
      }
    } finally {
      shutdown.dispose();
    }
  }
}

/// Constructs a [NativeAssetsBuilder] for the server at [serverDir]. The
/// builder discovers `package_config.json` itself (walking up to a workspace
/// root if needed).
NativeAssetsBuilder _createNativeAssetsBuilder({
  required String serverDir,
  required String projectRoot,
  required String serverpodToolDir,
  required String dartExecutable,
}) {
  return NativeAssetsBuilder(
    dartExecutable: dartExecutable,
    serverDir: serverDir,
    projectRoot: projectRoot,
    outputDir: p.join(serverpodToolDir, 'native_assets'),
  );
}

/// Runs build hooks via [builder] and applies the result to [compiler].
/// Returns false on hook failure (an error has been logged).
///
/// Wraps [NativeAssetsBuilder.applyTo] for the start.dart paths that don't
/// care about the restart-distinction (initial-build callers and the IDE
/// reload callback). The watch-loop and migration paths switch on the
/// outcome directly to read [NativeAssetsApplySuccess.restarted].
Future<bool> _runHooksFor(
  NativeAssetsBuilder builder,
  KernelCompiler compiler,
) async {
  final outcome = await builder.applyTo(compiler);
  switch (outcome) {
    case NativeAssetsApplySuccess():
      return true;
    case NativeAssetsApplyFailure(:final message):
      log.error(message);
      return false;
  }
}

/// Ensures Docker Compose services are running.
///
/// Returns `true` if this method started the containers (meaning we should
/// stop them on shutdown). Returns `false` if no action was taken.
Future<bool> _ensureDockerServices(String serverDir) async {
  final composeFile = File(p.join(serverDir, 'docker-compose.yaml'));
  if (!await composeFile.exists()) return false;

  // Check if containers are already running.
  final ps = await Process.run(
    'docker',
    ['compose', 'ps', '--status', 'running', '-q'],
    workingDirectory: serverDir,
  );

  if (ps.exitCode != 0) {
    log.warning(
      'Docker does not appear to be running. '
      'Start Docker or use --no-docker to skip.',
    );
    return false;
  }

  final running = (ps.stdout as String).trim();
  if (running.isNotEmpty) return false;

  // Start containers.
  log.info('Starting Docker Compose services...');
  final up = await Process.run(
    'docker',
    ['compose', 'up', '-d'],
    workingDirectory: serverDir,
  );

  if (up.exitCode != 0) {
    final error = (up.stderr as String).trim();
    log.warning('Failed to start Docker Compose services: $error');
    return false;
  }

  log.info('Docker Compose services started.');
  return true;
}

Future<void> _stopDockerServices(String serverDir) async {
  log.info('Stopping Docker Compose services...');
  await Process.run(
    'docker',
    ['compose', 'stop'],
    workingDirectory: serverDir,
  );
}

/// Prepends `--apply-migrations` to [serverArgs] unless it is already present.
///
/// Used for the **first** pod process started by `serverpod start` so pending
/// migrations run inside the server (without requiring the insights endpoint).
/// Also used when the CLI migration runner defers to the pod (e.g. missing
/// native database assets).
List<String> _withApplyMigrations(List<String> serverArgs) {
  if (serverArgs.contains('--apply-migrations')) return serverArgs;
  return ['--apply-migrations', ...serverArgs];
}

/// Watch-session [ApplyMigrationsAction] that applies pending and repair
/// migrations by calling the running pod's `applyMigrations` endpoint. The
/// pod itself runs the migration in-process; the CLI only triggers it.
Future<void> _applyMigrationsForSession({
  required String serverDir,
  required String runMode,
}) async {
  final client = ConfigInfo(
    runMode,
    serverDir: serverDir,
  ).createServiceClient();
  try {
    await client.insights.applyMigrations(
      applyRepairMigration: true,
      applyMigrations: true,
    );
  } finally {
    client.close();
  }
}

Future<WatchLoopSetupResult> _setupWatchLoop({
  required GeneratorConfig config,
  required String serverDir,
  required ServerArgsRef serverArgs,
  required bool watch,
  required bool docker,
  // When the project fails to generate or compile: if `true`, keep the session
  // open with no server running and recover later (the file watcher auto-boots
  // in watch mode; [WatchSession.retryStart] boots on demand otherwise). If
  // `false`, there is no way to recover (non-TUI `--no-watch`), so fail fast.
  required bool keepOpenOnFailure,
  required bool launchFlutterApp,
  required _ShutdownSignal shutdown,
  IOSink? serverStdoutSink,
  IOSink? serverStderrSink,
  IOSink Function(FlutterAppConfig app)? flutterStdoutSinkFor,
  IOSink Function(FlutterAppConfig app)? flutterStderrSinkFor,
  void Function(FlutterAppConfig app)? onEnsureFlutterAppTab,
  void Function(FlutterAppConfig app, String stage)? onFlutterProgress,
  void Function(FlutterAppConfig app, String? url)? onFlutterReady,
  void Function(FlutterAppConfig app)? onFlutterLaunchFailed,
  void Function(FlutterAppConfig app)? onFlutterStop,
  Future<void> Function(ServerProcess server)? onServerStart,
  Future<void> Function(FlutterAppConfig app, FlutterProcess flutter)?
  onFlutterStart,
  void Function(List<FlutterAppConfig>)? onFlutterAppsLoaded,
  List<Object> Function()? mcpGetLogHistory,
  List<String> Function(String appId)? mcpGetFlutterLogHistory,
}) async {
  log.info(watch ? 'Starting server in watch mode...' : 'Starting server...');

  final serverpodToolDir = p.join(serverDir, '.dart_tool', 'serverpod');
  final vmServiceInfoFile = p.join(serverpodToolDir, 'vm-service-info.json');
  // The pod always writes its raw VM service URI to a separate file; the
  // user-facing vm-service-info.json receives the proxy URI written by
  // _mountOrRetargetProxy.
  final podInfoFile = p.join(serverpodToolDir, 'vm-service-info.pod.json');

  // If a server is already running, abort so the IDE can attach to the
  // existing instance via the unchanged info file. Cheap local check; runs
  // before Docker Compose provisioning so we don't pay compose-up just to
  // discard it.
  final existingUri = await _checkExistingServer(vmServiceInfoFile);
  if (existingUri != null) {
    log.info('Existing server found.');
    log.info('VM service proxy listening on $existingUri');
    return const WatchLoopAborted(0);
  }

  var startedDocker = false;
  if (docker) {
    await log.progress('Starting Docker services', () async {
      startedDocker = await _ensureDockerServices(serverDir);
      return true;
    });
  }

  Future<void> stopDockerIfStarted() async {
    if (startedDocker) await _stopDockerServices(serverDir);
  }

  Future<void> rollbackProvisioning() async {
    await stopDockerIfStarted();
  }

  // Apply pending migrations from the CLI before booting the pod.
  try {
    serverArgs.value = _withApplyMigrations(serverArgs.value);
  } catch (_) {
    await rollbackProvisioning();
    rethrow;
  }

  // prime: false - the single full prime happens inside generateIfStale; here
  // we only spawn the isolate eagerly so it overlaps the staleness check.
  final analyzersFuture = IsolatedAnalyzers.create(config, prime: false);
  Future<void> closeAnalyzers() async => (await analyzersFuture).close();

  // Tear down everything provisioned so far: the analyzer isolate and any
  // Docker services. A failed/in-flight analyzer future must not prevent the
  // Docker teardown, so closing it is guarded.
  Future<void> rollbackStartup() async {
    try {
      await closeAnalyzers();
    } catch (_) {}
    await rollbackProvisioning();
  }

  // keepPrimedWhenFresh: the analyzers are needed by the watch session even when
  // generation is up to date.
  late final ({bool upToDate, bool success}) genResult;
  try {
    genResult = await generateIfStale(
      config: config,
      keepPrimedWhenFresh: true,
      createAnalyzers: () async {
        late final IsolatedAnalyzers analyzers;
        await log.progress('Initializing analyzers', () async {
          analyzers = await analyzersFuture;
          return true;
        });
        return analyzers;
      },
    );
  } catch (_) {
    // Tear down even when analysis/generation throws, not just on a clean
    // failure.
    await rollbackStartup();
    rethrow;
  }

  // Whether the project is currently buildable. A clean generation failure no
  // longer aborts: in a recoverable session we keep watching with no server
  // and boot it once the user fixes the errors.
  var buildOk = genResult.success;
  if (!buildOk) {
    log.error('Code generation failed.');
    if (!keepOpenOnFailure) {
      await rollbackStartup();
      return const WatchLoopAborted(1);
    }
  } else if (genResult.upToDate) {
    log.info(generatedCodeAlreadyUpToDate, type: TextLogType.success);
  }

  // FES setup (watch mode only).
  KernelCompiler? compiler;
  NativeAssetsBuilder? nativeAssetsBuilder;
  String? dartExecutable;
  // The resolution's `.dart_tool` whose package_config.json the FES reads;
  // watched below so a dependency change is picked up in place.
  String? serverDartToolDir;
  // Scopes a shared (workspace) package_config.json change to the server's own
  // dependency closure so the pod reloads only when its closure actually
  // changed. Null disables the gate (always reload), matching prior behavior.
  PackageDependencyTracker? serverDependencyTracker;
  if (watch) {
    final entryPoint = p.join(serverDir, 'bin', 'main.dart');
    final initialDill = p.join(serverpodToolDir, 'server.dill');
    // Resolve the server's resolution root once and reuse it everywhere it is
    // needed: the compiler's `--packages` (so the in-place invalidation targets
    // the exact URI the CFE loaded, see KernelCompiler), the native-assets
    // builder, and the watch set below. Single walk, single source of truth.
    final projectRoot = await discoverProjectRootFrom(serverDir);
    serverDartToolDir = p.join(projectRoot, '.dart_tool');
    final packageConfigPath = p.join(serverDartToolDir, 'package_config.json');
    final localCompiler = KernelCompiler(
      entryPoint: entryPoint,
      outputDill: initialDill,
      packagesPath: packageConfigPath,
    );

    final localBuilder = _createNativeAssetsBuilder(
      serverDir: serverDir,
      projectRoot: projectRoot,
      serverpodToolDir: serverpodToolDir,
      dartExecutable: localCompiler.dartExecutable,
    );
    late final bool hooksOk;
    await log.progress('Running build hooks', () async {
      hooksOk = await _runHooksFor(localBuilder, localCompiler);
      return hooksOk;
    });
    if (!hooksOk) {
      await rollbackStartup();
      return const WatchLoopAborted(1);
    }

    await localCompiler.start();

    // Compile if the cached dill is stale. The FES starts in the background
    // (KernelCompiler gates compile/reset calls internally until start
    // completes), so if the dill is up to date we boot immediately.
    //
    // Skip the compile when generation already failed - the generated code is
    // invalid, so the compile would only fail noisily. The FES stays in its
    // fresh post-start state, ready for the watch session to compile from
    // scratch once the project is fixed.
    if (buildOk) {
      if (!await localCompiler.compileIfNeeded(
        config.watchPaths(includeWeb: true, includeClientPackage: true),
      )) {
        // Reject the failed compile so the FES returns to its last accepted
        // (empty) state, leaving it ready for a clean full compile on recovery.
        await localCompiler.reject();
        log.error('Initial compilation failed.');
        buildOk = false;
        if (!keepOpenOnFailure) {
          await localCompiler.dispose();
          await rollbackStartup();
          return const WatchLoopAborted(1);
        }
      }
    }

    compiler = localCompiler;
    nativeAssetsBuilder = localBuilder;
    dartExecutable = localCompiler.dartExecutable;

    // Seed the closure baseline now (before any file event) so the first
    // package_config.json change computes a real delta. resolveDartToolDir
    // validates the resolution lists the server package; a null disables the
    // gate. Reads the same `.dart_tool` the FES resolves, so no extra watch.
    final serverResolutionDartTool =
        PackageDependencyTracker.resolveDartToolDir(
          serverDir,
          packageName: config.serverPackage,
        );
    serverDependencyTracker = serverResolutionDartTool == null
        ? null
        : PackageDependencyTracker(
            dartToolDir: serverResolutionDartTool,
            packageName: config.serverPackage,
          );
  }

  // IDE-facing Flutter VM-service proxies. Bound now so info files exist at
  // session start regardless of whether `--flutter` was passed.
  final runMode = runModeFromServerArgs(serverArgs.value);
  final serverPubspecFile = File(p.join(serverDir, 'pubspec.yaml'));
  final flutterManager = FlutterAppManager(
    runMode: runMode,
    projectName: config.name,
    // Whether to auto-launch every app flagged with `auto_launch`
    // (the synthesized default sibling app is flagged, preserving
    // the historical single-app behavior). When no app opts in, none
    // launch - the user starts them with Ctrl+R.
    launchFlutterApp: launchFlutterApp,
    serverpodToolDir: serverpodToolDir,
    serverPubspecFile: serverPubspecFile,
    serverPackageDirectoryPathParts: config.serverPackageDirectoryPathParts,
    onProgress: (app, stage) => onFlutterProgress?.call(app, stage),
    onReady: (app, url) => onFlutterReady?.call(app, url),
    onStart: (app, process) async {
      if (onFlutterStart != null) await onFlutterStart(app, process);
    },
    onStop: (app) => onFlutterStop?.call(app),
    onLaunchFailed: (app) => onFlutterLaunchFailed?.call(app),
    onEnsureAppTab: (app) => onEnsureFlutterAppTab?.call(app),
    stdoutSinkFor: (app) => flutterStdoutSinkFor?.call(app) ?? stdout,
    stderrSinkFor: (app) => flutterStderrSinkFor?.call(app) ?? stderr,
  );
  await flutterManager.initialize();
  onFlutterAppsLoaded?.call(flutterManager.apps.toList());

  // Server process factory. Invoked for the initial start and for each
  // subsequent restart driven by the WatchSession
  late final WatchSession session;
  VmServiceProxy? proxy;
  Future<ServerProcess> serverProcessFactory(String? dillPath) async {
    final serverProcess = ServerProcess(
      serverDir: serverDir,
      serverArgs: serverArgs.value,
      dartExecutable: dartExecutable,
      enableVmService: true,
      vmServiceInfoFile: podInfoFile,
      stdoutSink: serverStdoutSink,
      stderrSink: serverStderrSink,
    );
    await serverProcess.start(dillPath: dillPath);
    await serverProcess.connectToVmService();
    if (onServerStart != null) await onServerStart(serverProcess);
    proxy = await _mountOrRetargetProxy(
      serverProcess: serverProcess,
      existing: proxy,
      userInfoFile: vmServiceInfoFile,
      reload: watch ? () => session.forceReload() : null,
    );
    return serverProcess;
  }

  // Null in a degraded start: the project failed to build, so no server boots
  // now. The watch session brings it up once the project is fixed.
  ServerProcess? initialServerProcess;
  if (buildOk) {
    await log.progress('Starting server', () async {
      final initialDill = watch
          ? p.join(serverpodToolDir, 'server.dill')
          : null;
      initialServerProcess = await serverProcessFactory(initialDill);
      return true;
    });
  } else {
    log.warning(watch ? startBlockedByErrorsWatch : startBlockedByErrorsManual);
  }

  StreamSubscription<void>? fileChangeSub;

  /// Sets up single watcher across server/shared/client/web/flutter.
  /// Changes serialize through session.handleFileChange via WatchSession._chain.
  void setupFileWatcher() {
    fileChangeSub?.cancel();
    if (!watch) return;
    final currentApps = flutterManager.apps.toList();
    final flutterPackageGraphPaths = [
      for (final app in currentApps)
        ?flutterManager.packageGraphPathFor(app.id),
    ];
    final watcher = FileWatcher(
      watchPaths: buildWatchPaths(
        config: config,
        flutterApps: currentApps,
        serverDartToolDir: serverDartToolDir,
        flutterPackageGraphPaths: flutterPackageGraphPaths,
      ),
      // Exact files so a change to one resolution's artifact never triggers the
      // other's action (matters only in a non-workspace layout). The server has
      // a single package_config.json; each Flutter app contributes its own
      // package_graph.json (they collapse to one entry in a workspace layout).
      packageConfigPath: serverDartToolDir == null
          ? null
          : p.join(serverDartToolDir, 'package_config.json'),
      packageGraphPaths: {
        ...flutterPackageGraphPaths,
      },
    );
    fileChangeSub = watcher.onFilesChanged
        .asyncMapBuffer((events) => session.handleFileChange(events.merge()))
        .listen((_) {});
  }

  // Construct the watch session.
  session = WatchSession(
    compiler: compiler,
    nativeAssetsBuilder: nativeAssetsBuilder,
    generate: (affectedPaths, requirements) async {
      return analyzeAndGenerate(
        analyzers: await analyzersFuture,
        config: config,
        affectedPaths: affectedPaths,
        incremental: true,
        requirements: requirements,
      );
    },
    // Full-project regeneration for on-demand recovery from a degraded start
    // (retryStart), where there is no incremental change event to scope it.
    fullGenerate: () async {
      final allSources = await enumerateSourceFiles(config);
      return analyzeAndGenerate(
        analyzers: await analyzersFuture,
        config: config,
        affectedPaths: allSources.keys.toSet(),
        incremental: false,
        verifyStaleness: false,
        sourceStats: allSources,
      );
    },
    createServer: serverProcessFactory,
    initialServer: initialServerProcess,
    generatedDirPaths: config.generatedDirPaths,
    serverDependencyTracker: serverDependencyTracker,
    flutterManager: flutterManager,
    flutterAppsLoader: () async {
      await flutterManager.loadApps();
      onFlutterAppsLoaded?.call(flutterManager.apps.toList());
      setupFileWatcher();
    },
    applyMigrationsAction: () => _applyMigrationsForSession(
      serverDir: serverDir,
      runMode: runMode,
    ),
  );

  // Route IDE attach auto-launch through the session so it serializes with
  // reload/restart cycles.
  flutterManager.launchOnWaitingClient = session.spawnFlutterApp;

  // Forward server exit into the shutdown signal so the wait-for-exit
  // point only ever has to await [shutdown.future]
  unawaited(session.done.then(shutdown.complete));

  // Start MCP socket server for AI agent integration. Exposes the proxy
  // URI (not the pod's) so MCP-initiated reloads flow through the same
  // interceptor that IDE attach uses.
  McpSocketServer? mcpSocket = McpSocketServer(serverDir: serverDir);
  try {
    await mcpSocket.start();
    mcpSocket.connect(
      onApplyMigration: session.applyMigration,
      onCreateMigration: ({String? tag, bool force = false}) =>
          _createMigrationForMcp(config, tag: tag, force: force),
      onCreateRepairMigration:
          ({
            String? tag,
            bool force = false,
            String? targetMigrationVersion,
          }) => _createRepairMigrationForMcp(
            config,
            runMode: runMode,
            tag: tag,
            force: force,
            targetMigrationVersion: targetMigrationVersion,
          ),
      onHotReload: session.forceReload,
      onHotRestart: session.forceRestart,
      getLogHistory: mcpGetLogHistory,
      getFlutterAppIds: () => [for (final app in flutterManager.apps) app.id],
      getFlutterLogHistory: mcpGetFlutterLogHistory,
      onSpawnFlutterApp: session.spawnFlutterApp,
      getVmServiceUri: () => proxy?.httpUri.toString(),
      getFlutterDtdUris: () => flutterManager.dtdUris,
      vmServiceUriChanges: session.vmServiceUriChanges,
    );
    log.info('MCP server listening on ${mcpSocket.socketPath}');
  } on SocketException catch (e) {
    log.warning('Failed to start MCP server: $e');
    mcpSocket = null;
  }

  setupFileWatcher();

  return WatchLoopReady(
    WatchLoopContext(
      session: session,
      proxy: () => proxy,
      flutterManager: flutterManager,
      mcpSocket: mcpSocket,
      closeAnalyzers: closeAnalyzers,
      stopFileWatcher: () => fileChangeSub?.cancel(),
      stopDocker: startedDocker ? () => _stopDockerServices(serverDir) : null,
      vmServiceInfoFile: vmServiceInfoFile,
    ),
  );
}

/// The paths the watch-mode [FileWatcher] observes: server/shared/client
/// source, the server's web dir, each Flutter app's lib and pubspec.yaml, and
/// the exact `package_config.json` / `package_graph.json` files of the
/// resolution `.dart_tool`(s).
///
/// [serverDartToolDir] is the server's resolution `.dart_tool` (workspace root
/// or the package itself); watching its `package_config.json` is what makes a
/// dependency change reload the server in place. [flutterPackageGraphPaths]
/// contains the resolved or expected graph path for every Flutter app.
///
/// The pub artifacts are watched as exact files rather than their `.dart_tool`
/// directories: those directories also hold large, churning build state (e.g.
/// `flutter_build` intermediates when a Flutter app builds, or the server's
/// dill), and a recursive directory watch has to scan and re-list that tree on
/// every build - heavy disk I/O for events that would all be discarded anyway.
@visibleForTesting
Set<String> buildWatchPaths({
  required GeneratorConfig config,
  List<FlutterAppConfig> flutterApps = const [],
  String? serverDartToolDir,
  Iterable<String> flutterPackageGraphPaths = const [],
}) {
  return {
    p.absolute(p.joinAll(config.libSourcePathParts)),
    ...config.sharedModelsLibSourcePaths.map(p.absolute),
    p.absolute(p.joinAll([...config.clientPackagePathParts, 'lib'])),
    p.absolute(p.joinAll([...config.serverPackageDirectoryPathParts, 'web'])),
    // The server's pubspec.yaml watched for changes to the flutter_apps config.
    p.absolute(
      p.joinAll([...config.serverPackageDirectoryPathParts, 'pubspec.yaml']),
    ),
    for (final app in flutterApps) ...[
      p.absolute(p.joinAll([...app.pathParts, 'lib'])),
      // The app's pubspec.yaml, watched as an exact file (it lives in the app
      // root, not under lib/) so an assets/fonts/dependency change triggers a
      // full Flutter relaunch.
      p.absolute(p.joinAll([...app.pathParts, 'pubspec.yaml'])),
    ],
    // The server resolution's package_config.json, reloaded into the FES in
    // place on dependency changes. The exact-file watcher persists across an
    // initial absence or deletion without scanning the rest of .dart_tool.
    if (serverDartToolDir != null)
      p.absolute(p.join(serverDartToolDir, 'package_config.json')),
    // Each Flutter resolution's package_graph.json, watched to detect Flutter
    // dependency changes (workspace root or, in a non-workspace project, the
    // Flutter package's own .dart_tool).
    ...flutterPackageGraphPaths.map(p.absolute),
  };
}

/// Mounts a fresh [VmServiceProxy] in front of [serverProcess] (writing
/// the proxy's URI to [userInfoFile]), or retargets [existing] in place
/// when called for a subsequent pod restart so the published proxy URI
/// stays stable across pod swaps.
///
/// When [reload] is non-null, IDE-initiated `reloadSources` requests are
/// intercepted and routed through it (so the FES + codegen pipeline runs
/// before the VM reloads). When `null` - i.e. `--no-watch` mode, where
/// there is no FES to drive - reloadSources passes through verbatim so
/// the IDE keeps full request/response fidelity (notices, `pause`, etc.)
/// against the VM's own kernel service.
///
/// Returns the (possibly retargeted) proxy on success, or [existing] when
/// the pod hasn't published a VM service URI - the watch session keeps
/// running without an attachable proxy in that case.
Future<VmServiceProxy?> _mountOrRetargetProxy({
  required ServerProcess serverProcess,
  required VmServiceProxy? existing,
  required String userInfoFile,
  required Future<void> Function()? reload,
}) async {
  final podHttp = serverProcess.vmServiceUri;
  if (podHttp == null) {
    log.warning(
      'Pod did not publish a VM service URI; IDE attach will not be '
      'available for this pod. (Reload, restart, and the rest of the '
      'watch loop continue to work.)',
    );
    return existing;
  }
  final podWs = Uri.parse(vmServiceWsUri(podHttp));

  if (existing != null) {
    await existing.setUpstream(podWs);
    return existing;
  }

  final proxy = VmServiceProxy(
    upstreamWs: podWs,
    interceptor: reload == null ? null : reloadSourcesInterceptor(reload),
  );
  await proxy.bind();
  await File(userInfoFile).writeAsString(
    jsonEncode({'uri': proxy.httpUri.toString()}),
  );
  log.info('VM service proxy listening on ${proxy.httpUri}');
  return proxy;
}

/// One-shot exit signal shared between the orchestrator, the
/// presentation layer, and `_setupWatchLoop`.
///
/// When [listenForSignals] is true (the default for non-TUI), SIGINT and
/// SIGTERM complete [future] with 0. The TUI passes `false` because
/// `runServerpodApp` already owns the signal subscriptions and forwards
/// them via its own callback. Either way, callers can [complete] the
/// signal directly (e.g. when the server crashes or the Quit button is
/// pressed) so the wait-for-exit point only ever has to await [future].
///
/// Call [dispose] to cancel the signal subscriptions, if any.
class _ShutdownSignal {
  final Completer<int> _completer = Completer<int>();
  StreamSubscription<void>? _sigintSub;
  StreamSubscription<void>? _sigtermSub;

  _ShutdownSignal({bool listenForSignals = true}) {
    if (!listenForSignals) return;
    _sigintSub = ProcessSignal.sigint.watch().listen(_completeFromSignal);
    if (!Platform.isWindows) {
      _sigtermSub = ProcessSignal.sigterm.watch().listen(_completeFromSignal);
    }
  }

  void _completeFromSignal(ProcessSignal _) => complete(0);

  /// Completes [future] with [code] if it isn't completed yet; no-op
  /// otherwise. Safe to call from multiple paths (signal handlers, the
  /// Quit button, server-exit forwarders).
  void complete([int code = 0]) {
    if (!_completer.isCompleted) _completer.complete(code);
  }

  /// Whether shutdown has been requested.
  bool get isShutdown => _completer.isCompleted;

  /// Completes with the requested exit code.
  Future<int> get future => _completer.future;

  /// Cancels the signal subscriptions.
  void dispose() {
    _sigintSub?.cancel();
    _sigtermSub?.cancel();
  }
}

/// Cheap pre-flight check for an existing `serverpod start` instance for
/// [config]'s project, by probing the per-project MCP socket. Logs a
/// message and returns `true` when another process is listening on it, so
/// callers can bail before any further setup - in particular before the
/// TUI takes over the terminal, where the message would otherwise be
/// invisible.
Future<bool> _detectExistingInstance(GeneratorConfig config) async {
  final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
  final socketPath = serverpodMcpSocketPath(serverDir);
  try {
    final probe = await connectUnixSocket(
      socketPath,
      timeout: const Duration(seconds: 1),
    );
    probe.destroy();
  } catch (_) {
    // No live listener (or path doesn't fit / no support) - safe to take
    // over. A stale file left behind by a crashed runner is unlinked by
    // [bindUnixSocket] when we actually bind.
    return false;
  }
  log.info(
    'A serverpod instance for "${config.name}" is already running '
    '(MCP socket: $socketPath).',
  );
  return true;
}

/// Checks if a server is already running by reading the VM service info file
/// and attempting to connect. Returns the URI if reachable, `null` otherwise.
/// Cleans up stale files.
Future<String?> _checkExistingServer(String infoPath) async {
  final file = File(infoPath);
  if (!file.existsSync()) return null;

  try {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final uri = json['uri'] as String?;
    if (uri == null) {
      await file.deleteIfExists();
      return null;
    }

    final vmService = await vmServiceConnectUri(vmServiceWsUri(uri)).timeout(
      const Duration(seconds: 3),
    );
    await vmService.dispose();
    return uri;
  } on Exception {
    // Stale or unreachable - clean up and proceed with normal startup.
    await file.deleteIfExists();
    return null;
  }
}

/// Runs the server with the nocterm TUI.
///
/// The TUI takes over the terminal via [nocterm.runApp], which blocks the main
/// isolate. Backend work starts via the [ServerpodWatchApp.onReady] callback,
/// which fires after the first frame via [addPostFrameCallback], ensuring the
/// component tree is fully mounted before any [setState] calls.
Future<int> _runWithTui({
  required Configuration<StartOption> commandConfig,
  required bool watch,
  required bool launchFlutterApp,
  required List<String> serverArgs,
  required GeneratorConfig config,
}) async {
  final holder = StartAppStateHolder(
    ServerWatchState()..watchModeEnabled = watch,
  );
  var backendStarted = false;

  // Shared shutdown signal
  final shutdown = _ShutdownSignal(listenForSignals: false);

  // Captured on a fatal crash so it can be replayed to the real terminal in
  // [preExit] when the user quits. The crash is also shown inside the TUI, but
  // that copy lives in an in-memory log history that is discarded once we leave
  // the alternate screen - so without this capture it would never reach the
  // user's scrollback. First crash wins.
  ({Object error, StackTrace stackTrace})? fatalCrash;
  void recordFatalCrash(Object error, StackTrace stackTrace) {
    fatalCrash ??= (error: error, stackTrace: stackTrace);
  }

  // Captured so the renderer tear-down listener can wait for the
  // backend's cleanup (ctx.dispose) to finish before calling
  // shutdownTuiApp. Default to a no-op so the listener is safe to invoke
  // even if SIGINT arrives before onReady fires.
  Future<void> backendFuture = Future.value();

  void onReady(StartAppStateHolder h) {
    if (backendStarted) return;
    backendStarted = true;

    backendFuture = _runTuiBackend(
      holder: h,
      commandConfig: commandConfig,
      watch: watch,
      launchFlutterApp: launchFlutterApp,
      serverArgs: serverArgs,
      config: config,
      shutdown: shutdown,
      onFatalError: recordFatalCrash,
    ).catchError((Object e, StackTrace st) => recordFatalCrash(e, st));
  }

  // Runs after the TUI tears down (alternate screen restored) but before the
  // process exits. Restores the stdout logger and replays any captured crash
  // so it survives in the user's scrollback - mirrors how `serverpod create`
  // flushes its errors to the terminal on exit.
  Future<void> preExit() async {
    final crash = fatalCrash;
    if (crash == null) return;
    // Swap the TUI-backed logger (whose output went to the now-gone alternate
    // screen) for a fresh stdout-backed one, so the replayed crash actually
    // reaches the terminal.
    await closeLogger();
    initializeLogger();
    printInternalError(crash.error, crash.stackTrace);
    await log.flush();
  }

  // Wait for the backend's dispose to finish before calling shutdownTuiApp
  unawaited(
    shutdown.future.then((code) async {
      await backendFuture;
      shutdownTuiApp(code);
    }),
  );

  await runTuiApp(
    ServerpodWatchApp(holder: holder, onReady: onReady),
    backend: ServerpodTerminalBackend(preExit: preExit),
    onShutdownSignal: () => shutdown.complete(0),
  );

  // runServerpodApp returned, so shutdownServerpodApp ran, so the listener fired,
  // so shutdown.future is completed.
  return shutdown.future;
}

/// Backend logic that runs after the TUI is mounted and ready.
Future<void> _runTuiBackend({
  required StartAppStateHolder holder,
  required Configuration<StartOption> commandConfig,
  required bool watch,
  required bool launchFlutterApp,
  required List<String> serverArgs,
  required GeneratorConfig config,
  required _ShutdownSignal shutdown,
  required void Function(Object error, StackTrace stackTrace) onFatalError,
}) async {
  try {
    // Replace the CLI logger with a TUI-backed logger.
    final tuiWriter = TuiLogWriter();
    initializeLoggerWith(ServerpodCliLogger(tuiWriter));
    tuiWriter.attach(holder);

    final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
    final docker = commandConfig.value(StartOption.docker);

    final argsRef = ServerArgsRef(serverArgs);

    final stdoutSink = TuiLogSink(holder, addLine: holder.state.rawLines.add);
    final stderrSink = TuiLogSink(holder, addLine: holder.state.rawLines.add);

    final result = await _setupWatchLoop(
      config: config,
      serverDir: serverDir,
      serverArgs: argsRef,
      watch: watch,
      docker: docker,
      // The TUI always stays open on a broken project: in watch mode the file
      // watcher auto-recovers; otherwise the user triggers a rebuild manually.
      keepOpenOnFailure: true,
      launchFlutterApp: launchFlutterApp,
      shutdown: shutdown,
      serverStdoutSink: stdoutSink,
      serverStderrSink: stderrSink,
      flutterStdoutSinkFor: (app) => TuiLogSink(
        holder,
        addLine: (line) => holder.state.appLogTabFor(app.id)?.lines.add(line),
      ),
      flutterStderrSinkFor: (app) => TuiLogSink(
        holder,
        addLine: (line) => holder.state.appLogTabFor(app.id)?.lines.add(line),
      ),
      onEnsureFlutterAppTab: (app) {
        final tab = holder.state.getOrCreateAppLogTab(
          appId: app.id,
          label: app.name,
        );
        tab.ready = false;
        tab.stopped = false;
        tab.url = null;
        // Focus the tab only when the launch was initiated from the launch
        // panel (which is open at that point). Apps auto-started by
        // `serverpod start` launch with the panel closed, so the Server logs
        // tab stays active for them.
        if (holder.state.showLaunchPanel) {
          holder.state.tabs.focusTab(tab);
        }
        holder.markDirty();
      },
      onFlutterProgress: (app, stage) {
        final tab = holder.state.appLogTabFor(app.id);
        if (tab != null) {
          tab.startupStage = stage;
          holder.markDirty();
        }
      },
      onFlutterReady: (app, url) {
        final tab = holder.state.appLogTabFor(app.id);
        if (tab != null) {
          // Null on non-web devices, which publish no URL; the status line
          // then falls back to its generic running label.
          tab.url = url;
          tab.ready = true;
          tab.stopped = false;
          holder.markDirty();
        }
      },
      onFlutterLaunchFailed: (app) {
        final tab = holder.state.appLogTabFor(app.id);
        if (tab != null) {
          tab.ready = false;
          tab.stopped = true;
          tab.url = null;
          holder.markDirty();
        }
      },
      onServerStart: (server) async {
        // Fires on every server boot - the initial start, a restart, and the
        // first boot after recovering from a degraded start. Mark the UI ready
        // so a degraded->running transition lights up the action buttons.
        holder.state.serverReady = true;
        holder.state.serverStartable = false;
        holder.markDirty();
        final vmService = server.vmService;
        if (vmService == null) return;
        await vmService.streamListen('Extension');
        vmService.onExtensionEvent.listen(
          (event) => handleServerLogEvent(holder, event),
        );
      },
      onFlutterStart: (app, flutter) async {
        final vmService = flutter.vmService;
        if (vmService == null) return;
        await vmService.streamListen('Extension');
        vmService.onExtensionEvent.listen(
          (event) => handleServerLogEvent(holder, event),
        );
      },
      onFlutterStop: (app) {
        final tab = holder.state.appLogTabFor(app.id);
        if (tab != null) {
          tab.ready = false;
          tab.stopped = true;
          holder.markDirty();
        }
      },
      onFlutterAppsLoaded: (newApps) {
        // Remove tabs for gone apps and update state.
        final oldApps = holder.state.launchableApps;
        for (final app in oldApps) {
          late final tab = holder.state.appLogTabFor(app.id);
          if (!newApps.any((a) => a.id == app.id) && tab != null) {
            holder.state.tabs.removeTab(tab);
          }
        }
        holder.state.createAppsTabAreaIfNeeded();
        holder.state.launchableApps = newApps;
        holder.state.canLaunchApps =
            newApps.isNotEmpty &&
            runModeFromServerArgs(serverArgs) == 'development';
        holder.markDirty();
      },
      mcpGetLogHistory: () => holder.state.logHistory.toList(),
      mcpGetFlutterLogHistory: (appId) =>
          holder.state.appLogTabFor(appId)?.lines.toList() ?? <String>[],
    );

    switch (result) {
      case WatchLoopAborted(:final exitCode):
        shutdown.complete(exitCode);
        return;
      case WatchLoopReady(:final ctx):
        // Offer Ctrl+R whenever a Flutter app could run here - even after a
        // `--no-flutter` start, where it acts as a "launch the app" button.
        final apps = ctx.flutterManager.apps.toList();
        holder.state.canLaunchApps =
            apps.isNotEmpty &&
            runModeFromServerArgs(serverArgs) == 'development';
        holder.state.launchableApps = apps;
        holder.state.isAppRunning = (appId) =>
            ctx.flutterManager.isRunning(appId);
        holder.state.isAppLaunching = (appId) =>
            ctx.flutterManager.isLaunching(appId);
        holder.onLaunchApp = (index) {
          final flutterApps = ctx.flutterManager.apps.toList();
          if (index < 0 || index >= flutterApps.length) return;
          final app = flutterApps[index];
          // Selecting an already-running app relaunches it; a stopped one is
          // launched. Either path focuses the app's tab via onEnsureAppTab.
          final isRunning = ctx.flutterManager.isRunning(app.id);
          runTrackedAction(
            holder,
            isRunning ? 'Relaunch ${app.name}' : 'Launch ${app.name}',
            () => ctx.session.relaunchFlutterApp(app.id),
          );
        };
        holder.onStopApp = (index) {
          final flutterApps = ctx.flutterManager.apps.toList();
          if (index < 0 || index >= flutterApps.length) return;
          final app = flutterApps[index];
          if (!ctx.flutterManager.isRunning(app.id)) return;
          runTrackedAction(
            holder,
            'Stop ${app.name}',
            () => ctx.session.stopFlutterApp(app.id),
          );
        };
        holder.onQuit = () => shutdown.complete(0);
        holder.onHotReload = () {
          runTrackedAction(holder, 'Hot reload', ctx.session.forceReload);
        };
        holder.onHotRestart = () {
          // While degraded (no server yet), the R action rebuilds and boots the
          // server via retryStart; once running it is an ordinary hot restart.
          final running = ctx.session.isRunning;
          runTrackedAction(
            holder,
            running ? 'Hot restart' : 'Rebuild & start',
            running ? ctx.session.forceRestart : ctx.session.retryStart,
            allowWhenStartable: !running,
          );
        };
        holder.onRestartFlutterApp = () {
          runTrackedAction(
            holder,
            ctx.session.isFlutterAppRunning
                ? 'Restart Flutter app'
                : 'Start Flutter app',
            // Routed through the session so the relaunch is serialized behind
            // any in-flight reload/restart and guarded against re-spawning
            // during shutdown.
            ctx.session.restartFlutterApp,
          );
        };
        holder.onCreateMigration = ({bool force = false}) {
          runTrackedAction(
            holder,
            force ? 'Force-creating migration' : 'Creating migration',
            () => _runCreateMigrationForTui(config, force: force),
          );
        };
        holder.onCreateRepairMigration = ({bool force = false}) {
          runTrackedAction(
            holder,
            force
                ? 'Force-creating repair migration'
                : 'Creating repair migration',
            () => _runCreateRepairMigrationForTui(
              config,
              runMode: runModeFromServerArgs(serverArgs),
              force: force,
            ),
          );
        };
        holder.onApplyMigration = () {
          runTrackedAction(
            holder,
            'Applying migrations',
            ctx.session.applyMigration,
          );
        };

        holder.state.serverReady = ctx.session.isRunning;
        // Degraded start (no server yet): expose the manual "Start server"
        // recovery action. The watcher also auto-recovers in watch mode.
        holder.state.serverStartable = !ctx.session.isRunning;
        holder.markDirty();

        if (ctx.session.isRunning) log.info(serverRunning);

        // All termination triggers (Quit, SIGINT/SIGTERM, server crash,
        // unhandled errors) funnel through `shutdown`
        final exitCode = await shutdown.future;
        holder.state.serverReady = false;
        holder.markDirty();
        log.info('Server stopped (exitCode: $exitCode).');

        await ctx.dispose();
    }
  } catch (e, st) {
    // Surface the crash in the TUI (left open so it stays visible alongside the
    // preceding logs), and capture it via [onFatalError] so it is also replayed
    // to the terminal in [_runWithTui] when the user quits - the in-TUI copy is
    // lost when we leave the alternate screen.
    holder.state.showSplash = false;
    log.error('$e', stackTrace: st);
    onFatalError(e, st);
  }
}

/// Maps a [CreateMigrationOutcome] to a `(message, isError)` pair shared by
/// the TUI and MCP wrappers. [forceHint] is the surface-specific instruction
/// for retrying past warnings (e.g. `--force` for the CLI/TUI, `force: true`
/// for the MCP tool).
({String message, bool isError}) _describeCreateMigration(
  CreateMigrationOutcome outcome, {
  required String forceHint,
  bool isServer = true,
}) {
  final label = '${isServer ? 'Server' : 'Client'} migration';
  return switch (outcome) {
    CreateMigrationCreated(:final versionName, :final migrationDirectory) => (
      message: '$label "$versionName" created at $migrationDirectory.',
      isError: false,
    ),
    CreateMigrationNoChanges() => (
      message: '$label skipped. No changes detected.',
      isError: false,
    ),
    CreateMigrationAborted() => (
      message: '$label aborted due to warnings. $forceHint',
      isError: true,
    ),
    CreateMigrationFailed(:final message) => (
      message: message,
      isError: true,
    ),
    CreateMigrationServerClientCreated(
      :final serverResult,
      :final clientResult,
    ) =>
      () {
        final serverDescription = _describeCreateMigration(
          serverResult,
          forceHint: forceHint,
          isServer: true,
        );
        final clientDescription = _describeCreateMigration(
          clientResult,
          forceHint: forceHint,
          isServer: false,
        );
        return (
          message: '${serverDescription.message}\n${clientDescription.message}',
          isError: serverDescription.isError || clientDescription.isError,
        );
      }(),
  };
}

/// Runs `create-migration` for the TUI's Create Migration button.
///
/// Logs the outcome; throws on failure so [runTrackedAction] marks the
/// operation red.
Future<void> _runCreateMigrationForTui(
  GeneratorConfig config, {
  bool force = false,
}) async {
  final outcome = await createMigrationAction(config: config, force: force);
  final result = _describeCreateMigration(
    outcome,
    forceHint: 'Use ⇧+M to force-create it anyway.',
  );
  if (result.isError) throw Exception(result.message);
  log.info(result.message);
}

/// Runs `create-migration` for the MCP `create_migration` tool. Returns a
/// structured result so the MCP server can flag errors.
Future<CreateMigrationMcpResult> _createMigrationForMcp(
  GeneratorConfig config, {
  String? tag,
  bool force = false,
}) async {
  final outcome = await createMigrationAction(
    config: config,
    tag: tag,
    force: force,
  );
  final result = _describeCreateMigration(
    outcome,
    forceHint: 'Call again with `force: true` to create it anyway.',
  );
  final followUp = outcome is CreateMigrationCreated
      ? ' Call `apply_migrations` to run it against the database.'
      : '';
  return CreateMigrationMcpResult(
    message: result.message + followUp,
    isError: result.isError,
  );
}

/// Runs `create-repair-migration` for the TUI's Repair Migration button.
///
/// Logs the outcome; throws on failure so [runTrackedAction] marks the
/// operation red.
Future<void> _runCreateRepairMigrationForTui(
  GeneratorConfig config, {
  required String runMode,
  bool force = false,
}) async {
  final File? file;
  try {
    file = await createRepairMigrationAction(
      config: config,
      runMode: runMode,
      force: force,
    );
  } on MigrationAbortedException {
    log.info('Use ⇧+P to force-create it anyway.');
    rethrow;
  }

  if (file == null) {
    log.info('Repair migration skipped. No schema drift detected.');
    return;
  }
  final versionName = p.basenameWithoutExtension(file.path);
  log.info('Repair migration "$versionName" created at ${file.path}.');
}

/// Runs `create-repair-migration` for the MCP `create_repair_migration` tool.
/// Returns a structured result so the MCP server can flag errors.
Future<CreateMigrationMcpResult> _createRepairMigrationForMcp(
  GeneratorConfig config, {
  required String runMode,
  String? tag,
  bool force = false,
  String? targetMigrationVersion,
}) async {
  final File? file;
  try {
    file = await createRepairMigrationAction(
      config: config,
      tag: tag,
      runMode: runMode,
      force: force,
      targetMigrationVersion: targetMigrationVersion,
    );
  } on MigrationAbortedException {
    return const CreateMigrationMcpResult(
      message:
          'Repair migration aborted due to warnings. '
          'Call again with `force: true` to create it anyway.',
      isError: true,
    );
  } on Exception catch (e) {
    return CreateMigrationMcpResult(message: '$e', isError: true);
  }

  if (file == null) {
    return const CreateMigrationMcpResult(
      message: 'Repair migration skipped. No schema drift detected.',
    );
  }

  final versionName = p.basenameWithoutExtension(file.path);
  return CreateMigrationMcpResult(
    message:
        'Repair migration "$versionName" created at ${file.path}. '
        'Call `apply_migrations` to run it against the database.',
  );
}
