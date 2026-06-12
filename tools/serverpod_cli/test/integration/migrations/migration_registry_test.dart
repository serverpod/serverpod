import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = path.join(
    'test',
    'integration',
    'migrations',
    'test_assets',
  );

  group(
    'Given a migration folder with multiple migrations',
    () {
      var projectDirectory = Directory(
        path.join(testAssetsPath, 'multiple_migrations'),
      );

      test(
        'when loading migration registry then migrations are listed in alphabetical sorting order',
        () async {
          var artifactStore = FileSystemMigrationArtifactStore(
            projectDirectory: projectDirectory,
          );
          var versions = await artifactStore.listVersions();

          expect(versions, [
            '00000000000000',
            '00000000000001',
            '00000000000002',
            '00000000000002-1',
            '00000000000002-2',
            '00000000000002-a',
            '00000000000002-b',
          ]);
        },
      );
    },
  );
}
