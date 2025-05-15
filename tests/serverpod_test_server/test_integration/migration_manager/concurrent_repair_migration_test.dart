import 'dart:io';

import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../test_tools/serverpod_test_tools.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:serverpod/src/database/migrations/migration_manager.dart';
import 'package:serverpod_cli/src/migrations/generator.dart';

void main() {
  withServerpod(
      rollbackDatabase: RollbackDatabase.disabled,
      testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
      'Given unapplied repair migration that errors if applied multiple times',
      (sessionBuilder, _) async {
    final migrationName = MigrationGenerator.createVersionName(null);
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
      -- MIGRATION VERSION FOR _repair
      --
      INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
          VALUES ('_repair', '${migrationName}', now())
          ON CONFLICT ("module")
          DO UPDATE SET "version" = '${migrationName}', "timestamp" = now();


      COMMIT;
    ''';

    setUp(() async {
      await d.dir('repair-migration', [
        d.file('${migrationName}.sql', sqlThatThrowsIfAppliedMultipleTimes),
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
        DELETE FROM "serverpod_migrations"
          WHERE "module" = '_repair'
          AND "version" = '${migrationName}';

        COMMIT;
      ''');
    });

    test(
        'when triggering multiple concurrent repair migrations then migration is successfully applied once',
        () async {
      var migrationManager = MigrationManager(
        Directory(d.sandbox),
      );

      var concurrentMigrations = Future.wait([
        migrationManager.applyRepairMigration(sessionBuilder.build()),
        migrationManager.applyRepairMigration(sessionBuilder.build()),
      ]);

      expect(concurrentMigrations, completes);
    });
  });
}
