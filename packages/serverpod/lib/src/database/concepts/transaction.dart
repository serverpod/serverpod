/// A function performing a transaction, passed to the transaction method.
typedef TransactionFunction<R> = Future<R> Function(Transaction transaction);

/// Holds the state of a running database transaction.
abstract interface class Transaction {
  /// Cancels the transaction.
  /// Subsequent calls to the database will have no effect and might throw an
  /// exception depending on driver.
  Future<void> cancel();
}

/// Isolation levels for transactions.
enum IsolationLevel {
  /// A statement can only see rows committed before it began.
  readCommitted,

  /// Transaction may see uncommitted changes made by other transactions.
  /// Not supported in PostgreSQL and is treated as readCommitted.
  readUncommitted,

  /// A transaction can only see rows committed before the first query or
  /// data-modification statement was executed.
  repeatableRead,

  /// A transaction can only see rows committed before the first query or
  /// data-modification statement was executed.
  ///
  /// If reads and writes among concurrent serializable transactions occur blablabla
  serializable,
}

/// Settings for a transaction.
class TransactionSettings {
  /// The isolation level of the transaction.
  final IsolationLevel isolationLevel;

  /// Creates a new transaction settings object.
  const TransactionSettings({
    this.isolationLevel = IsolationLevel.readCommitted,
  });
}
