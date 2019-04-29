import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:postgres/src/text_codec.dart';
import 'package:yaml/yaml.dart';

import 'table.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

final PostgresTextEncoder _encoder = const PostgresTextEncoder(true);

class Database {
  PostgreSQLConnection connection;
  SerializationManager _serializationManager;

  final _tableClassMapping = <String, String>{};

  Database(SerializationManager serializationManager, String host, int port, String name, String user, String pass) {
    _serializationManager = serializationManager;
    connection = PostgreSQLConnection(host, port, name, username: user, password: pass);
    if (_serializationManager != null)
      _loadTableClassMappings();
  }

  bool _loadTableClassMappings() {
    // Parse yaml files for data
    var dir = Directory('bin/protocol');
    var list = dir.listSync();
    for (var entity in list) {
      if (entity is File && entity.path.endsWith('.yaml')) {
        _addDefinition(entity);
      }
    }
    return true;
  }

  void _addDefinition(File file) {
    String yamlStr = file.readAsStringSync();
    var doc = loadYaml(yamlStr);

    String name = doc['tableName'];
    String className = doc['class'];

    _tableClassMapping[name] = className;
  }

  Future<bool> connect() async {
    await connection.open();
    return !connection.isClosed;
  }

  Future<Null> disconnect() async {
    await connection.close();
  }

  Future<List<String>> getTableNames() async {
    var tableNames = <String>[];

    var query = 'SELECT * FROM pg_catalog.pg_tables';
    var result = await connection.mappedResultsQuery(query);

    for (Map row in result) {
      row = row.values.first;
      if (row['schemaname'] == 'public')
        tableNames.add(row['tablename']);
    }

    return tableNames;
  }

  Future<Table> getTableDescription(String tableName) async {
    var query = 'select column_name, data_type, character_maximum_length from INFORMATION_SCHEMA.COLUMNS where table_name =\'$tableName\'';
    var result = await connection.mappedResultsQuery(query);
    var columns = <Column>[];

    bool hasID = false;
    for (Map row in result) {
      row = row.values.first;
      String columnName = row['column_name'];
      String sqlType = row['data_type'];
      int varcharLength = row['character_maximum_length'];
      Type type = _sqlTypeToDartType(sqlType);

      if (columnName == 'id' && type == int)
        hasID = true;

      if (type == null) {
        return null;
      }

      if (type == String)
        columns.add(ColumnString(columnName, varcharLength: varcharLength));
      else if (type == int)
        columns.add(ColumnInt(columnName));
      else if (type == double)
        columns.add(ColumnDouble(columnName));
      else if (type == DateTime)
        columns.add(ColumnDateTime(columnName));
    }

    if (!hasID) {
      return null;
    }

    return Table(
      tableName: tableName,
      columns: columns,
    );
  }

  Type _sqlTypeToDartType(String type) {
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

  Future<TableRow> findById(Table table, int id) async {
    var result = await find(
      table,
      where: Expression('id = $id'),
    );
    if (result.length == 0)
      return null;
    return result[0];
  }
  
  Future<List<TableRow>> find(Table table, {Expression where, int limit, int offset, Column orderBy, bool orderDescending=false, bool useCache=true}) async {
    String tableName = table.tableName;
    var query = 'SELECT * FROM $tableName WHERE $where';
    if (orderBy != null) {
      query += ' ORDER BY $orderBy';
      if (orderDescending)
        query += ' DESC';
    }
    if (limit != null)
      query += ' LIMIT $limit';
    if (offset != null)
      query += ' OFFSET $offset';

    print('query: $query');

    var list = <TableRow>[];
    var result = await connection.mappedResultsQuery(query);

    for (var rawRow in result) {
      list.add(_formatTableRow(tableName, rawRow[tableName]));
    }

    return list;
  }

  Future<TableRow> findSingleRow(Table table, {Expression where, int offset, Column orderBy, bool orderDescending=false, bool useCache=true}) async {
    var result = await find(table, where: where, orderBy: orderBy, orderDescending: orderDescending, useCache: useCache, limit: 1, offset: offset);
    if (result.length == 0)
      return null;
    else
      return result[0];
  }

  TableRow _formatTableRow(String tableName, Map<String, dynamic> rawRow) {
    String className = _tableClassMapping[tableName];
    if (className == null)
      return null;

    var data = <String, dynamic>{};

    for (var columnName in rawRow.keys) {
      var value = rawRow[columnName];
      if (value is DateTime)
        data[columnName] = value.toIso8601String();
      else
        data[columnName] = value;
    }

    var serialization = <String, dynamic> {'data': data, 'class': className};

    return _serializationManager.createEntityFromSerialization(serialization);
  }

  Future<int> count(Table table, {Expression where, int limit, bool useCache=true}) async {
    String tableName = table.tableName;
    var query = 'SELECT COUNT(*) as c FROM $tableName WHERE $where';
    if (limit != null)
      query += ' LIMIT $limit';
    print('$query');

    var result = await connection.query(query);
    if (result.length != 1)
      return 0;

    List returnedRow = result[0];
    if (returnedRow.length != 1)
      return 0;

    return returnedRow[0];
  }

  Future<bool> update(TableRow row, {Transaction transaction}) async {
    Map data = row.serializeForDatabase()['data'];

    int id = data['id'];

    var updatesList = <String>[];

    for(String column in data.keys) {
      if (column == 'id')
        continue;
      String value = _encoder.convert(data[column]);

      updatesList.add('"$column" = $value');
    }
    String updates = updatesList.join(', ');

    var query = 'UPDATE ${row.tableName} SET $updates WHERE id = $id';

    if (transaction != null) {
      transaction._queries.add(query);
      transaction._database = this;
      return null;
    }

    print('$query');

    int affectedRows = await connection.execute(query);
    return affectedRows == 1;
  }

  Future<bool> insert(TableRow row, {Transaction transaction}) async {
    Map data = row.serializeForDatabase()['data'];

    var columnsList = <String>[];
    var valueList = <String>[];

    for(String column in data.keys) {
      if (column == 'id')
        continue;

      String value = _encoder.convert(data[column]);
      if (value == null)
        continue;

      columnsList.add('"$column"');
      valueList.add(value);
    }
    String columns = columnsList.join(', ');
    String values = valueList.join(', ');

    var query = 'INSERT INTO ${row.tableName} ($columns) VALUES ($values) RETURNING id';

    if (transaction != null) {
      transaction._queries.add(query);
      transaction._database = this;
      return null;
    }
    print('$query');

    List<List<dynamic>> result;
    try {
      result = await connection.query(query);
      if (result.length != 1)
        return false;
    }
    catch (e) {
      return false;
    }

    List returnedRow = result[0];
    if (returnedRow.length != 1)
      return false;

    row.setColumn('id', returnedRow[0]);
    return true;
  }

  Future<int> delete(Table table, {Expression where, Transaction transaction}) async {
    assert(where != null, 'Missing where parameter');

    String tableName = table.tableName;

    var query = 'DELETE FROM $tableName WHERE $where';

    if (transaction != null) {
      transaction._queries.add(query);
      transaction._database = this;
      return null;
    }

    print('$query');
    int affectedRows = await connection.execute(query);

    return affectedRows;
  }

  Future<bool> deleteRow(TableRow row, {Transaction transaction}) async {
    var query = 'DELETE FROM ${row.tableName} WHERE id = ${row.id}';

    if (transaction != null) {
      transaction._queries.add(query);
      transaction._database = this;
      return null;
    }

    print('$query');
    int affectedRows = await connection.execute(query);

    return affectedRows == 1;
  }
}

class Transaction {
  List<String> _queries = [];
  Database _database;

  Future<bool> execute() async {
    assert(_queries.length > 0, 'No queries added to transaction');
    assert(_database != null, 'Database cannot be null');

    try {
      await _database.connection.transaction((
          PostgreSQLExecutionContext ctx) async {
        for (var query in _queries) {
          await ctx.query(query);
        }
      });
    }
    catch (e) {
      return false;
    }
    return true;
  }
}

class Expression {
  final String expression;

  const Expression(this.expression);

  @override
  String toString() {
    return expression;
  }

  Expression operator & (dynamic other) {
    assert(other is Expression);
    return Expression('($this AND $other)');
  }

  Expression operator | (dynamic other) {
    assert(other is Expression);
    return Expression('($this OR $other)');
  }

  Expression operator > (dynamic other) {
    return Expression('($this > $other)');
  }

  Expression operator >= (dynamic other) {
    return Expression('($this >= $other)');
  }

  Expression operator < (dynamic other) {
    return Expression('($this < $other)');
  }

  Expression operator <= (dynamic other) {
    return Expression('($this <= $other)');
  }

  Expression operator + (dynamic other) {
    return Expression('($this = $other)');
  }

  Expression operator - (dynamic other) {
    return Expression('($this != $other)');
  }
}

abstract class Column extends Expression {
  final Type type;
  final int varcharLength;
  final String _columnName;

  const Column(String this._columnName, this.type, {this.varcharLength}) : super('"$_columnName"');

  String get columnName => expression;
}

class ColumnInt extends Column {
  const ColumnInt(String name) : super (name, int);

  Expression equals(int value) {
    if (value == null)
      return Expression('${this.columnName} IS NULL');
    else
      return Expression('${this.columnName} = $value');
  }

  Expression notEquals(int value) {
    return Expression('${this.columnName} != $value');
  }
}

class ColumnDouble extends Column {
  const ColumnDouble(String name) : super (name, double);

  Expression equals(double value) {
    if (value == null)
      return Expression('${this.columnName} IS NULL');
    else
      return Expression('${this.columnName} = $value');
  }

  Expression notEquals(double value) {
    if (value == null)
      return Expression('${this.columnName} IS NOT NULL');
    else
      return Expression('${this.columnName} != $value');
  }
}

class ColumnString extends Column {
  const ColumnString(String name, {int varcharLength}) : super (name, String, varcharLength: varcharLength);

  Expression equals(String value) {
    if (value == null)
      return Expression('${this.columnName} IS NULL');
    else
      return Expression('${this.columnName} = ${_encoder.convert(value)}');
  }

  Expression notEquals(String value) {
    if (value == null)
      return Expression('${this.columnName} IS NOT NULL');
    else
      return Expression('${this.columnName} != ${_encoder.convert(value)}');
  }
}

class ColumnBool extends Column {
  const ColumnBool(String name) : super (name, bool);

  Expression equals(bool value) {
    if (value == null)
      return Expression('${this.columnName} IS NULL');
    else
      return Expression('${this.columnName} = $value');
  }

  Expression notEquals(bool value) {
    if (value == null)
      return Expression('${this.columnName} IS NOT NULL');
    else
      return Expression('${this.columnName} != $value');
  }
}

class ColumnDateTime extends Column {
  const ColumnDateTime(String name) : super (name, DateTime);

  Expression equals(bool value) {
    if (value == null)
      return Expression('${this.columnName} IS NULL');
    else
      return Expression('${this.columnName} = ${_encoder.convert(value)}');
  }

  Expression notEquals(bool value) {
    if (value == null)
      return Expression('${this.columnName} IS NOT NULL');
    else
      return Expression('${this.columnName} != ${_encoder.convert(value)}');
  }
}

class Constant extends Expression {
  const Constant(String value) : super('\'$value\'');
}

class Table {
  final String tableName;
  List<Column> _columns;
  List<Column> get columns => _columns;

  Table({this.tableName, List<Column> columns}) {
    _columns = columns;
  }

  @override
  String toString() {
    String str = '$tableName\n';
    for (var col in columns) {
      str += '  ${col.columnName} (${col.type})\n';
    }
    return str;
  }
}