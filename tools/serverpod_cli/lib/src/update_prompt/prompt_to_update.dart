import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/latest_cli_version.dart';
import 'package:serverpod_cli/src/util/pub_api_client.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Check current Serverpod CLI version and prompt user to update if needed
Future<void> promptToUpdateIfNeeded(Version currentVersion) async {
  var latestVersion = await LatestCliVersion.tryFetchLatestValidCliVersion(
      storeLatestCliVersion: (CliVersionData versionArtefact) =>
          resourceManager.storeLatestCliVersion(
            versionArtefact,
          ),
      fetchLatestCliVersionFromLocalStorage: () =>
          resourceManager.tryFetchLatestCliVersion(),
      fetchLatestCliVersionFromPubDev: () async {
        var pubClient = PubApiClient();
        return await pubClient.tryFetchLatestStableVersion('serverpod_cli');
      });
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
