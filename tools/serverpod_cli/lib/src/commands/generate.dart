import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generator_continuous.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';

class GenerateCommand extends ServerpodCommand {
  @override
  final name = 'generate';
  @override
  final description = 'Generate code from yaml files for server and clients.';

  GenerateCommand() {
    argParser.addFlag(
      'watch',
      abbr: 'w',
      defaultsTo: false,
      negatable: false,
      help: 'Watch for changes and continuously generate code.',
    );
  }

  @override
  Future<void> run() async {
    // Always do a full generate.
    bool watch = argResults!['watch'];

    // TODO: add a -d option to select the directory
    GeneratorConfig config;
    try {
      config = await GeneratorConfig.load();
    } catch (_) {
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    // Validate cli version is compatible with serverpod packages
    var warnings = performServerpodPackagesAndCliVersionCheck(
        Version.parse(templateVersion), Directory.current.parent);
    if (warnings.isNotEmpty) {
      log.warning(
        'The version of the CLI may be incompatible with the Serverpod '
        'packages used in your project.',
      );
      for (var warning in warnings) {
        log.sourceSpanException(warning);
      }
    }

    var endpointDirectory =
        Directory(path.joinAll(config.endpointsSourcePathParts));
    var endpointsAnalyzer = EndpointsAnalyzer(endpointDirectory);

    bool success = true;
    if (watch) {
      success = await performGenerateContinuously(
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
      );
    } else {
      success = await log.progress(
        'Generating code',
        () => performGenerate(
          config: config,
          endpointsAnalyzer: endpointsAnalyzer,
        ),
      );
    }

    if (!success) {
      throw ExitException();
    } else {
      log.info('Done.', type: TextLogType.success);
    }
  }
}
