import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/commands/upgrade/published_versions.dart';
import 'package:serverpod_cli/src/commands/upgrade/upgrade_target.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/dart_install.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../generated/version.dart';

const _packageName = 'serverpod_cli';

/// Parses `--version` values, rejecting anything but a single version.
class _VersionParser extends ValueParser<Version> {
  const _VersionParser();

  @override
  Version parse(final String value) => Version.parse(value);
}

enum UpgradeOption<V> implements OptionDefinition<V> {
  channel(
    EnumOption(
      enumParser: EnumParser(UpgradeChannel.values),
      argName: 'channel',
      helpText:
          'Which published versions to consider. Defaults to following '
          'prereleases when a prerelease is installed, and stable releases '
          'otherwise.',
      allowedValues: UpgradeChannel.values,
      allowedHelp: {
        'stable': 'Only install stable releases',
        'any': 'Install the newest version, including prereleases',
      },
    ),
  ),
  version(
    ComparableValueOption<Version>(
      valueParser: _VersionParser(),
      argName: 'version',
      valueHelp: 'version',
      helpText:
          'Install a specific version instead of the newest one in the '
          'channel. This is the only way to move the installation backwards.',
    ),
  ),
  force(
    FlagOption(
      argName: 'force',
      argAbbrev: 'f',
      defaultsTo: false,
      negatable: false,
      helpText:
          'Install even when the installed version is already the target, or '
          'when the CLI being run is not the one that would be replaced.',
    ),
  );

  const UpgradeOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class UpgradeCommand extends ServerpodCommand<UpgradeOption> {
  static const String commandName = 'upgrade';

  UpgradeCommand() : super(options: UpgradeOption.values);

  @override
  final name = commandName;

  @override
  final description = 'Upgrade the Serverpod CLI to the latest version.';

  @override
  Future<void> runWithConfig(
    final Configuration commandConfig,
  ) async {
    final force = commandConfig.value(UpgradeOption.force);
    final requested = commandConfig.optionalValue(UpgradeOption.version);

    final installation = CliInstallation.resolve();
    _verifyInstallationIsUpgradable(installation, force: force);

    final currentVersion = Version.parse(templateVersion);
    final channel =
        commandConfig.optionalValue(UpgradeOption.channel) ??
        UpgradeChannel.forVersion(currentVersion);

    final published = await _fetchPublishedVersions();
    if (published == null) {
      log.error(
        'Could not reach pub.dev to look up the published versions of '
        '$_packageName.',
      );
      throw ExitException.error();
    }

    final target = resolveUpgradeTarget(
      current: currentVersion,
      published: published,
      channel: channel,
      requested: requested,
    );

    if (target == null) {
      log.error(
        requested != null
            ? 'Version $requested of $_packageName is not published.'
            : 'Found no published versions of $_packageName.',
      );
      throw ExitException.error();
    }

    final version = target.version;

    if (target.action == UpgradeAction.downgradeBlocked) {
      final suggestions = [
        if (channel == UpgradeChannel.stable)
          '"serverpod upgrade --channel any" to follow prereleases',
        '"serverpod upgrade --version $version" to install that version',
      ];
      log.error(
        'The installed Serverpod CLI ($currentVersion) is newer than the '
        'newest published version in this channel ($version), so there is '
        'nothing to upgrade to.\n'
        'Run ${suggestions.join(', or ')}.',
      );
      throw ExitException.error();
    }

    if (target.action == UpgradeAction.upToDate && !force) {
      log.info('The Serverpod CLI is already up to date ($currentVersion).');
      _warnAboutPathMismatch(installation);
      return;
    }

    await _install('$_packageName@$version');
    _reportInstalled(
      installation: installation,
      from: currentVersion,
      installed: version,
    );
  }

  /// Refuses to install when the CLI being run is not the one an upgrade
  /// replaces.
  void _verifyInstallationIsUpgradable(
    final CliInstallation installation, {
    required final bool force,
  }) {
    final message = switch (installation.kind) {
      CliInstallationKind.managed => null,
      CliInstallationKind.source =>
        'Serverpod $templateVersion is running from a source checkout '
            '(${installation.runningExecutable}). "serverpod upgrade" updates '
            'the CLI installed in ${installation.managedBinDirectory}, not '
            'this checkout.',
      CliInstallationKind.foreign =>
        'Serverpod $templateVersion is running from '
            '${installation.invokedExecutable}, which "dart install" does not '
            'manage. Upgrading installs into '
            '${installation.managedBinDirectory} and leaves the executable '
            'you just ran untouched.\n'
            'If it came from "dart pub global activate", run '
            '"dart pub global deactivate $_packageName" to remove it. '
            'Otherwise, fix the order of your PATH.',
    };

    if (message == null) return;

    if (force) {
      log.warning(message);
      return;
    }

    log.error('$message\nRe-run with --force to install anyway.');
    throw ExitException.error();
  }

  /// Reports what was installed, and nothing about what `serverpod` runs.
  void _reportInstalled({
    required final CliInstallation installation,
    required final Version from,
    required final Version installed,
  }) {
    if (!installation.upgradesRunningExecutable) {
      log.info(
        'Installed $_packageName $installed to '
        '${installation.managedBinDirectory}.',
      );
    } else if (installed > from) {
      log.info('Upgraded the Serverpod CLI: $from -> $installed.');
    } else if (installed < from) {
      log.info('Downgraded the Serverpod CLI: $from -> $installed.');
    } else {
      log.info('Reinstalled the Serverpod CLI ($installed).');
    }

    _warnAboutPathMismatch(installation);

    log.info(
      'Remember to update the Serverpod dependencies in your server, client, '
      'and Flutter projects.',
    );
  }

  /// Warns when `serverpod` resolves to an executable this command did not
  /// install.
  void _warnAboutPathMismatch(final CliInstallation installation) {
    final executableOnPath = installation.executableOnPath;
    if (executableOnPath == null) {
      log.warning(
        'No "serverpod" executable was found on PATH. Add '
        '${installation.managedBinDirectory} to your PATH to use the '
        'installed CLI.',
      );
      return;
    }

    if (installation.pathResolvesToManaged) return;

    log.warning(
      '"serverpod" on your PATH resolves to $executableOnPath, which this '
      'command did not change. That is the CLI that runs the next time you '
      'type "serverpod".',
    );
  }

  Future<void> _install(final String descriptor) async {
    final result = await runDartInstall(
      descriptor,
      message: 'Installing $descriptor',
    );
    if (result.success) return;

    final details = result.errorOutput;
    log.error(
      'Failed to install $descriptor.${details.isEmpty ? '' : '\n$details'}',
    );
    throw ExitException.error();
  }

  /// Fetches every CLI version published to pub.dev, or `null` if pub.dev
  /// could not be reached.
  Future<List<Version>?> _fetchPublishedVersions() async {
    List<Version>? published;

    await log.progress('Looking up published Serverpod versions', () async {
      published = await fetchPublishedVersions(_packageName);
      return published != null;
    });

    return published;
  }
}
