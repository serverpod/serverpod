import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/util/pub_api_client.dart';

abstract class LatestCliVersionConstants {
  static const serverpodPackageName = 'serverpod_cli';
  static const badConnectionRetryTimeout = Duration(hours: 1);
  static const localStorageValidityTime = Duration(days: 1);
}

/// Attempts to fetch the latest cli version from either local storage of pub.dev
Future<Version?> tryFetchLatestValidCliVersion({
  localStorageService = const CliVersionStorageService(),
  PubDevService? pubDevService,
}) async {
  var latestCliVersion = await localStorageService.fetchLatestCliVersion();

  if (latestCliVersion != null) return latestCliVersion;

  var service = pubDevService ?? PubDevService();
  latestCliVersion = await service.tryFetchAndStoreLatestVersion();

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
  final String? _optionalLocalStoragePath;
  final PubApiClient _client;

  PubDevService({
    String? optionalLocalStoragePath,
    PubApiClient? pubDevClient,
  })  : _optionalLocalStoragePath = optionalLocalStoragePath,
        _client = pubDevClient ?? PubApiClient();

  Future<Version?> tryFetchAndStoreLatestVersion() async {
    var pubDevLatestVersion = await _client.tryFetchLatestStableVersion(
      LatestCliVersionConstants.serverpodPackageName,
    );

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
        localStoragePath: _optionalLocalStoragePath);
    return returnVersion;
  }
}
