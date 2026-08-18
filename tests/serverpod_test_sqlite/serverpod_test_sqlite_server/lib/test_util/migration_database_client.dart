import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';

late final Client _client = _createClient();

Client _createClient() {
  MigrationTestUtils.setModuleName('serverpod_test_sqlite');
  MigrationTestUtils.setDatabaseDialect(DatabaseDialect.sqlite);
  return Client('http://localhost:8080/');
}

/// Runs [queries] on the live test server through the migration database
/// endpoint; returns the rows of the last query encoded as JSON.
Future<String> runQueries(List<String> queries) =>
    _client.migrationDatabase.runQueries(queries);
