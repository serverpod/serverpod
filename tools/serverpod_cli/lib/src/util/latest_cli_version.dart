import 'package:pub_semver/pub_semver.dart';

abstract class LatestCliVersionConstants {
  static const badConnectionRetryTimeout = Duration(hours: 1);
  static const localStorageValidityTime = Duration(days: 1);
}

abstract class LatestCliVersion {
  static Future<Version?> tryFetchLatestValidCliVersion({
    required Future<void> Function(CliVersionData versionArtefact)
        storeLatestCliVersion,
    required Future<CliVersionData?> Function()
        fetchLatestCliVersionFromLocalStorage,
    required Future<Version?> Function() fetchLatestCliVersionFromPubDev,
  }) async {
    var storedVersionData = await fetchLatestCliVersionFromLocalStorage();

    if (storedVersionData != null && _validVersion(storedVersionData)) {
      return storedVersionData.version;
    }

    var pubDevVersion = await fetchLatestCliVersionFromPubDev();

    await _storePubDevVersion(
      pubDevVersion,
      storeLatestCliVersion: storeLatestCliVersion,
    );

    return pubDevVersion;
  }

  static bool _validVersion(CliVersionData versionData) {
    return versionData.validUntil.isAfter(DateTime.now());
  }

  static Future<void> _storePubDevVersion(
    Version? version, {
    required Future<void> Function(CliVersionData versionArtefact)
        storeLatestCliVersion,
  }) async {
    CliVersionData versionArtefact;
    if (version != null) {
      versionArtefact = CliVersionData(
        version,
        DateTime.now().add(LatestCliVersionConstants.localStorageValidityTime),
      );
    } else {
      versionArtefact = CliVersionData(
        Version.none,
        DateTime.now().add(LatestCliVersionConstants.badConnectionRetryTimeout),
      );
    }

    await storeLatestCliVersion(versionArtefact);
  }
}

class CliVersionData {
  Version version;
  DateTime validUntil;

  CliVersionData(this.version, this.validUntil);

  factory CliVersionData.fromJson(Map<String, dynamic> json) => CliVersionData(
        Version.parse(json['version']),
        DateTime.fromMillisecondsSinceEpoch(json['valid_until']),
      );

  Map<String, dynamic> toJson() => {
        'version': version.toString(),
        'valid_until': validUntil.millisecondsSinceEpoch
      };
}
