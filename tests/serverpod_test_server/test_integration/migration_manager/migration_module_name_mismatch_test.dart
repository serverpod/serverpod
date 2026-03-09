import 'dart:io';

import 'package:serverpod/src/database/migrations/migration_manager.dart';
import 'package:serverpod/src/database/migrations/migrations.dart';
import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_tools/serverpod_test_tools.dart';

void main() {
  final existingMigrations = MigrationVersions.listVersions(
    projectDirectory: Directory.current,
  );

  withServerpod(
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    'Given migration definition.json with wrong module name',
    (sessionBuilder, _) async {
      final migrationName = MigrationGenerator.createVersionName(null);

      // Use 'serverpod' (the package module name) as the wrong module —
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
        await d.dir('migrations', [
          for (var version in existingMigrations) d.dir(version, []),
          d.dir(migrationName, [
            d.file(
              'definition.json',
              '{"moduleName": "$wrongModuleName"}',
            ),
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
        'when migrateToLatest is called then prints warning about module name mismatch to stderr.',
        () async {
          var migrationManager = MigrationManager(Directory(d.sandbox));
          var record = MockStdout();

          await IOOverrides.runZoned(
            () async {
              await migrationManager.migrateToLatest(sessionBuilder.build());
            },
            stderr: () => record,
          );

          expect(
            record.output,
            equals(
              'WARNING: The module name in the migration definition '
              '("$wrongModuleName") does not match the module name of the '
              'serialization manager ("serverpod_test"). This may indicate that the '
              'wrong Protocol class is being used in "server.dart". Make sure you '
              'are using the Protocol class generated under "src/generated/protocol.dart" '
              'and not one from an external package.\n',
            ),
          );
        },
      );
    },
  );
}
