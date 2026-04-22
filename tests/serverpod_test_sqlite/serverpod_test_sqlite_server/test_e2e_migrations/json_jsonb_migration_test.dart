@Timeout(Duration(minutes: 5))
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_sqlite_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given existing protocol model with json column', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when changing to jsonb and creating migration without --force, '
      'then migration creation succeeds.',
      () async {
        var tag = 'json-to-jsonb';
        var initialStateProtocols = {
          'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>
  ''',
        };

        await MigrationTestUtils.createInitialState(
          migrationProtocols: [initialStateProtocols],
          tag: tag,
        );

        var targetStateProtocols = {
          'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>, serializationDataType=jsonb
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
          reason: 'Migration should succeed without --force for json to jsonb.',
        );
      },
    );

    test(
      'when changing to jsonb and applying migration, '
      'then column type is jsonb.',
      () async {
        var tag = 'json-to-jsonb-apply';
        var initialStateProtocols = {
          'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>
  ''',
        };

        await MigrationTestUtils.createInitialState(
          migrationProtocols: [initialStateProtocols],
          tag: tag,
        );

        var targetStateProtocols = {
          'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>, serializationDataType=jsonb
  ''',
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
            );
        expect(createMigrationExitCode, 0);

        var applyMigrationExitCode =
            await MigrationTestUtils.runApplyMigrations();
        expect(applyMigrationExitCode, 0);

        var liveDefinition = await serviceClient.insights
            .getLiveDatabaseDefinition();
        var table = liveDefinition.tables.firstWhere(
          (t) => t.name == 'migrated_table',
        );
        var column = table.columns.firstWhere((c) => c.name == 'data');

        expect(column.columnType.name, 'jsonb');
      },
    );
  });

  group('Given existing protocol model with jsonb column', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when changing to json and applying migration, '
      'then column type is json.',
      () async {
        var tag = 'jsonb-to-json';
        var initialStateProtocols = {
          'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>, serializationDataType=jsonb
  ''',
        };

        await MigrationTestUtils.createInitialState(
          migrationProtocols: [initialStateProtocols],
          tag: tag,
        );

        var targetStateProtocols = {
          'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>
  ''',
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: tag,
            );
        expect(createMigrationExitCode, 0);

        var applyMigrationExitCode =
            await MigrationTestUtils.runApplyMigrations();
        expect(applyMigrationExitCode, 0);

        var liveDefinition = await serviceClient.insights
            .getLiveDatabaseDefinition();
        var table = liveDefinition.tables.firstWhere(
          (t) => t.name == 'migrated_table',
        );
        var column = table.columns.firstWhere((c) => c.name == 'data');

        expect(column.columnType.name, 'json');
      },
    );
  });
}
