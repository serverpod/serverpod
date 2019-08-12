import 'dart:async';
import 'dart:io';

import 'package:postgres/src/text_codec.dart';
import 'package:resource/src/resolve.dart';
import 'package:yaml/yaml.dart';

import 'package:serverpod_serialization/serverpod_serialization.dart';

class Database {
  final String host;
  final int port;
  final String databaseName;
  final String userName;
  final String password;
  SerializationManager _serializationManager;
  SerializationManager get serializationManager => _serializationManager;

  final tableClassMapping = <String, String>{};
  static final PostgresTextEncoder encoder = const PostgresTextEncoder(true);

  Database(SerializationManager serializationManager, this.host, this.port, this.databaseName, this.userName, this.password) {
    _serializationManager = serializationManager;
  }

  Future<Null> initialize() async {
    if (_serializationManager != null) {
      await _loadTableClassMappings('bin/protocol');
      await _loadTableClassMappings('package:serverpod/src/protocol');
    }
  }

  Future<bool> _loadTableClassMappings(String directory) async {
    if (directory.startsWith('package:')) {
      var uri = await resolveUri(Uri.parse(directory));
      directory = uri.path;
    }

    // Parse yaml files for data
    var dir = Directory(directory);
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

    tableClassMapping[name] = className;
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
    if (!(other is Expression))
      other = Database.encoder.convert(other);
    return Expression('($this > $other)');
  }

  Expression operator >= (dynamic other) {
    if (!(other is Expression))
      other = Database.encoder.convert(other);
    return Expression('($this >= $other)');
  }

  Expression operator < (dynamic other) {
    if (!(other is Expression))
      other = Database.encoder.convert(other);
    return Expression('($this < $other)');
  }

  Expression operator <= (dynamic other) {
    if (!(other is Expression))
      other = Database.encoder.convert(other);
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

  String get columnName => _columnName;
}

class ColumnInt extends Column {
  const ColumnInt(String name) : super (name, int);

  Expression equals(int value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = $value');
  }

  Expression notEquals(int value) {
    return Expression('"${this.columnName}" != $value');
  }
}

class ColumnDouble extends Column {
  const ColumnDouble(String name) : super (name, double);

  Expression equals(double value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = $value');
  }

  Expression notEquals(double value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NOT NULL');
    else
      return Expression('"${this.columnName}" != $value');
  }
}

class ColumnString extends Column {
  const ColumnString(String name, {int varcharLength}) : super (name, String, varcharLength: varcharLength);

  Expression equals(String value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = ${Database.encoder.convert(value)}');
  }

  Expression notEquals(String value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NOT NULL');
    else
      return Expression('"${this.columnName}" != ${Database.encoder.convert(value)}');
  }
}

class ColumnBool extends Column {
  const ColumnBool(String name) : super (name, bool);

  Expression equals(bool value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = $value');
  }

  Expression notEquals(bool value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NOT NULL');
    else
      return Expression('"${this.columnName}" != $value');
  }
}

class ColumnDateTime extends Column {
  const ColumnDateTime(String name) : super (name, DateTime);

  Expression equals(bool value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = ${Database.encoder.convert(value)}');
  }

  Expression notEquals(bool value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NOT NULL');
    else
      return Expression('"${this.columnName}" != ${Database.encoder.convert(value)}');
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