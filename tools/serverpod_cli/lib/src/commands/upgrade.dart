import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../generated/version.dart';

/// Options for the `upgrade` command.
enum UpgradeOption<V> implements OptionDefinition<V> {
  /// Option to check for available updates without installing.
  check(
    FlagOption(
      argName: 'check',
      argAbbrev: 'c',
      helpText: 'Check for available updates without installing.',
      negatable: false,
      defaultsTo: false,
    ),
  ),
  ;

  const UpgradeOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Command to upgrade Serverpod CLI to the latest version.
class UpgradeCommand extends ServerpodCommand<UpgradeOption> {
  @override
  final name = 'upgrade';

  @override
  final List<String> aliases = const ['update'];

  @override
  final description = 'Upgrade Serverpod to the latest version.';

  UpgradeCommand() : super(options: UpgradeOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<UpgradeOption> commandConfig,
  ) async {
    var currentVersion = Version.parse(templateVersion);
    var isCheckOnly = commandConfig.value(UpgradeOption.check);

    if (isCheckOnly) {
      await _handleCheckOnly(currentVersion);
      return;
    }

    var success = await _performUpgrade();
    if (!success) {
      log.info('Failed to update Serverpod.');
      throw ExitException.error();
    }

    var latestVersion = await _fetchLatestVersion();
    _reportUpgradeResult(currentVersion, latestVersion);
  }

  /// Fetches the latest stable version of `serverpod_cli` from pub.dev.
  Future<Version?> _fetchLatestVersion() async {
    var pubClient = PubApiClient();
    try {
      return await pubClient.tryFetchLatestStableVersion('serverpod_cli');
    } catch (_) {
      return null;
    } finally {
      pubClient.close();
    }
  }

  /// Handles the `--check` flag execution by checking for updates without installing.
  Future<void> _handleCheckOnly(Version currentVersion) async {
    var latestVersion = await _fetchLatestVersion();

    if (latestVersion == null) {
      log.info('Failed to check for updates.');
    } else if (currentVersion < latestVersion) {
      log.info(
        'A new version of Serverpod CLI is available: $latestVersion (installed: $currentVersion).\n'
        'Run "serverpod upgrade" to update.',
      );
    } else {
      log.info('Serverpod CLI is up to date: $currentVersion.');
    }
  }

  /// Runs `dart install serverpod_cli` to upgrade the CLI to the latest version.
  Future<bool> _performUpgrade() async {
    return await log.progress('Updating Serverpod Cli...', () async {
      log.debug('Running `dart install serverpod_cli`...');
      var startProcess = await Process.start('dart', [
        'install',
        'serverpod_cli',
      ]);
      startProcess.stdout.transform(const Utf8Decoder()).listen(log.debug);
      startProcess.stderr.transform(const Utf8Decoder()).listen(log.error);
      return await startProcess.exitCode == 0;
    });
  }

  /// Reports the result of the upgrade operation to the user.
  void _reportUpgradeResult(Version currentVersion, Version? latestVersion) {
    if (latestVersion != null) {
      if (currentVersion < latestVersion) {
        log.info('Serverpod CLI updated to version $latestVersion.');
      } else {
        log.info('Serverpod CLI is up to date: $latestVersion.');
      }
    } else {
      log.info('Serverpod CLI updated successfully.');
    }
  }
}
