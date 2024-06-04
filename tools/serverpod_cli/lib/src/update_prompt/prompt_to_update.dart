import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Check current Serverpod CLI version and prompt user to update if needed
Future<void> promptToUpdateIfNeeded(Version currentVersion) async {
  var latestVersion = await PackageVersion.fetchLatestPackageVersion(
    storePackageVersionData: (PackageVersionData versionArtefact) =>
        resourceManager.storeLatestCliVersion(
      versionArtefact,
    ),
    loadPackageVersionData: () => resourceManager.tryFetchLatestCliVersion(),
    fetchLatestPackageVersion: () async {
      var pubClient = PubApiClient();
      Version? version;
      try {
        version = await pubClient.tryFetchLatestStableVersion('serverpod_cli');
      } on VersionFetchException catch (e) {
        log.error(e.message);
      } on VersionParseException catch (e) {
        log.error(e.message);
      } finally {
        pubClient.close();
      }

      return version;
    },
  );
  if (latestVersion == null) return;

  if (currentVersion < latestVersion) {
    _printPrompt(latestVersion);
  }
}

void _printPrompt(Version version) {
  var message = '''A new version $version of Serverpod is available!

To update to the latest version, run "dart pub global activate serverpod_cli".
Also, do not forget to update packages in your server, client, and flutter projects.''';

  log.info(
    message,
    type: const BoxLogType(newParagraph: true),
  );
}
