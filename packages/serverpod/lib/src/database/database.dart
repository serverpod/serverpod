import 'dart:async';
import 'dart:typed_data';

import 'package:postgres/postgres.dart';
import 'package:retry/retry.dart';
import 'package:serverpod/src/database/columns.dart';

import '../server/session.dart';
import 'database_connection.dart';
import 'expressions.dart';
import 'table.dart';

/// Provides easy access to the database in relation to the current [Session].
class Database {
  final Session _session;

  final DatabaseConnection _databaseConnection;

  /// Creates a new [Database] object. Typically, this is done automatically
  /// when a [Session] is created.
  Database({required Session session})
      : _session = session,
        _databaseConnection = DatabaseConnection(session.server.databaseConfig);

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
    bool useCache = true,
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
  Future<T?> findRow<T extends TableRow>({
    Expression? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    Transaction? transaction,
    Include? include,
  }) async {
    return await _databaseConnection.findRow<T>(
      _session,
      where: where,
      offset: offset,
      orderBy: orderBy,
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

  /// Updates a single [TableRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<T> updateRow<T extends TableRow>(
    TableRow row, {
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

  /// Inserts a single [TableRow] and returns the inserted row.
  Future<T> insertRow<T extends TableRow>(
    TableRow row, {
    Transaction? transaction,
  }) async {
    return _databaseConnection.insertRow<T>(
      _session,
      row,
      transaction: transaction,
    );
  }

  /// Deletes a single [TableRow].
  Future<int> deleteRow<T extends TableRow>(
    TableRow row, {
    Transaction? transaction,
  }) async {
    return await _databaseConnection.deleteRow(
      _session,
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<int>> deleteWhere<T extends TableRow>({
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

  /// Stores a file in the database, specifically using the
  /// serverpod_cloud_storage table. Used by the the [DatabaseCloudStorage].
  Future<void> storeFile(
    String storageId,
    String path,
    ByteData byteData,
    DateTime? expiration,
    bool verified,
  ) async {
    return await _databaseConnection.legacy.storeFile(
        storageId, path, byteData, expiration, verified,
        session: _session);
  }

  /// Retrieves a file stored in the database or null if it doesn't exist,
  /// specifically using the serverpod_cloud_storage table. Used by the the
  /// [DatabaseCloudStorage].
  Future<ByteData?> retrieveFile(
    String storageId,
    String path,
  ) async {
    return await _databaseConnection.legacy
        .retrieveFile(storageId, path, session: _session);
  }

  /// Verifies that a file has been successfully uploaded.
  Future<bool> verifyFile(
    String storageId,
    String path,
  ) async {
    return await _databaseConnection.legacy.verifyFile(
      storageId,
      path,
      session: _session,
    );
  }

  /// Executes a single SQL query. A [List] of rows represented of another
  /// [List] with columns will be returned.
  /// You are responsible to sanitize the query to avoid SQL injection.
  Future<PostgreSQLResult> queryDangerously(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    return _databaseConnection.query(
      _session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );
  }

  /// Executes a single SQL query. Returns the number of rows that were affected
  /// by the query.
  /// You are responsible to sanitize the query to avoid SQL injection.
  Future<int> executeDangerously(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    return _databaseConnection.execute(
      _session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );
  }

  /// Executes a [Transaction].
  Future<R> transaction<R>(
    TransactionFunction<R> transactionFunction, {
    RetryOptions? retryOptions,
    FutureOr<R> Function()? orElse,
    FutureOr<bool> Function(Exception exception)? retryIf,
  }) async {
    return await _databaseConnection.transaction(
      transactionFunction,
      retryOptions: retryOptions,
      orElse: orElse,
      retryIf: retryIf,
    );
  }
}
