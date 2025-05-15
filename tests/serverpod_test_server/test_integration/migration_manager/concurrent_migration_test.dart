import 'dart:io';

import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../test_tools/serverpod_test_tools.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:serverpod/src/database/migrations/migration_manager.dart';
import 'package:serverpod/src/database/migrations/migrations.dart';
import 'package:serverpod_cli/src/migrations/generator.dart';

void main() {
  final existingMigrations = MigrationVersions.listVersions(
    projectDirectory: Directory.current,
  );

  withServerpod(
      rollbackDatabase: RollbackDatabase.disabled,
      testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
      'Given unapplied migration that errors if applied multiple times',
      (sessionBuilder, _) async {
    final migrationName = MigrationGenerator.createVersionName(null);
    final migrationRegistryContents =
        [...existingMigrations, migrationName].join('\n');
    final testTableName = 'test_table_${const Uuid().v4().replaceAll('-', '')}';
    final sqlThatThrowsIfAppliedMultipleTimes = '''
      BEGIN;

      CREATE TABLE ${testTableName} (
        id INT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
      );

      -- Sleep for 1 second to ensure multiple concurrent migrations
      -- are triggered at the same time
      SELECT pg_sleep(1);

      --
      -- MIGRATION VERSION FOR serverpod_test
      --
      INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
          VALUES ('serverpod_test', '${migrationName}', now())
          ON CONFLICT ("module")
          DO UPDATE SET "version" = '${migrationName}', "timestamp" = now();

      COMMIT;
    ''';

    setUp(() async {
      await d.dir('migrations', [
        d.file('migration_registry.txt', migrationRegistryContents),
        for (var version in existingMigrations) d.dir(version, []),
        d.dir(migrationName, [
          d.file('definition_project.json', ''),
          d.file('definition.json', ''),
          d.file('migration.json', ''),
          d.file('migration.sql', sqlThatThrowsIfAppliedMultipleTimes),
          d.file('definition.sql', sqlThatThrowsIfAppliedMultipleTimes),
        ])
      ]).create();
    });

    tearDown(() async {
      var session = sessionBuilder.build();
      await session.db.unsafeExecute('''
        BEGIN; 

        DROP TABLE IF EXISTS ${testTableName};

        --
        -- MIGRATION VERSION FOR serverpod_test
        --
        INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
            VALUES ('serverpod_test', '${existingMigrations.last}', now())
            ON CONFLICT ("module")
            DO UPDATE SET "version" = '${existingMigrations.last}', "timestamp" = now();

        COMMIT;
      ''');
    });

    test(
        'when triggering multiple concurrent then migration is successfully applied once',
        () async {
      var migrationManager = MigrationManager(
        Directory(d.sandbox),
      );

      var concurrentMigrations = Future.wait([
        migrationManager.migrateToLatest(sessionBuilder.build()),
        migrationManager.migrateToLatest(sessionBuilder.build()),
      ]);

      expect(concurrentMigrations, completes);
    });
  });
}
