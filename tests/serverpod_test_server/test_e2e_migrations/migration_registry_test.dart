@Timeout(Duration(minutes: 5))

import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/service_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    authenticationKeyManager: ServiceKeyManager('0', 'super_SECRET_password'),
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
      var migrationRegistry = MigrationTestUtils.readMigrationRegistryFile();
      expect(migrationRegistry, isNot(contains(tag)));
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

      migrationRegistry = MigrationTestUtils.readMigrationRegistryFile();
      expect(migrationRegistry, contains(tag));
    });
  });

  group('Given existing migration registry', () {
    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        serviceClient: serviceClient,
      );
    });

    test('when creating multiple migrations then all are added to registry.',
        () async {
      var tag = 'add-multiple-migrations';
      var migrationRegistry = MigrationTestUtils.readMigrationRegistryFile();
      expect(migrationRegistry, isNot(contains(tag)));

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
      migrationRegistry = MigrationTestUtils.readMigrationRegistryFile();
      expect(migrationRegistry, contains(tag));
      var tagCount = RegExp(tag).allMatches(migrationRegistry).length;
      expect(
        tagCount,
        3,
        reason: 'Expected 3 migrations with the tag to be added',
      );
    });
  });
}
