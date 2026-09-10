import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

Future<void> main(List<String> args) async {
  final analytics = PostHogAnalytics(
    uniqueUserId: 'test-user',
    projectApiKey: 'test-key',
    version: templateVersion,
    host: args[0],
  );
  initializeCliAnalytics(
    CliAnalytics(analytics: analytics, commandAnalytics: analytics),
  );
  initializeLogger();
  final runner = ServerpodCommandRunner.createCommandRunner(
    analytics,
    false,
    Version.parse(templateVersion),
    onBeforeRunCommand: (_) async {},
  )..addCommand(GenerateCommand());

  await runner.run([
    '--verbose',
    '--no-interactive',
    'generate',
    '--watch',
    '--directory',
    args[1],
  ]);
  await closeLogger();
  // Deliberately do not flush here: the watch command must finish its own
  // shutdown before returning, including sends still awaiting HTTP responses.
  exit(0);
}
