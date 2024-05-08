import 'dart:async';

import 'package:serverpod/src/database/concepts/columns.dart';
import 'package:serverpod/src/database/concepts/includes.dart';
import 'package:serverpod/src/database/concepts/order.dart';
import 'package:serverpod/src/database/concepts/transaction.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';
import 'package:serverpod/src/database/concepts/database_result.dart';
import 'package:serverpod/src/database/query_parameters.dart';

import '../server/session.dart';
import 'adapters/postgres/database_connection.dart';
import 'concepts/expressions.dart';
import 'concepts/table.dart';

/// Provides easy access to the database in relation to the current [Session].
class Database {
  final Session _session;

  final DatabaseConnection _databaseConnection;

  /// Creates a new [Database] object. Typically, this is done automatically
  /// when a [Session] is created.
  Database({required Session session, required DatabasePoolManager poolManager})
      : _session = session,
        _databaseConnection = DatabaseConnection(poolManager);

  /// Find a list of [TableRow]s from a table, using the provided [where]
  /// expression, optionally using [limit], [offset], and [orderBy]. To order by
  /// multiple columns, user [orderByList]. If [where] is omitted, all rows in
  /// the table will be returned.
  Future<List<T>> find<T extends TableRow>({
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    Transaction? transaction,
    Include? include,
  }) async {
    return _databaseConnection.find<T>(
      _session,
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

  /// Find a single [TableRow] from a table, using the provided [where]
  Future<T?> findFirstRow<T extends TableRow>({
    Expression? where,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    Transaction? transaction,
    Include? include,
  }) async {
    return await _databaseConnection.findFirstRow<T>(
      _session,
      where: where,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  /// Find a single [TableRow] by its [id] or null if no such row exists. It's
  /// often useful to cast the object returned.
  ///
  ///     var myRow = session.db.findById<MyClass>(myId);
  Future<T?> findById<T extends TableRow>(
    int id, {
    Transaction? transaction,
    Include? include,
  }) async {
    return _databaseConnection.findById<T>(
      _session,
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Update all [TableRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// update, none of the rows will be updated.
  Future<List<T>> update<T extends TableRow>(
    List<T> rows, {
    List<Column>? columns,
    Transaction? transaction,
  }) async {
    return _databaseConnection.update<T>(
      _session,
      rows,
      columns: columns,
      transaction: transaction,
    );
  }

  /// Updates a single [TableRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<T> updateRow<T extends TableRow>(
    T row, {
    List<Column>? columns,
    Transaction? transaction,
  }) async {
    return _databaseConnection.updateRow<T>(
      _session,
      row,
      columns: columns,
      transaction: transaction,
    );
  }

  /// Inserts all [TableRow]s in the list and returns the inserted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// insert, none of the rows will be inserted.
  Future<List<T>> insert<T extends TableRow>(
    List<T> rows, {
    Transaction? transaction,
  }) async {
    return _databaseConnection.insert<T>(
      _session,
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TableRow] and returns the inserted row.
  Future<T> insertRow<T extends TableRow>(
    T row, {
    Transaction? transaction,
  }) async {
    return _databaseConnection.insertRow<T>(
      _session,
      row,
      transaction: transaction,
    );
  }

  /// Deletes all [TableRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<T>> delete<T extends TableRow>(
    List<T> rows, {
    Transaction? transaction,
  }) async {
    return _databaseConnection.delete<T>(
      _session,
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TableRow].
  Future<T> deleteRow<T extends TableRow>(
    T row, {
    Transaction? transaction,
  }) async {
    return await _databaseConnection.deleteRow<T>(
      _session,
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<T>> deleteWhere<T extends TableRow>({
    required Expression where,
    Transaction? transaction,
  }) async {
    return _databaseConnection.deleteWhere<T>(
      _session,
      where,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count<T extends TableRow>({
    Expression? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return _databaseConnection.count<T>(
      _session,
      where: where,
      limit: limit,
      transaction: transaction,
    );
  }

  /// Executes a single SQL query. A [List] of rows represented of another
  /// [List] with columns will be returned.
  ///
  /// You are responsible to sanitize the query to avoid SQL injection. Always
  /// use QueryParameters for passing values to SQL queries.
  Future<DatabaseResult> unsafeQuery(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) async {
    return _databaseConnection.query(
      _session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
      parameters: parameters,
    );
  }

  /// Executes a single SQL query. Returns the number of rows that were affected
  /// by the query.
  ///
  /// You are responsible to sanitize the query to avoid SQL injection. Always
  /// use QueryParameters for passing values to SQL queries.
  Future<int> unsafeExecute(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) async {
    return _databaseConnection.execute(
      _session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
      parameters: parameters,
    );
  }

  /// Executes a single SQL query in simple query mode.
  /// A [List] of rows represented of another [List] with columns will be
  /// returned.
  ///
  /// The simple query protocol does not support parameter binding.
  /// You are responsible to sanitize the query to avoid SQL injection.
  ///
  /// Simple query mode is useful for queries that contain multiple statements.
  Future<DatabaseResult> unsafeSimpleQuery(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    return _databaseConnection.simpleQuery(
      _session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );
  }

  /// Executes a single SQL query in simple query mode.
  /// Returns the number of rows that were affected by the query.
  ///
  /// The simple query protocol does not support parameter binding.
  /// You are responsible to sanitize the query to avoid SQL injection.
  ///
  /// Simple query mode is useful for queries that contain multiple statements.
  Future<int> unsafeSimpleExecute(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    return _databaseConnection.simpleExecute(
      _session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );
  }

  /// Executes a [Transaction].
  Future<R> transaction<R>(TransactionFunction<R> transactionFunction) async {
    return await _databaseConnection.transaction(
      transactionFunction,
    );
  }

  /// Tests the database connection.
  /// Returns true if the connection is working.
  /// Throws an exception if the connection is not working.
  Future<bool> testConnection() {
    return _databaseConnection.testConnection();
  }
}
