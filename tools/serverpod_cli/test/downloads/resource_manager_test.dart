import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/downloads/resource_manager_constants.dart';
import 'package:test/test.dart';

void main() {
  group('Latest Cli Version', () {
    var testCacheFolderPath = p.join('test', 'downloads', 'localCache');

    tearDown(() {
      var directory = Directory(testCacheFolderPath);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });

    test('Serialization roundtrip for latest cli version artefact', () async {
      var storedArtefact =
          LatestCliVersionArtefact(Version(1, 1, 1), DateTime.now());

      await resourceManager.storeLatestCliVersion(storedArtefact,
          localCachePath: testCacheFolderPath);

      var fetchedArtefact = await resourceManager.tryFetchLatestCliVersion(
          localCachePath: testCacheFolderPath);

      expect(fetchedArtefact?.version, storedArtefact.version);
      expect(fetchedArtefact?.validUntil.millisecondsSinceEpoch,
          storedArtefact.validUntil.millisecondsSinceEpoch);
    });

    test('Corrupted file on disk is removed', () async {
      var file =
          File(p.join(testCacheFolderPath, LatestCliVersionConstants.filePath));
      file.createSync(recursive: true);
      file.writeAsStringSync(
          'This is corrupted content and :will not be :parsed as yaml');
      expect(file.existsSync(), isTrue);

      await resourceManager.tryFetchLatestCliVersion(
          localCachePath: testCacheFolderPath);

      expect(file.existsSync(), isFalse);
    });
  });
}
