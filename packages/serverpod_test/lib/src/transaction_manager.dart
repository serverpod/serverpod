import 'dart:async';

import 'package:serverpod/serverpod.dart';

import 'test_serverpod.dart';

/// Thrown when trying to create a new transaction while another transaction is ongoing.
class ConcurrentTransactionsException implements Exception {}

/// Creates a transaction and manages savepoints for a given [Session].
class TransactionManager {
  final List<Savepoint> _savepoints = [];

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
      serverpodSession.db
          .transaction(
            (newTransaction) async {
              localTransaction = newTransaction;

              transactionStartedCompleter.complete();

              await _endTransactionScopeCompleter.future;
            },
            isUserCall: false,
          )
          .catchError((error, stackTrace) {
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
  Future<void> addSavepoint({
    bool lock = false,
    bool isPartOfTransaction = false,
  }) async {
    var localTransaction = currentTransaction;
    if (localTransaction == null) {
      throw StateError('No ongoing transaction.');
    }

    if (_isTransactionStackLocked && !isPartOfTransaction) {
      throw ConcurrentTransactionsException();
    } else if (lock) {
      _isTransactionStackLocked = true;
    }

    var savepoint = await localTransaction.createSavepoint();

    _savepoints.add(savepoint);
  }

  /// Rolls back the database to the previous savepoint in the current transaction.
  Future<void> rollbackToPreviousSavepoint({bool unlock = false}) async {
    var savepoint = await _popPreviousSavepoint(unlock: unlock);
    await savepoint.rollback();
  }

  /// Removes the previous savepoint in the current transaction.
  Future<Savepoint> _popPreviousSavepoint({bool unlock = false}) async {
    if (currentTransaction == null) {
      throw StateError('No ongoing transaction.');
    }

    if (_savepoints.isEmpty) {
      throw StateError('No previous savepoint to rollback to.');
    }

    if (unlock) {
      _isTransactionStackLocked = false;
    }

    return _savepoints.removeLast();
  }

  /// Releases the previous savepoint in the current transaction.
  Future<void> releasePreviousSavepoint({bool unlock = true}) async {
    var savepoint = await _popPreviousSavepoint(unlock: unlock);

    await savepoint.release();
  }

  /// Ensures the transaction stack is unlocked and cleans up any remaining savepoints.
  Future<void> ensureTransactionIsUnlocked() async {
    if (_isTransactionStackLocked) {
      _isTransactionStackLocked = false;

      // If there are savepoints remaining, pop the last one that was locked
      // This handles cases where an exception other than DatabaseException occurred
      if (_savepoints.isNotEmpty) {
        var lastSavepoint = _savepoints.removeLast();
        await lastSavepoint.rollback();
      }
    }
  }
}
