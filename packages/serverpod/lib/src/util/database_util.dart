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
  static Future<R> transactionOrSavepoint<R>(
    final Database database,
    final TransactionFunction<R> f, {
    required final Transaction? transaction,
  }) async {
    if (transaction == null) {
      return database.transaction(f);
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
      } catch (e, stackTrace) {
        // ignore: avoid_print
        print(
          'Failed to roll back to savepoint: $e, $stackTrace',
        );
      }

      rethrow;
    }
  }
}
