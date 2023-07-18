import 'dart:async';
import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/analytics.dart';
import 'package:serverpod_cli/src/commands/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/generate_pubspecs.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/migrate.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
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
  var runner = buildCommandRunner();
  await runner.run(args);
  _analytics.cleanUp();
}

ServerpodCommandRunner buildCommandRunner() {
  var runner = ServerpodCommandRunner.createCommandRunner(
      _analytics, productionMode, Version.parse(templateVersion));

  runner.addCommand(AnalyzePubspecsCommand());
  runner.addCommand(CreateCommand());
  runner.addCommand(GenerateCommand());
  runner.addCommand(GeneratePubspecsCommand());
  runner.addCommand(LanguageServerCommand());
  runner.addCommand(MigrateCommand());
  runner.addCommand(VersionCommand());

  return runner;
}
