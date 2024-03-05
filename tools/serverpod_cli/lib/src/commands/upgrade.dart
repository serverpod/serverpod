import 'dart:io';

import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

import '../generated/version.dart';

class UpgradeCommand extends ServerpodCommand {
  @override
  final name = 'upgrade';

  @override
  final description = 'Upgrade Serverpod to the latest version.';

  @override
  void run() async {
    dynamic error;
    var success = await log.progress('Running `dart pub global activate serverpod_cli`...', () async {
      var process = await Process.run('dart', ['pub global activate serverpod_cli']);
      error = process.stderr;
      return !process.exitCode.isNegative;
    });

    if (success) {
      log.info('Serverpod is up to date: $templateVersion version.');
    } else {
      log.error('Serverpod upgrade failed: $error');
    }
  }
}
