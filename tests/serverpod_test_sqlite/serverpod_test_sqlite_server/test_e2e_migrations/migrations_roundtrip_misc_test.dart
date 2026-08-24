@Timeout(Duration(minutes: 5))
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_sqlite_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given invalid protocol file', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating migration then create migration exits with error and migration is not created.',
      () async {
        var tag = 'invalid-protocol';
        var targetStateProtocols = {
          'migrated_table': '''
  This is not a valid protocol file, in yaml format
  ''',
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
            );
        expect(
          createMigrationExitCode,
          isNot(0),
          reason: 'Should fail to create migration but exit code was 0.',
        );

        var migrationVersions =
            await MigrationTestUtils.loadMigrationRegistry();
        expect(migrationVersions, isNot(contains(tag)));
      },
    );
  });

  group('Given a new table that should not be managed by Serverpod', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating migration then create migration exits successfully and migration is not created.',
      () async {
        var tag = 'managed-false';
        var targetStateProtocols = {
          'migrated_table': '''
  class: MigratedTable
  managedMigration: false
  table: migrated_table
  fields:
    name: String
  ''',
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
            );
        expect(
          createMigrationExitCode,
          equals(0),
          reason: 'No managed changes should exit with code 0.',
        );

        var migrationVersions =
            await MigrationTestUtils.loadMigrationRegistry();
        expect(migrationVersions, isNot(contains(tag)));
      },
    );
  });

  /// Issue: https://github.com/serverpod/serverpod/issues/3503
  group(
    'Given an existing table when a new table is added that is lexically sorted after the existing table and the existing table references the new table',
    () {
      var oldTable = 'a_old_table';
      var newTable = 'z_new_table';
      tearDown(() async {
        await MigrationTestUtils.migrationTestCleanup(
          resetSql:
              'DROP TABLE IF EXISTS $oldTable;'
              'DROP TABLE IF EXISTS $newTable;',
          serviceClient: serviceClient,
        );
      });

      test(
        'when creating and applying migrations then both tables and the relation exist in the database.',
        () async {
          var initialTag = 'create-old-table';
          // a Prefix ensure that it is lexically sorted before the new table
          var initialStateProtocols = {
            oldTable:
                '''
  class: OldTable
  table: $oldTable
  fields:
    name: String
  ''',
          };
          await MigrationTestUtils.createInitialState(
            migrationProtocols: [initialStateProtocols],
            tag: initialTag,
          );

          var newTag = 'add-new-table-with-relation';
          // z Prefix ensure that it is lexically sorted after the old table
          var targetStateProtocols = {
            oldTable:
                '''
  class: OldTable
  table: $oldTable
  fields:
    name: String
    newTableId: NewTable?, relation(optional)
  ''',
            newTable:
                '''
  class: NewTable
  table: $newTable
  fields:
    description: String
  ''',
          };

          var createMigrationExitCode =
              await MigrationTestUtils.createMigrationFromProtocols(
                protocols: targetStateProtocols,
                tag: newTag,
              );
          expect(
            createMigrationExitCode,
            0,
            reason: 'Failed to create migration, exit code was not 0.',
          );

          var applyNewMigrationExitCode =
              await MigrationTestUtils.runApplyMigrations();
          expect(
            applyNewMigrationExitCode,
            0,
            reason: 'Failed to apply new migration, exit code was not 0.',
          );

          var liveDefinition = await serviceClient.insights
              .getLiveDatabaseDefinition();
          var databaseTables = liveDefinition.tables.map((t) => t.name);
          expect(
            databaseTables,
            containsAll([oldTable, newTable]),
            reason: 'Could not find both tables in live table definitions.',
          );

          var oldTableDefinition = liveDefinition.tables.firstWhere(
            (t) => t.name == oldTable,
          );
          var relations = oldTableDefinition.foreignKeys;
          expect(
            relations,
            isNotEmpty,
            reason: 'Could not find relation from old_table to new_table.',
          );
        },
      );
    },
  );

  group(
    'Given existing protocol model with camelCase column migrated to snake_case with column override',
    () {
      tearDown(() async {
        await MigrationTestUtils.migrationTestCleanup(
          resetSql: 'DROP TABLE IF EXISTS migrated_table;',
          serviceClient: serviceClient,
        );
      });

      test(
        'when creating and applying migration then database contains new column name.',
        () async {
          var tag = 'rename-column-with-override';
          var table = 'migrated_table';
          var initialStateProtocols = {
            'migrated_table':
                '''
  class: MigratedTable
  table: $table
  fields:
    camelCase: int
  ''',
          };
          await MigrationTestUtils.createInitialState(
            migrationProtocols: [initialStateProtocols],
            tag: tag,
          );

          var targetStateProtocols = {
            'migrated_table':
                '''
  class: MigratedTable
  table: $table
  fields:
    camelCase: int, column=snake_case
  ''',
          };
          var createMigrationExitCode =
              await MigrationTestUtils.createMigrationFromProtocols(
                protocols: targetStateProtocols,
                tag: tag,
                force: true,
              );
          expect(
            createMigrationExitCode,
            0,
            reason: 'Failed to create migration, exit code was not 0.',
          );

          var applyMigrationExitCode =
              await MigrationTestUtils.runApplyMigrations();
          expect(
            applyMigrationExitCode,
            0,
            reason: 'Failed to apply migration, exit code was not 0.',
          );

          var liveDefinition = await serviceClient.insights
              .getLiveDatabaseDefinition();
          var databaseTables = liveDefinition.tables.map((t) => t.name);
          expect(
            databaseTables,
            contains(table),
            reason: 'Could not find migration table in live table definitions.',
          );

          var migratedTable = liveDefinition.tables.firstWhere(
            (t) => t.name == table,
          );
          var databaseColumns = migratedTable.columns.map((c) => c.name);
          expect(
            databaseColumns,
            contains('snake_case'),
            reason:
                'Could not find snake_case column in migrated table columns.',
          );
          expect(
            databaseColumns,
            isNot(contains('camelCase')),
            reason: 'Found camelCase column in migrated table columns.',
          );
        },
      );
    },
  );
}
