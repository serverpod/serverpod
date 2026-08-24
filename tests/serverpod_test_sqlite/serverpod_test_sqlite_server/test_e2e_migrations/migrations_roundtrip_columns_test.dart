@Timeout(Duration(minutes: 5))
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_sqlite_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given existing protocol model with added nullable column', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating and applying migration then contains new column.',
      () async {
        var tag = 'add-nullable-column';
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

        var addedColumn = 'addedColumn';
        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
    $addedColumn: String?
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
          contains(table),
          reason: 'Could not find migration table in live table definitions.',
        );

        var migratedTable = liveDefinition.tables.firstWhere(
          (t) => t.name == table,
        );
        var databaseColumns = migratedTable.columns.map((c) => c.name);
        expect(
          databaseColumns,
          contains(addedColumn),
          reason: 'Could not find added column in migrated table columns.',
        );
      },
    );
  });

  group('Given existing protocol model with removed column', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating migration using --force and applying it then table is removed from database.',
      () async {
        var tag = 'drop-column';
        var table = 'migrated_table';
        var columnToRemove = 'columnToRemove';
        var initialStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
    $columnToRemove: String
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
    anInt: int
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
          isNot(contains(columnToRemove)),
          reason: 'Could still find removed column in migrated table columns.',
        );
      },
    );
  });

  group('Given existing protocol model with removed column', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      var tag = 'drop-column';
      var table = 'migrated_table';
      var columnToRemove = 'columnToRemove';
      var initialStateProtocols = {
        'migrated_table':
            '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
    $columnToRemove: String
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
        isNot(0),
        reason: 'Should fail to create migration, exit code was 0.',
      );
    });
  });

  group('Given existing protocol model with added non nullable column', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      var tag = 'add-non-nullable-column';
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

      var addedColumn = 'addedColumn';
      var targetStateProtocols = {
        'migrated_table':
            '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
    $addedColumn: String
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
        reason: 'Should fail to create migration, exit code was 0.',
      );
    });
  });

  group('Given existing protocol model with non nullable column', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating migration using --force and applying it then database contains new column.',
      () async {
        var tag = 'add-non-nullable-column';
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

        var addedColumn = 'addedColumn';
        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
    $addedColumn: String
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
          contains(addedColumn),
          reason: 'Could not find added column in migrated table columns.',
        );
      },
    );
  });
}
