import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:serverpod/server.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import '../generated/protocol.dart';

import 'database_config.dart';
import 'table.dart';
import 'expressions.dart';
import 'package:serverpod_postgres_pool/postgres_pool.dart';
import '../server/session.dart';

/// A connection to the database. In most cases the [Database] db object in
/// the [Session] object should be used when connecting with the database.
class DatabaseConnection {
  /// Database configuration.
  final DatabaseConfig config;

  /// Access to the raw Postgresql connection pool.
  late PgPool postgresConnection;

  /// Creates a new database connection from the configuration. For most cases
  /// this shouldn't be called directly, use the db object in the [Session] to
  /// access the database.
  DatabaseConnection(this.config) {
    postgresConnection = config.pool;
  }

  /// Returns a list of names of all tables in the current database.
  Future<List<String>> getTableNames() async {
    List<String?> tableNames = <String>[];

    var query = 'SELECT * FROM pg_catalog.pg_tables';
    var result = await postgresConnection.mappedResultsQuery(
      query,
      allowReuse: false,
      timeoutInSeconds: 60,
      substitutionValues: {},
    );

    for (Map row in result) {
      row = row.values.first;
      if (row['schemaname'] == 'public')
        tableNames.add(row['tablename']);
    }

    return tableNames as FutureOr<List<String>>;
  }

  /// Returns a description for a table in the database.
  Future<Table?> getTableDescription(String tableName) async {
    var query = 'select column_name, data_type, character_maximum_length from INFORMATION_SCHEMA.COLUMNS where table_name =\'$tableName\'';
    var result = await postgresConnection.mappedResultsQuery(
      query,
      allowReuse: false,
      timeoutInSeconds: 60,
      substitutionValues: {},
    );
    var columns = <Column>[];

    var hasID = false;
    for (Map row in result) {
      row = row.values.first;
      String? columnName = row['column_name'];
      String? sqlType = row['data_type'];
      int? varcharLength = row['character_maximum_length'];
      var type = _sqlTypeToDartType(sqlType);

      if (columnName == 'id' && type == int)
        hasID = true;

      if (type == null) {
        return null;
      }

      if (type == String)
        columns.add(ColumnString(columnName!, varcharLength: varcharLength));
      else if (type == int)
        columns.add(ColumnInt(columnName!));
      else if (type == double)
        columns.add(ColumnDouble(columnName!));
      else if (type == DateTime)
        columns.add(ColumnDateTime(columnName!));
    }

    if (!hasID) {
      return null;
    }

    return Table(
      tableName: tableName,
      columns: columns,
    );
  }

  Type? _sqlTypeToDartType(String? type) {
    if (type == 'character varying' || type == 'text')
      return String;
    if (type == 'integer')
      return int;
    if (type == 'boolean')
      return bool;
    if (type == 'double precision')
      return double;
    if (type == 'timestamp without time zone' || type == 'date')
      return DateTime;
    return null;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<TableRow?> findById(Table table, int id, {Session? session}) async {
    var result = await find(
      table,
      where: Expression('id = $id'),
      session: session,
    );
    if (result.isEmpty)
      return null;
    return result[0];
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<TableRow>> find(Table table, {Expression? where, int? limit, int? offset, Column? orderBy, List<Order>? orderByList, bool orderDescending=false, bool useCache=true, Session? session}) async {
    assert(orderByList == null || orderBy == null);

    var startTime = DateTime.now();
    where ??= Expression('TRUE');

    var tableName = table.tableName;
    var query = 'SELECT * FROM $tableName WHERE $where';
    if (orderBy != null) {
      query += ' ORDER BY $orderBy';
      if (orderDescending)
        query += ' DESC';
    }
    else if (orderByList != null) {
      assert(orderByList.isNotEmpty);

      var strList = <String>[];
      for (var order in orderByList)
        strList.add(order.toString());

      query += ' ORDER BY ${strList.join(',')}';
    }
    if (limit != null)
      query += ' LIMIT $limit';
    if (offset != null)
      query += ' OFFSET $offset';

    List<TableRow?> list = <TableRow>[];
    try {
      var result = await postgresConnection.mappedResultsQuery(
        query,
        allowReuse: false,
        timeoutInSeconds: 60,
        substitutionValues: {},
      );
      for (var rawRow in result) {
        list.add(_formatTableRow(tableName, rawRow[tableName]));
      }
    }
    catch(e, trace) {
      _logQuery(session, query, startTime, exception: e, trace: trace);
      rethrow;
    }

    _logQuery(session, query, startTime, numRowsAffected: list.length);
    return list as FutureOr<List<TableRow>>;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<TableRow?> findSingleRow(Table table, {Expression? where, int? offset, Column? orderBy, bool orderDescending=false, bool useCache=true, Session? session}) async {
    var result = await find(table, where: where, orderBy: orderBy, orderDescending: orderDescending, useCache: useCache, limit: 1, offset: offset, session: session);

    if (result.isEmpty)
      return null;
    else
      return result[0];
  }

  TableRow? _formatTableRow(String tableName, Map<String, dynamic>? rawRow) {
    String? className = config.tableClassMapping[tableName];
    if (className == null)
      return null;

    var data = <String, dynamic>{};

    for (var columnName in rawRow!.keys) {
      var value = rawRow[columnName];

      if (value is DateTime) {
        data[columnName] = value.toIso8601String();
      }
      else if (value is Uint8List) {
        throw(UnimplementedError('Binary storage is not yet supported.'));

        // TODO: It seems like the Postgres driver is returning incorrect data
        // var byteData = ByteData.view(value.buffer);
        // data[columnName] = byteData.base64encodedString();
      }
      else {
        data[columnName] = value;
      }
    }

    var serialization = <String, dynamic> {'data': data, 'class': className};

    return config.serializationManager.createEntityFromSerialization(serialization) as TableRow?;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> count(Table table, {Expression? where, int? limit, bool useCache=true, Session? session}) async {
    var startTime = DateTime.now();

    where ??= Expression('TRUE');

    var tableName = table.tableName;
    var query = 'SELECT COUNT(*) as c FROM $tableName WHERE $where';
    if (limit != null)
      query += ' LIMIT $limit';

    try {
      var result = await postgresConnection.query(query, allowReuse: false, substitutionValues: {});

      if (result.length != 1)
        return 0;

      List returnedRow = result[0];
      if (returnedRow.length != 1)
        return 0;

      _logQuery(session, query, startTime, numRowsAffected: 1);
      return returnedRow[0];
    }
    catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<bool> update(TableRow row, {Transaction? transaction, Session? session}) async {
    var startTime = DateTime.now();

    Map data = row.serializeForDatabase()['data'];

    int? id = data['id'];

    var updatesList = <String>[];

    for(var column in data.keys as Iterable<String>) {
      if (column == 'id')
        continue;
      var value = DatabaseConfig.encoder.convert(data[column]);

      updatesList.add('"$column" = $value');
    }
    var updates = updatesList.join(', ');

    var query = 'UPDATE ${row.tableName} SET $updates WHERE id = $id';

    if (transaction != null) {
      transaction._queries.add(query);
      return false;
    }

    try {
      var affectedRows = await postgresConnection.execute(query, substitutionValues: {});
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows == 1;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<bool> insert(TableRow row, {Transaction? transaction, Session? session}) async {
    var startTime = DateTime.now();

    Map data = row.serializeForDatabase()['data'];

    var columnsList = <String>[];
    var valueList = <String>[];

    for(var column in data.keys as Iterable<String>) {
      if (column == 'id')
        continue;

      if (data[column] is Map || data[column] is List)
        data[column] = jsonEncode(data[column]);

      String value;
      var unformattedValue = data[column];
      // TODO: Support binary stores in the database
      // if (unformattedValue is String && unformattedValue.startsWith('decode(\'')/* && unformattedValue.endsWith('\', \'base64\')') */) {
      //   // TODO:
      //   // This is a bit of a hack since strings that starts with
      //   // `convert('` and ends with `', 'base64') will be incorrectly encoded
      //   // to base64. Best would be to find a better way to detect when we are
      //   // trying to store a ByteData.
      //   print('DETECTED BINARY');
      //   value = data[column];
      // }
      // else {
      //   value = DatabaseConfig.encoder.convert(unformattedValue);
      // }
      value = DatabaseConfig.encoder.convert(unformattedValue);

      columnsList.add('"$column"');
      valueList.add(value);
    }
    var columns = columnsList.join(', ');
    var values = valueList.join(', ');

    var query = 'INSERT INTO ${row.tableName} ($columns) VALUES ($values) RETURNING id';

    if (transaction != null) {
      transaction._queries.add(query);
      return false;
    }

    List<List<dynamic>> result;
    try {
      result = await postgresConnection.query(query, allowReuse: false, substitutionValues: {});
      if (result.length != 1)
        return false;
    }
    catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      return false;
    }

    var returnedRow = result[0];

    _logQuery(session, query, startTime, numRowsAffected: returnedRow.length);

    if (returnedRow.length != 1)
      return false;

    row.setColumn('id', returnedRow[0]);
    return true;
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<int> delete(Table table, {required Expression where, Transaction? transaction, Session? session}) async {
    var startTime = DateTime.now();

    var tableName = table.tableName;

    var query = 'DELETE FROM $tableName WHERE $where';

    if (transaction != null) {
      transaction._queries.add(query);
      return 0;
    }

    try {
      var affectedRows = await postgresConnection.execute(query, substitutionValues: {});
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows;
    }
    catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<bool> deleteRow(TableRow row, {Transaction? transaction, Session? session}) async {
    var startTime = DateTime.now();

    var query = 'DELETE FROM ${row.tableName} WHERE id = ${row.id}';

    if (transaction != null) {
      transaction._queries.add(query);
      return false;
    }

    try {
      var affectedRows = await postgresConnection.execute(query, substitutionValues: {});
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows == 1;
    }
    catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<void> storeFile(String storageId, String path, ByteData byteData, DateTime? expiration, {Session? session}) async {
    var startTime = DateTime.now();
    var query = '';
    try {
      // query = 'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, @byteData';
      var encoded = byteData.base64encodedString();
      query = 'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, $encoded) ON CONFLICT("storageId", "path") DO UPDATE SET "byteData"=$encoded, "addedTime"=@addedTime, "expiration"=@expiration';
      await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: {
          'storageId': storageId,
          'path': path,
          'addedTime': DateTime.now().toUtc(),
          'expiration': expiration?.toUtc(),
          // TODO: Use substitution value for the data for efficiency (seems not to work with the driver currently).
          // 'byteData': byteData.buffer.asUint8List(),
        },
      );
      _logQuery(session, query, startTime);
    }
    catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<ByteData?> retrieveFile(String storageId, String path, {Session? session}) async {
    var startTime = DateTime.now();
    var query = '';
    try {
      // query = 'INSERT INTO serverpod_cloud_storage ("storageId", "path", "addedTime", "expiration", "byteData") VALUES (@storageId, @path, @addedTime, @expiration, @byteData';
      query = 'SELECT encode("byteData", \'base64\') AS "encoded" FROM serverpod_cloud_storage WHERE "storageId"=@storageId AND path=@path';
      var result = await postgresConnection.query(
        query,
        allowReuse: false,
        substitutionValues: {
          'storageId': storageId,
          'path': path,
        },
      );
      _logQuery(session, query, startTime);
      if (result.isNotEmpty) {
        var encoded = (result.first.first as String).replaceAll('\n', '');
        return ByteData.view(base64Decode(encoded).buffer);
      }
      return null;
    }
    catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<List<List<dynamic>>> query(String query, {Session? session, int? timeoutInSeconds}) async {
    var startTime = DateTime.now();

    try {
      var result = await postgresConnection.query(query, allowReuse: false, timeoutInSeconds: timeoutInSeconds, substitutionValues: {});
      _logQuery(session, query, startTime);
      return result;
    }
    catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  /// For most cases use the corresponding method in [Database] instead.
  Future<bool> executeTransaction(Transaction transaction, {Session? session}) async {
    return await transaction._execute(postgresConnection, this, session);
  }

  void _logQuery(Session? session, String query, DateTime startTime, {int? numRowsAffected, exception, StackTrace? trace}) {
    if (session == null)
      return;

    session.queries.add(
      QueryLogEntry(
        query: query,
        duration: DateTime.now().difference(startTime).inMicroseconds / 1000000.0,
        numRows: numRowsAffected,
        exception: exception?.toString(),
        stackTrace: trace?.toString(),
      ),
    );
  }
}

/// Defines how to order a database [column].
class Order {
  /// The columns to order by.
  final Column column;

  /// Whether the column should be ordered ascending or descending.
  final bool orderDescending;

  /// Creates a new [Order] definition for a specific [column] and whether it
  /// should be ordered descending or ascending.
  Order({required this.column, this.orderDescending=false});

  @override
  String toString() {
    var str = '$column';
    if (orderDescending)
      str += ' DESC';
    return str;
  }
}

// TODO: Transactions

/// Represents a database transaction.
class Transaction {
  final List<String> _queries = [];

  Future<bool> _execute(PgPool postgresConnection, DatabaseConnection conn, Session? session) async {
    // Ignore empty transactions
    if (_queries.isEmpty)
      return true;

    var query = _queries.join('\n');
    query = 'BEGIN;\n$query\nCOMMIT;';

    var startTime = DateTime.now();

    try {
      await postgresConnection.runTx((PostgreSQLExecutionContext ctx) async {
       for (var query in _queries) {
         await ctx.query(
           query,
           substitutionValues: {},
         );
       }
      });
    }
    catch (e) {
      conn._logQuery(session, query, startTime, exception: e);
      return false;
    }

    conn._logQuery(session, query, startTime);
    return true;
  }
}
