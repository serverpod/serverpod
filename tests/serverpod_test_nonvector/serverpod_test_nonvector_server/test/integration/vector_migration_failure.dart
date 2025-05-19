@Timeout(Duration(minutes: 5))

import 'package:test/test.dart';

import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/test_service_key_manager.dart';
import 'test_tools/serverpod_test_tools.dart';

const serviceServerUrl = 'http://localhost:8081/';

void main() {
  MigrationTestUtils.setModuleName('serverpod_test_nonvector');

  withServerpod('Given a database without pgvector extension',
      runMode: 'production', (sessionBuilder, endpoints) {
    var serviceClient = Client(
      serviceServerUrl,
      authenticationKeyManager: TestServiceKeyManager(
        '0',
        'super_SECRET_password',
      ),
    );

    group('when applying a migration with no vector columns', () {
      tearDown(() async {
        await MigrationTestUtils.migrationTestCleanup(
          resetSql: 'DROP TABLE IF EXISTS integrity_test_table;',
          serviceClient: serviceClient,
        );
      });

      test('then the database migration is correctly applied.', () async {
        var tableName = 'integrity_test_table';
        var tag = 'integrity-test';
        var targetStateProtocols = {
          'integrity_test_table': '''
class: IntegrityTestTable
table: $tableName
fields:
  name: String
  description: String?
  greetingId: int, relation(parent=greeting)
  createdAt: DateTime, default=now
'''
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

        var liveDefinition =
            await serviceClient.insights.getLiveDatabaseDefinition();

        var databaseTable = liveDefinition.tables.firstWhereOrNull(
          (t) => t.name == tableName,
        );

        expect(
          databaseTable,
          isNotNull,
          reason: 'Could not find test table in live table definitions.',
        );
      });
    });

    group('when applying a migration with a vector column', () {
      tearDown(() async {
        await MigrationTestUtils.migrationTestCleanup(
          resetSql: 'DROP TABLE IF EXISTS vector_test_table;',
          serviceClient: serviceClient,
        );
      });

      test('then the migration fails due to missing pgvector extension.',
          () async {
        var tableName = 'vector_test_table';
        var tag = 'vector-column-test';
        var targetStateProtocols = {
          'vector_test_table': '''
class: VectorTestTable
table: $tableName
fields:
  embedding: Vector(1536)
'''
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
          isNot(0),
          reason: 'Migration should fail due to missing pgvector extension.',
        );

        // Verify table was not created
        var liveDefinition =
            await serviceClient.insights.getLiveDatabaseDefinition();

        var databaseTable = liveDefinition.tables.firstWhereOrNull(
          (t) => t.name == tableName,
        );

        expect(
          databaseTable,
          isNull,
          reason: 'Vector table should not have been created.',
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
