import 'dart:io';

import 'package:serverpod/src/database/server_migration_manager.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_tools/serverpod_test_tools.dart';

void main() {
  /// Version string that does not exist in the test project's migrations folder.
  const ghostVersion = '20990101120000000';

  withServerpod(
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    'Given DB has migration version not found in project files',
    (sessionBuilder, _) async {
      late List<String> existingMigrations;

      setUp(() async {
        existingMigrations = await ServerMigrationManager(
          Directory.current,
        ).listAvailableVersions();

        final latestVersion = existingMigrations.last;
        final migrationSQL =
            '''
      BEGIN;

      --
      -- MIGRATION VERSION FOR serverpod_test
      --
      INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
          VALUES ('serverpod_test', '$latestVersion', now())
          ON CONFLICT ("module")
          DO UPDATE SET "version" = '$latestVersion', "timestamp" = now();

      COMMIT;
    ''';

        const minimalDefinition = '''
{
  "moduleName": "serverpod_test",
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
          for (var i = 0; i < existingMigrations.length - 1; i++)
            d.dir(existingMigrations[i], []),
          d.dir(latestVersion, [
            d.file('definition.json', minimalDefinition),
            d.file('definition_project.json', minimalDefinition),
            d.file('migration.json', minimalMigration),
            d.file('migration.sql', migrationSQL),
            d.file('definition.sql', migrationSQL),
          ]),
        ]).create();

        var session = sessionBuilder.build();
        await session.db.unsafeExecute('''
        BEGIN;

        INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
            VALUES ('serverpod_test', '$ghostVersion', now())
            ON CONFLICT ("module")
            DO UPDATE SET "version" = '$ghostVersion', "timestamp" = now();

        COMMIT;
      ''');
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

      const expectedMessage =
          'WARNING: Database has migration version "$ghostVersion" '
          'registered but it is not found in the project files.';

      test(
        'when migrating to latest on production, '
        'then it prints a warning about the missing migration version to stderr.',
        () async {
          var record = MockStdout();

          await IOOverrides.runZoned(
            () async {
              var migrationManager = ServerMigrationManager(
                Directory(d.sandbox),
                runMode: 'production',
              );
              await migrationManager.migrateToLatest(sessionBuilder.build());
            },
            stderr: () => record,
          );

          expect(record.output, '$expectedMessage\n');
        },
      );

      group(
        'when migrating to latest on development,',
        () {
          late MockStdout stderrRecord;
          late Object? thrown;

          setUp(() async {
            stderrRecord = MockStdout();
            thrown = null;

            try {
              await IOOverrides.runZoned(
                () async {
                  var migrationManager = ServerMigrationManager(
                    Directory(d.sandbox),
                    runMode: 'development',
                  );
                  await migrationManager.migrateToLatest(
                    sessionBuilder.build(),
                  );
                },
                stderr: () => stderrRecord,
              );
            } catch (e) {
              thrown = e;
            }
          });

          test('then it throws due to the missing migration version.', () {
            expect(
              thrown,
              isA<Exception>().having(
                (e) => e.toString(),
                'toString',
                'Exception: $expectedMessage',
              ),
            );
          });

          test('then it does not write a warning to stderr.', () {
            expect(stderrRecord.output, isEmpty);
          });
        },
      );
    },
  );
}
