import 'package:postgres/postgres.dart';

/// A function performing a transaction, passed to the transaction method.
typedef TransactionFunction<R> = Future<R> Function(Transaction transaction);

/// Holds the state of a running database transaction.
abstract class Transaction {
  /// The Postgresql execution context associated with a running transaction.
  // TODO: Replace with a more generic database context and rename to executionContext.
  final PostgreSQLExecutionContext postgresContext;

  /// Constructs a new transaction object.
  Transaction(this.postgresContext);
}
