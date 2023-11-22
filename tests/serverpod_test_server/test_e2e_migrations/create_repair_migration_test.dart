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

  group('Given database matching latest migration', () {
    tearDownAll(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
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
    });

    tearDown(() {
      MigrationTestUtils.removeRepairMigration();
    });

    test('when creating repair migration then no migration is created.',
        () async {
      var exitCode = await MigrationTestUtils.runCreateRepairMigration();
      expect(
        exitCode,
        isNot(0),
        reason: 'Should fail to create repair migration.',
      );

      var maybeRepairMigration =
          MigrationTestUtils.tryLoadRepairMigrationFile();
      expect(
        maybeRepairMigration,
        isNull,
        reason: 'Should not create a repair migration.',
      );
    });

    test(
        'when creating repair migration with --force then a migration is created.',
        () async {
      var exitCode =
          await MigrationTestUtils.runCreateRepairMigration(force: true);
      expect(
        exitCode,
        0,
        reason: 'Should create a repair migration.',
      );

      var maybeRepairMigration =
          MigrationTestUtils.tryLoadRepairMigrationFile();
      expect(
        maybeRepairMigration,
        isNotNull,
        reason: 'Should find repair migration on disk.',
      );
    });
  });

  group('Given database with migrations that would be destructive if reverted',
      () {
    tearDownAll(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
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
  aString: String?
'''
      };

      await MigrationTestUtils.createInitialState(migrationProtocols: [
        firstMigrationProtocols,
        secondMigrationProtocols,
      ]);
    });

    tearDown(() {
      MigrationTestUtils.removeRepairMigration();
    });

    test(
        'when creating repair migration towards older migration then a migration is not created.',
        () async {
      var migrationRegistry = MigrationTestUtils.loadMigrationRegistry();
      var previousMigrationIndex = migrationRegistry.versions.length - 2;
      var previousMigrationName =
          migrationRegistry.versions[previousMigrationIndex];

      var exitCode = await MigrationTestUtils.runCreateRepairMigration(
        targetVersion: previousMigrationName,
      );

      expect(
        exitCode,
        isNot(0),
        reason: 'Should not create a repair migration but exit code was 0.',
      );
    });

    test(
        'when creating repair migration towards older migration with --force then migration is created.',
        () async {
      var migrationRegistry = MigrationTestUtils.loadMigrationRegistry();
      var previousMigrationIndex = migrationRegistry.versions.length - 2;
      var previousMigrationName =
          migrationRegistry.versions[previousMigrationIndex];

      var exitCode = await MigrationTestUtils.runCreateRepairMigration(
        targetVersion: previousMigrationName,
        force: true,
      );
      expect(
        exitCode,
        0,
        reason: 'Should create a repair migration.',
      );

      var maybeRepairMigration =
          MigrationTestUtils.tryLoadRepairMigrationFile();
      expect(
        maybeRepairMigration,
        isNotNull,
        reason: 'Should find repair migration on disk.',
      );
    });
  });

  group('Given database with migrations that are non destructive if reverted',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    setUp(() async {
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
indexes:
  migrated_table_idx:
    fields: anInt
'''
      };

      await MigrationTestUtils.createInitialState(migrationProtocols: [
        firstMigrationProtocols,
        secondMigrationProtocols,
      ]);
    });

    test(
        'when creating repair migration towards older migration then a migration is created.',
        () async {
      var migrationRegistry = MigrationTestUtils.loadMigrationRegistry();
      var previousMigrationIndex = migrationRegistry.versions.length - 2;
      var previousMigrationName =
          migrationRegistry.versions[previousMigrationIndex];

      var exitCode = await MigrationTestUtils.runCreateRepairMigration(
        targetVersion: previousMigrationName,
      );
      expect(
        exitCode,
        0,
        reason: 'Should create a repair migration.',
      );

      var maybeRepairMigration =
          MigrationTestUtils.tryLoadRepairMigrationFile();
      expect(
        maybeRepairMigration,
        isNotNull,
        reason: 'Should find repair migration on disk.',
      );
    });
  });

  group(
      'Given database definition matching latest migration but without recording migrations in database',
      () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
        serviceClient: serviceClient,
      );
    });

    setUp(() async {
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

      await serviceClient.insights.executeSql(
          'DELETE FROM serverpod_migrations WHERE module=\'serverpod_test\';');
    });

    test('when creating repair migration then a migration is created.',
        () async {
      var exitCode = await MigrationTestUtils.runCreateRepairMigration();
      expect(
        exitCode,
        0,
        reason: 'Should create a repair migration.',
      );

      var maybeRepairMigration =
          MigrationTestUtils.tryLoadRepairMigrationFile();
      expect(
        maybeRepairMigration,
        isNotNull,
        reason: 'Should find repair migration on disk.',
      );
    });
  });

  group('Given database not matching latest migration', () {
    tearDownAll(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS migrated_table;',
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
  aString: String?
'''
      };

      assert(0 ==
          await MigrationTestUtils.createMigrationFromProtocols(
            protocols: unappliedMigrationProtocols,
          ));
    });

    tearDown(() {
      MigrationTestUtils.removeRepairMigration();
    });
    test('when creating repair migration then repair migration is created.',
        () async {
      var exitCode = await MigrationTestUtils.runCreateRepairMigration();
      expect(
        exitCode,
        0,
        reason: 'Should create a repair migration.',
      );

      var maybeRepairMigration =
          MigrationTestUtils.tryLoadRepairMigrationFile();
      expect(
        maybeRepairMigration,
        isNotNull,
        reason: 'Should find repair migration on disk.',
      );
    });
  });
}
