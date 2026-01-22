import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/composite_analytics.dart';
import 'package:serverpod_cli/src/analytics/posthog_analytics.dart';
import 'package:serverpod_cli/src/analytics/posthog_config.dart';
import 'package:serverpod_cli/src/commands/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/commands/create_repair_migration.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/generate_pubspecs.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/run.dart';
import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

const _mixPanelToken = '05e8ab306c393c7482e0f41851a176d8';

final Analytics _analytics = CompositeAnalytics([
  PostHogAnalytics(
    projectApiKey: PostHogConfig.apiKey,
    host: PostHogConfig.host,
    uniqueUserId: ResourceManager().uniqueUserId,
    version: templateVersion,
    enabled: PostHogConfig.enabled,
  ),
  MixPanelAnalytics(
    uniqueUserId: ResourceManager().uniqueUserId,
    projectToken: _mixPanelToken,
    version: templateVersion,
  ),
]);

void main(List<String> args) async {
  await runZonedGuarded(
    () async {
      try {
        await _main(args);
        // _preExit() is called in _main() after runner.run() completes
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
    // Wait for analytics requests to complete before exiting
    await _preExit();
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
    GenerateCommand(),
    GeneratePubspecsCommand(),
    LanguageServerCommand(),
    CreateMigrationCommand(),
    CreateRepairMigrationCommand(),
    RunCommand(),
    UpgradeCommand(),
    VersionCommand(version),
  ]);
}

Future<void> _preExit() async {
  _analytics.cleanUp();
  // Wait for PostHog requests to complete if using CompositeAnalytics
  if (_analytics is CompositeAnalytics) {
    await (_analytics as CompositeAnalytics).waitForPendingRequests();
  } else if (_analytics is PostHogAnalytics) {
    await (_analytics as PostHogAnalytics).waitForPendingRequests();
  }
  await log.flush();
}
