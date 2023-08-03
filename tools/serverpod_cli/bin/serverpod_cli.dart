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
  await runZonedGuarded(
    () async {
      try {
        await _main(args);
        await _preExit();
      } on ExitException catch (e) {
        await _preExit();
        exit(e.exitCode);
      } catch (error, stackTrace) {
        // Last resort error handling.
        printInternalError(error, stackTrace);
        await _preExit();
        exit(ExitCodeType.general.exitCode);
      }
    },
    (error, stackTrace) async {
      printInternalError(error, stackTrace);
      await _preExit();
      exit(ExitCodeType.general.exitCode);
    },
  );
}

Future<void> _main(List<String> args) async {
  // Need to initialize logger before building command runner because we need
  // the terminal column width that is accessed through the logger for proper
  // formatted usage messages.
  initializeLogger();
  var runner = buildCommandRunner();
  await runner.run(args);
}

ServerpodCommandRunner buildCommandRunner() {
  return ServerpodCommandRunner.createCommandRunner(
    _analytics,
    productionMode,
    Version.parse(templateVersion),
  )
    ..addCommand(AnalyzePubspecsCommand())
    ..addCommand(CreateCommand())
    ..addCommand(GenerateCommand())
    ..addCommand(GeneratePubspecsCommand())
    ..addCommand(LanguageServerCommand())
    ..addCommand(MigrateCommand())
    ..addCommand(VersionCommand());
}

Future<void> _preExit() async {
  _analytics.cleanUp();
  await log.flush();
}
