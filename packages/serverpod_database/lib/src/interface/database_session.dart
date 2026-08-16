import '../concepts/transaction.dart';
import '../database.dart';

/// Function type for logging a query.
typedef LogQueryFunction =
    void Function({
      required String query,
      required Duration duration,
      required int? numRowsAffected,
      required String? error,
      required StackTrace stackTrace,
    });

/// Function type for logging a warning during the execution of a query.
typedef LogWarningFunction =
    Future<void> Function(
      String message,
    );

/// Interface for accessing the database.
abstract interface class DatabaseSession {
  /// The database to access.
  Database get db;

  /// Optional transaction to use for all database queries.
  Transaction? get transaction;

  /// Optional function to log a query.
  LogQueryFunction? get logQuery;

  /// Optional function to log a warning during the execution of a query.
  LogWarningFunction? get logWarning;
}
