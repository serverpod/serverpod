@Timeout(Duration(minutes: 5))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a pending regular migration with a new protocol model', () {
    const tableName = 'endpoint_test_migrated_table';

    setUp(() async {
      var protocols = {
        'endpoint_test_migrated_table':
            '''
class: EndpointTestMigratedTable
table: $tableName
fields:
  anInt: int
''',
      };

      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: protocols,
            tag: 'apply-migrations-from-endpoint',
          );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS $tableName;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when applying migrations through the applyMigrations endpoint '
      'then the migration is applied and integrity is verified.',
      () async {
        final result = await serviceClient.insights.applyMigrations(
          applyRepairMigration: false,
          applyMigrations: true,
        );

        expect(result.migrationsApplied, hasLength(1));
        expect(result.repairMigrationApplied, isNull);
        expect(result.databaseMatchesTargetState, isTrue);

        final liveDefinition = await serviceClient.insights
            .getLiveDatabaseDefinition();
        final databaseTables = liveDefinition.tables.map((t) => t.name);
        expect(
          databaseTables,
          contains(tableName),
          reason:
              'The newly migrated table was not found in the live database.',
        );
      },
    );
  });

  group('Given a pending repair migration', () {
    const tableName = 'endpoint_test_repair_table';
    final migrationName = MigrationGenerator.createVersionName(null);
    final repairSql =
        '''
BEGIN;

CREATE TABLE IF NOT EXISTS $tableName (
  id INT PRIMARY KEY,
  name VARCHAR(255)
);

INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('_repair', '$migrationName', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '$migrationName', "timestamp" = now();

COMMIT;
''';

    setUp(() async {
      final repairDir = Directory(
        path.join(Directory.current.path, 'repair-migration'),
      );
      repairDir.createSync(recursive: true);
      File(
        path.join(repairDir.path, '$migrationName.sql'),
      ).writeAsStringSync(repairSql);
    });

    tearDown(() async {
      await serviceClient.insights.executeSql('''
        BEGIN;

        DROP TABLE IF EXISTS $tableName;

        DELETE FROM "serverpod_migrations"
          WHERE "module" = '_repair'
          AND "version" = '$migrationName';

        COMMIT;
      ''');
      MigrationTestUtils.removeRepairMigration();
    });

    test(
      'when applying the repair migration through the applyMigrations endpoint '
      'then the repair migration is applied and integrity is verified.',
      () async {
        final result = await serviceClient.insights.applyMigrations(
          applyRepairMigration: true,
          applyMigrations: false,
        );

        expect(result.repairMigrationApplied, equals(migrationName));
        expect(result.migrationsApplied, isNull);
        expect(result.databaseMatchesTargetState, isTrue);
      },
    );
  });
}
