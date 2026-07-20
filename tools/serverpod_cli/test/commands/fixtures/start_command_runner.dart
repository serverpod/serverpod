import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

Future<void> main(List<String> arguments) async {
  initializeLogger();
  try {
    final runner = ServerpodCommandRunner(
      'serverpod',
      'Serverpod test runner',
      productionMode: false,
      cliVersion: Version(1, 0, 0),
      onBeforeRunCommand: (_) async {},
    )..addCommand(StartCommand());

    try {
      await runner.run(arguments);
    } on ExitException catch (exception) {
      exitCode = exception.exitCode;
    }
  } finally {
    await closeLogger();
  }
}
