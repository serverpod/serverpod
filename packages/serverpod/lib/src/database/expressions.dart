import 'database_config.dart';

class Expression {
  final String expression;

  Expression(this.expression);

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
      other = DatabaseConfig.encoder.convert(other);
    return Expression('($this > $other)');
  }

  Expression operator >= (dynamic other) {
    if (!(other is Expression))
      other = DatabaseConfig.encoder.convert(other);
    return Expression('($this >= $other)');
  }

  Expression operator < (dynamic other) {
    if (!(other is Expression))
      other = DatabaseConfig.encoder.convert(other);
    return Expression('($this < $other)');
  }

  Expression operator <= (dynamic other) {
    if (!(other is Expression))
      other = DatabaseConfig.encoder.convert(other);
    return Expression('($this <= $other)');
  }
}

abstract class Column extends Expression {
  final Type type;
  final int? varcharLength;
  final String _columnName;

  Column(String this._columnName, this.type, {this.varcharLength}) : super('"$_columnName"');

  String get columnName => _columnName;
}

class ColumnInt extends Column {
  ColumnInt(String name) : super (name, int);

  Expression equals(int? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = $value');
  }

  Expression notEquals(int? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NOT NULL');
    else
      return Expression('"${this.columnName}" != $value');
  }
}

class ColumnDouble extends Column {
  ColumnDouble(String name) : super (name, double);

  Expression equals(double? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = $value');
  }

  Expression notEquals(double? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NOT NULL');
    else
      return Expression('"${this.columnName}" != $value');
  }
}

class ColumnString extends Column {
  ColumnString(String name, {int? varcharLength}) : super (name, String, varcharLength: varcharLength);

  Expression equals(String? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = ${DatabaseConfig.encoder.convert(value)}');
  }

  Expression notEquals(String? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NOT NULL');
    else
      return Expression('"${this.columnName}" != ${DatabaseConfig.encoder.convert(value)}');
  }

  Expression like(String value) {
    return Expression('"${this.columnName}" LIKE ${DatabaseConfig.encoder.convert(value)}');
  }

  Expression ilike(String value) {
    return Expression('"${this.columnName}" ILIKE ${DatabaseConfig.encoder.convert(value)}');
  }
}

class ColumnBool extends Column {
  ColumnBool(String name) : super (name, bool);

  Expression equals(bool? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = $value');
  }

  Expression notEquals(bool? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NOT NULL');
    else
      return Expression('"${this.columnName}" != $value');
  }

  Expression isDistinctFrom(bool value) {
    return Expression('"${this.columnName}" IS DISTINCT FROM $value');
  }
}

class ColumnDateTime extends Column {
  ColumnDateTime(String name) : super (name, DateTime);

  Expression equals(DateTime? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NULL');
    else
      return Expression('"${this.columnName}" = ${DatabaseConfig.encoder.convert(value)}');
  }

  Expression notEquals(DateTime? value) {
    if (value == null)
      return Expression('"${this.columnName}" IS NOT NULL');
    else
      return Expression('"${this.columnName}" != ${DatabaseConfig.encoder.convert(value)}');
  }
}

class ColumnSerializable extends Column {
  ColumnSerializable(String name) : super (name, String);
  
  // TODO: Add comparisons and possibly other operations
}

class Constant extends Expression {
  // TODO: Handle more types
  Constant(dynamic? value) : super(_formatValue(value));

  static String _formatValue(dynamic value) {
    if (value == null)
      return 'NULL';
    if (value is bool)
      return '$value'.toUpperCase();
    else if (value is String)
      return '\'$value\'';
    else
      throw FormatException();
  }
}

class Table {
  final String tableName;
  late List<Column>? _columns;
  List<Column> get columns => _columns!;

  Table({required this.tableName, List<Column>? columns}) {
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