import '../server/session.dart';

import 'database_connection.dart';
import 'expressions.dart';
import 'table.dart';

class Database {
  Session session;

  DatabaseConnection? _databaseConnection;
  Future<DatabaseConnection> get databaseConnection async {
    if (_databaseConnection != null)
      return _databaseConnection!;
    return DatabaseConnection(session.server.databaseConnection);
  }

  Database({required this.session});

  Future<TableRow?> findById(Table table, int id) async {
    var conn = await databaseConnection;
    return await conn.findById(table, id, session: session);
  }

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

  Future<bool> update(TableRow row, {Transaction? transaction}) async {
    var conn = await databaseConnection;

    return await conn.update(
      row,
      transaction: transaction,
      session: session,
    );
  }

  Future<bool> insert(TableRow row, {Transaction? transaction}) async {
    var conn = await databaseConnection;

    return await conn.insert(
      row,
      transaction: transaction,
      session: session,
    );
  }

  Future<int> delete(Table table, {required Expression where, Transaction? transaction}) async {
    var conn = await databaseConnection;

    return await conn.delete(
      table,
      where: where,
      transaction: transaction,
      session: session,
    );
  }

  Future<bool> deleteRow(TableRow row, {Transaction? transaction}) async {
    var conn = await databaseConnection;

    return await conn.deleteRow(
      row,
      transaction: transaction,
      session: session,
    );
  }

  Future<List<List<dynamic>>> query(String query, {int? timeoutInSeconds}) async {
    var conn = await databaseConnection;

    return conn.query(
      query,
      session: session,
      timeoutInSeconds: timeoutInSeconds,
    );
  }
}