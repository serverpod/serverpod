import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/analytics/analytics.dart';
import 'package:serverpod_cli/src/commands/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/generate_pubspecs.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/migrate.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';

final Analytics _analytics = Analytics();

void main(List<String> args) async {
  // TODO: Add flaggs for setting log level.
  // For now, use old behavior and log everything.
  initializeLogger(LogLevel.debug);

  await runZonedGuarded(
    () async {
      try {
        await _main(args);
      } on ExitException catch (e) {
        _analytics.cleanUp();
        exit(e.exitCode);
      } catch (error, stackTrace) {
        // Last resort error handling.
        printInternalError(error, stackTrace);
        exit(ExitCodeType.general.exitCode);
      }
    },
    (error, stackTrace) {
      printInternalError(error, stackTrace);
      exit(ExitCodeType.general.exitCode);
    },
  );
}

Future<void> _main(List<String> args) async {
  if (Platform.isWindows) {
    log.warning(
        'Windows is not officially supported yet. Things may or may not work '
        'as expected.');
  }

  // Check that required tools are installed
  if (!await CommandLineTools.existsCommand('dart')) {
    log.error(
        'Failed to run serverpod. You need to have dart installed and in your \$PATH');
    throw ExitException();
  }
  if (!await CommandLineTools.existsCommand('flutter')) {
    log.error(
        'Failed to run serverpod. You need to have flutter installed and in your \$PATH');
    throw ExitException();
  }

  if (!loadEnvironmentVars()) {
    throw ExitException();
  }

  // Make sure all necessary downloads are installed
  if (!resourceManager.isTemplatesInstalled) {
    try {
      await resourceManager.installTemplates();
    } catch (e) {
      log.error('Failed to download templates.');
      throw ExitException();
    }

    if (!resourceManager.isTemplatesInstalled) {
      log.error(
          'Could not download the required resources for Serverpod. Make sure that you are connected to the internet and that you are using the latest version of Serverpod.');
      throw ExitException();
    }
  }

  var runner = buildCommandRunner();
  await runner.run(args);
  _analytics.cleanUp();
}

ServerpodCommandRunner buildCommandRunner() {
  var runner =
      ServerpodCommandRunner.createCommandRunner(_analytics, productionMode);

  runner.addCommand(AnalyzePubspecsCommand());
  runner.addCommand(CreateCommand());
  runner.addCommand(GenerateCommand());
  runner.addCommand(GeneratePubspecsCommand());
  runner.addCommand(LanguageServerCommand());
  runner.addCommand(MigrateCommand());
  runner.addCommand(VersionCommand());

  return runner;
}
