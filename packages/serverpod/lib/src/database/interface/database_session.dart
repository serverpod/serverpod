import '../concepts/transaction.dart';
import '../database.dart';

/// Function type for logging a query.
typedef LogQueryFunction =
    Future<void> Function({
      required String query,
      required Duration duration,
      required int? numRowsAffected,
      required String? error,
      required StackTrace stackTrace,
    });

/// Interface for accessing the database.
abstract interface class DatabaseSession {
  /// The database to access.
  Database get db;

  /// Optional transaction to use for all database queries.
  Transaction? get transaction;

  /// Optional function to log a query.
  LogQueryFunction? get logQuery;
}
