/// A function performing a transaction, passed to the transaction method.
typedef TransactionFunction<R> = Future<R> Function(Transaction transaction);

/// Holds the state of a running database transaction.
abstract interface class Transaction {
  /// Cancels the transaction.
  /// Subsequent calls to the database will have no effect.
  void cancel();
}
