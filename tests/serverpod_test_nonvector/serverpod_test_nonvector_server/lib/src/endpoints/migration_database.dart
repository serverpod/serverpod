import 'package:serverpod/serverpod.dart';

/// Raw SQL access for the migration e2e suites. Test fixture only.
class MigrationDatabaseEndpoint extends Endpoint {
  /// Executes [queries] in order in a single transaction and returns the rows
  /// of the last query encoded as JSON.
  Future<String> runQueries(Session session, List<String> queries) async {
    return session.db.transaction((transaction) async {
      DatabaseResult? result;
      for (var query in queries) {
        result = await session.db.unsafeQuery(query, transaction: transaction);
      }
      return SerializationManager.encode(result!);
    });
  }
}
