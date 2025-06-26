import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/generator/generator_continuous.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/pubspec_lock_parser.dart';
import 'package:serverpod_cli/src/util/pubspec_plus.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

enum GenerateOption<V> implements OptionDefinition<V> {
  watch(FlagOption(
    argName: 'watch',
    argAbbrev: 'w',
    defaultsTo: false,
    negatable: false,
    helpText: 'Watch for changes and continuously generate code.',
  ));

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

    // TODO: add a -d option to select the directory
    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load();
    } catch (e) {
      log.error('An error occurred while parsing the server config file: $e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    // Directory.current is the server directory
    var serverPubspecFile = File('pubspec.yaml');
    var clientPubspecFile = File(path.joinAll([
      ...config.clientPackagePathParts,
      'pubspec.yaml',
    ]));
    var pubspecsToCheck = [
      serverPubspecFile,
      if (await clientPubspecFile.exists()) clientPubspecFile,
    ].map(PubspecPlus.fromFile);

    // Validate cli version is compatible with serverpod packages
    var cliVersion = Version.parse(templateVersion);
    var warnings = [
      for (var p in pubspecsToCheck)
        ...validateServerpodPackagesVersion(cliVersion, p)
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
      var serverLockFile = File('pubspec.lock');
      var clientLockFile = File(path.joinAll([
        ...config.clientPackagePathParts,
        'pubspec.lock',
      ]));

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

    var libDirectory = Directory(path.joinAll(config.libSourcePathParts));
    var endpointsAnalyzer = EndpointsAnalyzer(libDirectory);

    var yamlModels = await ModelHelper.loadProjectYamlModelsFromDisk(config);
    var modelAnalyzer = StatefulAnalyzer(config, yamlModels, (uri, collector) {
      collector.printErrors();
    });

    bool success = true;
    if (watch) {
      success = await performGenerateContinuously(
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
        modelAnalyzer: modelAnalyzer,
      );
    } else {
      success = await log.progress(
        'Generating code',
        () => performGenerate(
          config: config,
          endpointsAnalyzer: endpointsAnalyzer,
          modelAnalyzer: modelAnalyzer,
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
