@Timeout(Duration(minutes: 5))
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/test_service_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    authenticationKeyManager: TestServiceKeyManager(
      '0',
      'super_SECRET_password',
    ),
  );

  group('Given an existing table with a nullable column,', () {
    setUpAll(() async {
      var createTableProtocol = {
        'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          number: int
          existingColumn: DateTime?
        ''',
      };

      await MigrationTestUtils.createMigrationFromProtocols(
        protocols: createTableProtocol,
        tag: 'create-existing-table',
      );

      await MigrationTestUtils.runApplyMigrations();
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS existing_table;',
        serviceClient: serviceClient,
      );
    });

    group(
      'when attempting to modify it to be non-nullable with a default value without force,',
      () {
        test('then the migration should fail and throw an error.', () async {
          var targetStateProtocols = {
            'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          number: int
          existingColumn: DateTime, default=now
        ''',
          };

          var createMigrationExitCode =
              await MigrationTestUtils.createMigrationFromProtocols(
                protocols: targetStateProtocols,
                tag: 'modify-existing-column',
              );

          expect(
            createMigrationExitCode,
            isNot(0),
            reason:
                'Expected an error when creating the migration without force, but exit code was 0.',
          );
        });
      },
    );
  });

  group('Given an existing table with a column having a default value,', () {
    setUpAll(() async {
      var createTableProtocol = {
        'existing_table': '''
      class: ExistingTable
      table: existing_table
      fields:
        number: int
        columnToRemove: DateTime, default=now
      ''',
      };

      await MigrationTestUtils.createMigrationFromProtocols(
        protocols: createTableProtocol,
        tag: 'create-existing-table',
      );

      await MigrationTestUtils.runApplyMigrations();
    });

    tearDown(() async {
      await MigrationTestUtils.migrationTestCleanup(
        resetSql: 'DROP TABLE IF EXISTS existing_table;',
        serviceClient: serviceClient,
      );
    });

    group('when attempting to remove the column without force,', () {
      test('then the migration should fail and throw an error.', () async {
        var targetStateProtocols = {
          'existing_table': '''
      class: ExistingTable
      table: existing_table
      fields:
        number: int
      ''',
        };

        var createMigrationExitCode =
            await MigrationTestUtils.createMigrationFromProtocols(
              protocols: targetStateProtocols,
              tag: 'remove-column',
            );

        expect(
          createMigrationExitCode,
          isNot(0),
          reason:
              'Expected an error when creating the migration without force, but exit code was 0.',
        );
      });
    });
  });
}
