import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/flush_analytics.dart';
import 'package:serverpod_cli/src/commands/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/commands/clean.dart';
import 'package:serverpod_cli/src/commands/cloud.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/commands/create_repair_migration.dart';
import 'package:serverpod_cli/src/commands/database.dart';
import 'package:serverpod_cli/src/commands/doctor.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/generate_pubspecs.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/mcp.dart';
import 'package:serverpod_cli/src/commands/migrate.dart';
import 'package:serverpod_cli/src/commands/quickstart.dart';
import 'package:serverpod_cli/src/commands/run.dart';
import 'package:serverpod_cli/src/commands/runner.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

const _postHogApiKey = 'phc_xGBPHgcrTrDuWGtyNX3UJODXgnR684rzRPZjWRlqVxf';

final _postHogAnalytics = _LazyPostHogAnalytics();

/// Creates the PostHog client, and with it the user ID file, only once an
/// event is actually sent, so opted-out runs leave the user's profile alone.
class _LazyPostHogAnalytics extends Analytics {
  PostHogAnalytics? _client;

  /// If the user ID is not available, 'unknown' still collects analytics,
  /// albeit anonymously.
  PostHogAnalytics get _postHog => _client ??= PostHogAnalytics(
    uniqueUserId: ResourceManager().uniqueUserId ?? 'unknown',
    projectApiKey: _postHogApiKey,
    version: templateVersion,
    libName: 'serverpod_cli',
  );

  @override
  Future<void> sendEvent({
    required final String event,
    final Map<String, dynamic> properties = const {},
  }) => _postHog.sendEvent(event: event, properties: properties);

  @override
  void cleanUp() => _client?.cleanUp();
}

void main(List<String> args) async {
  await runZonedGuarded(
    () async {
      var exitCode = 0;
      try {
        await _main(args);
      } on ExitException catch (e) {
        exitCode = e.exitCode;
      } catch (error, stackTrace) {
        printInternalError(error, stackTrace);
        exitCode = ExitException.codeError;
      } finally {
        await _preExit();
      }
      exit(exitCode);
    },
    (error, stackTrace) async {
      printInternalError(error, stackTrace);
      await _preExit();
      exit(ExitException.codeError);
    },
  );
}

Future<void> _main(List<String> args) async {
  initializeCliAnalytics(
    CliAnalytics(analytics: _postHogAnalytics),
  );

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
    _postHogAnalytics,
    productionMode,
    version,
  )..addCommands([
    AnalyzePubspecsCommand(),
    CleanCommand(),
    CloudCommand(),
    CreateCommand(),
    DatabaseCommand(),
    DoctorCommand(),
    QuickstartCommand(),
    GenerateCommand(),
    GeneratePubspecsCommand(),
    LanguageServerCommand(),
    McpCommand(),
    CreateMigrationCommand(),
    CreateRepairMigrationCommand(),
    MigrateCommand(),
    RunCommand(),
    RunnerCommand(),
    StartCommand(),
    UpgradeCommand(),
    VersionCommand(version),
  ]);
}

Future<void> _preExit() async {
  await flushAnalytics();
  _postHogAnalytics.cleanUp();
  await closeLogger();
}
