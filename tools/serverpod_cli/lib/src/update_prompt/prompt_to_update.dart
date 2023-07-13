import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/util/latest_cli_version.dart';

/// Check current Serverpod CLI version and prompt user to update if needed
Future<void> promptToUpdateIfNeeded(Version currentVersion) async {
  var latestVersion = await tryFetchLatestValidCliVersion();
  if (latestVersion == null) return;

  if (currentVersion < latestVersion) {
    _printPrompt(latestVersion);
  }
}

void _printPrompt(Version version) {
  print('');
  print(_promptMessage(version));
  print('');
}

String _promptMessage(Version version) {
  var versionLine = '│ A new version $version of Serverpod is available!'
      '                                              │';
  if (versionLine.length > 89) {
    while (versionLine.length > 89) {
      versionLine = versionLine.removeAtIndex(versionLine.length - 2);
    }
  }

  return '''
┌───────────────────────────────────────────────────────────────────────────────────────┐
$versionLine
│                                                                                       │
│ To update to the latest version, run "dart pub global activate serverpod_cli".        │
│ Also, do not forget to update packages in your server, client, and flutter projects.  │
└───────────────────────────────────────────────────────────────────────────────────────┘
''';
}

extension on String {
  String removeAtIndex(int i) => substring(0, i) + substring(i + 1);
}
