import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/src/transaction_manager.dart';

import 'with_serverpod.dart';

/// A database proxy that forwards all calls to the provided database.
class TestDatabaseProxy implements Database {
  final Database _db;
  final RollbackDatabase _rollbackDatabase;
  final TransactionManager _transactionManager;

  /// Creates a new [TestDatabaseProxy]
  TestDatabaseProxy(this._db, this._rollbackDatabase, this._transactionManager);

  @override
  Future<int> count<T extends TableRow>({
    Expression? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) {
    return _db.count<T>(
      where: where,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @override
  Future<List<T>> delete<T extends TableRow>(
    List<T> rows, {
    Transaction? transaction,
  }) {
    return _db.delete<T>(rows, transaction: transaction);
  }

  @override
  Future<T> deleteRow<T extends TableRow>(
    T row, {
    Transaction? transaction,
  }) {
    return _db.deleteRow<T>(row, transaction: transaction);
  }

  @override
  Future<List<T>> deleteWhere<T extends TableRow>({
    required Expression where,
    Transaction? transaction,
  }) {
    return _db.deleteWhere<T>(where: where, transaction: transaction);
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
    return _db.find<T>(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  @override
  Future<T?> findById<T extends TableRow>(
    int id, {
    Transaction? transaction,
    Include? include,
  }) {
    return _db.findById<T>(id, transaction: transaction, include: include);
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
    return _db.findFirstRow<T>(
      where: where,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  @override
  Future<List<T>> insert<T extends TableRow>(
    List<T> rows, {
    Transaction? transaction,
  }) {
    return _db.insert<T>(rows, transaction: transaction);
  }

  @override
  Future<T> insertRow<T extends TableRow>(
    T row, {
    Transaction? transaction,
  }) {
    return _db.insertRow<T>(row, transaction: transaction);
  }

  @override
  Future<bool> testConnection() {
    return _db.testConnection();
  }

  @override
  Future<R> transaction<R>(
    TransactionFunction<R> transactionFunction, {
    isUserCall = true,
  }) async {
    if (!isUserCall || _rollbackDatabase == RollbackDatabase.disabled) {
      return _db.transaction(transactionFunction);
    }

    var localTransaction = _transactionManager.currentTransaction;
    if (localTransaction == null) {
      throw StateError('No ongoing transaction.');
    }

    try {
      await _transactionManager.addSavePoint(lock: true);
    } on ConcurrentTransactionsException {
      throw InvalidConfigurationException(
        'Concurrent calls to transaction are not supported when database rollbacks are enabled. '
        'Disable rolling back the database by setting `rollbackDatabase` to `RollbackDatabase.disabled`.',
      );
    }

    try {
      var result = await transactionFunction(localTransaction);
      await _transactionManager.removePreviousSavePoint(unlock: true);
      return result;
    } catch (e) {
      await _transactionManager.rollbackToPreviousSavePoint(unlock: true);
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
    return _db.unsafeQuery(
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
      parameters: parameters,
    );
  }

  @override
  Future<int> unsafeSimpleExecute(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) {
    return _db.unsafeSimpleExecute(
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );
  }

  @override
  Future<DatabaseResult> unsafeSimpleQuery(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) {
    return _db.unsafeSimpleQuery(
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );
  }

  @override
  Future<List<T>> update<T extends TableRow>(
    List<T> rows, {
    List<Column>? columns,
    Transaction? transaction,
  }) {
    return _db.update<T>(rows, columns: columns, transaction: transaction);
  }

  @override
  Future<T> updateRow<T extends TableRow>(
    T row, {
    List<Column>? columns,
    Transaction? transaction,
  }) {
    return _db.updateRow<T>(row, columns: columns, transaction: transaction);
  }
}
