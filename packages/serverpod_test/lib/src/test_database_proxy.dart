import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/src/transaction_manager.dart';
import 'with_serverpod.dart';
import 'package:synchronized/synchronized.dart';

/// A database proxy that forwards all calls to the provided database.
class TestDatabaseProxy implements Database {
  final Database _db;
  final RollbackDatabase _rollbackDatabase;
  final TransactionManager _transactionManager;
  final RuntimeParametersListBuilder? _runtimeParametersBuilder;

  final Lock _databaseOperationLock = Lock();

  /// Creates a new [TestDatabaseProxy]
  TestDatabaseProxy(
    this._db,
    this._rollbackDatabase,
    this._transactionManager,
    this._runtimeParametersBuilder,
  );

  @override
  Future<int> count<T extends TableRow>({
    Expression? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.count<T>(
        where: where,
        limit: limit,
        useCache: useCache,
        transaction: transaction,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<List<T>> delete<T extends TableRow>(
    List<T> rows, {
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.delete<T>(
        rows,
        transaction: transaction,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<T> deleteRow<T extends TableRow>(
    T row, {
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.deleteRow<T>(
        row,
        transaction: transaction,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<List<T>> deleteWhere<T extends TableRow>({
    required Expression where,
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.deleteWhere<T>(
        where: where,
        transaction: transaction,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<List<T>> find<T extends TableRow>({
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    Transaction? transaction,
    Include? include,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.find<T>(
        where: where,
        limit: limit,
        offset: offset,
        orderBy: orderBy,
        orderByList: orderByList,
        orderDescending: orderDescending,
        transaction: transaction,
        include: include,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<T?> findById<T extends TableRow>(
    Object id, {
    Transaction? transaction,
    Include? include,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.findById<T>(id, transaction: transaction, include: include),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<T?> findFirstRow<T extends TableRow>({
    Expression? where,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    Transaction? transaction,
    Include? include,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.findFirstRow<T>(
        where: where,
        offset: offset,
        orderBy: orderBy,
        orderByList: orderByList,
        orderDescending: orderDescending,
        transaction: transaction,
        include: include,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<List<T>> insert<T extends TableRow>(
    List<T> rows, {
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.insert<T>(
        rows,
        transaction: transaction,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<T> insertRow<T extends TableRow>(
    T row, {
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.insertRow<T>(
        row,
        transaction: transaction,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<bool> testConnection() {
    return _db.testConnection();
  }

  @override
  Future<R> transaction<R>(
    TransactionFunction<R> transactionFunction, {
    TransactionSettings? settings,
    bool isUserCall = true,
  }) async {
    if (!isUserCall || _rollbackDatabase == RollbackDatabase.disabled) {
      return _db.transaction(transactionFunction, settings: settings);
    }

    var localTransaction = _transactionManager.currentTransaction;
    if (localTransaction == null) {
      throw StateError('No ongoing transaction.');
    }

    try {
      await _transactionManager.addSavepoint(lock: true);
    } on ConcurrentTransactionsException {
      throw InvalidConfigurationException(
        'Concurrent calls to transaction are not supported when database rollbacks are enabled. '
        'Disable rolling back the database by setting `rollbackDatabase` to `RollbackDatabase.disabled`.',
      );
    }

    try {
      var result = await transactionFunction(localTransaction);
      await _transactionManager.releasePreviousSavepoint(unlock: true);
      await _resetRuntimeParameters(localTransaction);
      return result;
    } catch (e) {
      await _transactionManager.rollbackToPreviousSavepoint(unlock: true);
      rethrow;
    }
  }

  @override
  Future<int> unsafeExecute(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.unsafeExecute(
        query,
        timeoutInSeconds: timeoutInSeconds,
        transaction: transaction,
        parameters: parameters,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  /// This method is not guarded by the test guard and should only be
  /// used by the package internal [TransactionManager].
  Future<int> unsafeExecuteWithoutDatabaseExceptionGuard(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) {
    return _db.unsafeExecute(
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
      parameters: parameters,
    );
  }

  @override
  Future<DatabaseResult> unsafeQuery(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.unsafeQuery(
        query,
        timeoutInSeconds: timeoutInSeconds,
        transaction: transaction,
        parameters: parameters,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<int> unsafeSimpleExecute(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.unsafeSimpleExecute(
        query,
        timeoutInSeconds: timeoutInSeconds,
        transaction: transaction,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<DatabaseResult> unsafeSimpleQuery(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.unsafeSimpleQuery(
        query,
        timeoutInSeconds: timeoutInSeconds,
        transaction: transaction,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<List<T>> update<T extends TableRow>(
    List<T> rows, {
    List<Column>? columns,
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () => _db.update<T>(
        rows,
        columns: columns,
        transaction: transaction,
      ),
      isPartOfUserTransaction: transaction != null,
    );
  }

  @override
  Future<T> updateRow<T extends TableRow>(
    T row, {
    List<Column>? columns,
    Transaction? transaction,
  }) {
    return _rollbackSingleOperationIfDatabaseException(
      () async {
        return _db.updateRow<T>(
          row,
          columns: columns,
          transaction: transaction,
        );
      },
      isPartOfUserTransaction: transaction != null,
    );
  }

  Future<T> _rollbackSingleOperationIfDatabaseException<T>(
    Future<T> Function() databaseOperation, {
    required bool isPartOfUserTransaction,
  }) async {
    if (_rollbackDatabase == RollbackDatabase.disabled) {
      return databaseOperation();
    }

    return _databaseOperationLock.synchronized(() async {
      try {
        await _transactionManager.addSavepoint(
          lock: true,
          isPartOfTransaction: isPartOfUserTransaction,
        );
      } on ConcurrentTransactionsException {
        throw InvalidConfigurationException(
          'Concurrent database calls outside an already active transaction '
          'are not supported when database rollbacks are enabled. '
          'If this is intended, disable rolling back the '
          'database by setting `rollbackDatabase` to `RollbackDatabase.disabled`.',
        );
      }

      try {
        var result = await databaseOperation();
        await _transactionManager.releasePreviousSavepoint(unlock: true);
        return result;
      } on DatabaseException catch (_) {
        await _transactionManager.rollbackToPreviousSavepoint(unlock: true);
        rethrow;
      }
    });
  }

  Future<void> _resetRuntimeParameters(Transaction transaction) async {
    if (transaction.runtimeParameters.isEmpty) return;
    for (var paramName in transaction.runtimeParameters.keys.toList()) {
      await _db.unsafeExecute('SET LOCAL $paramName TO DEFAULT;');
      transaction.runtimeParameters.remove(paramName);
    }

    // As eventual runtime parameters might have been overridden locally in the
    // transaction and reverted to default above, they need to be set again to
    // the previously set global values.
    if (_runtimeParametersBuilder != null) {
      await transaction.setRuntimeParameters(_runtimeParametersBuilder);
    }
  }
}
