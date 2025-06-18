import 'package:serverpod/serverpod.dart';

/// Provides utility functions for working with the [Database].
abstract class DatabaseUtil {
  /// Runs the closure [f] in isolation and undoes any changes to the database in case [f] fails.
  ///
  /// Depending on whether the [transaction] parameter refers to an active transaction (non-`null`)
  /// or not, the method has 2 slightly distinct behaviors:
  ///
  /// - In case no [transaction] was given (`null`), the method [f] is run in a new transaction.
  ///
  ///   If [f] should error, the internally created transaction is cancelled.
  ///
  ///   Code outside of [f] accessing the database, which does not have access to the internal
  ///   transaction, can not see any changes until this method finishes.
  ///
  ///   Once this method is finished, all changes are persisted to the database.
  ///
  /// - In case an active [transaction] was given, this method creates a [savepoint](https://www.postgresql.org/docs/current/sql-savepoint.html)
  ///   before invoking [f].
  ///
  ///   In case [f] errs, this method rolls back to the previously created savepoint, thus undoing any
  ///   changes made in [f]. If the rollback to the savepoint should fail for whatever reason,
  ///   this method will throw a [RollbackToSavepointFailedException], with the error from [f]
  ///   available as `innerException`. In this case, the entire [transaction] is in an unclear
  ///   state and should probably be discarded by the caller.
  ///
  ///   Callers that pass a [transaction] should ensure that it is not used in parallel while this method
  ///   still executes. Since in this case only a savepoint is created (and not an entirely separate transaction),
  ///   all other code with access to the same transaction at the time this method runs can see the modifications
  ///   made while [f] is still running. Furthermore, creating multiple savepoints in parallel and rolling some
  ///   of them back can lead to unexpected behavior, undoing other modifications done in parallel.
  ///
  ///   Changes made in this mode will only be visible on the outside database (without access to the same transaction)
  ///   once the given `transaction` is committed.
  static Future<R> runInTransactionOrSavepoint<R>(
    final Database database,
    final Transaction? transaction,
    final TransactionFunction<R> f, {
    /// Settings to be applied in case a new transaction is created.
    final TransactionSettings? settings,
  }) async {
    if (transaction == null) {
      return database.transaction(f, settings: settings);
    }

    Savepoint? savepoint;
    try {
      savepoint = await transaction.createSavepoint();

      final result = await f(transaction);

      await savepoint.release();

      return result;
    } catch (_) {
      try {
        await savepoint?.rollback();
      } catch (e) {
        throw RollbackToSavepointFailedException(e);
      }

      rethrow;
    }
  }
}

/// Exception thrown when an attempt to rollback to a savepoint in response
/// to clean up after another exception fails.
class RollbackToSavepointFailedException implements Exception {
  /// The inner exception which caused the rollback to the savepoint to be attempted in the first place.
  final Object innerException;

  /// Creates a new instance of a rollback failed exception, wrapping the [innerException].
  RollbackToSavepointFailedException(this.innerException);

  @override
  String toString() {
    return 'RollbackToSavepointFailedException(innerException: $innerException)';
  }
}
