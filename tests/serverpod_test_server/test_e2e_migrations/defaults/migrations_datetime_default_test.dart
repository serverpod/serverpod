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

  group('Given new protocol model with table and fields with "default" value',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then the database contains the new table with the correct "default" values.',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultNow: DateTime, default=now
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
        3,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultNow = columns[1];
      expect(
        dateTimeDefaultNow.columnDefault,
        'CURRENT_TIMESTAMP',
        reason: 'Could not find "columnDefault" for "dateTimeDefaultNow"',
      );

      var dateTimeDefaultStr = columns[2];
      expect(
        dateTimeDefaultStr.columnDefault,
        "'2024-05-24 22:00:00'::timestamp without time zone",
        reason: 'Could not find "columnDefault" for "dateTimeDefaultStr"',
      );
    });
  });

  group(
      'Given new protocol model with table and fields with "defaultModel" value',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then the database contains the new table with the correct "defaultModel" values.',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultNow: DateTime, defaultModel=now
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
        3,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultNow = columns[1];
      expect(
        dateTimeDefaultNow.columnDefault,
        isNull,
        reason: '"dateTimeDefaultNow" column should not have "columnDefault"',
      );

      var dateTimeDefaultStr = columns[2];
      expect(
        dateTimeDefaultStr.columnDefault,
        isNull,
        reason: '"dateTimeDefaultStr" column should not have "columnDefault"',
      );
    });
  });

  group(
      'Given new protocol model with table and fields with "defaultPersist" value',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then the database contains the new table with the correct "defaultPersist" values.',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultNow: DateTime?, defaultPersist=now
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
        3,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultNow = columns[1];
      expect(
        dateTimeDefaultNow.columnDefault,
        'CURRENT_TIMESTAMP',
        reason: 'Could not find "columnDefault" for "dateTimeDefaultNow"',
      );

      var dateTimeDefaultStr = columns[2];
      expect(
        dateTimeDefaultStr.columnDefault,
        "'2024-05-24 22:00:00'::timestamp without time zone",
        reason: 'Could not find "columnDefault" for "dateTimeDefaultStr"',
      );
    });
  });

  group(
      'Given new protocol model with table and fields with "defaultModel" and "defaultPersist" value',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when creating and applying migration then the database contains the new table with the correct "defaultPersist" values.',
        () async {
      var tableName = 'migrated_table';
      var tag = 'add-table';
      var targetStateProtocols = {
        'migrated_table': '''
        class: MigratedTable
        table: $tableName 
        fields:
          dateTimeDefaultNow: DateTime, defaultModel=now, defaultPersist=now
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
        3,
        reason: 'Invalid Table Columns',
      );

      var dateTimeDefaultNow = columns[1];
      expect(
        dateTimeDefaultNow.columnDefault,
        'CURRENT_TIMESTAMP',
        reason: 'Could not find "columnDefault" for "dateTimeDefaultNow"',
      );

      var dateTimeDefaultStr = columns[2];
      expect(
        dateTimeDefaultStr.columnDefault,
        "'2024-05-24 22:00:00'::timestamp without time zone",
        reason: 'Could not find "columnDefault" for "dateTimeDefaultStr"',
      );
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