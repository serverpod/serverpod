import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:args/args.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/sdk_path.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/commands/start/watch_session.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
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

      if (watch) {
        // Watch mode: the entire loop (generation, compilation, reload)
        // runs in one long-lived isolate so analyzers persist and can
        // be updated incrementally on each file change.
        await _startWithWatch(
          config: config,
          serverDir: serverDir,
          serverArgs: serverArgs,
        );
      } else {
        // One-shot: generate in an isolate, then run.
        final success = await log.progress(
          'Generating code',
          () => _generateInIsolate(config),
        );

        if (!success) {
          log.error('Code generation failed.');
          throw ExitException.error();
        }

        await _startOnce(
          serverDir: serverDir,
          serverArgs: serverArgs,
        );
      }
    } finally {
      if (startedDocker) {
        await _stopDockerServices(serverDir);
      }
    }
  }

  /// Starts the server once and waits for it to exit.
  Future<void> _startOnce({
    required String serverDir,
    required List<String> serverArgs,
  }) async {
    log.info('Starting server...');

    final serverProcess = ServerProcess(
      serverDir: serverDir,
      serverArgs: serverArgs,
    );

    await serverProcess.start();
    final exitCode = await serverProcess.exitCode;

    if (exitCode != 0) {
      throw ExitException(exitCode);
    }
  }

  /// Starts the server with file watching. On changes, re-generates code
  /// if needed, incrementally recompiles, and hot reloads the server.
  ///
  /// The entire watch loop runs in a single long-lived isolate so that
  /// analyzers persist and can be updated incrementally on each file change.
  Future<void> _startWithWatch({
    required GeneratorConfig config,
    required String serverDir,
    required List<String> serverArgs,
  }) async {
    final exitCode = await Isolate.run(
      () => _runWatchMode(
        config: config,
        serverDir: serverDir,
        serverArgs: serverArgs,
      ),
    );

    if (exitCode != 0) {
      throw ExitException(exitCode);
    }
  }

  /// Ensures Docker Compose services are running.
  ///
  /// Returns `true` if this method started the containers (meaning we should
  /// stop them on shutdown). Returns `false` if no action was taken.
  Future<bool> _ensureDockerServices(String serverDir) async {
    final composeFile = File(p.join(serverDir, 'docker-compose.yaml'));
    if (!composeFile.existsSync()) return false;

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
}) async {
  log.info('Starting server in watch mode...');

  // Check if a server is already running by verifying the service info file.
  final serverpodToolDir = p.join(serverDir, '.dart_tool', 'serverpod');
  final vmServiceInfoFile = p.join(serverpodToolDir, 'vm-service-info.json');
  final existingUri = await _checkExistingServer(vmServiceInfoFile);
  if (existingUri != null) {
    log.info('Existing server found.');
    log.info('The Dart VM service is listening on $existingUri');
    log.info('Server running.');
    return 0;
  }

  // Create persistent analyzers for incremental generation.
  final libDirectory = Directory(p.joinAll(config.libSourcePathParts));
  final endpointsAnalyzer = EndpointsAnalyzer(libDirectory);
  final yamlModels = await ModelHelper.loadProjectYamlModelsFromDisk(config);
  final modelAnalyzer = StatefulAnalyzer(config, yamlModels, (uri, collector) {
    collector.printErrors();
  });
  final futureCallsAnalyzer = FutureCallsAnalyzer(
    directory: libDirectory,
    parameterValidator: FutureCallMethodParameterValidator(
      modelAnalyzer: modelAnalyzer,
    ),
  );

  // Initial code generation.
  final genSuccess = await log.progress(
    'Generating code',
    () => performGenerate(
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
      modelAnalyzer: modelAnalyzer,
      futureCallsAnalyzer: futureCallsAnalyzer,
    ),
  );

  if (!genSuccess) {
    log.error('Code generation failed.');
    return 1;
  }

  // Resolve the dart executable from the SDK to ensure we use the same
  // version that compiled the kernel.
  final sdkRoot = getSdkPath();
  final dartExecutable = p.join(sdkRoot, 'bin', 'dart');

  final watchPaths = _watchPaths(config);
  final ignorePath = p.absolute(
    p.joinAll(config.generatedServeModelPackagePathParts),
  );

  final watcher = FileWatcher(
    watchPaths: watchPaths,
    ignorePath: ignorePath,
  );

  // Set up incremental compiler.
  final entryPoint = p.join(serverDir, 'bin', 'main.dart');
  final initialDill = p.join(serverpodToolDir, 'server.dill');
  final compiler = KernelCompiler(
    entryPoint: entryPoint,
    outputDill: initialDill,
  );

  await compiler.start();

  final initialResult = await _compileWithProgress(
    'Compiling server',
    () => compiler.compile(),
  );

  if (initialResult == null) {
    await compiler.dispose();
    log.error('Initial compilation failed.');
    return 1;
  }

  compiler.accept();

  // IDE reload callback: compile incrementally and return the dill path.
  Future<String?> onReloadRequested() async {
    compiler.reset();
    final result = await _compileWithProgress(
      'Compiling server (IDE reload)',
      () => compiler.compile(),
      compiler: compiler,
    );
    if (result == null) return null;
    compiler.accept();
    return result.dillOutput ?? initialDill;
  }

  // External reload callback: reset FES so next compile is full.
  void onExternalReload() {
    log.info('External reload detected, resetting compiler.');
    compiler.reset();
  }

  ServerProcess createServerProcess() => ServerProcess(
    serverDir: serverDir,
    serverArgs: serverArgs,
    dartExecutable: dartExecutable,
    enableVmService: true,
    vmServiceInfoFile: vmServiceInfoFile,
    onReloadRequested: onReloadRequested,
    onExternalReload: onExternalReload,
  );

  Future<ServerProcess> serverProcessFactory(String dillPath) async {
    final sp = createServerProcess();
    await sp.start(dillPath: dillPath);
    await sp.connectToVmService();
    return sp;
  }

  // Start the initial server process.
  final initialServerProcess = createServerProcess();
  await initialServerProcess.start(dillPath: initialDill);
  await initialServerProcess.connectToVmService();
  log.info('Server running.');

  final session = WatchSession(
    compiler: compiler,
    generate: (affectedPaths) => performGenerate(
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
      modelAnalyzer: modelAnalyzer,
      futureCallsAnalyzer: futureCallsAnalyzer,
      affectedPaths: affectedPaths,
    ),
    createServer: serverProcessFactory,
    initialServer: initialServerProcess,
    initialDill: initialDill,
  );

  session.listen(watcher.onFilesChanged);

  // Wait for SIGINT/SIGTERM or unexpected server exit.
  final signalCompleter = Completer<int>();

  final sigintSub = ProcessSignal.sigint.watch().listen((_) {
    if (!signalCompleter.isCompleted) signalCompleter.complete(0);
  });
  final sigtermSub = ProcessSignal.sigterm.watch().listen((_) {
    if (!signalCompleter.isCompleted) signalCompleter.complete(0);
  });

  final exitCode = await Future.any([signalCompleter.future, session.done]);

  // Clean up.
  await session.dispose();
  await sigintSub.cancel();
  await sigtermSub.cancel();

  return exitCode;
}

/// Runs code generation in a fresh isolate (used for one-shot generation).
Future<bool> _generateInIsolate(GeneratorConfig config) {
  return Isolate.run(() => _runGeneration(config: config));
}

Future<bool> _runGeneration({
  required GeneratorConfig config,
}) async {
  var libDirectory = Directory(p.joinAll(config.libSourcePathParts));
  var endpointsAnalyzer = EndpointsAnalyzer(libDirectory);

  var yamlModels = await ModelHelper.loadProjectYamlModelsFromDisk(config);
  var modelAnalyzer = StatefulAnalyzer(config, yamlModels, (uri, collector) {
    collector.printErrors();
  });

  var futureCallsAnalyzer = FutureCallsAnalyzer(
    directory: libDirectory,
    parameterValidator: FutureCallMethodParameterValidator(
      modelAnalyzer: modelAnalyzer,
    ),
  );

  return performGenerate(
    config: config,
    endpointsAnalyzer: endpointsAnalyzer,
    modelAnalyzer: modelAnalyzer,
    futureCallsAnalyzer: futureCallsAnalyzer,
  );
}

List<String> _watchPaths(GeneratorConfig config) {
  final paths = <String>[];

  // Use absolute paths so DirectoryWatcher reports absolute event paths.
  // The Frontend Server needs absolute file:// URIs to match sources.
  final libPath = p.absolute(p.joinAll(config.libSourcePathParts));
  paths.add(libPath);

  for (final pathParts in config.sharedModelsSourcePathsParts.values) {
    final sharedLibPath = p.absolute(
      p.joinAll([
        ...config.serverPackageDirectoryPathParts,
        ...pathParts,
        'lib',
      ]),
    );
    paths.add(sharedLibPath);
  }

  // Watch the web directory for static file changes (HTML, JS, CSS).
  final webPath = p.absolute(
    p.joinAll([...config.serverPackageDirectoryPathParts, 'web']),
  );
  if (Directory(webPath).existsSync()) {
    paths.add(webPath);
  }

  return paths;
}

/// Runs a compilation step with progress feedback.
///
/// Returns the [CompileResult] on success, or `null` if compilation failed.
/// On failure, logs compiler output and rejects via [compiler].
Future<CompileResult?> _compileWithProgress(
  String message,
  Future<CompileResult> Function() compile, {
  KernelCompiler? compiler,
}) async {
  late CompileResult result;
  final success = await log.progress(message, () async {
    result = await compile();
    return result.errorCount == 0;
  });

  if (!success) {
    for (final line in result.compilerOutputLines) {
      log.error(line);
    }
    if (compiler != null) {
      await compiler.reject();
    }
    return null;
  }

  return result;
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
      file.deleteSync();
      return null;
    }

    final vmService = await vmServiceConnectUri(vmServiceWsUri(uri)).timeout(
      const Duration(seconds: 3),
    );
    await vmService.dispose();
    return uri;
  } on Exception {
    // Stale or unreachable - clean up and proceed with normal startup.
    try {
      file.deleteSync();
    } on FileSystemException {
      // Ignore.
    }
    return null;
  }
}

