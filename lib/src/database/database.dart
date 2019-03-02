import 'dart:io';
import 'dart:mirrors';

import 'package:postgres/postgres.dart';
import 'package:yaml/yaml.dart';

import 'table.dart';
import '../server/protocol.dart';

class Database {
  PostgreSQLConnection connection;
  SerializationManager _serializationManager;

  Database(SerializationManager serializationManager, String host, int port, String name, String user, String pass) {
    _serializationManager = serializationManager;
    connection = PostgreSQLConnection(host, port, name, username: user, password: pass);
  }

  Future<bool> connect() async {
    await connection.open();
    return !connection.isClosed;
  }

  Future<TableRow> findById(String tableName, int id) async {
    var result = await find(tableName, Expression('id = $id'));
    if (result.length == 0)
      return null;
    return result[0];
  }
  
  Future<List<TableRow>> find(String tableName, Expression exp) async {
    var query = 'SELECT * FROM $tableName WHERE $exp';

    print('query: $query');

    var list = <TableRow>[];
    var result = await connection.mappedResultsQuery(query);

    for (var rawRow in result) {
      list.add(_formatTableRow(tableName, rawRow[tableName]));
    }

    return list;
  }

  TableRow _formatTableRow(String tableName, Map<String, dynamic> rawRow) {
    String className = _serializationManager.tableClassMapping[tableName];
    ClassMirror classMirror = _serializationManager.serializableClassMirrors[className];
    if (classMirror == null)
      return null;

    TableRow table = classMirror.newInstance(Symbol(''), []).reflectee;

    for (var columnName in rawRow.keys) {
      var value = rawRow[columnName];
      table.setColumn(columnName, value);
    }

    return table;
  }
}

class Expression {
  final String expression;

  const Expression(this.expression);

  @override
  String toString() {
    return expression;
  }

  Expression and(Expression other) {
    return Expression('$this AND $other');
  }

  Expression equals(Expression other) {
    return Expression('$this = $other');
  }
}

class Column extends Expression {
  final Type type;
  const Column(String name, this.type) : super(name);
}

class Constant extends Expression {
  const Constant(String value) : super('\'$value\'');
}