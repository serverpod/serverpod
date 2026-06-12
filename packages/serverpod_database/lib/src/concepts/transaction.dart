import 'runtime_parameters.dart';

/// A function performing a transaction, passed to the transaction method.
typedef TransactionFunction<R> = Future<R> Function(Transaction transaction);

/// A savepoint in a transaction.
abstract interface class Savepoint {
  /// The id of the savepoint.
  String get id;

  /// Releases the savepoint and any savepoints created after this savepoint.
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

  /// Sets runtime parameters local to the transaction.
  ///
  /// Use the callback function to discover runtime parameters:
  /// ```dart
  /// await transaction.setRuntimeParameters((params) => [
  ///   params.hnswIndexQuery(efSearch: 50),
  ///   params.vectorIndexQuery(enableIndexScan: true),
  /// ]);
  /// ```
  Future<void> setRuntimeParameters(RuntimeParametersListBuilder builder);

  /// All locally applied runtime parameters.
  Map<String, dynamic> get runtimeParameters;
}

/// Isolation levels for transactions.
enum IsolationLevel {
  /// Allow transaction to see uncommitted changes made by other transactions.
  /// Though in PostgreSQL, this behaves like read committed.
  readUncommitted,

  /// Each statement in the transaction sees a snapshot of the database as of
  /// the beginning of the statement. This means each statement might observe
  /// a different version of the database.
  readCommitted,

  /// The transaction transaction can only see rows committed before the first
  /// statement was executed giving a consistent view of the database.
  ///
  /// If conflicting writes among concurrent transactions occur, an exception is
  /// thrown and the transaction is rolled back.
  ///
  /// It is good to be prepared to retry transactions when using this isolation
  /// level.
  repeatableRead,

  /// The transaction can only see rows committed before the first
  /// statement was executed giving a consistent view of the database.
  ///
  /// If a read row is updated by another transaction, an exception is thrown
  /// and the transaction is rolled back.
  ///
  /// If conflicting writes among concurrent transactions occur, an
  /// exception is thrown and the transaction is rolled back.
  ///
  /// It is good to be prepared to retry transactions when using this isolation
  /// level.
  serializable,
}

/// Settings for a transaction.
class TransactionSettings {
  /// The isolation level of the transaction.
  final IsolationLevel? isolationLevel;

  /// Creates a new transaction settings object.
  const TransactionSettings({
    this.isolationLevel,
  });
}
