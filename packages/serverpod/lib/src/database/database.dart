import 'dart:async';

import 'package:serverpod/src/database/concepts/columns.dart';
import 'package:serverpod/src/database/concepts/database_result.dart';
import 'package:serverpod/src/database/concepts/includes.dart';
import 'package:serverpod/src/database/concepts/order.dart';
import 'package:serverpod/src/database/concepts/transaction.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';
import 'package:serverpod/src/database/query_parameters.dart';

import '../server/session.dart';
import 'adapters/postgres/database_connection.dart';
import 'concepts/expressions.dart';
import 'concepts/table.dart';

/// Extension to only expose the [Database] constructor
/// internally within the Serverpod package.
extension DatabaseConstructor on Database {
  /// Creates a new [Database] object.
  static Database create({
    required Session session,
    required DatabasePoolManager poolManager,
  }) {
    return Database._(session: session, poolManager: poolManager);
  }
}

/// Provides easy access to the database in relation to the current [Session].
class Database {
  final Session _session;

  final DatabaseConnection _databaseConnection;

  /// Creates a new [Database] object. Typically, this is done automatically
  /// when a [Session] is created.
  Database._({
    required Session session,
    required DatabasePoolManager poolManager,
  })  : _session = session,
        _databaseConnection = DatabaseConnection(poolManager);

  /// Returns a list of [TableRow]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after with [limit] (or all)
  /// items are read from the database.
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
      include: include,
    );
  }

  /// Returns the first matching [TableRow] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
      include: include,
    );
  }

  /// Finds a single [TableRow] by its [id] or null if no such row exists. It's
  /// often useful to cast the object returned.
  ///
  /// ```dart
  /// var myRow = session.db.findById<MyClass>(myId);
  /// ```
  Future<T?> findById<T extends TableRow>(
    int id, {
    Transaction? transaction,
    Include? include,
  }) async {
    return _databaseConnection.findById<T>(
      _session,
      id,
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
      include: include,
    );
  }

  /// Updates all [TableRow]s in the list and returns the updated rows. If
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
    );
  }

  /// Inserts all [TableRow]s in the list and returns the inserted rows.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<T>> insert<T extends TableRow>(
    List<T> rows, {
    Transaction? transaction,
  }) async {
    return _databaseConnection.insert<T>(
      _session,
      rows,
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
    );
  }

  /// Deletes all [TableRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// be deleted, none of the rows will be deleted.
  Future<List<T>> delete<T extends TableRow>(
    List<T> rows, {
    Transaction? transaction,
  }) async {
    return _databaseConnection.delete<T>(
      _session,
      rows,
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
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
      // ignore: invalid_use_of_visible_for_testing_member
      transaction: transaction ?? _session.transaction,
    );
  }

  /// Executes a [Transaction].
  Future<R> transaction<R>(
    TransactionFunction<R> transactionFunction, {
    TransactionSettings? settings,
  }) async {
    return await _databaseConnection.transaction(
      transactionFunction,
      settings: settings ?? const TransactionSettings(),
      session: _session,
    );
  }

  /// Tests the database connection.
  /// Returns true if the connection is working.
  /// Throws an exception if the connection is not working.
  Future<bool> testConnection() {
    return _databaseConnection.testConnection();
  }
}
