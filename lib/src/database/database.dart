import 'dart:io';
import 'dart:mirrors';

import 'package:postgres/postgres.dart';
import 'package:yaml/yaml.dart';

import '../database/table.dart';

class Database {
  PostgreSQLConnection connection;

  final _tableNames = <String, String>{};
  final _tableClassMirrors = <String, ClassMirror>{};

  Database(String host, int port, String name, String user, String pass) {
    connection = PostgreSQLConnection(host, port, name, username: user, password: pass);

  }

  Future<bool> loadDefinitions() async {
    // Parse yaml files for data
    var dir = Directory('bin/database');
    var list = dir.listSync();
    for (var entity in list) {
      if (entity is File && entity.path.endsWith('.yaml')) {
        _addDefinition(entity);
      }
    }

    // Find mirrors for generated table classes
    for (var libName in currentMirrorSystem().libraries.keys) {
      if (libName.toString().contains('bin/database/')) {
        // Look for table classes in each matching library
        for (String tableName in _tableNames.keys) {
          String className = _tableNames[tableName];

          LibraryMirror libraryMirror = currentMirrorSystem().libraries[libName];
          ClassMirror classMirror = libraryMirror.declarations[Symbol(className)];

          if (classMirror != null)
            _tableClassMirrors[tableName] = classMirror;
        }
      }
    }

    return true;
  }

  void _addDefinition(File file) {
    String yamlStr = file.readAsStringSync();
    var doc = loadYaml(yamlStr);

    String name = doc['tableName'];
    String className = doc['class'];

    _tableNames[name] = className;
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
    ClassMirror classMirror = _tableClassMirrors[tableName];
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