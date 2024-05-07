import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/downloads/resource_manager_constants.dart';
import 'package:serverpod_cli/src/logger/loggers/void_logger.dart';
import 'package:serverpod_cli/src/util/package_version.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

void main() {
  var testStorageFolderPath = p.join(
    'test',
    'integration',
    'util',
    'test_assets',
    'temp_package_version',
  );

  initializeLoggerWith(VoidLogger());

  tearDown(() {
    var directory = Directory(testStorageFolderPath);
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  });

  void storeVersionOnDisk(
    Version version,
    DateTime validUntil,
  ) async {
    var storedArtefact = PackageVersionData(version, validUntil);

    await resourceManager.storeLatestCliVersion(storedArtefact,
        localStoragePath: testStorageFolderPath);
    var file = File(p.join(
        testStorageFolderPath, ResourceManagerConstants.latestVersionFilePath));

    expect(file.existsSync(), isTrue);
  }

  var versionForTest = Version(1, 1, 0);

  group('Stored version on disk', () {
    test('fetched with "valid until" time in the future.', () async {
      storeVersionOnDisk(
          versionForTest, DateTime.now().add(const Duration(hours: 1)));

      var fetchedVersion = await PackageVersion.fetchLatestPackageVersion(
        storePackageVersionData: (PackageVersionData versionArtefact) =>
            resourceManager.storeLatestCliVersion(
          versionArtefact,
          localStoragePath: testStorageFolderPath,
        ),
        loadPackageVersionData: () => resourceManager.tryFetchLatestCliVersion(
          localStoragePath: testStorageFolderPath,
        ),
        fetchLatestPackageVersion: () async => null,
      );

      expect(fetchedVersion, isNotNull);
      expect(fetchedVersion, versionForTest);
    });

    group('with "valid until" already passed', () {
      setUp(() {
        storeVersionOnDisk(
            versionForTest,
            DateTime.now().subtract(
              const Duration(hours: 1),
            ));
      });

      test('when successful in fetching latest version from pub.dev.',
          () async {
        var pubDevVersion = versionForTest.nextMajor;

        var fetchedVersion = await PackageVersion.fetchLatestPackageVersion(
          storePackageVersionData: (PackageVersionData versionArtefact) =>
              resourceManager.storeLatestCliVersion(
            versionArtefact,
            localStoragePath: testStorageFolderPath,
          ),
          loadPackageVersionData: () =>
              resourceManager.tryFetchLatestCliVersion(
            localStoragePath: testStorageFolderPath,
          ),
          fetchLatestPackageVersion: () async => pubDevVersion,
        );

        expect(fetchedVersion, isNotNull);
        expect(fetchedVersion, pubDevVersion);
      });

      test('when failed to fetch latest version from pub.dev.', () async {
        var version = await PackageVersion.fetchLatestPackageVersion(
          storePackageVersionData: (PackageVersionData versionArtefact) =>
              resourceManager.storeLatestCliVersion(
            versionArtefact,
            localStoragePath: testStorageFolderPath,
          ),
          loadPackageVersionData: () =>
              resourceManager.tryFetchLatestCliVersion(
            localStoragePath: testStorageFolderPath,
          ),
          fetchLatestPackageVersion: () async => null,
        );

        expect(version, isNull);
      });
    });
  });

  group('No file on disk', () {
    test('when successful in fetching latest version from pub.dev.', () async {
      var version = await PackageVersion.fetchLatestPackageVersion(
        storePackageVersionData: (PackageVersionData versionArtefact) =>
            resourceManager.storeLatestCliVersion(
          versionArtefact,
          localStoragePath: testStorageFolderPath,
        ),
        loadPackageVersionData: () => resourceManager.tryFetchLatestCliVersion(
          localStoragePath: testStorageFolderPath,
        ),
        fetchLatestPackageVersion: () async => versionForTest,
      );

      expect(version, isNotNull);
      expect(version, versionForTest);
      var localStorageFile = File(p.join(testStorageFolderPath,
          ResourceManagerConstants.latestVersionFilePath));
      expect(localStorageFile.existsSync(), isTrue);
    });

    test('when failed to fetch latest version from pub.dev.', () async {
      var version = await PackageVersion.fetchLatestPackageVersion(
        storePackageVersionData: (PackageVersionData versionArtefact) =>
            resourceManager.storeLatestCliVersion(
          versionArtefact,
          localStoragePath: testStorageFolderPath,
        ),
        loadPackageVersionData: () => resourceManager.tryFetchLatestCliVersion(
          localStoragePath: testStorageFolderPath,
        ),
        fetchLatestPackageVersion: () async => null,
      );

      expect(version, isNull);
      var localStorageFile = File(p.join(testStorageFolderPath,
          ResourceManagerConstants.latestVersionFilePath));
      expect(localStorageFile.existsSync(), isTrue);
    });
  });
}
