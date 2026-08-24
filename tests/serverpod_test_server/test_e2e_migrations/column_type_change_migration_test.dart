@Timeout(Duration(minutes: 5))
import 'dart:convert';

import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given existing protocol model with json column and a target definition that changes it to jsonb',
    () {
      var tag = 'json-to-jsonb';
      var initialStateProtocols = {
        'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>
  ''',
      };
      var targetStateProtocols = {
        'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>, serializationDataType=jsonb
  ''',
      };

      tearDown(() async {
        await MigrationTestUtils.migrationTestCleanup(
          resetSql: 'DROP TABLE IF EXISTS migrated_table;',
          serviceClient: serviceClient,
        );
      });

      test(
        'when creating migration without --force, '
        'then migration creation succeeds.',
        () async {
          await MigrationTestUtils.createInitialState(
            migrationProtocols: [initialStateProtocols],
            tag: tag,
          );

          var createMigrationExitCode =
              await MigrationTestUtils.createMigrationFromProtocols(
                protocols: targetStateProtocols,
                tag: tag,
              );

          expect(
            createMigrationExitCode,
            0,
            reason:
                'Migration should succeed without --force for json to jsonb.',
          );
        },
      );

      test(
        'when applying the migration, '
        'then the column type is jsonb.',
        () async {
          await MigrationTestUtils.createInitialState(
            migrationProtocols: [initialStateProtocols],
            tag: tag,
          );

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
    },
  );

  group(
    'Given existing protocol model with jsonb column and a target definition that changes it to json',
    () {
      var tag = 'jsonb-to-json';
      var initialStateProtocols = {
        'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>, serializationDataType=jsonb
  ''',
      };
      var targetStateProtocols = {
        'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>
  ''',
      };

      tearDown(() async {
        await MigrationTestUtils.migrationTestCleanup(
          resetSql: 'DROP TABLE IF EXISTS migrated_table;',
          serviceClient: serviceClient,
        );
      });

      test(
        'when applying the migration, '
        'then the column type is json.',
        () async {
          await MigrationTestUtils.createInitialState(
            migrationProtocols: [initialStateProtocols],
            tag: tag,
          );

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
    },
  );

  group(
    'Given existing table with json data and a target definition that changes it to jsonb and back',
    () {
      var tag = 'json-jsonb-roundtrip';
      var jsonProtocol = {
        'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>
  ''',
      };
      var jsonbProtocol = {
        'migrated_table': '''
  class: MigratedTable
  table: migrated_table
  fields:
    data: List<String>, serializationDataType=jsonb
  ''',
      };

      tearDown(() async {
        await MigrationTestUtils.migrationTestCleanup(
          resetSql: 'DROP TABLE IF EXISTS migrated_table;',
          serviceClient: serviceClient,
        );
      });

      test(
        'when migrating and applying both directions, '
        'then data is preserved through the round-trip.',
        () async {
          await MigrationTestUtils.createInitialState(
            migrationProtocols: [jsonProtocol],
            tag: tag,
          );

          // Insert test data
          await serviceClient.insights.executeSql(
            "INSERT INTO migrated_table (data) VALUES "
            "('[\"dart\",\"flutter\"]'), ('[]'), ('[\"special\"]')",
          );

          // Migrate json → jsonb
          var exitCode = await MigrationTestUtils.createMigrationFromProtocols(
            protocols: jsonbProtocol,
            tag: tag,
          );
          expect(exitCode, 0);
          expect(await MigrationTestUtils.runApplyMigrations(), 0);

          // Verify data preserved after json → jsonb
          var resultAfterJsonb = await serviceClient.insights.runQueries([
            'SELECT data FROM migrated_table ORDER BY id;',
          ]);
          expect(resultAfterJsonb.numAffectedRows, 3);
          var rowsAfterJsonb = jsonDecode(resultAfterJsonb.data) as List;
          expect(rowsAfterJsonb[0][0], isA<List>());
          expect(rowsAfterJsonb[0][0], ['dart', 'flutter']);
          expect(rowsAfterJsonb[1][0], []);
          expect(rowsAfterJsonb[2][0], ['special']);

          // Migrate jsonb → json
          exitCode = await MigrationTestUtils.createMigrationFromProtocols(
            protocols: jsonProtocol,
            tag: tag,
          );
          expect(exitCode, 0);
          expect(await MigrationTestUtils.runApplyMigrations(), 0);

          // Verify data preserved after jsonb → json
          var resultAfterJson = await serviceClient.insights.runQueries([
            'SELECT data FROM migrated_table ORDER BY id;',
          ]);
          expect(resultAfterJson.numAffectedRows, 3);
          var rowsAfterJson = jsonDecode(resultAfterJson.data) as List;
          expect(rowsAfterJson[0][0], isA<List>());
          expect(rowsAfterJson[0][0], ['dart', 'flutter']);
          expect(rowsAfterJson[1][0], []);
          expect(rowsAfterJson[2][0], ['special']);
        },
      );
    },
  );
}
