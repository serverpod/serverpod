import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/runner.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

Future<void> main(List<String> arguments) async {
  initializeLogger();
  try {
    final runner =
        ServerpodCommandRunner.createCommandRunner(
            CompoundAnalytics([]),
            false,
            Version(1, 0, 0),
            preCommandHooks: false,
          )
          ..addCommand(RunnerCommand())
          ..addCommand(StartCommand());

    try {
      await runner.run(arguments, env: const {});
    } on ExitException catch (exception) {
      exitCode = exception.exitCode;
    }
  } finally {
    await closeLogger();
  }
}
