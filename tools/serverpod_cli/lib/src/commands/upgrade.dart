import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:pub_api_client/pub_api_client.dart' show PubClient;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/commands/upgrade/upgrade_target.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/dart_install.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../generated/version.dart';

const _packageName = 'serverpod_cli';

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
    StringOption(
      argName: 'version',
      helpText:
          'Install a specific version or version constraint instead of the '
          'newest one in the channel. This is the only way to move the '
          'installation backwards.',
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
    final requestedArgument = commandConfig.optionalValue(
      UpgradeOption.version,
    );
    final requested = requestedArgument == null
        ? null
        : _parseConstraint(requestedArgument);

    final installation = CliInstallation.resolve();
    _verifyInstallationIsUpgradable(installation, force: force);

    final currentVersion = Version.parse(templateVersion);
    final channel =
        commandConfig.optionalValue(UpgradeOption.channel) ??
        UpgradeChannel.forVersion(currentVersion);

    final published = await _fetchPublishedVersions();
    if (published == null) {
      await _installWithoutVersionLookup(
        installation: installation,
        channel: channel,
        requested: requestedArgument,
      );
      return;
    }

    final target = resolveUpgradeTarget(
      current: currentVersion,
      published: published,
      channel: channel,
      requested: requested,
    );

    if (target == null) {
      log.error(
        requestedArgument != null
            ? 'No published version of $_packageName matches '
                  '"$requestedArgument".'
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

  /// Installs without knowing the resulting version, all that is possible
  /// when pub.dev cannot be reached.
  Future<void> _installWithoutVersionLookup({
    required final CliInstallation installation,
    required final UpgradeChannel channel,
    required final String? requested,
  }) async {
    if (requested == null && channel == UpgradeChannel.any) {
      log.error(
        'Could not reach pub.dev to look up the published versions of '
        '$_packageName. Installing without a version would replace the '
        'installation with the latest stable release, which this channel does '
        'not track. Re-run with --version to pick a version explicitly.',
      );
      throw ExitException.error();
    }

    final descriptor = requested == null
        ? _packageName
        : '$_packageName@$requested';
    await _install(descriptor);

    log.info(
      'Installed $descriptor to ${installation.managedBinDirectory}. pub.dev '
      'could not be reached to look up version numbers, so run '
      '"serverpod version" to see what was installed.',
    );
    _warnAboutPathMismatch(installation);
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
      final client = PubClient();
      try {
        final versions = await client
            .packageVersions(_packageName)
            .timeout(const Duration(seconds: 10));
        published = versions.map(_tryParseVersion).nonNulls.toList();
        return true;
      } catch (e) {
        log.debug('Failed to look up published versions of $_packageName: $e');
        return false;
      } finally {
        client.close();
      }
    });

    return published;
  }

  Version? _tryParseVersion(final String version) {
    try {
      return Version.parse(version);
    } on FormatException catch (e) {
      log.debug('Ignoring unparsable version "$version": ${e.message}');
      return null;
    }
  }

  VersionConstraint _parseConstraint(final String value) {
    try {
      return VersionConstraint.parse(value);
    } on FormatException catch (e) {
      log.error('Invalid --version value "$value": ${e.message}');
      throw ExitException.error();
    }
  }
}
