@Timeout(Duration(minutes: 5))
import 'dart:io';

import 'package:serverpod_cli/src/migrations/cli_migration_runner.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a migration with multiple new protocol models with table', () {
    final tables = [
      'migrated_table',
      'migrated_table_2',
      'migrated_table_3',
    ];

    setUp(() async {
      var tag = 'apply-migrations-from-the-cli';

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
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS ${tables.join(', ')};',
        serviceClient: serviceClient,
      );
    });

    test(
      'when applying migrations from the CLI '
      'then database contains new tables.',
      () async {
        final result = await applyPendingMigrations(
          serverDir: Directory.current.path,
          runMode: 'production',
          moduleName: 'serverpod_test',
        );

        expect(result, hasLength(1));

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

  group('Given a schema drift on the live database', () {
    const tableName = 'simple_data';
    const renamedTableName = 'simple_data_cli_migration_backup';

    setUp(() async {
      // Rename a table to simulate a schema drift
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
      'when applying migrations from the CLI '
      'then schema drift warnings are logged.',
      () async {
        final testWriter = TestLogWriter();
        logWriter.add(testWriter);

        final result = await applyPendingMigrations(
          serverDir: Directory.current.path,
          runMode: 'production',
          moduleName: 'serverpod_test',
        );

        expect(result, isEmpty);
        expect(testWriter.entries, hasLength(1));

        final warning = testWriter.entries.first;
        expect(warning.level, LogLevel.warning);
        expect(
          warning.message,
          startsWith(
            'The database does not match the target database:\n'
            ' - Table "simple_data" is missing.',
          ),
        );
      },
    );
  });
}
