import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = path.join(
    'test',
    'integration',
    'migrations',
    'test_assets',
  );
  var tempDirectory = Directory(path.join(testAssetsPath, 'temp'));

  setUp(() {
    tempDirectory.createSync();
  });

  tearDown(() {
    tempDirectory.deleteSync(recursive: true);
  });

  test(
    'Given an existing directory when writing migration version with same name then exception is thrown.',
    () async {
      var versionName = '00000000000000';
      var versionDirectory = Directory(
        path.join(
          tempDirectory.path,
          'migrations',
          versionName,
        ),
      );
      versionDirectory.createSync(recursive: true);

      var artifactStore = FileSystemMigrationArtifactStore(
        projectDirectory: tempDirectory,
      );
      var emptyDefinition = DatabaseDefinition(
        moduleName: 'example_project',
        tables: [],
        installedModules: [],
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
      );

      await expectLater(
        artifactStore.writeVersion(
          MigrationVersionArtifacts(
            version: versionName,
            definitionSql: '',
            migrationSql: '',
            definition: emptyDefinition,
            projectDefinition: emptyDefinition,
            migration: DatabaseMigration(
              actions: [],
              warnings: [],
              migrationApiVersion: DatabaseConstants.migrationApiVersion,
            ),
          ),
        ),
        throwsA(isA<MigrationVersionAlreadyExistsException>()),
      );
    },
  );
}
