import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/copy_migrations.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/generator/generator_continuous.dart';
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
      'verbose',
      abbr: 'v',
      defaultsTo: false,
      negatable: false,
      help: 'Output more detailed information.',
    );
    argParser.addFlag(
      'watch',
      abbr: 'w',
      defaultsTo: false,
      negatable: false,
      help: 'Watch for changes and continuously generate code.',
    );
  }

  @override
  Future run() async {
    // Always do a full generate.
    bool verbose = argResults!['verbose'];
    bool watch = argResults!['watch'];

    // TODO: add a -d option to select the directory
    var config = await GeneratorConfig.load();
    if (config == null) {
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

    // Copy migrations from modules.
    await copyMigrations(config);

    var endpointsAnalyzer = EndpointsAnalyzer(config);

    bool hasErrors = await performGenerate(
      verbose: verbose,
      config: config,
      endpointsAnalyzer: endpointsAnalyzer,
    );
    if (watch) {
      log.info('Initial code generation complete. Listening for changes.');
      hasErrors = await performGenerateContinuously(
        verbose: verbose,
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
      );
    } else {
      log.info('Done.',
          style: const TextLogStyle(type: AbstractStyleType.success));
    }

    if (hasErrors) {
      throw ExitException();
    }
  }
}
