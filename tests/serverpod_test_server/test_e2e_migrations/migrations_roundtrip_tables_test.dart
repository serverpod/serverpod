@Timeout(Duration(minutes: 5))
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given new protocol model with table', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating and applying migration then database contains new table.',
      () async {
        var tableName = 'migrated_table';
        var tag = 'add-table';
        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $tableName
  fields:
    anInt: int
  ''',
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
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
          contains(tableName),
          reason: 'Could not find migration table in live table definitions.',
        );
      },
    );
  });

  group('Given multiple new protocol models with table', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql:
            'DROP TABLE IF EXISTS migrated_table, migrated_table_2, migrated_table_3;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating and applying migration then database contains new tables.',
      () async {
        var tag = 'add-multiple-tables';
        var tables = [
          'migrated_table',
          'migrated_table_2',
          'migrated_table_3',
        ];
        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: ${tables[0]}
  fields:
    anInt: int
  ''',
          'migrated_table_2':
              '''
  class: MigratedTable2
  table: ${tables[1]}
  fields:
    aBool: bool
  ''',
          'migrated_table_3':
              '''
  class: MigratedTable3
  table: ${tables[2]}
  fields:
    aString: String
  ''',
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
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
          containsAll(tables),
          reason: 'Could not find the new tables in live table definitions.',
        );
      },
    );
  });

  group('Given protocol model with table that is removed', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      var tag = 'drop-table';
      var initialStateProtocols = {
        'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    anInt: int
  ''',
      };
      await MigrationTestUtils.createInitialState(
        migrationProtocols: [initialStateProtocols],
        tag: tag,
      );

      var targetStateProtocols = <String, String>{};
      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: targetStateProtocols,
            tag: tag,
          );

      expect(
        createMigrationExitCode,
        isNot(0),
        reason: 'Should fail to create migration, exit code was 0.',
      );
    });
  });

  group('Given protocol model with table that is removed', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating migration using --force and applying it then table is removed from database.',
      () async {
        var tag = 'drop-table';
        var table = 'migrated_table';
        var initialStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
  ''',
        };
        await MigrationTestUtils.createInitialState(
          migrationProtocols: [initialStateProtocols],
          tag: tag,
        );

        var targetStateProtocols = <String, String>{};
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
          isNot(contains(table)),
          reason: 'Could still find migration table in live table definitions.',
        );
      },
    );
  });
}
