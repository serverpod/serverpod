import 'dart:convert';

import 'package:http/http.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';

const _packageName = 'serverpod_cli';

/// Check current Serverpod CLI version and prompt user to update if needed
Future<void> promptToUpdateIfNeeded(Version currentVersion) async {
  var storageResult = await _StorageService.fetchCachedVersion(currentVersion);

  if (storageResult.status == _CacheResultStatus.versionIsCurrent) {
    return;
  }

  if (storageResult.status == _CacheResultStatus.newVersionAvailable) {
    _printPrompt(storageResult.latestVersion);
    return;
  }

  _Package? package = await _PackageService.getLatestPackage(_packageName);
  if (package == null) {
    // If we didn't get a package back we wait an hour before trying again
    var cliVersionArtefact = LatestCliVersionArtefact(
        Version.none, DateTime.now().add(const Duration(hours: 1)));
    await resourceManager.storeLatestCliVersion(cliVersionArtefact);
    return;
  }

  if (currentVersion < package.version) {
    _printPrompt(package.version);
  }

  var cliVersionArtefact = LatestCliVersionArtefact(
      package.version, DateTime.now().add(const Duration(hours: 24)));
  await resourceManager.storeLatestCliVersion(cliVersionArtefact);
}

abstract class _StorageService {
  static Future<_CacheResult> fetchCachedVersion(Version currentVersion) async {
    var cachedData = await resourceManager.tryFetchLatestCliVersion();
    if (cachedData == null) {
      return _CacheResult(Version.none, _CacheResultStatus.needsUpdate);
    }

    if (currentVersion < cachedData.version) {
      return _CacheResult(
          cachedData.version, _CacheResultStatus.newVersionAvailable);
    }

    return cachedData.validUntil.isBefore(DateTime.now())
        ? _CacheResult(Version.none, _CacheResultStatus.needsUpdate)
        : _CacheResult(currentVersion, _CacheResultStatus.versionIsCurrent);
  }
}

class _CacheResult {
  Version latestVersion;
  _CacheResultStatus status;

  _CacheResult(this.latestVersion, this.status);
}

enum _CacheResultStatus {
  needsUpdate,
  versionIsCurrent,
  newVersionAvailable,
}

abstract class _PackageService {
  static Future<_Package?> getLatestPackage(String name) async {
    try {
      Response response =
          await get(Uri.parse('https://pub.dev/api/packages/$name'))
              .timeout(const Duration(seconds: 2));
      Map<String, dynamic> map = jsonDecode(response.body);
      return _Package(
        name: map['name'],
        version: Version.parse(map['latest']['version']),
      );
    } catch (e) {
      return null;
    }
  }
}

class _Package {
  final String name;
  final Version version;
  _Package({
    required this.name,
    required this.version,
  });
}

void _printPrompt(Version version) {
  print('');
  print(_promptMessage(version));
  print('');
}

String _promptMessage(Version version) {
  var versionLine =
      '│ A new version $version of Serverpod is available!                                              │';
  if (versionLine.length > 89) {
    while (versionLine.length > 89) {
      versionLine = versionLine.removeAtIndex(versionLine.length - 2);
    }
  }

  return '''
┌───────────────────────────────────────────────────────────────────────────────────────┐
$versionLine
│                                                                                       │
│ To update to the latest version, run "serverpod upgrade".                             │
│ Also, do not forget to update packages in your server, client, and flutter projects.  │
└───────────────────────────────────────────────────────────────────────────────────────┘
''';
}

extension on String {
  String removeAtIndex(int i) => substring(0, i) + substring(i + 1);
}
