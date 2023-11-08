@Timeout(Duration(minutes: 5))

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/migration_registry.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/service_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    authenticationKeyManager: ServiceKeyManager('0', 'password'),
  );

  group('Given new protocol entity with table', () {
    tearDown(() async {
      await _migrationTestCleanup(
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
        'migrated_table': '''
class: MigratedTable
table: $tableName 
fields:
  anInt: int
'''
      };

      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(tableName),
        reason: 'Could not find migration table in live table definitions.',
      );
    });
  });

  group('Given multiple new protocol entities with table', () {
    tearDown(() async {
      await _migrationTestCleanup(
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
        'migrated_table': '''
class: MigratedTable
table: ${tables[0]}
fields:
  anInt: int
''',
        'migrated_table_2': '''
class: MigratedTable2
table: ${tables[1]} 
fields:
  aBool: bool
''',
        'migrated_table_3': '''
class: MigratedTable3
table: ${tables[2]} 
fields:
  aString: String
'''
      };

      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        containsAll(tables),
        reason: 'Could not find the new tables in live table definitions.',
      );
    });
  });

  group('Given protocol entity with table that is removed', () {
    tearDown(() async {
      await _migrationTestCleanup(
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
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = <String, String>{};
      var createMigrationExitCode = await _createMigrationFromProtocols(
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

  group('Given protocol entity with table that is removed', () {
    tearDown(() async {
      await _migrationTestCleanup(
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
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = <String, String>{};
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
        force: true,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        isNot(contains(table)),
        reason: 'Could still find migration table in live table definitions.',
      );
    });
  });

  group('Given existing protocol entity with added nullable column', () {
    tearDown(() async {
      await _migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test('when creating and applying migration then contains new column.',
        () async {
      var tag = 'add-nullable-column';
      var table = 'migrated_table';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var addedColumn = 'addedColumn';
      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $addedColumn: String?
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
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
    });
  });

  group('Given existing protocol entity with removed column', () {
    tearDown(() async {
      await _migrationTestCleanup(
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
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $columnToRemove: String
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
        force: true,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
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
    });
  });

  group('Given existing protocol entity with removed column', () {
    tearDown(() async {
      await _migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      var tag = 'drop-column';
      var table = 'migrated_table';
      var columnToRemove = 'columnToRemove';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $columnToRemove: String
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
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

  group('Given existing protocol entity with added non nullable column', () {
    tearDown(() async {
      await _migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      var tag = 'add-non-nullable-column';
      var table = 'migrated_table';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var addedColumn = 'addedColumn';
      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $addedColumn: String
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
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

  group('Given existing protocol entity with non nullable column', () {
    tearDown(() async {
      await _migrationTestCleanup(
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
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var addedColumn = 'addedColumn';
      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $addedColumn: String
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
        force: true,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
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
    });
  });

  group('Given existing protocol entity with nullability added to column', () {
    tearDown(() async {
      await _migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then database column is nullable.',
        () async {
      var tag = 'add-column-nullability';
      var table = 'migrated_table';
      var columnToModify = 'previouslyNonNullableColumn';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $columnToModify: String
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $columnToModify: String?
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(table),
        reason: 'Could not find migration table in live table definitions.',
      );

      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == table,
      );
      var migratedTableColumnNames = migratedTable.columns.map((c) => c.name);
      expect(
        migratedTableColumnNames,
        contains(columnToModify),
        reason: 'Could not find modified column in migrated table columns.',
      );

      var migratedTableColumn =
          migratedTable.columns.firstWhere((c) => c.name == columnToModify);
      expect(
        migratedTableColumn.isNullable,
        isTrue,
        reason: 'Column should be nullable after migration',
      );
    });
  });

  group('Given existing protocol entity with nullability removed from column',
      () {
    tearDown(() async {
      await _migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating migration using --force and applying it then database contains non nullable column.',
        () async {
      var tag = 'drop-column-nullability';
      var table = 'migrated_table';
      var columnToModify = 'previouslyNullableColumn';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $columnToModify: String?
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $columnToModify: String
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
        force: true,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(table),
        reason: 'Could not find migration table in live table definitions.',
      );

      var migratedTable = liveDefinition.tables.firstWhere(
        (t) => t.name == table,
      );
      var migratedTableColumnNames = migratedTable.columns.map((c) => c.name);
      expect(
        migratedTableColumnNames,
        contains(columnToModify),
        reason: 'Could not find modified column in migrated table columns.',
      );

      var migratedTableColumn =
          migratedTable.columns.firstWhere((c) => c.name == columnToModify);
      expect(
        migratedTableColumn.isNullable,
        isFalse,
        reason: 'Column should not be nullable after migration',
      );
    });
  });

  group('Given existing protocol entity with nullability removed from column',
      () {
    tearDown(() async {
      await _migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then creating migration fails.', () async {
      var tag = 'drop-column-nullability';
      var table = 'migrated_table';
      var columnToModify = 'previouslyNullableColumn';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $columnToModify: String?
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
  $columnToModify: String
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
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

  group('Given protocol entity with added index', () {
    tearDown(() async {
      await _migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test('when creating and applying migration then contains new index.',
        () async {
      var tag = 'add-index';
      var table = 'migrated_table';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var addedIndex = 'migrated_table_index';
      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
indexes:
  $addedIndex:
    fields: anInt
    unique: false

'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
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
    });
  });

  group('Given protocol entity with index that is removed', () {
    tearDown(() async {
      await _migrationTestCleanup(
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
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
indexes:
  $indexToRemove:
    fields: anInt
    unique: false
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int

'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
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
    });
  });

  group('Given protocol entity with added relation', () {
    tearDown(() async {
      await _migrationTestCleanup(
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
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int, relation(parent=migrated_table)
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
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
    });
  });

  group('Given protocol entity with relation that is removed', () {
    tearDown(() async {
      await _migrationTestCleanup(
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
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int, relation(parent=migrated_table)
'''
      };
      await _createInitialState(protocols: initialStateProtocols, tag: tag);

      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      var createMigrationExitCode = await _createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var applyMigrationExitCode = await _runApplyMigrations();
      expect(
        applyMigrationExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
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
    });
  });
}

Future<void> _migrationTestCleanup({
  required String resetSql,
  required Client serviceClient,
}) async {
  _removeAllTaggedMigrations();
  _removeMigrationTestProtocolFolder();
  await _resetDatabase(resetSql: resetSql, serviceClient: serviceClient);
  await _removeTaggedMigrationsFromRegistry();
  await _setDatabaseMigrationToLatestInRegistry(serviceClient: serviceClient);
}

Future<int> _runApplyMigrations() async {
  var applyMigrationProcess = await Process.start(
    'dart',
    [
      'run',
      'bin/main.dart',
      '--apply-migrations',
      '--role',
      'maintenance',
      '--mode',
      'production',
    ],
    workingDirectory: Directory.current.path,
  );

  applyMigrationProcess.stderr.transform(utf8.decoder).listen(print);
  applyMigrationProcess.stdout.transform(utf8.decoder).listen(print);

  return await applyMigrationProcess.exitCode;
}

Future<void> _createInitialState({
  required Map<String, String> protocols,
  required String tag,
}) async {
  assert(
    await _createMigrationFromProtocols(protocols: protocols, tag: tag) == 0,
    'Failed to create migration.',
  );
  assert(
    await _runApplyMigrations() == 0,
    'Failed to create migration.',
  );
}

Future<int> _createMigrationFromProtocols({
  required Map<String, String> protocols,
  required String tag,
  bool force = false,
}) async {
  _removeMigrationTestProtocolFolder();
  _migrationProtocolTestDirectory().createSync(recursive: true);

  protocols.forEach((fileName, contents) {
    var protocolFile = File(path.join(
      _migrationProtocolTestDirectory().path,
      '$fileName.yaml',
    ));

    protocolFile.writeAsStringSync(contents);
  });

  var createMigrationProcess = await Process.start(
    'serverpod',
    [
      'create-migration',
      '--tag',
      tag,
      if (force) '--force',
    ],
    workingDirectory: Directory.current.path,
  );

  createMigrationProcess.stderr.transform(utf8.decoder).listen(print);
  createMigrationProcess.stdout.transform(utf8.decoder).listen(print);
  return await createMigrationProcess.exitCode;
}

Directory _migrationProtocolTestDirectory() => Directory(path.join(
      Directory.current.path,
      'lib',
      'src',
      'protocol',
      'migration_test_protocol_files',
    ));

Directory _migrationsProjectDirectory() => Directory(path.join(
      Directory.current.path,
      'migrations',
      'serverpod_test',
    ));

void _removeAllTaggedMigrations() {
  for (var entity in _migrationsProjectDirectory().listSync()) {
    if (entity is Directory) {
      if (path.basename(entity.path).contains('-')) {
        entity.deleteSync(recursive: true);
      }
    }
  }
}

void _removeMigrationTestProtocolFolder() {
  var protocolDirectory = _migrationProtocolTestDirectory();
  if (protocolDirectory.existsSync()) {
    protocolDirectory.deleteSync(recursive: true);
  }
}

Future<void> _removeTaggedMigrationsFromRegistry() async {
  var migrationRegistry = await MigrationRegistry.load(
    _migrationsProjectDirectory(),
  );

  var lastMigration = migrationRegistry.getLatest();
  while (lastMigration != null && lastMigration.contains('-')) {
    migrationRegistry.removeLast();
    lastMigration = migrationRegistry.getLatest();
  }

  await migrationRegistry.write();
}

Future<void> _setDatabaseMigrationToLatestInRegistry({
  required Client serviceClient,
}) async {
  var migrationRegistry = await MigrationRegistry.load(
    _migrationsProjectDirectory(),
  );

  var latestMigration = migrationRegistry.getLatest();

  await serviceClient.insights.executeSql('''
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '$latestMigration', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '$latestMigration', "priority" = 2;
''');
}

Future<void> _resetDatabase({
  required Client serviceClient,
  required String resetSql,
}) async {
  await serviceClient.insights.executeSql(resetSql);
}

enum AssetType {
  initialState('initial_state'),
  targetState('target_state');

  final String name;
  const AssetType(this.name);
}
