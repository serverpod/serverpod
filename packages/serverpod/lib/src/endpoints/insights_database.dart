import 'package:serverpod_database/serverpod_database.dart';

import '../../serverpod.dart';

/// Opt-in endpoint exposing raw database access for tooling, such as the
/// Serverpod Insights database browser.
///
/// Not served by default. To enable it, extend this endpoint in your server,
/// like with the auth module endpoints:
///
/// ```dart
/// class MyInsightsDatabaseEndpoint extends InsightsDatabaseEndpoint {}
/// ```
abstract class InsightsDatabaseEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Executes SQL commands. Returns the number of rows affected.
  Future<int> executeSql(Session session, String sql) async {
    try {
      return await session.db.unsafeExecute(sql);
    } catch (e) {
      throw BulkDataException(
        message: 'Failed to execute sql: $e',
      );
    }
  }

  /// Exports raw data serialized in JSON from the database.
  Future<BulkData> fetchDatabaseBulkData(
    Session session, {
    required String table,
    required int startingId,
    required int limit,
    Filter? filter,
  }) async {
    try {
      return await DatabaseBulkData.exportTableData(
        database: session.db,
        table: table,
        lastId: startingId,
        limit: limit,
        filter: filter,
      );
    } catch (e) {
      throw BulkDataException(
        message: 'Failed to fetch bulk data. ($e)',
      );
    }
  }

  /// Executes a list of queries on the database and returns the last result.
  /// The queries are executed in a single transaction.
  Future<BulkQueryResult> runQueries(
    Session session,
    List<String> queries,
  ) async {
    try {
      var result = await DatabaseBulkData.executeQueries(
        database: session.db,
        queries: queries,
      );
      return result;
    } catch (e) {
      if (e is DatabaseException) {
        throw BulkDataException(
          message: 'Failed to execute query: ${e.message}',
        );
      } else {
        throw BulkDataException(
          message: 'Failed to execute query: $e',
        );
      }
    }
  }

  /// Returns the approximate number of rows in the provided [table].
  Future<int> getDatabaseRowCount(
    Session session, {
    required String table,
  }) async {
    return DatabaseBulkData.approximateRowCount(
      database: session.db,
      table: table,
    );
  }
}
