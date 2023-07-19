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
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';

final Analytics _analytics = Analytics();

void main(List<String> args) async {
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
