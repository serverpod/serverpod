@Timeout(Duration(minutes: 5))
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a migration creating a table that already exists in the '
      'live database', () {
    const tableName = 'migrated_table';

    setUp(() async {
      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: {
              'migrated_table':
                  '''
  class: MigratedTable
  table: $tableName
  fields:
    anInt: int
  ''',
            },
            tag: 'failing-migration',
          );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      // Makes the CREATE TABLE statement of the migration fail.
      await serviceClient.insights.executeSql(
        'CREATE TABLE "$tableName" ("id" bigserial PRIMARY KEY);',
      );
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS $tableName;',
        serviceClient: serviceClient,
      );
    });

    test(
      'when applying migrations with the maintenance role in production mode '
      'then the exit code is 1.',
      () async {
        var applyMigrationExitCode =
            await MigrationTestUtils.runApplyMigrations();

        expect(applyMigrationExitCode, 1);
      },
    );
  });

  group('Given a schema drift on the live database', () {
    const tableName = 'simple_data';
    const renamedTableName = 'simple_data_exit_code_backup';

    setUp(() async {
      await serviceClient.insights.executeSql(
        'ALTER TABLE "$tableName" RENAME TO "$renamedTableName";',
      );
    });

    tearDown(() async {
      await MigrationTestUtils.migrationArtifactsCleanup();
      await serviceClient.insights.executeSql(
        'ALTER TABLE IF EXISTS "$renamedTableName" RENAME TO "$tableName";',
      );
    });

    test(
      'when applying migrations with the maintenance role in production mode '
      'then the exit code is 1.',
      () async {
        var applyMigrationExitCode =
            await MigrationTestUtils.runApplyMigrations();

        expect(applyMigrationExitCode, 1);
      },
    );
  });
}
