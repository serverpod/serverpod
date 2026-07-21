@Tags(['migration_artifacts'])
@Timeout(Duration(minutes: 5))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod/src/endpoints/insights.dart';
import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    rollbackDatabase: RollbackDatabase.disabled,
    'Given a pending regular migration with a new protocol model',
    (sessionBuilder, _) async {
      const tableName = 'endpoint_destructive_test_migrated_table';

      setUp(() async {
        var protocols = {
          'endpoint_destructive_test_migrated_table':
              '''
class: EndpointDestructiveTestMigratedTable
table: $tableName
fields:
  anInt: int
''',
        };
        final exitCode = await MigrationTestUtils.createMigrationFromProtocols(
          protocols: protocols,
          tag: 'apply-migrations-endpoint-destructive',
        );
        expect(
          exitCode,
          0,
          reason: 'Failed to create migration, exit code was not 0.',
        );
      });

      tearDown(() async {
        await MigrationTestUtils.migrationArtifactsCleanup();

        final session = sessionBuilder.build();
        await session.db.unsafeExecute('DROP TABLE IF EXISTS $tableName;');

        final versions = await MigrationTestUtils.loadMigrationRegistry();
        final latestMigration = versions.lastOrNull;
        if (latestMigration != null) {
          await session.db.unsafeExecute('''
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '$latestMigration', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '$latestMigration', "timestamp" = now();
''');
        }
      });

      test(
        'when calling the applyMigrations endpoint '
        'then the new migration is applied and integrity is verified.',
        () async {
          final endpoint = InsightsEndpoint();
          final session = sessionBuilder.build();
          final result = await endpoint.applyMigrations(
            session,
            applyRepairMigration: false,
            applyMigrations: true,
          );

          expect(result.migrationsApplied, hasLength(1));
          expect(result.repairMigrationApplied, isNull);
          expect(result.databaseMatchesTargetState, isTrue);
        },
      );
    },
  );

  withServerpod(
    rollbackDatabase: RollbackDatabase.disabled,
    'Given a pending repair migration',
    (sessionBuilder, _) async {
      const tableName = 'endpoint_destructive_test_repair_table';
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
        final session = sessionBuilder.build();
        await session.db.unsafeExecute('''
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
        'when calling the applyMigrations endpoint '
        'then the repair migration is applied and integrity is verified.',
        () async {
          final endpoint = InsightsEndpoint();
          final session = sessionBuilder.build();
          final result = await endpoint.applyMigrations(
            session,
            applyRepairMigration: true,
            applyMigrations: false,
          );

          expect(result.repairMigrationApplied, equals(migrationName));
          expect(result.migrationsApplied, isNull);
          expect(result.databaseMatchesTargetState, isTrue);
        },
      );
    },
  );
}
