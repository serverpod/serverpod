import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:nocterm/nocterm.dart' as nocterm;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/mcp_socket.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/event_handler.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/start/tui/tui_log_sink.dart';
import 'package:serverpod_cli/src/commands/start/tui/tui_logger.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/commands/watcher.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/isolated_analyzers.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/file_ex.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:vm_service/vm_service_io.dart';

/// Options for the `start` command.
enum StartOption<V> implements OptionDefinition<V> {
  watch(
    FlagOption(
      argName: 'watch',
      argAbbrev: 'w',
      defaultsTo: false,
      negatable: false,
      helpText: 'Watch for changes and hot reload the server.',
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
  noFes(
    FlagOption(
      argName: 'no-fes',
      defaultsTo: false,
      negatable: false,
      helpText:
          'Skip the Frontend Server compilation pipeline. '
          'The server is started with dart run and the VM service info file '
          'is kept so an IDE debugger can attach and handle hot reload.',
    ),
  ),
  tui(
    FlagOption(
      argName: 'tui',
      defaultsTo: true,
      helpText: 'Show interactive terminal UI.',
    ),
  );

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
    final noFes = commandConfig.value(StartOption.noFes);
    final useTui =
        commandConfig.value(StartOption.tui) && stdout.hasTerminal && !noFes;

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
    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load(
        serverRootDir: directory,
        interactive: interactive,
      );
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

    // Start Docker Compose services if needed.
    var startedDocker = false;
    if (docker) {
      startedDocker = await _ensureDockerServices(serverDir);
    }

    try {
      // If a signal arrived during Docker startup, skip starting the server.
      if (shutdown.isShutdown) return;

      // Extract passthrough args (everything after '--').
      final serverArgs = argResults?.rest ?? [];

      if (watch) {
        final exitCode = await _runWatchMode(
          config: config,
          serverDir: serverDir,
          serverArgs: serverArgs,
          shutdownSignal: shutdown.future,
          noFes: noFes,
        );
        if (exitCode != 0) throw ExitException(exitCode);
      } else {
        // One-shot: generate, then run.
        final success = await performOneShotGenerate(config: config);

        if (!success) {
          log.error('Code generation failed.');
          throw ExitException.error();
        }

        await _startOnce(
          serverDir: serverDir,
          serverArgs: serverArgs,
          noFes: noFes,
          watchDirs: config.watchPaths(
            includeWeb: true,
            includeClientPackage: true,
          ),
        );
      }
    } finally {
      shutdown.dispose();
      if (startedDocker) {
        await _stopDockerServices(serverDir);
      }
    }
  }

  /// Starts the server once and waits for it to exit.
  ///
  /// When [noFes] is false (default), compiles the server to a .dill file
  /// using the Frontend Server and starts from the compiled kernel.
  /// When [noFes] is true, starts the server with `dart run`.
  Future<void> _startOnce({
    required String serverDir,
    required List<String> serverArgs,
    required bool noFes,
    required Set<String> watchDirs,
  }) async {
    log.info('Starting server...');

    if (noFes) {
      final serverProcess = ServerProcess(
        serverDir: serverDir,
        serverArgs: serverArgs,
      );

      await serverProcess.start();
      log.info('Server running.');

      final exitCode = await serverProcess.exitCode;
      if (exitCode != 0) throw ExitException(exitCode);
      return;
    }

    final serverpodToolDir = p.join(serverDir, '.dart_tool', 'serverpod');
    final entryPoint = p.join(serverDir, 'bin', 'main.dart');
    final dillPath = p.join(serverpodToolDir, 'server.dill');

    final compiler = KernelCompiler(
      entryPoint: entryPoint,
      outputDill: dillPath,
    );
    await compiler.start();

    try {
      if (!await compiler.compileIfNeeded(watchDirs)) {
        log.error('Compilation failed.');
        throw ExitException.error();
      }

      final serverProcess = ServerProcess(
        serverDir: serverDir,
        serverArgs: serverArgs,
        dartExecutable: compiler.dartExecutable,
      );
      await serverProcess.start(dillPath: dillPath);
      log.info('Server running.');

      final exitCode = await serverProcess.exitCode;
      if (exitCode != 0) throw ExitException(exitCode);
    } finally {
      await compiler.dispose();
    }
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

/// Runs the entire watch-mode loop.
///
/// Analyzers are created once and updated incrementally on each file change,
/// avoiding the cost of re-initializing them from scratch every time.
Future<int> _runWatchMode({
  required GeneratorConfig config,
  required String serverDir,
  required List<String> serverArgs,
  required Future<int> shutdownSignal,
  required bool noFes,
}) async {
  log.info('Starting server in watch mode...');

  final serverpodToolDir = p.join(serverDir, '.dart_tool', 'serverpod');
  final vmServiceInfoFile = p.join(serverpodToolDir, 'vm-service-info.json');

  if (noFes) {
    // Check if a server is already running by verifying the service info file.
    final existingUri = await _checkExistingServer(vmServiceInfoFile);
    if (existingUri != null) {
      log.info('Existing server found.');
      log.info('The Dart VM service is listening on $existingUri');
      log.info('Server running.');
      return 0;
    }
  }

  // Start analyzer initialization in the background.
  final analyzersFuture = Analyzers.createAndUpdate(config);

  // Ensure generated code is up to date (runs concurrently with analyzers).
  final allSources = await enumerateSourceFiles(config);
  if (!await isGenerationUpToDate(config, allSources)) {
    final analyzers = await analyzersFuture;
    final genResult = await analyzeAndGenerate(
      analyzers: analyzers,
      config: config,
      affectedPaths: allSources,
      requirements: GenerationRequirements.full,
    );
    if (!genResult.success) {
      log.error('Code generation failed.');
      return 1;
    }
  }

  return _startWatchSession(
    serverDir: serverDir,
    serverArgs: serverArgs,
    serverpodToolDir: serverpodToolDir,
    vmServiceInfoFile: vmServiceInfoFile,
    shutdownSignal: shutdownSignal,
    watcher: FileWatcher(
      watchPaths: {
        p.absolute(p.joinAll(config.libSourcePathParts)),
        ...config.sharedModelsLibSourcePaths.map(p.absolute),
        p.absolute(p.joinAll([...config.clientPackagePathParts, 'lib'])),
        p.absolute(
          p.joinAll([...config.serverPackageDirectoryPathParts, 'web']),
        ),
      },
    ),
    generatedDirPaths: config.generatedDirPaths,
    generate: (affectedPaths, requirements) async {
      final analyzers = await analyzersFuture;
      return analyzeAndGenerate(
        analyzers: analyzers,
        config: config,
        affectedPaths: affectedPaths,
        skipStalenessCheck: true,
        requirements: requirements,
      );
    },
    noFes: noFes,
  );
}

/// Sets up the server process, creates a [WatchSession], and runs the
/// file-change loop until the server exits or a termination signal arrives.
///
/// When [noFes] is true, the server is started with `dart run` and no
/// compiler is created - the IDE handles compilation and hot reload.
/// The session still runs code generation and triggers VM service reloads
/// for static file changes.
Future<int> _startWatchSession({
  required String serverDir,
  required List<String> serverArgs,
  required String serverpodToolDir,
  required String vmServiceInfoFile,
  required Future<int> shutdownSignal,
  required FileWatcher watcher,
  required Set<String> generatedDirPaths,
  required GenerateAction generate,
  required bool noFes,
}) async {
  KernelCompiler? compiler;
  ServerProcessFactory? serverProcessFactory;
  ServerProcess initialServerProcess;

  if (noFes) {
    // No compiler - the IDE handles compilation and hot reload.
    // Start the server with dart run; the VM's kernel_service gets its
    // own compiler, so IDE-initiated reloadSources calls work natively.
    final serverProcess = ServerProcess(
      serverDir: serverDir,
      serverArgs: serverArgs,
      enableVmService: true,
      vmServiceInfoFile: vmServiceInfoFile,
    );
    await serverProcess.start();
    await serverProcess.connectToVmService();
    initialServerProcess = serverProcess;
  } else {
    // Set up incremental compiler.
    final entryPoint = p.join(serverDir, 'bin', 'main.dart');
    final initialDill = p.join(serverpodToolDir, 'server.dill');
    compiler = KernelCompiler(
      entryPoint: entryPoint,
      outputDill: initialDill,
    );
    await compiler.start();

    // Compile if the cached dill is stale. The FES starts in the background
    // (KernelCompiler gates compile/reset calls internally until start
    // completes), so if the dill is up to date we boot immediately.
    if (!await compiler.compileIfNeeded(watcher.watchPaths)) {
      await compiler.dispose();
      log.error('Initial compilation failed.');
      return 1;
    }

    // IDE reload callback: compile incrementally and return the dill path.
    Future<String?> onReloadRequested() async {
      await compiler!.reset();
      final result = await compileWithProgress(
        'Compiling server (IDE reload)',
        compiler,
        rejectOnFailure: true,
      );
      if (result == null) return null;
      compiler.accept();
      return result.dillOutput ?? initialDill;
    }

    serverProcessFactory =
        (
          String dillPath, {
          List<String> extraArgs = const [],
        }) async {
          final serverProcess = ServerProcess(
            serverDir: serverDir,
            serverArgs: [...serverArgs, ...extraArgs],
            dartExecutable: compiler!.dartExecutable,
            enableVmService: true,
            vmServiceInfoFile: vmServiceInfoFile,
            onReloadRequested: onReloadRequested,
          );
          await serverProcess.start(dillPath: dillPath);
          await serverProcess.connectToVmService();
          return serverProcess;
        };

    initialServerProcess = await serverProcessFactory(initialDill);
  }

  final session = WatchSession(
    compiler: compiler,
    generate: generate,
    createServer: serverProcessFactory,
    initialServer: initialServerProcess,
    generatedDirPaths: generatedDirPaths,
  );

  // Start MCP socket server for AI agent integration.
  // Only available when using the built-in compiler (not --no-fes), since all
  // current MCP tools require the compiler and process lifecycle.
  McpSocketServer? mcpSocket;
  if (!noFes) {
    mcpSocket = McpSocketServer(
      socketPath: p.join(serverpodToolDir, 'mcp.sock'),
    );
    try {
      await mcpSocket.start();
      mcpSocket.connect(onApplyMigration: session.applyMigration);
      log.info('MCP server listening on ${mcpSocket.socketPath}');
    } on SocketException catch (e) {
      log.warning('Failed to start MCP server: $e');
      mcpSocket = null;
    }
  }

  final fileChangeSub = watcher.onFilesChanged
      .asyncMapBuffer(
        (events) => session.handleFileChange(events.merge()),
      )
      .listen((_) {});

  if (session.isRunning) log.info(serverRunning);

  final exitCode = await Future.any([shutdownSignal, session.done]);

  log.info('Server stopped (exitCode: $exitCode).');

  // Clean up.
  await fileChangeSub.cancel();
  await mcpSocket?.close();
  await session.dispose();

  return exitCode;
}

/// Listens for SIGINT/SIGTERM and exposes a [future] that completes when
/// a termination signal is received.
///
/// Call [dispose] to cancel the signal subscriptions.
class _ShutdownSignal {
  final Completer<int> _completer = Completer<int>();
  late final StreamSubscription<void> _sigintSub;
  late final StreamSubscription<void>? _sigtermSub;

  _ShutdownSignal() {
    _sigintSub = ProcessSignal.sigint.watch().listen(_complete);
    if (!Platform.isWindows) {
      _sigtermSub = ProcessSignal.sigterm.watch().listen(_complete);
    }
  }

  void _complete(ProcessSignal _) {
    if (!_completer.isCompleted) _completer.complete(0);
  }

  /// Whether a termination signal has been received.
  bool get isShutdown => _completer.isCompleted;

  /// Completes with 0 when a termination signal is received.
  Future<int> get future => _completer.future;

  /// Cancels the signal subscriptions.
  void dispose() {
    _sigintSub.cancel();
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
  final holder = AppStateHolder(
    ServerWatchState(),
  );
  var exitCode = 0;
  var backendStarted = false;

  void onReady(AppStateHolder h) {
    if (backendStarted) return;
    backendStarted = true;

    _runTuiBackend(
      holder: h,
      commandConfig: commandConfig,
      watch: watch,
      serverArgs: serverArgs,
      interactive: interactive,
      onExitCode: (code) => exitCode = code,
    ).catchError((Object e, StackTrace st) {
      h.state.logHistory.add(
        TuiLogEntry(
          timestamp: DateTime.now(),
          level: TuiLogLevel.fatal,
          message: 'Fatal error: $e\n$st',
        ),
      );
      h.markDirty();
      exitCode = 1;
    });
  }

  // Block on the TUI.
  await nocterm.runApp(
    nocterm.NoctermApp(
      theme: nocterm.TuiThemeData.dark.copyWith(
        background: nocterm.Color.defaultColor,
      ),
      child: ServerpodWatchApp(
        holder: holder,
        onReady: onReady,
      ),
    ),
  );

  return exitCode;
}

/// Backend logic that runs after the TUI is mounted and ready.
Future<void> _runTuiBackend({
  required AppStateHolder holder,
  required Configuration<StartOption> commandConfig,
  required bool watch,
  required List<String> serverArgs,
  required bool? interactive,
  required void Function(int) onExitCode,
}) async {
  final tuiLogger = TuiLogger();

  try {
    // Replace the CLI logger with the TUI-aware logger.
    initializeLoggerWith(tuiLogger);
    tuiLogger.attach(holder);

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

    // Start Docker Compose services if needed.
    final docker = commandConfig.value(StartOption.docker);
    var startedDocker = false;
    if (docker) {
      await log.progress('Starting Docker services', () async {
        startedDocker = await _ensureDockerServices(serverDir);
        return true;
      });
    }

    final serverpodToolDir = p.join(serverDir, '.dart_tool', 'serverpod');
    final vmServiceInfoFile = p.join(serverpodToolDir, 'vm-service-info.json');

    // Start analyzer initialization on a worker isolate in the background.
    final analyzersFuture = IsolatedAnalyzers.create(config);

    // Code generation (staleness check runs concurrently with analyzers).
    final allSources = await enumerateSourceFiles(config);
    if (!await isGenerationUpToDate(config, allSources)) {
      late final IsolatedAnalyzers analyzers;
      await log.progress('Initializing analyzers', () async {
        analyzers = await analyzersFuture;
        return true;
      });
      final genResult = await analyzeAndGenerate(
        analyzers: analyzers,
        config: config,
        affectedPaths: allSources,
        requirements: GenerationRequirements.full,
      );
      if (!genResult.success) {
        log.error('Code generation failed.');
        await (await analyzersFuture).close();
        onExitCode(1);
        nocterm.shutdownApp(1);
        return;
      }
    }

    // Compilation.
    final entryPoint = p.join(serverDir, 'bin', 'main.dart');
    final initialDill = p.join(serverpodToolDir, 'server.dill');
    final compiler = KernelCompiler(
      entryPoint: entryPoint,
      outputDill: initialDill,
    );
    await compiler.start();

    if (!await compiler.compileIfNeeded(
      config.watchPaths(includeWeb: true, includeClientPackage: true),
    )) {
      await compiler.dispose();
      log.error('Initial compilation failed.');
      onExitCode(1);
      nocterm.shutdownApp(1);
      return;
    }

    // Create TUI log sinks for server output.
    final stdoutSink = TuiLogSink(holder);
    final stderrSink = TuiLogSink(holder);

    // IDE reload callback.
    Future<String?> onReloadRequested() async {
      await compiler.reset();
      final result = await compileWithProgress(
        'Compiling server (IDE reload)',
        compiler,
        rejectOnFailure: true,
      );
      if (result == null) return null;
      compiler.accept();
      return result.dillOutput ?? initialDill;
    }

    // Server process factory. Subscribes to VM service extension events
    // on each new server process so restarts pick up the new connection.
    ServerProcessFactory serverProcessFactory;
    serverProcessFactory =
        (
          String dillPath, {
          List<String> extraArgs = const [],
        }) async {
          final serverProcess = ServerProcess(
            serverDir: serverDir,
            serverArgs: [...serverArgs, ...extraArgs],
            dartExecutable: compiler.dartExecutable,
            enableVmService: true,
            vmServiceInfoFile: vmServiceInfoFile,
            onReloadRequested: onReloadRequested,
            stdoutSink: stdoutSink,
            stderrSink: stderrSink,
          );
          await serverProcess.start(dillPath: dillPath);
          await serverProcess.connectToVmService();

          final vmService = serverProcess.vmService;
          if (vmService != null) {
            await vmService.streamListen('Extension');
            vmService.onExtensionEvent.listen(
              (event) => handleServerLogEvent(holder, event),
            );
          }

          return serverProcess;
        };

    late final ServerProcess initialServer;
    await log.progress('Starting server', () async {
      initialServer = await serverProcessFactory(initialDill);
      return true;
    });

    // Create watch session.
    final session = WatchSession(
      compiler: compiler,
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
      initialServer: initialServer,
      generatedDirPaths: config.generatedDirPaths,
    );

    // Start MCP socket server.
    McpSocketServer? mcpSocket;
    mcpSocket = McpSocketServer(
      socketPath: p.join(serverpodToolDir, 'mcp.sock'),
    );
    try {
      await mcpSocket.start();
      mcpSocket.connect(onApplyMigration: session.applyMigration);
      log.info('MCP server listening on ${mcpSocket.socketPath}');
    } on SocketException catch (e) {
      log.warning('Failed to start MCP server: $e');
      mcpSocket = null;
    }

    // Start file watcher if in watch mode.
    StreamSubscription? fileChangeSub;
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
          .asyncMapBuffer(
            (events) => session.handleFileChange(events.merge()),
          )
          .listen((_) {});
    }

    // Wire button callbacks.
    holder.onQuit = () async {
      holder.state.serverReady = false;
      holder.markDirty();
      await fileChangeSub?.cancel();
      await mcpSocket?.close();
      await session.dispose();
      if (startedDocker) {
        await _stopDockerServices(serverDir);
      }
      nocterm.shutdownApp(0);
    };
    holder.onHotReload = () {
      runTrackedAction(holder, 'Hot reload', session.forceReload);
    };
    holder.onApplyMigration = () {
      runTrackedAction(holder, 'Applying migrations', session.applyMigration);
    };

    holder.state.serverReady = session.isRunning;
    holder.markDirty();

    if (session.isRunning) log.info(serverRunning);

    // Wait for server exit.
    final serverExitCode = await session.done;
    holder.state.serverReady = false;
    holder.markDirty();
    onExitCode(serverExitCode);
    log.info('Server stopped (exitCode: $serverExitCode).');

    // Clean up.
    await fileChangeSub?.cancel();
    await mcpSocket?.close();
    await session.dispose();
  } catch (e, st) {
    // Show the error in the TUI. Keep it open so the user can read it.
    holder.state.showSplash = false;
    holder.state.logHistory.add(
      TuiLogEntry(
        timestamp: DateTime.now(),
        level: TuiLogLevel.error,
        message: '$e\n$st',
      ),
    );
    holder.markDirty();
    onExitCode(1);
  }
}
