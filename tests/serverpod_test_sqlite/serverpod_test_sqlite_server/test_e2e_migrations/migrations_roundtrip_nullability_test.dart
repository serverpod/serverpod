@Timeout(Duration(minutes: 5))
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_sqlite_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given existing protocol model with nullability added to column', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
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
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
    $columnToModify: String
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
    $columnToModify: String?
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
        var migratedTableColumnNames = migratedTable.columns.map((c) => c.name);
        expect(
          migratedTableColumnNames,
          contains(columnToModify),
          reason: 'Could not find modified column in migrated table columns.',
        );

        var migratedTableColumn = migratedTable.columns.firstWhere(
          (c) => c.name == columnToModify,
        );
        expect(
          migratedTableColumn.isNullable,
          isTrue,
          reason: 'Column should be nullable after migration',
        );
      },
    );
  });

  group('Given existing protocol model with nullability removed from column', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
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
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
    $columnToModify: String?
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
    $columnToModify: String
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
        var migratedTableColumnNames = migratedTable.columns.map((c) => c.name);
        expect(
          migratedTableColumnNames,
          contains(columnToModify),
          reason: 'Could not find modified column in migrated table columns.',
        );

        var migratedTableColumn = migratedTable.columns.firstWhere(
          (c) => c.name == columnToModify,
        );
        expect(
          migratedTableColumn.isNullable,
          isFalse,
          reason: 'Column should not be nullable after migration',
        );
      },
    );
  });

  group(
    'Given existing protocol model with nullability removed from column',
    () {
      tearDown(() async {
        await MigrationTestUtils.migrationTestCleanup(
          resetSql: 'DROP TABLE IF EXISTS migrated_table;',
          serviceClient: serviceClient,
        );
      });

      test('when creating migration then creating migration fails.', () async {
        var tag = 'drop-column-nullability';
        var table = 'migrated_table';
        var columnToModify = 'previouslyNullableColumn';
        var initialStateProtocols = {
          'migrated_table':
              '''
  class: MigratedTable
  table: $table
  fields:
    anInt: int
    $columnToModify: String?
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
    $columnToModify: String
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
    },
  );
}
