import 'dart:async';
import 'dart:typed_data';

import 'package:retry/retry.dart';

import '../server/session.dart';
import 'database_connection.dart';
import 'expressions.dart';
import 'table.dart';

/// Provides easy access to the database in relation to the current [Session].
class Database {
  /// The [Session] the database is currently related to.
  Session session;

  DatabaseConnection? _databaseConnection;

  /// The [DatabaseConnection] currently used to access the database.
  Future<DatabaseConnection> get databaseConnection async {
    if (_databaseConnection != null) return _databaseConnection!;
    return DatabaseConnection(session.server.databaseConfig);
  }

  /// Creates a new [Database] object. Typically, this is done automatically
  /// when a [Session] is created.
  Database({required this.session});

  /// Find a single [TableRow] by its [id] or null if no such row exists. It's
  /// often useful to cast the object returned.
  ///
  ///     var myRow = session.db.findById(tMyTable, myId) as MyTable;
  Future<T?> findById<T>(
    int id, {
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;
    return await conn.findById<T>(
      id,
      session: session,
      transaction: transaction,
    );
  }

  /// Find a list of [TableRow]s from a table, using the provided [where]
  /// expression, optionally using [limit], [offset], and [orderBy]. To order by
  /// multiple columns, user [orderByList]. If [where] is omitted, all rows in
  /// the table will be returned.
  Future<List<T>> find<T>({
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;

    return await conn.find<T>(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      session: session,
      transaction: transaction,
    );
  }

  /// Find a list of [Distinct Column]s from a table, using the provided [where]
  /// expression, optionally using [limit], [offset], and [orderBy]. To order by
  /// multiple columns, user [orderByList]. If [where] is omitted, all rows in
  /// the table will be returned.
  Future<List> findDistinctValue<T>({
    Expression? where,
    int? limit,
    List<Column>? columns,
    bool? returnAsList,
    bool? isDistinct,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;
    return await conn.findDistinctValue<T>(
      where: where,
      limit: limit,
      offset: offset,
      returnAsList: returnAsList,
      columns: columns,
      isDistinct: isDistinct,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      session: session,
      transaction: transaction,
    );
  }

  /// Find a single [TableRow] from a table, using the provided [where]
  /// expression, optionally using [limit], [offset], and [orderBy]. To order by
  /// multiple columns, user [orderByList].
  Future<T?> findSingleRow<T>({
    Expression? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;

    return await conn.findSingleRow<T>(
      where: where,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      session: session,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count<T>({
    Expression? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;

    return await conn.count<T>(
      where: where,
      limit: limit,
      useCache: useCache,
      session: session,
      transaction: transaction,
    );
  }

  /// Updates a single [TableRow]. The row needs to have its id set.
  Future<bool> update(
    TableRow row, {
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;

    return await conn.update(
      row,
      session: session,
      transaction: transaction,
    );
  }

  /// Inserts a single [TableRow].
  Future<void> insert(
    TableRow row, {
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;

    await conn.insert(
      row,
      session: session,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<int> delete<T>({
    required Expression where,
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;

    return await conn.delete<T>(
      where: where,
      session: session,
      transaction: transaction,
    );
  }

  /// Deletes a single [TableRow].
  Future<bool> deleteRow(
    TableRow row, {
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;

    return await conn.deleteRow(
      row,
      session: session,
      transaction: transaction,
    );
  }

  /// Stores a file in the database, specifically using the
  /// serverpod_cloud_storage table. Used by the the [DatabaseCloudStorage].
  Future<void> storeFile(String storageId, String path, ByteData byteData,
      DateTime? expiration, bool verified) async {
    var conn = await databaseConnection;

    return await conn.storeFile(storageId, path, byteData, expiration, verified,
        session: session);
  }

  /// Retrieves a file stored in the database or null if it doesn't exist,
  /// specifically using the serverpod_cloud_storage table. Used by the the
  /// [DatabaseCloudStorage].
  Future<ByteData?> retrieveFile(
    String storageId,
    String path,
  ) async {
    var conn = await databaseConnection;

    return await conn.retrieveFile(storageId, path, session: session);
  }

  /// Verifies that a file has been successfully uploaded.
  Future<bool> verifyFile(
    String storageId,
    String path,
  ) async {
    var conn = await databaseConnection;

    return await conn.verifyFile(storageId, path, session: session);
  }

  /// Executes a single SQL query. A [List] of rows represented of another
  /// [List] with columns will be returned.
  Future<List<List<dynamic>>> query(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;

    return conn.query(
      query,
      session: session,
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
    var conn = await databaseConnection;
    return await conn.transaction(
      transactionFunction,
      retryOptions: retryOptions,
      orElse: orElse,
      retryIf: retryIf,
    );
  }

  /// Inserts/Update a Multiple [TableRow].
  /// [id] must be null to all values or not null to all value
  Future<void> insertOrupdateBulk(
    List<TableRow> row,
    Table table, {
    Transaction? transaction,
  }) async {
    var conn = await databaseConnection;
    await conn.insertOrupdateBulk(
      row,
      table,
      session: session,
      transaction: transaction,
    );
  }
}
