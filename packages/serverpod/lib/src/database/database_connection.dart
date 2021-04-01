import 'dart:async';
import 'database_config.dart';
import 'table.dart';
import 'expressions.dart';
import 'package:postgres_pool/postgres_pool.dart';
import '../server/session.dart';

class DatabaseConnection {
  final DatabaseConfig database;
  late PgPool postgresConnection;

//  PostgreSQLConnection postgresConnection;

  DatabaseConnection(this.database) {
    postgresConnection = database.pool;
  }

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

  Future<Table?> getTableDescription(String tableName) async {
    var query = 'select column_name, data_type, character_maximum_length from INFORMATION_SCHEMA.COLUMNS where table_name =\'$tableName\'';
    var result = await postgresConnection.mappedResultsQuery(
      query,
      allowReuse: false,
      timeoutInSeconds: 60,
      substitutionValues: {},
    );
    var columns = <Column>[];

    bool hasID = false;
    for (Map row in result) {
      row = row.values.first;
      String? columnName = row['column_name'];
      String? sqlType = row['data_type'];
      int? varcharLength = row['character_maximum_length'];
      Type? type = _sqlTypeToDartType(sqlType);

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

  Future<TableRow?> findById(Table table, int id, {Session? session}) async {
    var result = await find(
      table,
      where: Expression('id = $id'),
      session: session,
    );
    if (result.length == 0)
      return null;
    return result[0];
  }

  Future<List<TableRow>> find(Table table, {Expression? where, int? limit, int? offset, Column? orderBy, List<Order>? orderByList, bool orderDescending=false, bool useCache=true, Session? session}) async {
    assert(orderByList == null || orderBy == null);

    var startTime = DateTime.now();
    if (where == null)
      where = Expression('TRUE');

    String tableName = table.tableName;
    var query = 'SELECT * FROM $tableName WHERE $where';
    if (orderBy != null) {
      query += ' ORDER BY $orderBy';
      if (orderDescending)
        query += ' DESC';
    }
    else if (orderByList != null) {
      assert(orderByList.length > 0);

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

  Future<TableRow?> findSingleRow(Table table, {Expression? where, int? offset, Column? orderBy, bool orderDescending=false, bool useCache=true, Session? session}) async {
    var result = await find(table, where: where, orderBy: orderBy, orderDescending: orderDescending, useCache: useCache, limit: 1, offset: offset, session: session);

    if (result.length == 0)
      return null;
    else
      return result[0];
  }

  TableRow? _formatTableRow(String tableName, Map<String, dynamic>? rawRow) {
    String? className = database.tableClassMapping[tableName];
    if (className == null)
      return null;

    var data = <String, dynamic>{};

    for (var columnName in rawRow!.keys) {
      var value = rawRow[columnName];
      if (value is DateTime)
        data[columnName] = value.toIso8601String();
      else
        data[columnName] = value;
    }

    var serialization = <String, dynamic> {'data': data, 'class': className};

    return database.serializationManager.createEntityFromSerialization(serialization) as TableRow?;
  }

  Future<int> count(Table table, {Expression? where, int? limit, bool useCache=true, Session? session}) async {
    var startTime = DateTime.now();

    if (where == null)
      where = Expression('TRUE');

    String tableName = table.tableName;
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

  Future<bool> update(TableRow row, {Transaction? transaction, Session? session}) async {
    DateTime startTime = DateTime.now();

    Map data = row.serializeForDatabase()['data'];

    int? id = data['id'];

    var updatesList = <String>[];

    for(String column in data.keys as Iterable<String>) {
      if (column == 'id')
        continue;
      String value = DatabaseConfig.encoder.convert(data[column]);

      updatesList.add('"$column" = $value');
    }
    String updates = updatesList.join(', ');

    var query = 'UPDATE ${row.tableName} SET $updates WHERE id = $id';

    if (transaction != null) {
      transaction._queries.add(query);
      transaction.connection = this;
      return false;
    }

    try {
      int affectedRows = await postgresConnection.execute(query);
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows == 1;
    } catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  Future<bool> insert(TableRow row, {Transaction? transaction, Session? session}) async {
    DateTime startTime = DateTime.now();

    Map data = row.serializeForDatabase()['data'];

    var columnsList = <String>[];
    var valueList = <String>[];

    for(String column in data.keys as Iterable<String>) {
      if (column == 'id')
        continue;

      String value = DatabaseConfig.encoder.convert(data[column]);

      columnsList.add('"$column"');
      valueList.add(value);
    }
    String columns = columnsList.join(', ');
    String values = valueList.join(', ');

    var query = 'INSERT INTO ${row.tableName} ($columns) VALUES ($values) RETURNING id';

    if (transaction != null) {
      transaction._queries.add(query);
      transaction.connection = this;
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

    List returnedRow = result[0];

    _logQuery(session, query, startTime, numRowsAffected: returnedRow.length);

    if (returnedRow.length != 1)
      return false;

    row.setColumn('id', returnedRow[0]);
    return true;
  }

  Future<int> delete(Table table, {required Expression where, Transaction? transaction, Session? session}) async {
    DateTime startTime = DateTime.now();

    String tableName = table.tableName;

    var query = 'DELETE FROM $tableName WHERE $where';

    if (transaction != null) {
      transaction._queries.add(query);
      transaction.connection = this;
      return 0;
    }

    try {
      int affectedRows = await postgresConnection.execute(query);
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows;
    }
    catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  Future<bool> deleteRow(TableRow row, {Transaction? transaction, Session? session}) async {
    DateTime startTime = DateTime.now();

    var query = 'DELETE FROM ${row.tableName} WHERE id = ${row.id}';

    if (transaction != null) {
      transaction._queries.add(query);
      transaction.connection = this;
      return false;
    }

    try {
      int affectedRows = await postgresConnection.execute(query);
      _logQuery(session, query, startTime, numRowsAffected: affectedRows);
      return affectedRows == 1;
    }
    catch (exception, trace) {
      _logQuery(session, query, startTime, exception: exception, trace: trace);
      rethrow;
    }
  }

  Future<List<List<dynamic>>> query(String query, {Session? session, int? timeoutInSeconds}) async {
    DateTime startTime = DateTime.now();

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

  void _logQuery(Session? session, String query, DateTime startTime, {int? numRowsAffected, exception, StackTrace? trace}) {
    if (session == null)
      return;

    session.queries.add(
      QueryInfo(
        query: query,
        time: DateTime.now().difference(startTime),
        numRows: numRowsAffected,
        exception: exception,
        stackTrace: trace,
      ),
    );
  }
}

class Order {
  final Column column;
  final bool orderDescending;

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

class Transaction {
  List<String> _queries = [];
  DatabaseConnection? connection;

  Future<bool> execute() async {
    assert(_queries.length > 0, 'No queries added to transaction');
    assert(connection != null, 'Database cannot be null');

    try {
      // TODO: Comply with new format
//      await connection.postgresConnection.transaction((
//          PostgreSQLExecutionContext ctx) async {
//        for (var query in _queries) {
//          await ctx.query(query);
//        }
//      });
    }
    catch (e) {
      return false;
    }
    return true;
  }
}
