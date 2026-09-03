import 'package:cli_tools/cli_tools.dart';
import 'package:meta/meta.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade/published_versions.dart';
import 'package:serverpod_cli/src/commands/upgrade/upgrade_target.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

const _packageName = 'serverpod_cli';

/// Check current Serverpod CLI version and prompt user to update if needed
Future<void> promptToUpdateIfNeeded(Version currentVersion) async {
  var latestVersion = await PackageVersion.fetchLatestPackageVersion(
    storePackageVersionData: (PackageVersionData versionArtefact) =>
        resourceManager.storeLatestCliVersion(
          versionArtefact,
        ),
    loadPackageVersionData: () => resourceManager.tryFetchLatestCliVersion(),
    fetchLatestPackageVersion: () async {
      var published = await fetchPublishedVersions(
        _packageName,
        timeout: const Duration(seconds: 2),
      );
      if (published == null) return null;

      return latestVersionToPrompt(currentVersion, published);
    },
  );
  if (latestVersion == null) return;

  if (currentVersion < latestVersion) {
    _printPrompt(latestVersion);
  }
}

/// The version `serverpod upgrade` would install for [currentVersion], so the
/// prompt names the version the command goes on to install.
@visibleForTesting
Version? latestVersionToPrompt(
  final Version currentVersion,
  final Iterable<Version> published,
) => resolveUpgradeTarget(
  current: currentVersion,
  published: published,
  channel: UpgradeChannel.forVersion(currentVersion),
)?.version;

void _printPrompt(Version version) {
  var message = '''A new version $version of Serverpod is available!

To update to the latest version, run "serverpod upgrade".
Also, do not forget to update packages in your server, client, and flutter projects.''';

  log.info(
    message,
    type: const BoxLogType(newParagraph: true),
  );
}
