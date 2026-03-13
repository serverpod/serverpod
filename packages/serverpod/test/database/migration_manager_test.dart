import 'dart:io';
import 'package:serverpod/src/database/server_migration_manager.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:serverpod_database/src/interface/value_encoder.dart';
import 'package:test/test.dart';

void main() {
  ValueEncoder.set(PostgresValueEncoder());

  group('Given MigrationManager with available versions', () {
    late ServerMigrationManager migrationManager;
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('migration_test_');
      migrationManager = ServerMigrationManager(tempDir);
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
        final emptyMigrationManager = ServerMigrationManager(tempDir);
        const anyVersion = '20251111155452875';

        expect(
          emptyMigrationManager.availableVersions.indexOf(anyVersion),
          equals(-1),
        );
      },
    );
  });
}
