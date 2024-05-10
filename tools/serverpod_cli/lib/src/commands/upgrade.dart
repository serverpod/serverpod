import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../generated/version.dart';

class UpgradeCommand extends ServerpodCommand {
  @override
  final name = 'upgrade';

  @override
  final description = 'Upgrade Serverpod to the latest version.';

  @override
  void run() async {
    var success = await log.progress('Updating Serverpod Cli...', () async {
      log.debug('Running `dart pub global activate serverpod_cli`...');
      var startProcess = await Process.start(
          'dart', ['pub', 'global', 'activate', 'serverpod_cli']);
      startProcess.stdout.transform(const Utf8Decoder()).listen(log.debug);
      startProcess.stderr.transform(const Utf8Decoder()).listen(log.error);
      return await startProcess.exitCode == 0;
    });

    if (!success) {
      log.info('Failed to update Serverpod.');
      throw ExitException();
    }

    log.info('Serverpod is up to date: $templateVersion version.');
  }
}
