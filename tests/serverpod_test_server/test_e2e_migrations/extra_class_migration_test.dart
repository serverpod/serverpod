@Timeout(Duration(minutes: 5))
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_client.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given protocol model with String column and a target definition that changes it to CustomClass',
    () {
      var tag = 'string-to-custom-class';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  data: String
''',
      };
      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  data: CustomClass
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
        'then the column type remains text.',
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

          expect(column.columnType.name, 'text');
        },
      );
    },
  );

  group(
    'Given protocol model with Map column and a target definition that changes it to CustomClass2',
    () {
      var tag = 'map-to-custom-class-2';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  data: Map<String, dynamic>
''',
      };
      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  data: CustomClass2
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
        'then the column type remains json.',
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
    'Given protocol model with Map column and a target definition that changes it to FreezedCustomClass',
    () {
      var tag = 'map-to-freezed-custom-class';
      var initialStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  data: Map<String, dynamic>
''',
      };
      var targetStateProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  data: FreezedCustomClass
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
        'then the column type remains json.',
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
}
