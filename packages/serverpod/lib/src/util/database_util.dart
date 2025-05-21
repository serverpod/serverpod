import 'package:serverpod/serverpod.dart';

/// Provides utility functions for working with the [Database].
abstract class DatabaseUtil {
  /// Runs the closure [f] in isolation and undoing any changes in case it fails.
  ///
  /// This either reused the parent [transaction], or creates one itself.
  /// In case a [transaction] is given, this will create an internal savepoint.
  ///
  /// In case [f] errs, it will restore the database connection to the
  /// state before [f] was invoked, either by discard its transaction
  /// or rolling back to the previously created savepoint.
  ///
  /// In case the parent [transaction] is also used in parallel outside of
  /// [f], all modifications done in [f] will be visible there as well.
  /// In this case also restoring the savepoint in case of error would
  /// undo any changes made in parallel. So ideally the passed [transaction]
  /// should not be used elsewhere until this methods completes.
  ///
  /// In case [f] fails but the system is unable to restore the previous state
  /// by rolling back to the savepoint, a [RollbackToSavepointFailedException] is thrown.
  /// In that case the caller should discard the [transaction], if one was provided.
  static Future<R> transactionOrSavepoint<R>(
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
