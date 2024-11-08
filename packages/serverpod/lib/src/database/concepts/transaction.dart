/// A function performing a transaction, passed to the transaction method.
typedef TransactionFunction<R> = Future<R> Function(Transaction transaction);

/// A savepoint in a transaction.
abstract interface class Savepoint {
  /// The id of the savepoint.
  String get id;

  /// Releases the savepoint and any savepoint created after this savepoint.
  Future<void> release();

  /// Rolls back the transaction to the state of the savepoint.
  Future<void> rollback();
}

/// Holds the state of a running database transaction.
abstract interface class Transaction {
  /// Cancels the transaction.
  /// Subsequent calls to the database will have no effect and might throw an
  /// exception depending on driver.
  Future<void> cancel();

  /// Creates a savepoint in the transaction that can be used to rollback to a
  /// previous state.
  Future<Savepoint> createSavepoint();
}
