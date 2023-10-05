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
@Deprecated('Will be removed in 2.0.0. Use Database instead.')
class DatabaseLegacy {
  /// The [Session] the database is currently related to.
  Session session;

  /// The [DatabaseConnection] currently used to access the database.
  DatabaseConnection databaseConnection;

  /// Creates a new [Database] object. Typically, this is done automatically
  /// when a [Session] is created.
  DatabaseLegacy({required this.session})
      : databaseConnection = DatabaseConnection(session.server.databaseConfig);

  /// Find a single [TableRow] by its [id] or null if no such row exists. It's
  /// often useful to cast the object returned.
  ///
  ///     var myRow = session.db.findById(tMyTable, myId) as MyTable;
  Future<T?> findById<T extends TableRow>(
    int id, {
    Transaction? transaction,
    Include? include,
  }) async {
    return databaseConnection.findById<T>(
      session,
      id,
      transaction: transaction,
      include: include,
    );
  }

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
    return databaseConnection.find<T>(
      session,
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
  /// expression, optionally using [limit], [offset], and [orderBy]. To order by
  /// multiple columns, user [orderByList].
  Future<T?> findSingleRow<T extends TableRow>({
    Expression? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
    Include? include,
  }) async {
    var rows = await databaseConnection.find<T>(
      session,
      where: where,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );

    if (rows.isEmpty) return null;
    return rows.first;
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count<T extends TableRow>({
    Expression? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return databaseConnection.count<T>(
      session,
      where: where,
      limit: limit,
      transaction: transaction,
    );
  }

  /// Updates a single [TableRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<bool> update<T extends TableRow>(
    TableRow row, {
    List<Column>? columns,
    Transaction? transaction,
  }) async {
    return await databaseConnection.legacy.update(
      row,
      session: session,
      columns: columns,
      transaction: transaction,
    );
  }

  /// Inserts a single [TableRow].
  Future<void> insert(
    TableRow row, {
    Transaction? transaction,
  }) async {
    await databaseConnection.legacy.insert(
      row,
      session: session,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<int> delete<T extends TableRow>({
    required Expression where,
    Transaction? transaction,
  }) async {
    var list = await databaseConnection.deleteWhere<T>(
      session,
      where,
      transaction: transaction,
    );
    return list.length;
  }

  /// Deletes all rows matching the [where] expression, returns all deleted
  /// rows.
  Future<List<T>> deleteAndReturn<T extends TableRow>({
    required Expression where,
    Transaction? transaction,
  }) async {
    return await databaseConnection.legacy.deleteAndReturn<T>(
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
    await databaseConnection.legacy.deleteRow(
      row,
      session: session,
      transaction: transaction,
    );
    return true;
  }

  /// Stores a file in the database, specifically using the
  /// serverpod_cloud_storage table. Used by the the [DatabaseCloudStorage].
  Future<void> storeFile(String storageId, String path, ByteData byteData,
      DateTime? expiration, bool verified) async {
    return await databaseConnection.legacy.storeFile(
        storageId, path, byteData, expiration, verified,
        session: session);
  }

  /// Retrieves a file stored in the database or null if it doesn't exist,
  /// specifically using the serverpod_cloud_storage table. Used by the the
  /// [DatabaseCloudStorage].
  Future<ByteData?> retrieveFile(
    String storageId,
    String path,
  ) async {
    return await databaseConnection.legacy
        .retrieveFile(storageId, path, session: session);
  }

  /// Verifies that a file has been successfully uploaded.
  Future<bool> verifyFile(
    String storageId,
    String path,
  ) async {
    return await databaseConnection.legacy.verifyFile(
      storageId,
      path,
      session: session,
    );
  }

  /// Executes a single SQL query. A [List] of rows represented of another
  /// [List] with columns will be returned.
  Future<PostgreSQLResult> query(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    return databaseConnection.query(
      session,
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: transaction,
    );
  }

  /// Executes a single SQL query. Returns the number of rows that were affected
  /// by the query.
  Future<int> execute(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
  }) async {
    return databaseConnection.execute(
      session,
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
    return await databaseConnection.transaction(
      transactionFunction,
      retryOptions: retryOptions,
      orElse: orElse,
      retryIf: retryIf,
    );
  }
}
