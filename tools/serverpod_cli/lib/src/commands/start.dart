import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
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

    // Run code generation.
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

    if (watch) {
      // TODO: Implement watch mode (step 2).
      log.warning('Watch mode is not yet implemented. Starting without watch.');
    }

    // Extract passthrough args (everything after '--').
    final serverArgs = argResults?.rest ?? [];

    log.info('Starting server...');

    await _startServer(
      serverDir: serverDir,
      serverArgs: serverArgs,
    );
  }

  Future<void> _startServer({
    required String serverDir,
    required List<String> serverArgs,
  }) async {
    final process = await Process.start(
      'dart',
      ['run', 'bin/main.dart', ...serverArgs],
      workingDirectory: serverDir,
    );

    final sigintSub = ProcessSignal.sigint.watch().listen(
      (_) => process.kill(ProcessSignal.sigint),
    );
    final sigtermSub = ProcessSignal.sigterm.watch().listen(
      (_) => process.kill(ProcessSignal.sigterm),
    );

    // Forward process output to terminal.
    final stdoutDone = process.stdout.pipe(stdout);
    final stderrDone = process.stderr.pipe(stderr);

    final exitCode = await process.exitCode;

    // Wait for output streams to flush.
    await Future.wait([stdoutDone, stderrDone]);

    await sigintSub.cancel();
    await sigtermSub.cancel();

    if (exitCode != 0) {
      throw ExitException(exitCode);
    }
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
