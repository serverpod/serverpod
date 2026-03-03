import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/commands/start/file_watcher.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/pubspec_lock_parser.dart';
import 'package:serverpod_cli/src/util/pubspec_plus.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

enum GenerateOption<V> implements OptionDefinition<V> {
  watch(
    FlagOption(
      argName: 'watch',
      argAbbrev: 'w',
      defaultsTo: false,
      negatable: false,
      helpText: 'Watch for changes and continuously generate code.',
    ),
  ),
  directory(
    StringOption(
      argName: 'directory',
      argAbbrev: 'd',
      defaultsTo: '',
      helpText:
          'The directory to generate code for (defaults to current directory).',
    ),
  );

  const GenerateOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class GenerateCommand extends ServerpodCommand<GenerateOption> {
  @override
  final name = 'generate';
  @override
  final description = 'Generate code from yaml files for server and clients.';

  GenerateCommand() : super(options: GenerateOption.values);

  @override
  Future<void> runWithConfig(
    Configuration<GenerateOption> commandConfig,
  ) async {
    // Always do a full generate.
    bool watch = commandConfig.value(GenerateOption.watch);
    String directory = commandConfig.value(GenerateOption.directory);

    // Get interactive flag from global configuration
    final interactive = serverpodRunner.globalConfiguration.optionalValue(
      GlobalOption.interactive,
    );

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

    var serverPubspecFile = File(
      path.joinAll([
        ...config.serverPackageDirectoryPathParts,
        'pubspec.yaml',
      ]),
    );
    var clientPubspecFile = File(
      path.joinAll([
        ...config.clientPackagePathParts,
        'pubspec.yaml',
      ]),
    );
    var pubspecsToCheck = [
      serverPubspecFile,
      if (await clientPubspecFile.exists()) clientPubspecFile,
    ].map(PubspecPlus.fromFile);

    // Validate cli version is compatible with serverpod packages
    var cliVersion = Version.parse(templateVersion);
    var warnings = [
      for (var p in pubspecsToCheck)
        ...validateServerpodPackagesVersion(cliVersion, p),
    ];
    if (warnings.isNotEmpty) {
      log.warning(
        'The version of the CLI may be incompatible with the Serverpod '
        'packages used in your project.',
      );
      for (var warning in warnings) {
        log.sourceSpanException(warning);
      }
    }

    // Also check pubspec.lock files if pubspec validation passes
    if (warnings.isEmpty) {
      var serverLockFile = File(
        path.joinAll([
          ...config.serverPackageDirectoryPathParts,
          'pubspec.lock',
        ]),
      );
      var clientLockFile = File(
        path.joinAll([
          ...config.clientPackagePathParts,
          'pubspec.lock',
        ]),
      );

      var lockFilesToCheck = [
        if (await serverLockFile.exists()) serverLockFile,
        if (await clientLockFile.exists()) clientLockFile,
      ].map(PubspecLockParser.fromFile);

      var lockWarnings = [
        for (var lockParser in lockFilesToCheck)
          validateServerpodLockFileVersion(cliVersion, lockParser),
      ].nonNulls;

      for (var warning in lockWarnings) {
        log.sourceSpanException(warning);
      }
    }

    late final bool success;
    if (watch) {
      // Watch mode: the entire loop (generation + file watching) runs in one
      // long-lived isolate so analyzers persist and can be updated
      // incrementally on each file change.
      success = await Isolate.run(
        () => _performGenerateWatch(config: config),
      );
    } else {
      success = await log.progress(
        'Generating code',
        () => Isolate.run(
          () => _performGenerate(config: config),
        ),
      );
    }

    if (!success) {
      throw ExitException.error();
    } else {
      log.info('Done.', type: TextLogType.success);
    }
  }
}

/// One-shot code generation.
Future<bool> _performGenerate({
  required GeneratorConfig config,
}) async {
  var libDirectory = Directory(path.joinAll(config.libSourcePathParts));
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

/// Watch-mode code generation with persistent analyzers and file watching.
Future<bool> _performGenerateWatch({
  required GeneratorConfig config,
}) async {
  // Create persistent analyzers.
  var libDirectory = Directory(path.joinAll(config.libSourcePathParts));
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

  // Initial generation.
  var success = await log.progress(
    'Generating code',
    () => performGenerate(
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
      modelAnalyzer: modelAnalyzer,
      futureCallsAnalyzer: futureCallsAnalyzer,
    ),
  );

  if (!success) return false;

  log.info(
    'Initial code generation complete. Listening for changes.',
  );

  // Set up file watcher.
  final watchPaths = <String>[
    path.absolute(path.joinAll(config.libSourcePathParts)),
    for (final pathParts in config.sharedModelsSourcePathsParts.values)
      path.absolute(
        path.joinAll([
          ...config.serverPackageDirectoryPathParts,
          ...pathParts,
          'lib',
        ]),
      ),
  ];
  final ignorePath = path.absolute(
    path.joinAll(config.generatedServeModelPackagePathParts),
  );

  final watcher = FileWatcher(
    watchPaths: watchPaths,
    ignorePath: ignorePath,
  );

  // Process file change events.
  await for (final event in watcher.onFilesChanged) {
    final affectedPaths = {
      ...event.dartFiles,
      ...event.removedDartFiles,
      ...event.modelFiles,
    };

    if (affectedPaths.isEmpty) continue;

    try {
      success = await log.progress(
        'Generating code',
        () => performGenerate(
          config: config,
          endpointsAnalyzer: endpointsAnalyzer,
          modelAnalyzer: modelAnalyzer,
          futureCallsAnalyzer: futureCallsAnalyzer,
          affectedPaths: affectedPaths,
        ),
      );

      if (success) {
        log.info('Incremental code generation complete.');
      }
    } catch (e) {
      if (e is Error) {
        log.error(e.toString(), stackTrace: e.stackTrace);
      } else {
        log.error(e.toString());
      }
      success = false;
    }
  }

  return success;
}
