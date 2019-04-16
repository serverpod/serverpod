import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:yaml/yaml.dart';

import 'table.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

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

  Future<TableDescription> getTableDescription(String tableName) async {
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

      columns.add(Column(columnName, type, varcharLength: varcharLength));
    }

    if (!hasID) {
      return null;
    }

    return TableDescription(
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

  Future<TableRow> findById(String tableName, int id) async {
    var result = await find(
      tableName,
      expression: Expression('id = $id'),
    );
    if (result.length == 0)
      return null;
    return result[0];
  }
  
  Future<List<TableRow>> find(String tableName, {Expression expression, int limit, int offset, Column orderBy, bool orderDescending=false, bool useCache=true}) async {
    var query = 'SELECT * FROM $tableName WHERE $expression';
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

  Future<Null> update(TableRow row) async {
    Map data = row.serialize()['data'];

    int id = data['id'];

    var updatesList = <String>[];

    for(String column in data.keys) {
      if (column == 'id')
        continue;

      updatesList.add('$column = \'${data[column]}\'');
    }
    String updates = updatesList.join(', ');

    var query = 'UPDATE ${row.tableName} SET $updates WHERE id = $id';
    print('$query');

    int affectedRows = await connection.execute(query);
    print('updated $affectedRows rows');
  }
}

class Expression {
  final String expression;

  const Expression(this.expression);

  Expression.equalsInt(Column col, int value) : expression = '${col.columnName} = $value' {
    assert(col.type == int);
  }

  Expression.equalsDouble(Column col, double value) : expression = '${col.columnName} = $value' {
    assert(col.type == double);
  }

  Expression.equalsBool(Column col, bool value) : expression = '${col.columnName} = $value' {
    assert(col.type == bool);
  }

  Expression.equalsString(Column col, String value) : expression = '${col.columnName} = \'$value\'' {
    assert(col.type == String);
  }

  @override
  String toString() {
    return expression;
  }

  Expression equals(Expression other) {
    return Expression('($this = $other)');
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

class Column extends Expression {
  final Type type;
  final int varcharLength;

  const Column(String name, this.type, {this.varcharLength}) : super(name);

  String get columnName => expression;
}

class Constant extends Expression {
  const Constant(String value) : super('\'$value\'');
}

class TableDescription {
  final String tableName;
  final List<Column> columns;

  TableDescription({this.tableName, this.columns});

  @override
  String toString() {
    String str = '$tableName\n';
    for (var col in columns) {
      str += '  ${col.columnName} (${col.type})\n';
    }
    return str;
  }
}