import 'dart:io';

import 'package:serverpod/src/database/server_migration_manager.dart';
import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    'Given migration definition.json with wrong module name',
    (sessionBuilder, _) async {
      final migrationName = MigrationGenerator.createVersionName(null);
      late List<String> existingMigrations;

      // Use 'serverpod' (the package module name) as the wrong module -
      // the test server's Protocol returns 'serverpod_test'.
      const wrongModuleName = 'serverpod';

      final migrationSQL =
          '''
      BEGIN;

      --
      -- MIGRATION VERSION FOR serverpod_test
      --
      INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
          VALUES ('serverpod_test', '$migrationName', now())
          ON CONFLICT ("module")
          DO UPDATE SET "version" = '$migrationName', "timestamp" = now();

      COMMIT;
    ''';

      setUp(() async {
        existingMigrations = await ServerMigrationManager(
          Directory.current,
        ).listAvailableVersions();

        final minimalDefinition =
            '''
{
  "moduleName": "$wrongModuleName",
  "tables": [],
  "installedModules": [],
  "migrationApiVersion": 1
}
''';
        final minimalMigration = '''
{
  "actions": [],
  "warnings": [],
  "migrationApiVersion": 1
}
''';

        await d.dir('migrations', [
          for (var version in existingMigrations) d.dir(version, []),
          d.dir(migrationName, [
            d.file('definition.json', minimalDefinition),
            d.file('definition_project.json', minimalDefinition),
            d.file('migration.json', minimalMigration),
            d.file('migration.sql', migrationSQL),
            d.file('definition.sql', migrationSQL),
          ]),
        ]).create();
      });

      tearDown(() async {
        var session = sessionBuilder.build();
        await session.db.unsafeExecute('''
        BEGIN;

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
        'when migrateToLatest is called then logs warning about module name mismatch.',
        () async {
          var testWriter = TestLogWriter();
          logWriter.add(testWriter);
          addTearDown(() => logWriter.remove(testWriter));

          var migrationManager = ServerMigrationManager(
            Directory(d.sandbox),
          );
          await migrationManager.migrateToLatest(sessionBuilder.build());

          var warnings = testWriter.entries
              .where((e) => e.level == LogLevel.warning)
              .map((e) => e.message)
              .toList();
          expect(
            warnings,
            contains(
              'The module name in the migration definition '
              '("$wrongModuleName") does not match the module name of the '
              'serialization manager ("serverpod_test"). This may indicate that the '
              'wrong Protocol class is being used in "server.dart". Make sure you '
              'are using the Protocol class generated under "src/generated/protocol.dart" '
              'and not one from an external package.',
            ),
          );
        },
      );
    },
  );
}
