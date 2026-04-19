import 'dart:io';

import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../test_tools/serverpod_test_tools.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:serverpod/src/database/server_migration_manager.dart';
import 'package:serverpod_cli/src/migrations/generator.dart';

void main() {
  withServerpod(
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    'Given unapplied migration that errors if applied multiple times',
    (sessionBuilder, _) async {
      final migrationName = MigrationGenerator.createVersionName(null);
      late List<String> existingMigrations;
      late String migrationRegistryContents;
      final testTableName =
          'test_table_${const Uuid().v4().replaceAll('-', '')}';
      final sqlThatThrowsIfAppliedMultipleTimes =
          '''
      BEGIN;

      CREATE TABLE ${testTableName} (
        id INT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
      );

      -- Delay to ensure multiple concurrent migrations are triggered at the same time.
      -- SQLite has no sleep: use a recursive CTE to burn CPU for ~1 second.
      WITH RECURSIVE r(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM r LIMIT 2000000)
      SELECT 1 FROM r;

      --
      -- MIGRATION VERSION FOR serverpod_test_sqlite
      --
      INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
          VALUES ('serverpod_test_sqlite', '${migrationName}', (unixepoch('subsecond') * 1000))
          ON CONFLICT ("module")
          DO UPDATE SET "version" = '${migrationName}', "timestamp" = (unixepoch('subsecond') * 1000);

      COMMIT;
    ''';

      setUp(() async {
        existingMigrations = await ServerMigrationManager(
          Directory.current,
        ).listAvailableVersions();

        migrationRegistryContents = [
          ...existingMigrations,
          migrationName,
        ].join('\n');

        const minimalDefinition = '''
{
  "moduleName": "serverpod_test_sqlite",
  "tables": [],
  "installedModules": [],
  "migrationApiVersion": 1
}
''';
        const minimalMigration = '''
{
  "actions": [],
  "warnings": [],
  "migrationApiVersion": 1
}
''';

        await d.dir('migrations', [
          d.file('migration_registry.txt', migrationRegistryContents),
          for (var version in existingMigrations) d.dir(version, []),
          d.dir(migrationName, [
            d.file('definition_project.json', minimalDefinition),
            d.file('definition.json', minimalDefinition),
            d.file('migration.json', minimalMigration),
            d.file('migration.sql', sqlThatThrowsIfAppliedMultipleTimes),
            d.file('definition.sql', sqlThatThrowsIfAppliedMultipleTimes),
          ]),
        ]).create();
      });

      tearDown(() async {
        var session = sessionBuilder.build();
        await session.db.unsafeExecute('''
        BEGIN;

        DROP TABLE IF EXISTS ${testTableName};

        --
        -- MIGRATION VERSION FOR serverpod_test_sqlite
        --
        INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
            VALUES ('serverpod_test_sqlite', '${existingMigrations.last}', (unixepoch('subsecond') * 1000))
            ON CONFLICT ("module")
            DO UPDATE SET "version" = '${existingMigrations.last}', "timestamp" = (unixepoch('subsecond') * 1000);

        COMMIT;
      ''');
      });

      test(
        'when triggering multiple concurrent then migration is successfully applied once',
        () async {
          var migrationManager = ServerMigrationManager(
            Directory(d.sandbox),
          );

          var concurrentMigrations = Future.wait([
            migrationManager.migrateToLatest(sessionBuilder.build()),
            migrationManager.migrateToLatest(sessionBuilder.build()),
          ]);

          expect(concurrentMigrations, completes);
        },
      );
    },
  );
}
