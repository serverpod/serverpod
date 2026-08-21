import 'dart:io';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:test/test.dart';

void main() {
  ValueEncoder.set(const PostgresValueEncoder());

  group('Given MigrationManager with available versions', () {
    late MigrationManager migrationManager;
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('migration_test_');
      migrationManager = MigrationManager.fromDirectory(tempDir);
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
      'when the DB version is not in project files '
      'then getVersionsToApply throws MigrationVersionNotFoundException.',
      () {
        const nonExistentVersion = '20251110140000000';

        expect(
          () => migrationManager.getVersionsToApply(nonExistentVersion),
          throwsA(
            isA<MigrationVersionNotFoundException>().having(
              (e) => e.registeredVersion,
              'registeredVersion',
              nonExistentVersion,
            ),
          ),
        );
      },
    );

    test(
      'when the DB version exists in project files '
      'then getVersionsToApply returns later versions.',
      () {
        expect(
          migrationManager.getVersionsToApply('20251111155452875'),
          ['20251112160000000', '20251113170000000'],
        );
      },
    );

    test(
      'when available versions are empty then indexOf returns -1.',
      () {
        final emptyMigrationManager = MigrationManager.fromDirectory(tempDir);
        const anyVersion = '20251111155452875';

        expect(
          emptyMigrationManager.availableVersions.indexOf(anyVersion),
          equals(-1),
        );
      },
    );
  });
}
