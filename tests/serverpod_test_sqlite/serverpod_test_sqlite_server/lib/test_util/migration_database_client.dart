import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';

final _client = Client('http://localhost:8080/');

/// Runs [queries] on the live test server through the opt-in
/// [InsightsDatabaseTestEndpoint](../src/endpoints/insights_database.dart).
///
/// A getter so that merely referencing `runQueries` (e.g. passing it to
/// [MigrationTestUtils.migrationTestCleanup]) configures the utils for the
/// sqlite module before any dialect-specific SQL is built.
Future<BulkQueryResult> Function(List<String> queries) get runQueries {
  MigrationTestUtils.setModuleName('serverpod_test_sqlite');
  MigrationTestUtils.setDatabaseDialect(DatabaseDialect.sqlite);
  return (queries) => _client.insightsDatabaseTest.runQueries(queries);
}
