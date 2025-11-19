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

  group(
    'Given an existing table with a non-nullable column having a default value,',
    () {
      setUpAll(() async {
        var createTableProtocol = {
          'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          number: int
          existingColumn: DateTime, default=now
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

      group('when removing the default value,', () {
        test('then the default value is removed from the column.', () async {
          var targetStateProtocols = {
            'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          number: int
          existingColumn: DateTime
        ''',
          };

          var createMigrationExitCode =
              await MigrationTestUtils.createMigrationFromProtocols(
                protocols: targetStateProtocols,
                tag: 'remove-default-value',
              );

          expect(
            createMigrationExitCode,
            0,
            reason: 'Failed to create migration, exit code was not 0.',
          );

          var applyMigrationExitCode =
              await MigrationTestUtils.runApplyMigrations();

          expect(
            applyMigrationExitCode,
            0,
            reason: 'Failed to apply migration, exit code was not 0.',
          );

          var liveDefinition = await serviceClient.insights
              .getLiveDatabaseDefinition();

          var databaseTable = liveDefinition.tables.firstWhereOrNull(
            (t) => t.name == 'existing_table',
          );

          expect(
            databaseTable,
            isNotNull,
            reason: 'Could not find existing table in live table definitions.',
          );

          var columns = databaseTable!.columns;
          expect(
            columns.length,
            3,
            reason: 'Invalid Table Columns',
          );

          var existingColumn = columns[2];
          expect(
            existingColumn.columnDefault,
            isNull,
            reason: '"existingColumn" column should not have "columnDefault"',
          );
        });
      });
    },
  );

  group(
    'Given an existing table with a non-nullable column having a default value,',
    () {
      setUpAll(() async {
        var createTableProtocol = {
          'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          number: int
          existingColumn: DateTime, default=now
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
        'when removing the default value and making the column nullable,',
        () {
          test(
            'then the default value is removed and the column is made nullable.',
            () async {
              var targetStateProtocols = {
                'existing_table': '''
        class: ExistingTable
        table: existing_table
        fields:
          number: int
          existingColumn: DateTime?
        ''',
              };

              var createMigrationExitCode =
                  await MigrationTestUtils.createMigrationFromProtocols(
                    protocols: targetStateProtocols,
                    tag: 'remove-default-and-make-nullable',
                  );

              expect(
                createMigrationExitCode,
                0,
                reason: 'Failed to create migration, exit code was not 0.',
              );

              var applyMigrationExitCode =
                  await MigrationTestUtils.runApplyMigrations();

              expect(
                applyMigrationExitCode,
                0,
                reason: 'Failed to apply migration, exit code was not 0.',
              );

              var liveDefinition = await serviceClient.insights
                  .getLiveDatabaseDefinition();

              var databaseTable = liveDefinition.tables.firstWhereOrNull(
                (t) => t.name == 'existing_table',
              );

              expect(
                databaseTable,
                isNotNull,
                reason:
                    'Could not find existing table in live table definitions.',
              );

              var columns = databaseTable!.columns;
              expect(
                columns.length,
                3,
                reason: 'Invalid Table Columns',
              );

              var existingColumn = columns[2];
              expect(
                existingColumn.columnDefault,
                isNull,
                reason:
                    '"existingColumn" column should not have "columnDefault"',
              );

              expect(
                existingColumn.isNullable,
                isTrue,
                reason: '"existingColumn" should be nullable',
              );
            },
          );
        },
      );
    },
  );

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

    group('when removing the column,', () {
      test('then the column is removed from the table.', () async {
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
              force: true,
              tag: 'remove-column',
            );

        expect(
          createMigrationExitCode,
          0,
          reason: 'Failed to create migration, exit code was not 0.',
        );

        var applyMigrationExitCode =
            await MigrationTestUtils.runApplyMigrations();

        expect(
          applyMigrationExitCode,
          0,
          reason: 'Failed to apply migration, exit code was not 0.',
        );

        var liveDefinition = await serviceClient.insights
            .getLiveDatabaseDefinition();

        var databaseTable = liveDefinition.tables.firstWhereOrNull(
          (t) => t.name == 'existing_table',
        );

        expect(
          databaseTable,
          isNotNull,
          reason: 'Could not find existing table in live table definitions.',
        );

        var columns = databaseTable!.columns;
        expect(
          columns.length,
          2,
          reason: 'Invalid Table Columns',
        );
      });
    });
  });
}

extension _ListExt<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
