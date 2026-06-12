@Timeout(Duration(minutes: 5))
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/test_service_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    // ignore: deprecated_member_use
    authenticationKeyManager: TestServiceKeyManager(
      '0',
      'super_SECRET_password',
    ),
  );

  group('Given a table with a column', () {
    const tableName = 'column_rename_test_table';
    const originalColumnName = 'original_name';
    const newColumnName = 'renamed_name';

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS $tableName;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when creating table with initial column name then table is created with that column.',
      () async {
        var tag = 'create-table-with-original-column';
        var targetStateProtocols = {
          'column_rename_test':
              '''
class: ColumnRenameTest
table: $tableName
fields:
  $originalColumnName: String
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
        var table = liveDefinition.tables.firstWhere(
          (t) => t.name == tableName,
        );
        var columnNames = table.columns.map((c) => c.name).toList();

        expect(
          columnNames,
          contains(originalColumnName),
          reason: 'Original column name should exist in the table.',
        );
      },
    );

    test(
      'when renaming column using column override '
      'then live schema exposes the new column name and prior cell values are preserved.',
      () async {
        // First create the table with original column
        var initialTag = 'create-initial-table';
        var initialProtocols = {
          'column_rename_test':
              '''
class: ColumnRenameTest
table: $tableName
fields:
  $originalColumnName: String
''',
        };

        await MigrationTestUtils.createMigrationFromProtocols(
          protocols: initialProtocols,
          tag: initialTag,
        );
        await MigrationTestUtils.runApplyMigrations();

        // Insert test data to verify no data loss
        await serviceClient.insights.executeSql(
          '''
INSERT INTO "$tableName" ("id", "$originalColumnName")
VALUES (1, 'test_value_1'), (2, 'test_value_2');
''',
        );

        // Now rename the column using column override
        var renameTag = 'rename-column';
        var renameProtocols = {
          'column_rename_test':
              '''
class: ColumnRenameTest
table: $tableName
fields:
  $originalColumnName: String, column=$newColumnName
''',
        };

        var createRenameExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: renameProtocols,
              tag: renameTag,
            );
        expect(
          createRenameExitCode,
          0,
          reason: 'Failed to create rename migration, exit code was not 0.',
        );

        var applyRenameExitCode = await MigrationTestUtils.runApplyMigrations();
        expect(
          applyRenameExitCode,
          0,
          reason: 'Failed to apply rename migration, exit code was not 0.',
        );

        var liveDefinition = await serviceClient.insights
            .getLiveDatabaseDefinition();
        var table = liveDefinition.tables.firstWhere(
          (t) => t.name == tableName,
        );
        var columnNames = table.columns.map((c) => c.name).toList();

        expect(
          columnNames,
          ['id', newColumnName],
          reason: 'Original column name should not exist after rename.',
        );

        var columnValues = await serviceClient.insights.runQueries([
          'SELECT "$newColumnName" FROM "$tableName" ORDER BY id;',
        ]);
        expect(
          columnValues.numAffectedRows,
          2,
          reason: 'Bulk query should report two rows for the two inserted ids.',
        );
        expect(
          columnValues.data,
          contains('test_value_1'),
          reason: 'Renamed column should still hold the first inserted value.',
        );
        expect(
          columnValues.data,
          contains('test_value_2'),
          reason: 'Renamed column should still hold the second inserted value.',
        );
      },
    );
  });
}
