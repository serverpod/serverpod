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
  group('Given existing migration registry', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        serviceClient: serviceClient,
      );
    });

    test('when creating migration then migration is added to registry.',
        () async {
      var tag = 'add-migration';
      var migrationRegistry = await MigrationTestUtils.loadMigrationRegistry();
      var migrationsBefore = migrationRegistry.length;
      expect(migrationRegistry.getLatest(), isNot(contains(tag)));
      var migrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
'''
      };

      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
        protocols: migrationProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      migrationRegistry = await MigrationTestUtils.loadMigrationRegistry();
      expect(migrationRegistry, hasLength(migrationsBefore + 1));
      expect(migrationRegistry.getLatest(), contains(tag));
    });
  });

  // Crete multiple migrations and validate that they are added to the registry.
  group('Given existing migration registry', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        serviceClient: serviceClient,
      );
    });

    test('when creating multiple migrations then all are added to registry.',
        () async {
      var tag = 'add-multiple-migrations';
      var migrationRegistry = await MigrationTestUtils.loadMigrationRegistry();
      expect(migrationRegistry.getLatest(), isNot(contains(tag)));
      var migrationsBefore = migrationRegistry.length;

      var firstMigrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
'''
      };
      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
        protocols: firstMigrationProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var secondMigrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
  aString: String?
'''
      };
      createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
        protocols: secondMigrationProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var thirdMigrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: migrated_table
fields:
  anInt: int
  aString: String?
  aBool: bool?
'''
      };
      createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
        protocols: thirdMigrationProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );
      migrationRegistry = await MigrationTestUtils.loadMigrationRegistry();
      expect(migrationRegistry, hasLength(migrationsBefore + 3));
      var migrations = migrationRegistry.registry.migrations;
      var lastThreeMigrations = migrations.sublist(migrations.length - 3);
      expect(lastThreeMigrations, everyElement(contains(tag)));
    });
  });

  group('Given migration not in registry', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table, migrated_table_2;',
        serviceClient: serviceClient,
      );
    });

    test(
        'when applying migrations then only migrations in registry are applied.',
        () async {
      var tag = 'migration-not-in-registry';
      var migrationRegistry = await MigrationTestUtils.loadMigrationRegistry();
      expect(migrationRegistry.getLatest(), isNot(contains(tag)));
      var migrationsBefore = migrationRegistry.length;
      var table = 'migrated_table';
      var migrationInRegistry = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };
      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
        protocols: migrationInRegistry,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      var tableNotInRegistry = 'migrated_table_2';
      var migrationToRemoveFromRegistry = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
''',
        'migrated_table_2': '''
class: MigratedTable2
table: $tableNotInRegistry
fields:
  anInt: int
'''
      };
      createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
        protocols: migrationToRemoveFromRegistry,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );

      expect(
        await MigrationTestUtils.removeLastMigrationFromRegistry(),
        isTrue,
        reason: 'Failed to remove last migration from registry',
      );

      migrationRegistry = await MigrationTestUtils.loadMigrationRegistry();
      expect(migrationRegistry, hasLength(migrationsBefore + 1));

      var applyMigrationsExitCode =
          await MigrationTestUtils.runApplyMigrations();
      expect(
        applyMigrationsExitCode,
        0,
        reason: 'Failed to apply migration, exit code was not 0.',
      );

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        contains(table),
        reason:
            'Could not find table from applied migration in live table definitions.',
      );
      expect(
        databaseTables,
        isNot(contains(tableNotInRegistry)),
        reason:
            'Table from migration not in registry was still applied to database.',
      );
    });
  });

  group('Given migration version in registry but it does not exist', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });
    test('when applying migrations then no migrations are applied.', () async {
      var tag = 'migration-files-missing';
      var table = 'migrated_table';
      var migrationProtocols = {
        'migrated_table': '''
class: MigratedTable
table: $table 
fields:
  anInt: int
'''
      };

      var createMigrationExitCode =
          await MigrationTestUtils.createMigrationFromProtocols(
        protocols: migrationProtocols,
        tag: tag,
      );
      expect(
        createMigrationExitCode,
        0,
        reason: 'Failed to create migration, exit code was not 0.',
      );
      MigrationTestUtils.removeAllTaggedMigrations();

      /// TODO: Expect exit code to be non-zero after we support correct shutdown in serverpod.
      await MigrationTestUtils.runApplyMigrations();

      var liveDefinition =
          await serviceClient.insights.getLiveDatabaseDefinition();
      var databaseTables = liveDefinition.tables.map((t) => t.name);
      expect(
        databaseTables,
        isNot(contains(table)),
        reason: 'Database should not contain migration table.',
      );
    });
  });
}
