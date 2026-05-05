import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:nocterm/nocterm.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/mcp_server.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/commands/start/native_assets_builder.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/event_handler.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/watch_loop.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/commands/tui/run_app.dart';
import 'package:serverpod_cli/src/commands/tui/tui_log_sink.dart';
import 'package:serverpod_cli/src/commands/tui/tui_log_writer.dart';
import 'package:serverpod_cli/src/commands/watcher.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/isolated_analyzers.dart';
import 'package:serverpod_cli/src/migrations/cli_migration_runner.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/file_ex.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';
import 'package:serverpod_cli/src/vm_proxy/serverpod_hooks.dart';
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
      defaultsTo: true,
      helpText:
          'Start Docker Compose services if a docker-compose.yaml exists.',
    ),
  ),
  tui(
    FlagOption(
      argName: 'tui',
      defaultsTo: true,
      helpText: 'Show interactive terminal UI.',
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
  bool get hidden => true;

  @override
  final description =
      'EXPERIMENTAL! Generate code and start the server. '
      'Use --watch to watch for changes and hot reload.';

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

    // In TUI mode, start the UI immediately and do all setup in onReady.
    // This avoids a visible delay from config loading and Docker checks.
    if (useTui) {
      final exitCode = await _runWithTui(
        commandConfig: commandConfig,
        watch: watch,
        serverArgs: argResults?.rest ?? [],
        interactive: serverpodRunner.globalConfiguration.optionalValue(
          GlobalOption.interactive,
        ),
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
  required String serverpodToolDir,
  required String dartExecutable,
}) {
  return NativeAssetsBuilder(
    dartExecutable: dartExecutable,
    serverDir: serverDir,
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

/// Applies pending database migrations before the pod starts.
///
/// Returns `true` when the caller should pass `--apply-migrations` to the
/// pod because the in-process apply was skipped.
Future<bool> _applyMigrationsOnBoot({
  required String serverDir,
  required String runMode,
  required String moduleName,
}) async {
  try {
    final applied = await applyPendingMigrations(
      serverDir: serverDir,
      runMode: runMode,
      moduleName: moduleName,
    );
    log.info(formatAppliedMigrations(applied));
    return false;
  } on StateError {
    // No database configured for this run mode - nothing to apply.
    return false;
  } catch (e) {
    if (!isMissingNativeAssetError(e)) rethrow;
    log.warning(
      'Cannot apply migrations from the CLI: this build is missing the '
      'native asset for the configured database driver (typically SQLite). '
      'Falling back to --apply-migrations on the pod.',
    );
    return true;
  }
}

/// Prepends `--apply-migrations` to [serverArgs] unless it is already
/// present. Used by the boot path when [_applyMigrationsOnBoot] defers
/// migration apply to the pod.
List<String> _withApplyMigrations(List<String> serverArgs) {
  if (serverArgs.contains('--apply-migrations')) return serverArgs;
  return ['--apply-migrations', ...serverArgs];
}

/// Watch-session [ApplyMigrationsAction] that wraps [applyPendingMigrations]
/// with the same FFI-resolver fallback policy as the boot path
Future<ApplyMigrationsOutcome> _applyMigrationsForSession({
  required String serverDir,
  required String runMode,
  required String moduleName,
  required void Function() onDeferToPod,
}) async {
  try {
    final applied = await applyPendingMigrations(
      serverDir: serverDir,
      runMode: runMode,
      moduleName: moduleName,
    );
    log.info(formatAppliedMigrations(applied));
    return const MigrationsApplied();
  } catch (e) {
    if (!isMissingNativeAssetError(e)) rethrow;
    onDeferToPod();
    return const MigrationsRequirePodRestart();
  }
}

/// Runs the unified watch-loop setup shared by the TUI and non-TUI flows.
Future<WatchLoopSetupResult> _setupWatchLoop({
  required GeneratorConfig config,
  required String serverDir,
  required ServerArgsRef serverArgs,
  required bool watch,
  required bool docker,
  required _ShutdownSignal shutdown,
  IOSink? serverStdoutSink,
  IOSink? serverStderrSink,
  Future<void> Function(ServerProcess server)? onServerStart,
  List<Object> Function()? mcpGetLogHistory,
}) async {
  log.info(watch ? 'Starting server in watch mode...' : 'Starting server...');

  final serverpodToolDir = p.join(serverDir, '.dart_tool', 'serverpod');
  final vmServiceInfoFile = p.join(serverpodToolDir, 'vm-service-info.json');
  // The pod always writes its raw VM service URI to a separate file; the
  // user-facing vm-service-info.json receives the proxy URI written by
  // _mountOrRetargetProxy.
  final podInfoFile = p.join(serverpodToolDir, 'vm-service-info.pod.json');

  // Start Docker Compose services if needed.
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

  // If a server is already running, abort so the IDE can attach to the
  // existing instance via the unchanged info file.
  final existingUri = await _checkExistingServer(vmServiceInfoFile);
  if (existingUri != null) {
    log.info('Existing server found.');
    log.info('VM service proxy listening on $existingUri');
    await stopDockerIfStarted();
    return const WatchLoopAborted(0);
  }

  // Apply pending migrations from the CLI before booting the pod.
  try {
    final deferToPod = await _applyMigrationsOnBoot(
      serverDir: serverDir,
      runMode: runModeFromServerArgs(serverArgs.value),
      moduleName: config.name,
    );
    if (deferToPod) serverArgs.value = _withApplyMigrations(serverArgs.value);
  } catch (_) {
    await stopDockerIfStarted();
    rethrow;
  }

  final analyzersFuture = IsolatedAnalyzers.create(config);
  Future<void> closeAnalyzers() async => (await analyzersFuture).close();

  // Code generation staleness check.
  final allSources = await enumerateSourceFiles(config);
  if (!await isGenerationUpToDate(config, allSources)) {
    late final IsolatedAnalyzers analyzers;
    await log.progress('Initializing analyzers', () async {
      analyzers = await analyzersFuture;
      return true;
    });
    late final ({bool success, Set<String> generatedFiles}) genResult;
    await log.progress('Generating code', () async {
      genResult = await analyzeAndGenerate(
        analyzers: analyzers,
        config: config,
        affectedPaths: allSources,
        requirements: GenerationRequirements.full,
      );
      return genResult.success;
    });
    if (!genResult.success) {
      log.error('Code generation failed.');
      await closeAnalyzers();
      await stopDockerIfStarted();
      return const WatchLoopAborted(1);
    }
  }

  // FES setup (watch mode only).
  KernelCompiler? compiler;
  NativeAssetsBuilder? nativeAssetsBuilder;
  String? dartExecutable;
  if (watch) {
    final entryPoint = p.join(serverDir, 'bin', 'main.dart');
    final initialDill = p.join(serverpodToolDir, 'server.dill');
    final localCompiler = KernelCompiler(
      entryPoint: entryPoint,
      outputDill: initialDill,
    );

    final localBuilder = _createNativeAssetsBuilder(
      serverDir: serverDir,
      serverpodToolDir: serverpodToolDir,
      dartExecutable: localCompiler.dartExecutable,
    );
    late final bool hooksOk;
    await log.progress('Running build hooks', () async {
      hooksOk = await _runHooksFor(localBuilder, localCompiler);
      return hooksOk;
    });
    if (!hooksOk) {
      await closeAnalyzers();
      await stopDockerIfStarted();
      return const WatchLoopAborted(1);
    }

    await localCompiler.start();

    // Compile if the cached dill is stale. The FES starts in the background
    // (KernelCompiler gates compile/reset calls internally until start
    // completes), so if the dill is up to date we boot immediately.
    if (!await localCompiler.compileIfNeeded(
      config.watchPaths(includeWeb: true, includeClientPackage: true),
    )) {
      await localCompiler.dispose();
      log.error('Initial compilation failed.');
      await closeAnalyzers();
      await stopDockerIfStarted();
      return const WatchLoopAborted(1);
    }

    compiler = localCompiler;
    nativeAssetsBuilder = localBuilder;
    dartExecutable = localCompiler.dartExecutable;
  }

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

  late final ServerProcess initialServerProcess;
  await log.progress('Starting server', () async {
    final initialDill = watch ? p.join(serverpodToolDir, 'server.dill') : null;
    initialServerProcess = await serverProcessFactory(initialDill);
    return true;
  });

  // Construct the watch session.
  final runMode = runModeFromServerArgs(serverArgs.value);
  session = WatchSession(
    compiler: compiler,
    nativeAssetsBuilder: nativeAssetsBuilder,
    generate: (affectedPaths, requirements) async {
      return analyzeAndGenerate(
        analyzers: await analyzersFuture,
        config: config,
        affectedPaths: affectedPaths,
        skipStalenessCheck: true,
        requirements: requirements,
      );
    },
    createServer: serverProcessFactory,
    initialServer: initialServerProcess,
    generatedDirPaths: config.generatedDirPaths,
    applyMigrationsAction: () => _applyMigrationsForSession(
      serverDir: serverDir,
      runMode: runMode,
      moduleName: config.name,
      onDeferToPod: () {
        log.warning(
          'Cannot apply migrations from the CLI.\n'
          'Falling back to restarting the pod with --apply-migrations.',
        );
        serverArgs.value = _withApplyMigrations(serverArgs.value);
      },
    ),
  );

  // Forward server exit into the shutdown signal so the wait-for-exit
  // point only ever has to await [shutdown.future]
  unawaited(session.done.then(shutdown.complete));

  // Start MCP socket server for AI agent integration. Exposes the proxy
  // URI (not the pod's) so MCP-initiated reloads flow through the same
  // interceptor that IDE attach uses.
  McpSocketServer? mcpSocket = McpSocketServer(project: config.name);
  try {
    await mcpSocket.start();
    mcpSocket.connect(
      onApplyMigration: session.applyMigration,
      onCreateMigration: ({String? tag, bool force = false}) =>
          _createMigrationForMcp(config, tag: tag, force: force),
      onHotReload: session.forceReload,
      getLogHistory: mcpGetLogHistory,
      getVmServiceUri: () => proxy?.httpUri.toString(),
      vmServiceUriChanges: session.vmServiceUriChanges,
    );
    log.info('MCP server listening on ${mcpSocket.socketPath}');
  } on SocketException catch (e) {
    log.warning('Failed to start MCP server: $e');
    mcpSocket = null;
  }

  // File watcher (watch mode only).
  StreamSubscription<void>? fileChangeSub;
  if (watch) {
    final watcher = FileWatcher(
      watchPaths: {
        p.absolute(p.joinAll(config.libSourcePathParts)),
        ...config.sharedModelsLibSourcePaths.map(p.absolute),
        p.absolute(p.joinAll([...config.clientPackagePathParts, 'lib'])),
        p.absolute(
          p.joinAll([...config.serverPackageDirectoryPathParts, 'web']),
        ),
      },
    );
    fileChangeSub = watcher.onFilesChanged
        .asyncMapBuffer((events) => session.handleFileChange(events.merge()))
        .listen((_) {});
  }

  return WatchLoopReady(
    WatchLoopContext(
      session: session,
      proxy: proxy,
      mcpSocket: mcpSocket,
      fileChangeSub: fileChangeSub,
      closeAnalyzers: closeAnalyzers,
      stopDocker: startedDocker ? () => _stopDockerServices(serverDir) : null,
      vmServiceInfoFile: vmServiceInfoFile,
    ),
  );
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
    await existing.retarget(podWs);
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
  required List<String> serverArgs,
  required bool? interactive,
}) async {
  final holder = StartAppStateHolder(ServerWatchState());
  var backendStarted = false;

  // Shared shutdown signal
  final shutdown = _ShutdownSignal(listenForSignals: false);

  // Captured so the renderer tear-down listener can wait for the
  // backend's cleanup (ctx.dispose) to finish before calling
  // shutdownApp. Default to a no-op so the listener is safe to invoke
  // even if SIGINT arrives before onReady fires.
  Future<void> backendFuture = Future.value();

  void onReady(StartAppStateHolder h) {
    if (backendStarted) return;
    backendStarted = true;

    backendFuture =
        _runTuiBackend(
          holder: h,
          commandConfig: commandConfig,
          watch: watch,
          serverArgs: serverArgs,
          interactive: interactive,
          shutdown: shutdown,
        ).catchError((Object e, StackTrace st) {
          // Show the error in the TUI.
          // The TUI stays open until Ctrl-C / Quit completes shutdown.
          log.error('Fatal error: $e', stackTrace: st);
        });
  }

  // Wait for the backend's dispose to finish before calling shutdownApp
  unawaited(
    shutdown.future.then((code) async {
      await backendFuture;
      shutdownApp(code);
    }),
  );

  await runServerpodApp(
    ServerpodWatchApp(holder: holder, onReady: onReady),
    onShutdownSignal: () => shutdown.complete(0),
  );

  // runServerpodApp returned, so shutdownApp ran, so the listener fired,
  // so shutdown.future is completed.
  return shutdown.future;
}

/// Backend logic that runs after the TUI is mounted and ready.
Future<void> _runTuiBackend({
  required StartAppStateHolder holder,
  required Configuration<StartOption> commandConfig,
  required bool watch,
  required List<String> serverArgs,
  required bool? interactive,
  required _ShutdownSignal shutdown,
}) async {
  try {
    // Replace the CLI logger with a TUI-backed logger.
    final tuiWriter = TuiLogWriter();
    initializeLoggerWith(ServerpodCliLogger(tuiWriter));
    tuiWriter.attach(holder);

    final directory = commandConfig.value(StartOption.directory);

    // Load generator config.
    late final GeneratorConfig config;
    await log.progress('Loading project configuration', () async {
      config = await GeneratorConfig.load(
        serverRootDir: directory,
        interactive: interactive,
      );
      return true;
    });

    final serverDir = p.joinAll(config.serverPackageDirectoryPathParts);
    final docker = commandConfig.value(StartOption.docker);

    final argsRef = ServerArgsRef(serverArgs);

    final stdoutSink = TuiLogSink(holder);
    final stderrSink = TuiLogSink(holder);

    final result = await _setupWatchLoop(
      config: config,
      serverDir: serverDir,
      serverArgs: argsRef,
      watch: watch,
      docker: docker,
      shutdown: shutdown,
      serverStdoutSink: stdoutSink,
      serverStderrSink: stderrSink,
      onServerStart: (server) async {
        final vmService = server.vmService;
        if (vmService == null) return;
        await vmService.streamListen('Extension');
        vmService.onExtensionEvent.listen(
          (event) => handleServerLogEvent(holder, event),
        );
      },
      mcpGetLogHistory: () => holder.state.logHistory.toList(),
    );

    switch (result) {
      case WatchLoopAborted(:final exitCode):
        shutdown.complete(exitCode);
        return;
      case WatchLoopReady(:final ctx):
        holder.onQuit = () => shutdown.complete(0);
        holder.onHotReload = () {
          runTrackedAction(holder, 'Hot reload', ctx.session.forceReload);
        };
        holder.onCreateMigration = () {
          runTrackedAction(
            holder,
            'Creating migration',
            () => _runCreateMigrationForTui(config),
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
    // Show the error in the TUI; let the user read it. Quitting still
    // works via the Ctrl-C signal handler routed through shutdown.
    holder.state.showSplash = false;
    log.error('$e', stackTrace: st);
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
Future<void> _runCreateMigrationForTui(GeneratorConfig config) async {
  final outcome = await createMigrationAction(config: config);
  final result = _describeCreateMigration(
    outcome,
    forceHint: 'Run `serverpod create-migration --force` to create it anyway.',
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
