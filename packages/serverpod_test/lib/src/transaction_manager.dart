import 'dart:async';

import 'package:serverpod/serverpod.dart';

import 'test_serverpod.dart';

/// Thrown when trying to create a new transaction while another transaction is ongoing.
class ConcurrentTransactionsException implements Exception {}

/// Creates a transaction and manages savepoints for a given [Session].
class TransactionManager {
  final List<String> _savePointIds = [];

  /// The current transaction.
  Transaction? currentTransaction;

  late Completer _endTransactionScopeCompleter;

  /// The underlying Serverpod session.
  late InternalServerpodSession serverpodSession;

  /// Creates a new [TransactionManager] instance.
  TransactionManager(this.serverpodSession);

  bool _isTransactionStackLocked = false;

  /// Creates a new transaction.
  Future<Transaction> createTransaction() async {
    if (currentTransaction != null) {
      throw StateError('Transaction already exists.');
    }

    _endTransactionScopeCompleter = Completer();
    var transactionStartedCompleter = Completer();
    late Transaction localTransaction;

    unawaited(
      serverpodSession.db.transaction(
        (newTransaction) async {
          localTransaction = newTransaction;

          transactionStartedCompleter.complete();

          await _endTransactionScopeCompleter.future;
        },
        isUserCall: false,
      ).catchError((error, stackTrace) {
        // no-op:
        // If a database exception occurred during the transaction,
        // but the exception was caught and the transactions was allowed to complete,
        // then the transaction will rethrow it when it completes.
        // This has to be caught, otherwise the dart test runner will fail the test suite.
      }),
    );

    await transactionStartedCompleter.future;

    currentTransaction = localTransaction;

    return localTransaction;
  }

  /// Cancels the ongoing transaction.
  Future<void> cancelTransaction() async {
    var localTransaction = currentTransaction;
    if (localTransaction == null) {
      throw StateError('No ongoing transaction.');
    }

    await localTransaction.cancel();
    _endTransactionScopeCompleter.complete();
    currentTransaction = null;
  }

  /// Creates a savepoint in the current transaction.
  Future<void> addSavePoint({bool lock = false}) async {
    if (currentTransaction == null) {
      throw StateError('No ongoing transaction.');
    }

    if (_isTransactionStackLocked) {
      throw ConcurrentTransactionsException();
    } else if (lock) {
      _isTransactionStackLocked = true;
    }

    var savePointId = _getNextSavePointId();
    _savePointIds.add(savePointId);

    await serverpodSession.db.unsafeExecute(
      'SAVEPOINT $savePointId;',
      transaction: currentTransaction,
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
  Future<void> rollbackToPreviousSavePoint({bool unlock = false}) async {
    var savePointId = await removePreviousSavePoint(unlock: unlock);

    await serverpodSession.db.unsafeExecute(
      'ROLLBACK TO SAVEPOINT $savePointId;',
      transaction: currentTransaction,
    );
  }

  /// Removes the previous save point in the current transaction.
  Future<String> removePreviousSavePoint({bool unlock = false}) async {
    if (currentTransaction == null) {
      throw StateError('No ongoing transaction.');
    }

    if (_savePointIds.isEmpty) {
      throw StateError('No previous savepoint to rollback to.');
    }

    if (unlock) {
      _isTransactionStackLocked = false;
    }

    return _savePointIds.removeLast();
  }
}
