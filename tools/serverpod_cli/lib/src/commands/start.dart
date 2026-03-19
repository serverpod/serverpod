import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/commands/watcher.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
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
  final description =
      'Generate code and start the server. '
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

    // Start Docker Compose services if needed.
    var startedDocker = false;
    if (docker) {
      startedDocker = await _ensureDockerServices(serverDir);
    }

    try {
      // Extract passthrough args (everything after '--').
      final serverArgs = argResults?.rest ?? [];

      final noFes = commandConfig.value(StartOption.noFes);

      if (watch) {
        // Watch mode: the entire loop (generation, compilation, reload)
        // runs in one long-lived isolate so analyzers persist and can
        // be updated incrementally on each file change.
        final logLevel = log.logLevel;
        final exitCode = await Isolate.run(
          () => _runWatchMode(
            config: config,
            serverDir: serverDir,
            serverArgs: serverArgs,
            logLevel: logLevel,
            noFes: noFes,
          ),
        );
        if (exitCode != 0) throw ExitException(exitCode);
      } else {
        // One-shot: generate in an isolate, then run.
        final success = await log.progress(
          'Generating code',
          () => generateInIsolate(config),
        );

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
}

/// Runs the entire watch-mode loop in a single isolate.
///
/// Analyzers are created once and updated incrementally on each file change,
/// avoiding the cost of re-initializing them from scratch every time.
///
/// Must be a top-level function so the closure passed to [Isolate.run]
/// doesn't capture unsendable objects from the call site's scope.
Future<int> _runWatchMode({
  required GeneratorConfig config,
  required String serverDir,
  required List<String> serverArgs,
  required LogLevel logLevel,
  required bool noFes,
}) async {
  log.logLevel = logLevel;
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

  // Create analyzers and run initial code generation.
  final analyzers = createAndUpdateAnalyzers(config); // async

  // Ensure generated code is up to date.
  final allSources = await enumerateSourceFiles(config);
  if (!isGenerationUpToDate(config, allSources)) {
    // Generated code is stale! Block on generation before the server starts.
    // Use full requirements for initial generation to ensure all models,
    // endpoints, and future calls are properly generated.
    final genSuccess = await analyzeAndGenerate(
      config: config,
      analyzers: await analyzers,
      affectedPaths: allSources,
      requirements: GenerationRequirements.full,
    );
    if (!genSuccess) {
      log.error('Code generation failed.');
      return 1;
    }
  }

  return _startWatchSession(
    serverDir: serverDir,
    serverArgs: serverArgs,
    serverpodToolDir: serverpodToolDir,
    vmServiceInfoFile: vmServiceInfoFile,
    watcher: config.createFileWatcher(
      includeWeb: true,
      includeClientPackage: true,
    ),
    generate: (affectedPaths, requirements) async {
      // Wait for background priming to finish before touching analyzers.
      return analyzeAndGenerate(
        config: config,
        analyzers: await analyzers,
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
  required FileWatcher watcher,
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

    serverProcessFactory = (String dillPath) async {
      final serverProcess = ServerProcess(
        serverDir: serverDir,
        serverArgs: serverArgs,
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
  );

  final fileChangeSub = watcher.onFilesChanged
      .asyncMapBuffer(
        (events) => session.handleFileChange(events.merge()),
      )
      .listen((_) {});

  // Wait for SIGINT/SIGTERM or unexpected server exit.
  final (signal, teardownSignal) = _onTerminationSignal();

  if (session.isRunning) log.info(serverRunning);

  final exitCode = await Future.any([signal, session.done]);

  log.info('Server stopped (exitCode: $exitCode).');

  // Clean up.
  await fileChangeSub.cancel();
  await session.dispose();
  await teardownSignal();

  return exitCode;
}

/// Returns a future that completes with 0 when SIGINT or SIGTERM is received,
/// and a teardown function to cancel the signal subscriptions.
(Future<int>, Future<void> Function()) _onTerminationSignal() {
  final completer = Completer<int>();
  final sigintSub = ProcessSignal.sigint.watch().listen((_) {
    if (!completer.isCompleted) completer.complete(0);
  });
  final sigtermSub = ProcessSignal.sigterm.watch().listen((_) {
    if (!completer.isCompleted) completer.complete(0);
  });
  return (
    completer.future,
    () async {
      await sigintSub.cancel();
      await sigtermSub.cancel();
    },
  );
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
