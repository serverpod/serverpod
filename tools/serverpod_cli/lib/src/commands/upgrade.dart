import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:dart_data_home/dart_data_home.dart';
import 'package:meta/meta.dart' show visibleForTesting;
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

class UpgradeCommand extends ServerpodCommand {
  @override
  final name = 'upgrade';

  @override
  final description = 'Upgrade Serverpod to the latest version.';

  @override
  Future<void> runWithConfig(
    final Configuration commandConfig,
  ) async {
    var success = await log.progress('Updating Serverpod Cli...', () async {
      log.debug('Running `dart install serverpod_cli`...');
      var startProcess = await Process.start('dart', [
        'install',
        'serverpod_cli',
      ]);
      startProcess.stdout.transform(const Utf8Decoder()).listen(log.debug);
      startProcess.stderr.transform(const Utf8Decoder()).listen(log.error);
      return await startProcess.exitCode == 0;
    });

    if (!success) {
      log.info('Failed to update Serverpod.');
      throw ExitException.error();
    }

    final installedVersion = await fetchInstalledCliVersion();
    if (installedVersion == null) {
      log.info(
        'Serverpod was upgraded, but the installed version could not be determined.',
      );
      return;
    }

    log.info('Serverpod is up to date: $installedVersion version.');
  }

  /// Fetches the version of the installed `serverpod_cli` by running
  /// `serverpod version` and parsing the output.
  ///
  /// Returns `null` if the version cannot be determined.
  @visibleForTesting
  Future<Version?> fetchInstalledCliVersion() async {
    log.debug('Running `serverpod version` to determine installed version...');

    final serverpodExecutable = _resolveServerpodExecutablePath();

    try {
      var result = await Process.run(
        serverpodExecutable,
        ['version'],
        stdoutEncoding: utf8,
      );

      if (result.exitCode != 0) {
        log.debug('`serverpod version` failed with exit code ${result.exitCode}.');
        return null;
      }

      final output = result.stdout.toString().trim();
      final nonEmptyLines = output.split('\n').where(
        (line) => line.trim().isNotEmpty,
      );
      if (nonEmptyLines.isEmpty) {
        log.debug('`serverpod version` returned no output.');
        return null;
      }

      final versionLine = nonEmptyLines.last;
      const prefix = 'Serverpod version: ';
      if (!versionLine.startsWith(prefix)) {
        log.debug('Unexpected output from `serverpod version`: $output');
        return null;
      }

      final versionString = versionLine.substring(prefix.length).trim();
      return Version.parse(versionString);
    } on FormatException catch (e) {
      log.debug('Failed to parse installed Serverpod version: $e');
      return null;
    } on ProcessException catch (e) {
      log.debug('Failed to run `serverpod version`: $e');
      return null;
    }
  }

  /// Resolves the path to the `serverpod` executable installed by `dart install`.
  ///
  /// Falls back to invoking `serverpod` from PATH if the dart install directory
  /// does not contain the executable.
  String _resolveServerpodExecutablePath() {
    final name = Platform.isWindows ? 'serverpod.bat' : 'serverpod';

    final dartInstallPath = p.join(getDartDataHome('install'), 'bin', name);
    if (File(dartInstallPath).existsSync()) {
      return dartInstallPath;
    }

    return name;
  }
}
