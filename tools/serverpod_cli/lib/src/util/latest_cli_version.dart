import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';

abstract class _LatestCliVersionConstants {
  static const serverpodPackageName = 'serverpod_cli';
  static const cacheBadConnectionRetryTimeout = Duration(hours: 1);
  static const cacheValidityTime = Duration(days: 1);
  static const pubDevConnectionTimeout = Duration(seconds: 2);
}

/// Tries to fetch the latest cli version from either local storage of pub.dev
Future<Version?> tryFetchLatestValidCliVersion({
  localStorageService = const LocalStorageService(),
  pubDevService = const PubDevService(),
}) async {
  var latestCliVersion = await localStorageService.fetchLatestCliVersion();

  if (latestCliVersion != null) return latestCliVersion;

  latestCliVersion = await pubDevService.tryFetchAndStoreLatestVersion();

  return latestCliVersion;
}

class LocalStorageService {
  final String? optionalLocalCachePath;

  const LocalStorageService({this.optionalLocalCachePath});
  LocalStorageService.nonConst({this.optionalLocalCachePath});

  Future<Version?> fetchLatestCliVersion() async {
    var cachedData = await resourceManager.tryFetchLatestCliVersion(
      localCachePath: optionalLocalCachePath,
    );
    if (cachedData == null) return null;

    return cachedData.validUntil.isAfter(DateTime.now())
        ? cachedData.version
        : null;
  }
}

class PubDevService {
  final String? optionalLocalCachePath;
  final http.Client? client;

  const PubDevService({this.optionalLocalCachePath, this.client});
  PubDevService.nonConst({this.optionalLocalCachePath, this.client});

  Future<Version?> tryFetchAndStoreLatestVersion() async {
    var pubDevLatestVersion = await _tryFetchLatestCliVersion();

    LatestCliVersionArtefact versionArtefact;
    Version? returnVersion;
    if (pubDevLatestVersion != null) {
      versionArtefact = LatestCliVersionArtefact(
        pubDevLatestVersion,
        DateTime.now().add(_LatestCliVersionConstants.cacheValidityTime),
      );
      returnVersion = pubDevLatestVersion;
    } else {
      versionArtefact = LatestCliVersionArtefact(
        Version.none,
        DateTime.now()
            .add(_LatestCliVersionConstants.cacheBadConnectionRetryTimeout),
      );
    }

    await resourceManager.storeLatestCliVersion(versionArtefact);
    return returnVersion;
  }

  Future<Version?> _tryFetchLatestCliVersion() async {
    try {
      var uri = Uri.parse(
        'https://pub.dev/api/packages/${_LatestCliVersionConstants.serverpodPackageName}',
      );
      var httpClient = client ?? http.Client();

      var response = await httpClient
          .get(uri)
          .timeout(_LatestCliVersionConstants.pubDevConnectionTimeout);
      Map<String, dynamic> map = jsonDecode(response.body);
      return Version.parse(map['latest']['version']);
    } catch (e) {
      return null;
    }
  }
}
