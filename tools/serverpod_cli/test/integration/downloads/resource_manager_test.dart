import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/downloads/resource_manager_constants.dart';
import 'package:test/test.dart';

void main() {
  group('Latest Cli Version: ', () {
    var testCacheFolderPath =
        p.join('test', 'integration', 'downloads', 'localCache');

    tearDown(() {
      var directory = Directory(testCacheFolderPath);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });

    test('serialization roundtrip for latest cli version artefact.', () async {
      var storedArtefact = CliVersionData(Version(1, 1, 1), DateTime.now());

      await resourceManager.storeLatestCliVersion(storedArtefact,
          localStoragePath: testCacheFolderPath);

      var fetchedArtefact = await resourceManager.tryFetchLatestCliVersion(
          localStoragePath: testCacheFolderPath);

      expect(fetchedArtefact?.version, storedArtefact.version);
      expect(fetchedArtefact?.validUntil.millisecondsSinceEpoch,
          storedArtefact.validUntil.millisecondsSinceEpoch);
    });

    test('when corrupted file is stored on disk.', () async {
      var file = File(p.join(
          testCacheFolderPath, ResourceManagerConstants.latestVersionFilePath));
      file.createSync(recursive: true);
      file.writeAsStringSync(
          'This is corrupted content and :will not be :parsed as json');
      expect(file.existsSync(), isTrue);

      await resourceManager.tryFetchLatestCliVersion(
          localStoragePath: testCacheFolderPath);

      expect(file.existsSync(), isFalse);
    });
  });

  group('ServerpodCloudData: ', () {
    var testCacheFolderPath = p.join('test', 'downloads', 'localCache');

    tearDown(() {
      var directory = Directory(testCacheFolderPath);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });

    test(
        'Given cloud data when doing storage roundtrip then cloud data values are preserved.',
        () async {
      var storedArtefact = ServerpodCloudData('my-token');

      await resourceManager.storeServerpodCloudData(
        storedArtefact,
        localStoragePath: testCacheFolderPath,
      );

      var fetchedArtefact = await resourceManager.tryFetchServerpodCloudData(
        localStoragePath: testCacheFolderPath,
      );

      expect(fetchedArtefact?.token, storedArtefact.token);
    });

    test(
        'Given cloud data on disk when removing cloud data then file is deleted.',
        () async {
      var storedArtefact = ServerpodCloudData('my-token');

      await resourceManager.storeServerpodCloudData(
        storedArtefact,
        localStoragePath: testCacheFolderPath,
      );

      await resourceManager.removeServerpodCloudData(
        localStoragePath: testCacheFolderPath,
      );

      var serverpodCloudDataFile = File(p.join(
        testCacheFolderPath,
        ResourceManagerConstants.serverpodCloudDataFilePath,
      ));
      expect(serverpodCloudDataFile.existsSync(), isFalse);
    });

    group('Given corrupt cloud data on disk ', () {
      late File file;
      setUp(() async {
        file = File(p.join(testCacheFolderPath,
            ResourceManagerConstants.serverpodCloudDataFilePath));
        file.createSync(recursive: true);
        file.writeAsStringSync(
            'This is corrupted content and :will not be :parsed as json');
      });

      test('when fetching file from disk then null is returned.', () async {
        var cloudData = await resourceManager.tryFetchServerpodCloudData(
          localStoragePath: testCacheFolderPath,
        );

        expect(cloudData, isNull);
      });

      test('when fetching from disk then file is deleted.', () async {
        try {
          await resourceManager.tryFetchServerpodCloudData(
            localStoragePath: testCacheFolderPath,
          );
        } catch (_) {}

        expect(file.existsSync(), isFalse);
      });
    });
  });
}
