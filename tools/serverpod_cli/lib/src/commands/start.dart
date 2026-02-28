import 'dart:async';
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
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

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
      // Run initial code generation.
      final success = await log.progress(
        'Generating code',
        () => Isolate.run(
          () => _runGeneration(config: config),
        ),
      );

      if (!success) {
        log.error('Code generation failed.');
        throw ExitException.error();
      }

      // Extract passthrough args (everything after '--').
      final serverArgs = argResults?.rest ?? [];

      if (watch) {
        await _startWithWatch(
          config: config,
          serverDir: serverDir,
          serverArgs: serverArgs,
        );
      } else {
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

    final exitCode = await serverProcess.start();

    if (exitCode != 0) {
      throw ExitException(exitCode);
    }
  }

  /// Starts the server with file watching. On changes, re-generates code
  /// if needed and restarts the server.
  Future<void> _startWithWatch({
    required GeneratorConfig config,
    required String serverDir,
    required List<String> serverArgs,
  }) async {
    log.info('Starting server in watch mode...');

    final watchPaths = _watchPaths(config);
    final ignorePath = p.joinAll(config.generatedServeModelPackagePathParts);

    final watcher = FileWatcher(
      watchPaths: watchPaths,
      ignorePath: ignorePath,
    );

    var serverProcess = ServerProcess(
      serverDir: serverDir,
      serverArgs: serverArgs,
    );

    // Start initial server process (don't await — it runs until stopped).
    unawaited(
      serverProcess.start().then((exitCode) {
        // If the process exits on its own (not during restart), exit the CLI.
        if (serverProcess.isRunning) return;
        log.info('Server exited with code $exitCode.');
      }),
    );

    // Listen for changes and restart.
    final subscription = watcher.onFilesChanged.listen((event) async {
      log.info('Files changed, restarting server...');

      // Re-generate code if model files changed.
      if (event.modelFiles.isNotEmpty) {
        final genSuccess = await log.progress(
          'Generating code',
          () => Isolate.run(
            () => _runGeneration(config: config),
          ),
        );
        if (!genSuccess) {
          log.error('Code generation failed. Server not restarted.');
          return;
        }
      }

      // Stop the current server.
      await serverProcess.stop();

      // Start a new server process.
      serverProcess = ServerProcess(
        serverDir: serverDir,
        serverArgs: serverArgs,
      );

      unawaited(serverProcess.start());
      log.info('Server restarted.');
    });

    // Wait for SIGINT/SIGTERM to stop watch mode.
    final exitCompleter = Completer<void>();

    final sigintSub = ProcessSignal.sigint.watch().listen((_) {
      if (!exitCompleter.isCompleted) exitCompleter.complete();
    });
    final sigtermSub = ProcessSignal.sigterm.watch().listen((_) {
      if (!exitCompleter.isCompleted) exitCompleter.complete();
    });

    await exitCompleter.future;

    // Clean up.
    await subscription.cancel();
    await serverProcess.stop();
    await sigintSub.cancel();
    await sigtermSub.cancel();
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

  List<String> _watchPaths(GeneratorConfig config) {
    final paths = <String>[];

    final libPath = p.joinAll(config.libSourcePathParts);
    paths.add(libPath);

    for (final pathParts in config.sharedModelsSourcePathsParts.values) {
      final sharedLibPath = p.joinAll([
        ...config.serverPackageDirectoryPathParts,
        ...pathParts,
        'lib',
      ]);
      paths.add(sharedLibPath);
    }

    return paths;
  }
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

  var parameterValidator = FutureCallMethodParameterValidator(
    modelAnalyzer: modelAnalyzer,
  );

  var futureCallsAnalyzer = FutureCallsAnalyzer(
    directory: libDirectory,
    parameterValidator: parameterValidator,
  );

  return performGenerate(
    config: config,
    endpointsAnalyzer: endpointsAnalyzer,
    modelAnalyzer: modelAnalyzer,
    futureCallsAnalyzer: futureCallsAnalyzer,
  );
}
