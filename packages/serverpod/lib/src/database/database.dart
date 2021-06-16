import 'dart:typed_data';

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
    if (_databaseConnection != null)
      return _databaseConnection!;
    return DatabaseConnection(session.server.databaseConfig);
  }

  /// Creates a new [Database] object. Typically, this is done automatically
  /// when a [Session] is created.
  Database({required this.session});

  /// Find a single [TableRow] by its [id] or null if no such row exists. It's
  /// often useful to cast the object returned.
  ///
  ///     var myRow = session.db.findById(tMyTable, myId) as MyTable;
  Future<TableRow?> findById(Table table, int id) async {
    var conn = await databaseConnection;
    return await conn.findById(table, id, session: session);
  }

  /// Find a list of [TableRow]s from a table, using the provided [where]
  /// expression, optionally using [limit], [offset], and [orderBy]. To order by
  /// multiple columns, user [orderByList]. If [where] is omitted, all rows in
  /// the table will be returned.
  Future<List<TableRow>> find(Table table, {Expression? where, int? limit, int? offset, Column? orderBy, List<Order>? orderByList, bool orderDescending=false, bool useCache=true}) async {
    var conn = await databaseConnection;

    return await conn.find(
      table,
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      session: session,
    );
  }

  /// Find a single [TableRow] from a table, using the provided [where]
  /// expression, optionally using [limit], [offset], and [orderBy]. To order by
  /// multiple columns, user [orderByList].
  Future<TableRow?> findSingleRow(Table table, {Expression? where, int? offset, Column? orderBy, bool orderDescending=false, bool useCache=true}) async {
    var conn = await databaseConnection;

    return await conn.findSingleRow(
      table,
      where: where,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      session: session,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(Table table, {Expression? where, int? limit, bool useCache=true}) async {
    var conn = await databaseConnection;

    return await conn.count(
      table,
      where: where,
      limit: limit,
      useCache: useCache,
      session: session,
    );
  }

  /// Updates a single [TableRow]. The row needs to have its id set.
  Future<bool> update(TableRow row, {Transaction? transaction}) async {
    var conn = await databaseConnection;

    return await conn.update(
      row,
      transaction: transaction,
      session: session,
    );
  }

  /// Inserts a single [TableRow].
  Future<bool> insert(TableRow row, {Transaction? transaction}) async {
    var conn = await databaseConnection;

    return await conn.insert(
      row,
      transaction: transaction,
      session: session,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<int> delete(Table table, {required Expression where, Transaction? transaction}) async {
    var conn = await databaseConnection;

    return await conn.delete(
      table,
      where: where,
      transaction: transaction,
      session: session,
    );
  }

  /// Deletes a single [TableRow].
  Future<bool> deleteRow(TableRow row, {Transaction? transaction}) async {
    var conn = await databaseConnection;

    return await conn.deleteRow(
      row,
      transaction: transaction,
      session: session,
    );
  }

  /// Stores a file in the database, specifically using the
  /// serverpod_cloud_storage table. Used by the the [DatabaseCloudStorage].
  Future<void> storeFile(String storageId, String path, ByteData byteData, DateTime? expiration) async {
    var conn = await databaseConnection;

    return await conn.storeFile(storageId, path, byteData, expiration, session: session);
  }

  /// Retrieves a file stored in the database or null if it doesn't exist,
  /// specifically using the serverpod_cloud_storage table. Used by the the
  /// [DatabaseCloudStorage].
  Future<ByteData?> retrieveFile(String storageId, String path,) async {
    var conn = await databaseConnection;

    return await conn.retrieveFile(storageId, path, session: session);
  }

  /// Executes a single SQL query. A [List] of rows represented of another
  /// [List] with columns will be returned.
  Future<List<List<dynamic>>> query(String query, {int? timeoutInSeconds}) async {
    var conn = await databaseConnection;

    return conn.query(
      query,
      session: session,
      timeoutInSeconds: timeoutInSeconds,
    );
  }

  /// Executes a [Transaction].
  Future<bool> executeTransation(Transaction transaction) async {
    var conn = await databaseConnection;

    return conn.executeTransaction(
      transaction,
      session: session,
    );
  }
}