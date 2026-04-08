@Timeout(Duration(minutes: 5))
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/test_service_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var serviceClient = Client(
    serviceServerUrl,
    // ignore: deprecated_member_use
    authenticationKeyManager: TestServiceKeyManager(
      '0',
      'super_SECRET_password',
    ),
  );

  group(
    'Given an empty database and new protocol model with table and fields with "defaultPersist" Decimal value',
    () {
      tearDown(() async {
        await MigrationTestUtils.migrationTestCleanup(
          resetSql: 'DROP TABLE IF EXISTS migrated_table;',
          serviceClient: serviceClient,
        );
      });

      test(
        'when creating and applying migration, then the database contains the new table with the correct "defaultPersist" value for "decimalDefaultPersist".',
        () async {
          var tableName = 'migrated_table';
          var tag = 'add-table';
          var targetStateProtocols = {
            'migrated_table':
                '''
        class: MigratedTable
        table: $tableName
        fields:
          decimalDefaultPersist: Decimal?, defaultPersist=10.5
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
            (t) => t.name == tableName,
          );

          expect(
            databaseTable,
            isNotNull,
            reason: 'Could not find migration table in live table definitions.',
          );

          var columns = databaseTable!.columns;
          expect(
            columns.length,
            2,
            reason: 'Invalid Table Columns',
          );

          var decimalDefaultPersist = columns.last;
          expect(
            decimalDefaultPersist.columnDefault,
            '10.5',
            reason:
                'Could not find "columnDefault" for "decimalDefaultPersist"',
          );
        },
      );
    },
  );
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
