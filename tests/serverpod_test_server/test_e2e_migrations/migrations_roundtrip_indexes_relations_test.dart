@Timeout(Duration(minutes: 5))
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given protocol model with added index', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating and applying migration then contains new index.',
      () async {
        var tag = 'add-index';
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

        var addedIndex = 'migrated_table_index';
        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
  indexes:
    $addedIndex:
      fields: anInt
      unique: false

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
        var tableIndexes = migratedTable.indexes.map((i) => i.indexName);
        expect(
          tableIndexes,
          contains(addedIndex),
          reason: 'Could not find added index for migrated table.',
        );
      },
    );
  });

  group('Given protocol model with index that is removed', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating and applying migration then index is removed from database.',
      () async {
        var tag = 'drop-index';
        var table = 'migrated_table';
        var indexToRemove = 'migrated_table_index';
        var initialStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
  indexes:
    $indexToRemove:
      fields: anInt
      unique: false
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
        var tableIndexes = migratedTable.indexes.map((i) => i.indexName);
        expect(
          tableIndexes,
          isNot(contains(indexToRemove)),
          reason: 'Could still find removed index for migrated table.',
        );
      },
    );
  });

  group('Given protocol model with added relation', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating and applying migration then database contains new relation.',
      () async {
        var tag = 'add-relation';
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

        var targetStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int, relation(parent=migrated_table)
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
        var relations = migratedTable.foreignKeys;
        expect(
          relations,
          isNotEmpty,
          reason: 'Could not find added relation for migrated table.',
        );
      },
    );
  });

  group('Given protocol model with relation that is removed', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating and applying migration then relation is removed from database.',
      () async {
        var tag = 'drop-relation';
        var table = 'migrated_table';
        var initialStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int, relation(parent=migrated_table)
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
        var relations = migratedTable.foreignKeys;
        expect(
          relations,
          isEmpty,
          reason: 'Could still find relation for migrated table.',
        );
      },
    );
  });

}
