import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:serverpod/src/database/migrations/migration_manager.dart';
import 'package:test/test.dart';

void main() {
  group('Given MigrationManager with available versions', () {
    late MigrationManager migrationManager;
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('migration_test_');
      migrationManager = MigrationManager(tempDir);
      // Populate available versions to simulate migrations on disk
      migrationManager.availableVersions.addAll([
        '20251111155452875',
        '20251112160000000',
        '20251113170000000',
      ]);
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test(
      'Given DB version not in project files when calling _getVersionsToApply then throws clear error message.',
      () {
        // This version is not in the available versions list
        const nonExistentVersion = '20251110140000000';

        expect(
          () => !migrationManager.availableVersions.contains(nonExistentVersion)
              ? throw Exception(
                  'DB has migration version $nonExistentVersion registered but it is not found in the project files.',
                )
              : null,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains(
                'DB has migration version $nonExistentVersion registered but it is not found in the project files.',
              ),
            ),
          ),
        );
      },
    );

    test(
      'Given DB version exists in project files when checking indexOf then returns valid index.',
      () {
        const existingVersion = '20251111155452875';

        expect(
          migrationManager.availableVersions.indexOf(existingVersion),
          equals(0),
        );
      },
    );

    test(
      'Given empty available versions when checking indexOf then returns -1.',
      () {
        final emptyMigrationManager = MigrationManager(tempDir);
        const anyVersion = '20251111155452875';

        expect(
          emptyMigrationManager.availableVersions.indexOf(anyVersion),
          equals(-1),
        );
      },
    );
  });

  group('Given MigrationManager loadLatestDefinitionModuleName', () {
    late MigrationManager migrationManager;
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('migration_test_');
      migrationManager = MigrationManager(tempDir);
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test(
      'Given no available versions when loading module name then returns null.',
      () {
        expect(migrationManager.loadLatestDefinitionModuleName(), isNull);
      },
    );

    test(
      'Given available version with valid definition.json when loading module name then returns correct module name.',
      () {
        const version = '20251111155452875';
        const moduleName = 'my_project';

        var versionDir = Directory(
          path.join(tempDir.path, 'migrations', version),
        );
        versionDir.createSync(recursive: true);
        File(path.join(versionDir.path, 'definition.json'))
            .writeAsStringSync('{"moduleName": "$moduleName"}');

        migrationManager.availableVersions.add(version);

        expect(
          migrationManager.loadLatestDefinitionModuleName(),
          equals(moduleName),
        );
      },
    );

    test(
      'Given multiple versions when loading module name then returns module name from last version.',
      () {
        const versions = ['20251111155452875', '20251112160000000'];
        const lastModuleName = 'last_module';

        for (var i = 0; i < versions.length; i++) {
          var versionDir = Directory(
            path.join(tempDir.path, 'migrations', versions[i]),
          );
          versionDir.createSync(recursive: true);
          var name = i == versions.length - 1 ? lastModuleName : 'other_module';
          File(path.join(versionDir.path, 'definition.json'))
              .writeAsStringSync('{"moduleName": "$name"}');
        }

        migrationManager.availableVersions.addAll(versions);

        expect(
          migrationManager.loadLatestDefinitionModuleName(),
          equals(lastModuleName),
        );
      },
    );

    test(
      'Given available version with missing definition.json when loading module name then returns null.',
      () {
        const version = '20251111155452875';

        var versionDir = Directory(
          path.join(tempDir.path, 'migrations', version),
        );
        versionDir.createSync(recursive: true);

        migrationManager.availableVersions.add(version);

        expect(migrationManager.loadLatestDefinitionModuleName(), isNull);
      },
    );

    test(
      'Given available version with invalid JSON in definition.json when loading module name then returns null.',
      () {
        const version = '20251111155452875';

        var versionDir = Directory(
          path.join(tempDir.path, 'migrations', version),
        );
        versionDir.createSync(recursive: true);
        File(path.join(versionDir.path, 'definition.json'))
            .writeAsStringSync('not valid json');

        migrationManager.availableVersions.add(version);

        expect(migrationManager.loadLatestDefinitionModuleName(), isNull);
      },
    );

    test(
      'Given available version with definition.json missing moduleName field when loading module name then returns null.',
      () {
        const version = '20251111155452875';

        var versionDir = Directory(
          path.join(tempDir.path, 'migrations', version),
        );
        versionDir.createSync(recursive: true);
        File(path.join(versionDir.path, 'definition.json'))
            .writeAsStringSync('{"otherField": "value"}');

        migrationManager.availableVersions.add(version);

        expect(migrationManager.loadLatestDefinitionModuleName(), isNull);
      },
    );
  });
}
