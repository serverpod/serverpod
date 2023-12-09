@Timeout(Duration(minutes: 5))

import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    authenticationKeyManager: ServiceKeyManager('0', 'password'),
  );
  group('Given database not matching latest migration', () {
    tearDownAll(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table, migrated_table_2;',
        serviceClient: serviceClient,
      );
    });

    setUpAll(() async {
      var firstMigrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
'''
      };

      await MigrationTestUtils.createInitialState(migrationProtocols: [
        firstMigrationProtocols,
      ]);

      var unappliedMigrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
''',
        'migrated_table_2': '''
class: MigratedTable2
table: migrated_table_2
fields:
  anInt: int
'''
      };

      assert(0 ==
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: unappliedMigrationProtocols,
          ));
    });

    test(
        'when creating and applying repair migration then database matches latest migration',
        () async {
      var createRepairMigrationExitCode =
          await MigrationTestUtils.runCreateRepairMigration();
      expect(
        createRepairMigrationExitCode,
        0,
        reason: 'Should create a repair migration.',
      );

      var applyRepairMigrationExitCode =
          await MigrationTestUtils.runApplyRepairMigration();
      expect(
        applyRepairMigrationExitCode,
        0,
        reason: 'Should successfully apply repair migration.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains('migrated_table_2'),
        reason: 'Could not find table added in the repair migration.',
      );
    });
  });

  group('Given database matching latest migration', () {
    tearDownAll(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table, migrated_table_2;',
        serviceClient: serviceClient,
      );
    });

    setUpAll(() async {
      var firstMigrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
'''
      };

      var secondMigrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
''',
        'migrated_table_2': '''
class: MigratedTable2
table: migrated_table_2
fields:
  anInt: int
'''
      };

      await MigrationTestUtils.createInitialState(migrationProtocols: [
        firstMigrationProtocols,
        secondMigrationProtocols,
      ]);
    });

    test(
        'when creating and applying destructive repair migration to older migration then database matches older migration',
        () async {
      var migrationRegistry = MigrationTestUtils.loadMigrationRegistry();
      var previousMigrationIndex = migrationRegistry.versions.length - 2;
      var previousMigrationName =
          migrationRegistry.versions[previousMigrationIndex];

      var createRepairMigrationExitCode =
          await MigrationTestUtils.runCreateRepairMigration(
        targetVersion: previousMigrationName,
        force: true,
      );

      expect(
        createRepairMigrationExitCode,
        0,
        reason: 'Should create a repair migration.',
      );

      var applyRepairMigrationExitCode =
          await MigrationTestUtils.runApplyRepairMigration();
      expect(
        applyRepairMigrationExitCode,
        0,
        reason: 'Should successfully apply repair migration.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        isNot(contains('migrated_table_2')),
        reason: 'Could still find table removed in the repair migration.',
      );
    });
  });

  group('Given database not matching latest migration and unapplied migrations',
      () {
    tearDownAll(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table, migrated_table_2;',
        serviceClient: serviceClient,
      );
    });

    setUpAll(() async {
      var firstMigrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
'''
      };
      assert(0 ==
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: firstMigrationProtocols,
          ));

      var secondMigrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
''',
        'migrated_table_2': '''
class: MigratedTable2
table: migrated_table_2
fields:
  anInt: int
'''
      };
      assert(0 ==
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: secondMigrationProtocols,
          ));
    });
    test(
        'when creating and applying repair migration targeting older migration and applying migrations then database matches latest migration',
        () async {
      var migrationRegistry = MigrationTestUtils.loadMigrationRegistry();
      var previousMigrationIndex = migrationRegistry.versions.length - 2;
      var previousMigrationName =
          migrationRegistry.versions[previousMigrationIndex];

      var createRepairMigrationExitCode =
          await MigrationTestUtils.runCreateRepairMigration(
        targetVersion: previousMigrationName,
        force: true,
      );

      expect(
        createRepairMigrationExitCode,
        0,
        reason: 'Should create a repair migration.',
      );

      var applyRepairMigrationExitCode =
          await MigrationTestUtils.runApplyBothRepairMigrationAndMigrations();
      expect(
        applyRepairMigrationExitCode,
        0,
        reason: 'Should successfully apply repair migration and migrations.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains('migrated_table'),
        reason: 'Could not find table added in the repair migration.',
      );
      expect(
        databaseTables,
        contains('migrated_table_2'),
        reason: 'Could not find table added in the migrations.',
      );
    });
  });
}
