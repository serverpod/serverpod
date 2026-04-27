import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/commands/create_repair_migration.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/generate_pubspecs.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/mcp.dart';
import 'package:serverpod_cli/src/commands/quickstart.dart';
import 'package:serverpod_cli/src/commands/run.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/browser_launcher.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

const _mixPanelToken = '05e8ab306c393c7482e0f41851a176d8';
const _postHogApiKey = 'phc_xGBPHgcrTrDuWGtyNX3UJODXgnR684rzRPZjWRlqVxf';

/// The unique user ID for the CLI. If the user ID is not available, we use
/// 'unknown' to still collect analytics, albeit anonymously.
final _uniqueUserId = ResourceManager().uniqueUserId ?? 'unknown';

final Analytics _analytics = CompoundAnalytics([
  MixPanelAnalytics(
    uniqueUserId: _uniqueUserId,
    projectToken: _mixPanelToken,
    version: templateVersion,
  ),
  PostHogAnalytics(
    uniqueUserId: _uniqueUserId,
    projectApiKey: _postHogApiKey,
    version: templateVersion,
    libName: 'serverpod_cli',
  ),
]);

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

/// Check the number of runs and pop the web browser on first and 20th run.
///
/// If the user ID is not available, we skip the welcome and check-in pages to
/// avoid invoking the webpage every time the CLI is run if there is any
/// configuration preventing the CLI from writing to the user home directory.
Future<void> _main(List<String> args) async {
  final resourceManager = ResourceManager();
  final runCount = resourceManager.runCount;
  final uuid = resourceManager.uniqueUserId;

  if (uuid != null) {
    if (runCount == 1) {
      await BrowserLauncher.openUrl(
        Uri.parse('https://serverpod.dev/welcome?distinct_id=$uuid'),
      );
    } else if (runCount == 20) {
      await BrowserLauncher.openUrl(
        Uri.parse('https://serverpod.dev/checkin?distinct_id=$uuid'),
      );
    }
  }

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
  final version = Version.parse(templateVersion);
  return ServerpodCommandRunner.createCommandRunner(
    _analytics,
    productionMode,
    version,
  )..addCommands([
    AnalyzePubspecsCommand(),
    CreateCommand(),
    QuickstartCommand(),
    GenerateCommand(),
    GeneratePubspecsCommand(),
    LanguageServerCommand(),
    McpCommand(),
    CreateMigrationCommand(),
    CreateRepairMigrationCommand(),
    RunCommand(),
    StartCommand(),
    UpgradeCommand(),
    VersionCommand(version),
  ]);
}

Future<void> _preExit() async {
  _analytics.cleanUp();
  await closeLogger();
}
