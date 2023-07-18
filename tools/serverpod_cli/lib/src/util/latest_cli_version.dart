import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';

abstract class LatestCliVersionConstants {
  static const pubDevUri = 'https://pub.dev/api/packages/serverpod_cli';
  static const badConnectionRetryTimeout = Duration(hours: 1);
  static const localStorageValidityTime = Duration(days: 1);
  static const pubDevConnectionTimeout = Duration(seconds: 2);
}

/// Attempts to fetch the latest cli version from either local storage of pub.dev
Future<Version?> tryFetchLatestValidCliVersion({
  localStorageService = const CliVersionStorageService(),
  pubDevService = const PubDevService(),
}) async {
  var latestCliVersion = await localStorageService.fetchLatestCliVersion();

  if (latestCliVersion != null) return latestCliVersion;

  latestCliVersion = await pubDevService.tryFetchAndStoreLatestVersion();

  return latestCliVersion;
}

class CliVersionStorageService {
  final String? optionalLocalStoragePath;

  const CliVersionStorageService({this.optionalLocalStoragePath});

  Future<Version?> fetchLatestCliVersion() async {
    var localStorageData = await resourceManager.tryFetchLatestCliVersion(
      localStoragePath: optionalLocalStoragePath,
    );
    if (localStorageData == null) return null;

    return localStorageData.validUntil.isAfter(DateTime.now())
        ? localStorageData.version
        : null;
  }
}

class PubDevService {
  final String? optionalLocalStoragePath;
  final http.Client? client;
  final Duration timeout;

  const PubDevService({
    this.optionalLocalStoragePath,
    this.client,
    this.timeout = LatestCliVersionConstants.pubDevConnectionTimeout,
  });

  Future<Version?> tryFetchAndStoreLatestVersion() async {
    var pubDevLatestVersion = await _tryFetchLatestCliVersion();

    CliVersionData versionArtefact;
    Version? returnVersion;
    if (pubDevLatestVersion != null) {
      versionArtefact = CliVersionData(
        pubDevLatestVersion,
        DateTime.now().add(LatestCliVersionConstants.localStorageValidityTime),
      );
      returnVersion = pubDevLatestVersion;
    } else {
      versionArtefact = CliVersionData(
        Version.none,
        DateTime.now().add(LatestCliVersionConstants.badConnectionRetryTimeout),
      );
    }

    await resourceManager.storeLatestCliVersion(versionArtefact,
        localStoragePath: optionalLocalStoragePath);
    return returnVersion;
  }

  Future<Version?> _tryFetchLatestCliVersion() async {
    try {
      var uri = Uri.parse(
        LatestCliVersionConstants.pubDevUri,
      );
      var httpClient = client ?? http.Client();

      var response = await httpClient.get(uri).timeout(timeout);
      if (response.statusCode != HttpStatus.ok) return null;

      Map<String, dynamic> map = jsonDecode(response.body);
      return Version.parse(map['latest']['version']);
    } catch (e) {
      return null;
    }
  }
}
