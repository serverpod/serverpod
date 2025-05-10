import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/commands/create_repair_migration.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/generate_pubspecs.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

const _mixPanelToken = '05e8ab306c393c7482e0f41851a176d8';
final Analytics _analytics = MixPanelAnalytics(
  uniqueUserId: ResourceManager().uniqueUserId,
  projectToken: _mixPanelToken,
  version: templateVersion,
);

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
        exit(ExitException.codeError);
      }
    },
    (error, stackTrace) async {
      printInternalError(error, stackTrace);
      await _preExit();
      exit(ExitException.codeError);
    },
  );
}

Future<void> _main(List<String> args) async {
  // Need to initialize logger before building command runner because we need
  // the terminal column width that is accessed through the logger for proper
  // formatted usage messages.
  initializeLogger();
  var runner = buildCommandRunner();
  try {
    await runner.run(args);
  } on UsageException catch (e) {
    log.error(e.toString());
    throw ExitException.error();
  }
}

ServerpodCommandRunner buildCommandRunner() {
  return ServerpodCommandRunner.createCommandRunner(
    _analytics,
    productionMode,
    Version.parse(templateVersion),
  )..addCommands([
      AnalyzePubspecsCommand(),
      CreateCommand(),
      GenerateCommand(),
      GeneratePubspecsCommand(),
      LanguageServerCommand(),
      CreateMigrationCommand(),
      CreateRepairMigrationCommand(),
      UpgradeCommand(),
      VersionCommand(),
    ]);
}

Future<void> _preExit() async {
  _analytics.cleanUp();
  await log.flush();
}
