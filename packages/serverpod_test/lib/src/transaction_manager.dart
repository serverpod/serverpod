import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Creates a transaction and manages savepoints for a given [Session].
class TransactionManager {
  final List<String> _savePointIds = [];

  Transaction? _transaction;

  late Completer _endTransactionScopeCompleter;

  /// The underlying Serverpod session.
  late Session serverpodSession;

  /// Creates a new [TransactionManager] instance.
  TransactionManager(this.serverpodSession);

  /// Creates a new transaction.
  Future<Transaction> createTransaction() async {
    if (_transaction != null) {
      throw StateError('Transaction already exists.');
    }

    _endTransactionScopeCompleter = Completer();
    var transactionStartedCompleter = Completer();
    late Transaction localTransaction;

    unawaited(
      serverpodSession.db.transaction((newTransaction) async {
        localTransaction = newTransaction;

        transactionStartedCompleter.complete();

        await _endTransactionScopeCompleter.future;
      }),
    );

    await transactionStartedCompleter.future;

    _transaction = localTransaction;

    return localTransaction;
  }

  /// Cancels the ongoing transaction.
  Future<void> cancelTransaction() async {
    var localTransaction = _transaction;
    if (localTransaction == null) {
      throw StateError('No ongoing transaction.');
    }

    await localTransaction.cancel();
    _endTransactionScopeCompleter.complete();
    _transaction = null;
  }

  /// Creates a savepoint in the current transaction.
  Future<void> pushSavePoint() async {
    if (_transaction == null) {
      throw StateError('No ongoing transaction.');
    }

    var savePointId = _getNextSavePointId();
    _savePointIds.add(savePointId);

    await serverpodSession.db.unsafeExecute(
      'SAVEPOINT $savePointId;',
      transaction: _transaction,
    );
  }

  /// Generates and returns the next savepoint id.
  String _getNextSavePointId() {
    var postgresCompatibleRandomString =
        const Uuid().v4obj().toString().replaceAll(RegExp(r'-'), '_');
    var savePointId = 'savepoint_$postgresCompatibleRandomString';

    return savePointId;
  }

  /// Rolls back the database to the previous save point in the current transaction.
  Future<void> popSavePoint() async {
    if (_transaction == null) {
      throw StateError('No ongoing transaction.');
    }

    if (_savePointIds.isEmpty) {
      throw StateError('No previous savepoint to rollback to.');
    }

    await serverpodSession.db.unsafeExecute(
      'ROLLBACK TO SAVEPOINT ${_savePointIds.removeLast()};',
      transaction: _transaction,
    );
  }
}
