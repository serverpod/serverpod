import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

class UpgradeCommand extends ServerpodCommand {
  @override
  final name = 'upgrade';

  @override
  final description = 'Upgrade Serverpod to the latest version.';

  @override
  void run() async {
    log.info('Updating Serverpod Cli...');

    var startProcess = await Process.start(
        'dart', ['pub', 'global', 'activate', 'serverpod_cli']);
    var exitCode = await startProcess.exitCode;

    if (exitCode == 0) {
      startProcess.stdout.transform(const Utf8Decoder()).listen(log.info);
    } else {
      log.error('Serverpod upgrade failed');
      startProcess.stderr.transform(const Utf8Decoder()).listen(log.error);
    }
  }
}
