@Timeout(Duration(minutes: 5))

import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/test_service_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    authenticationKeyManager: TestServiceKeyManager(
      '0',
      'super_SECRET_password',
    ),
  );

  group(
      'Given an empty database and new protocol model with table and fields with "default" value',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration, then the database contains the new table with the correct "default" value for "dateTimeDefaultNow".',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultNow: DateTime, default=now
        '''
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

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();

      var databaseTable = liveDefinition.tables.firstWhereOrNull(
        (t) => t.name == tableName,
      );

      expect(
        databaseTable,
        isNotNull,
        reason: 'Could not find migration table in live table definitions.',
      );

      var columns = databaseTable!.columns;
      expect(
        columns.length,
        2,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultNow = columns[1];
      expect(
        dateTimeDefaultNow.columnDefault,
        'CURRENT_TIMESTAMP',
        reason: 'Could not find "columnDefault" for "dateTimeDefaultNow"',
      );
    });

    test(
        'when creating and applying migration, then the database contains the new table with the correct "default" value for "dateTimeDefaultStr".',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultStr: DateTime, default=2024-05-24T22:00:00.000Z
        '''
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

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();

      var databaseTable = liveDefinition.tables.firstWhereOrNull(
        (t) => t.name == tableName,
      );

      expect(
        databaseTable,
        isNotNull,
        reason: 'Could not find migration table in live table definitions.',
      );

      var columns = databaseTable!.columns;
      expect(
        columns.length,
        2,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultStr = columns[1];
      expect(
        dateTimeDefaultStr.columnDefault,
        "'2024-05-24 22:00:00'::timestamp without time zone",
        reason: 'Could not find "columnDefault" for "dateTimeDefaultStr"',
      );
    });
  });

  group(
      'Given an empty database and new protocol model with table and fields with "defaultModel" value',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration, then the database does not contain default values for "dateTimeDefaultNow" with "defaultModel".',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultNow: DateTime, defaultModel=now
        '''
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

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();

      var databaseTable = liveDefinition.tables.firstWhereOrNull(
        (t) => t.name == tableName,
      );

      expect(
        databaseTable,
        isNotNull,
        reason: 'Could not find migration table in live table definitions.',
      );

      var columns = databaseTable!.columns;
      expect(
        columns.length,
        2,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultNow = columns[1];
      expect(
        dateTimeDefaultNow.columnDefault,
        isNull,
        reason: '"dateTimeDefaultNow" column should not have "columnDefault"',
      );
    });

    test(
        'when creating and applying migration, then the database does not contain default values for "dateTimeDefaultStr" with "defaultModel".',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultStr: DateTime, defaultModel=2024-05-24T22:00:00.000Z
        '''
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

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();

      var databaseTable = liveDefinition.tables.firstWhereOrNull(
        (t) => t.name == tableName,
      );

      expect(
        databaseTable,
        isNotNull,
        reason: 'Could not find migration table in live table definitions.',
      );

      var columns = databaseTable!.columns;
      expect(
        columns.length,
        2,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultStr = columns[1];
      expect(
        dateTimeDefaultStr.columnDefault,
        isNull,
        reason: '"dateTimeDefaultStr" column should not have "columnDefault"',
      );
    });
  });

  group(
      'Given an empty database and new protocol model with table and fields with "defaultPersist" value',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration, then the database contains the new table with the correct "defaultPersist" value for "dateTimeDefaultNow".',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultNow: DateTime?, defaultPersist=now
        '''
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

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();

      var databaseTable = liveDefinition.tables.firstWhereOrNull(
        (t) => t.name == tableName,
      );

      expect(
        databaseTable,
        isNotNull,
        reason: 'Could not find migration table in live table definitions.',
      );

      var columns = databaseTable!.columns;
      expect(
        columns.length,
        2,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultNow = columns[1];
      expect(
        dateTimeDefaultNow.columnDefault,
        'CURRENT_TIMESTAMP',
        reason: 'Could not find "columnDefault" for "dateTimeDefaultNow"',
      );
    });

    test(
        'when creating and applying migration, then the database contains the new table with the correct "defaultPersist" value for "dateTimeDefaultStr".',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultStr: DateTime?, defaultPersist=2024-05-24T22:00:00.000Z
        '''
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

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();

      var databaseTable = liveDefinition.tables.firstWhereOrNull(
        (t) => t.name == tableName,
      );

      expect(
        databaseTable,
        isNotNull,
        reason: 'Could not find migration table in live table definitions.',
      );

      var columns = databaseTable!.columns;
      expect(
        columns.length,
        2,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultStr = columns[1];
      expect(
        dateTimeDefaultStr.columnDefault,
        "'2024-05-24 22:00:00'::timestamp without time zone",
        reason: 'Could not find "columnDefault" for "dateTimeDefaultStr"',
      );
    });
  });

  group(
      'Given an empty database and new protocol model with table and fields with "defaultModel" and "defaultPersist" value',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration, then the database contains the new table with the correct "defaultModel" and "defaultPersist" values for "dateTimeDefaultNow".',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultNow: DateTime, defaultModel=now, defaultPersist=now
        '''
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

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();

      var databaseTable = liveDefinition.tables.firstWhereOrNull(
        (t) => t.name == tableName,
      );

      expect(
        databaseTable,
        isNotNull,
        reason: 'Could not find migration table in live table definitions.',
      );

      var columns = databaseTable!.columns;
      expect(
        columns.length,
        2,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultNow = columns[1];
      expect(
        dateTimeDefaultNow.columnDefault,
        'CURRENT_TIMESTAMP',
        reason: 'Could not find "columnDefault" for "dateTimeDefaultNow"',
      );
    });

    test(
        'when creating and applying migration, then the database contains the new table with the correct "defaultModel" and "defaultPersist" values for "dateTimeDefaultStr".',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultStr: DateTime, defaultModel=2024-05-01T22:00:00.000Z, defaultPersist=2024-05-24T22:00:00.000Z
        '''
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

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();

      var databaseTable = liveDefinition.tables.firstWhereOrNull(
        (t) => t.name == tableName,
      );

      expect(
        databaseTable,
        isNotNull,
        reason: 'Could not find migration table in live table definitions.',
      );

      var columns = databaseTable!.columns;
      expect(
        columns.length,
        2,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultStr = columns[1];
      expect(
        dateTimeDefaultStr.columnDefault,
        "'2024-05-24 22:00:00'::timestamp without time zone",
        reason: 'Could not find "columnDefault" for "dateTimeDefaultStr"',
      );
    });
  });

  group(
      'Given an existing table, when adding a non-nullable column with a default value,',
      () {
    setUpAll(() async {
      var createTableProtocol = {
        'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
        '''
      };

      await MigrationTestUtils.createMigrationFromProtocols(
        protocols: createTableProtocol,
        tag: 'create-existing-table',
      );

      await MigrationTestUtils.runApplyMigrations();
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS existing_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'then the table contains the new non-nullable column with the correct default value.',
        () async {
      var targetStateProtocols = {
        'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
          newColumn: DateTime, default=now
        '''
      };

      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
        protocols: targetStateProtocols,
        tag: 'add-new-column',
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

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();

      var databaseTable = liveDefinition.tables.firstWhereOrNull(
        (t) => t.name == 'existing_table',
      );

      expect(
        databaseTable,
        isNotNull,
        reason: 'Could not find existing table in live table definitions.',
      );

      var columns = databaseTable!.columns;
      expect(
        columns.length,
        2,
        reason: 'Invalid Table Columns',
      );

      var newColumn = columns[1];
      expect(
        newColumn.columnDefault,
        'CURRENT_TIMESTAMP',
        reason: 'Could not find "columnDefault" for "newColumn"',
      );
    });
  });

  group('Given an existing table with a nullable column,', () {
    setUpAll(() async {
      var createTableProtocol = {
        'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
          existingColumn: DateTime?
        '''
      };

      await MigrationTestUtils.createMigrationFromProtocols(
        protocols: createTableProtocol,
        tag: 'create-existing-table',
      );

      await MigrationTestUtils.runApplyMigrations();
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS existing_table;',
        serviceClient: serviceClient,
      );
    });

    group('when modifying it to be non-nullable with a default value,', () {
      test(
          'then the column is modified to be non-nullable with the correct default value.',
          () async {
        var targetStateProtocols = {
          'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
          existingColumn: DateTime, default=now
        '''
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
          protocols: targetStateProtocols,
          tag: 'modify-existing-column',
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

        var liveDefinition =
            await serviceClient.insights.getLiveDatabaseDefinition();

        var databaseTable = liveDefinition.tables.firstWhereOrNull(
          (t) => t.name == 'existing_table',
        );

        expect(
          databaseTable,
          isNotNull,
          reason: 'Could not find existing table in live table definitions.',
        );

        var columns = databaseTable!.columns;
        expect(
          columns.length,
          2,
          reason: 'Invalid Table Columns',
        );

        var existingColumn = columns[1];
        expect(
          existingColumn.columnDefault,
          'CURRENT_TIMESTAMP',
          reason: 'Could not find "columnDefault" for "existingColumn"',
        );
      });
    });
  });

  group(
      'Given an existing table with a non-nullable column having a default value,',
      () {
    setUpAll(() async {
      var createTableProtocol = {
        'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
          existingColumn: DateTime, default=now
        '''
      };

      await MigrationTestUtils.createMigrationFromProtocols(
        protocols: createTableProtocol,
        tag: 'create-existing-table',
      );

      await MigrationTestUtils.runApplyMigrations();
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS existing_table;',
        serviceClient: serviceClient,
      );
    });

    group('when removing the default value,', () {
      test('then the default value is removed from the column.', () async {
        var targetStateProtocols = {
          'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
          existingColumn: DateTime
        '''
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
          protocols: targetStateProtocols,
          force: true,
          tag: 'remove-default-value',
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

        var liveDefinition =
            await serviceClient.insights.getLiveDatabaseDefinition();

        var databaseTable = liveDefinition.tables.firstWhereOrNull(
          (t) => t.name == 'existing_table',
        );

        expect(
          databaseTable,
          isNotNull,
          reason: 'Could not find existing table in live table definitions.',
        );

        var columns = databaseTable!.columns;
        expect(
          columns.length,
          2,
          reason: 'Invalid Table Columns',
        );

        var existingColumn = columns[1];
        expect(
          existingColumn.columnDefault,
          isNull,
          reason: '"existingColumn" column should not have "columnDefault"',
        );
      });
    });
  });

  group(
      'Given an existing table with a non-nullable column having a default value,',
      () {
    setUpAll(() async {
      var createTableProtocol = {
        'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
          existingColumn: DateTime, default=now
        '''
      };

      await MigrationTestUtils.createMigrationFromProtocols(
        protocols: createTableProtocol,
        tag: 'create-existing-table',
      );

      await MigrationTestUtils.runApplyMigrations();
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS existing_table;',
        serviceClient: serviceClient,
      );
    });

    group('when removing the default value and making the column nullable,',
        () {
      test('then the default value is removed and the column is made nullable.',
          () async {
        var targetStateProtocols = {
          'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
          existingColumn: DateTime?
        '''
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
          protocols: targetStateProtocols,
          force: true,
          tag: 'remove-default-and-make-nullable',
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

        var liveDefinition =
            await serviceClient.insights.getLiveDatabaseDefinition();

        var databaseTable = liveDefinition.tables.firstWhereOrNull(
          (t) => t.name == 'existing_table',
        );

        expect(
          databaseTable,
          isNotNull,
          reason: 'Could not find existing table in live table definitions.',
        );

        var columns = databaseTable!.columns;
        expect(
          columns.length,
          2,
          reason: 'Invalid Table Columns',
        );

        var existingColumn = columns[1];
        expect(
          existingColumn.columnDefault,
          isNull,
          reason: '"existingColumn" column should not have "columnDefault"',
        );

        expect(
          existingColumn.isNullable,
          isTrue,
          reason: '"existingColumn" should be nullable',
        );
      });
    });
  });

  group('Given an existing table with a column having a default value,', () {
    setUpAll(() async {
      var createTableProtocol = {
        'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
          columnToRemove: DateTime, default=now
        '''
      };

      await MigrationTestUtils.createMigrationFromProtocols(
        protocols: createTableProtocol,
        tag: 'create-existing-table',
      );

      await MigrationTestUtils.runApplyMigrations();
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS existing_table;',
        serviceClient: serviceClient,
      );
    });

    group('when removing the column,', () {
      test('then the column is removed from the table.', () async {
        var targetStateProtocols = {
          'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          id: int, primary=true
        '''
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
          protocols: targetStateProtocols,
          tag: 'remove-column',
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

        var liveDefinition =
            await serviceClient.insights.getLiveDatabaseDefinition();

        var databaseTable = liveDefinition.tables.firstWhereOrNull(
          (t) => t.name == 'existing_table',
        );

        expect(
          databaseTable,
          isNotNull,
          reason: 'Could not find existing table in live table definitions.',
        );

        var columns = databaseTable!.columns;
        expect(
          columns.length,
          1,
          reason: 'Invalid Table Columns',
        );
      });
    });
  });
}

extension _ListExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
