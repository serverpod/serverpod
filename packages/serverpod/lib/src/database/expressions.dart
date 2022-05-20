import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

/// A database [Expression].
class Expression {
  /// The [String] representation of the [Expression]. Note that the precedence
  /// of operators may not be what you think, so always use parentheses to make
  /// sure that that expressions are executed in the correct order.
  final String expression;

  /// Creates a new [Expression].
  Expression(this.expression);

  @override
  String toString() {
    return expression;
  }

  /// Database AND operator.
  Expression operator &(dynamic other) {
    assert(other is Expression);
    return Expression('($this AND $other)');
  }

  /// Database OR operator.
  Expression operator |(dynamic other) {
    assert(other is Expression);
    return Expression('($this OR $other)');
  }

  /// Database greater than operator.
  Expression operator >(dynamic other) {
    if (other is! Expression) {
      other = DatabasePoolManager.encoder.convert(other);
    }
    return Expression('($this > $other)');
  }

  /// Database greater or equal than operator.
  Expression operator >=(dynamic other) {
    if (other is! Expression) {
      other = DatabasePoolManager.encoder.convert(other);
    }
    return Expression('($this >= $other)');
  }

  /// Database less than operator.
  Expression operator <(dynamic other) {
    if (other is! Expression) {
      other = DatabasePoolManager.encoder.convert(other);
    }
    return Expression('($this < $other)');
  }

  /// Database less or equal than operator.
  Expression operator <=(dynamic other) {
    if (other is! Expression) {
      other = DatabasePoolManager.encoder.convert(other);
    }
    return Expression('($this <= $other)');
  }
}

/// Abstract class representing a database [Column]. Subclassed by the different
/// supported column types such as [ColumnInt] or [ColumnString].
abstract class Column extends Expression {
  /// Corresponding dart [Type].
  final Type type;

  /// Maximum length for a varchar
  final int? varcharLength;

  final String _columnName;

  /// Name of the [Column].
  String get columnName => _columnName;

  /// Creates a new [Column], this is typically done in generated code only.
  Column(this._columnName, this.type, {this.varcharLength})
      : super('"$_columnName"');
}

/// A [Column] holding an [int].
class ColumnInt extends Column {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnInt(String name) : super(name, int);

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(int? value) {
    if (value == null) {
      return Expression('"$columnName" IS NULL');
    } else {
      return Expression('"$columnName" = $value');
    }
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(int? value) {
    if (value == null) {
      return Expression('"$columnName" IS NOT NULL');
    } else {
      return Expression('"$columnName" != $value');
    }
  }
}

/// A [Column] holding an [double].
class ColumnDouble extends Column {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDouble(String name) : super(name, double);

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(double? value) {
    if (value == null) {
      return Expression('"$columnName" IS NULL');
    } else {
      return Expression('"$columnName" = $value');
    }
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(double? value) {
    if (value == null) {
      return Expression('"$columnName" IS NOT NULL');
    } else {
      return Expression('"$columnName" != $value');
    }
  }
}

/// A [Column] holding an [String].
class ColumnString extends Column {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnString(String name, {int? varcharLength})
      : super(name, String, varcharLength: varcharLength);

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(String? value) {
    if (value == null) {
      return Expression('"$columnName" IS NULL');
    } else {
      return Expression(
          '"$columnName" = ${DatabasePoolManager.encoder.convert(value)}');
    }
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(String? value) {
    if (value == null) {
      return Expression('"$columnName" IS NOT NULL');
    } else {
      return Expression(
          '"$columnName" != ${DatabasePoolManager.encoder.convert(value)}');
    }
  }

  /// Creates an [Expression] checking if the value in the column is LIKE the
  /// specified value. See Postgresql docs for more info on the LIKE operator.
  Expression like(String value) {
    return Expression(
        '"$columnName" LIKE ${DatabasePoolManager.encoder.convert(value)}');
  }

  /// Creates an [Expression] checking if the value in the column is LIKE the
  /// specified value but ignoring case. See Postgresql docs for more info on
  /// the ILIKE operator.
  Expression ilike(String value) {
    return Expression(
        '"$columnName" ILIKE ${DatabasePoolManager.encoder.convert(value)}');
  }
}

/// A [Column] holding an [bool].
class ColumnBool extends Column {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnBool(String name) : super(name, bool);

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(bool? value) {
    if (value == null) {
      return Expression('"$columnName" IS NULL');
    } else {
      return Expression('"$columnName" = $value');
    }
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(bool? value) {
    if (value == null) {
      return Expression('"$columnName" IS NOT NULL');
    } else {
      return Expression('"$columnName" != $value');
    }
  }

  /// Creates an [Expression] checking if the value in the column is distinct
  /// from the specified value.
  Expression isDistinctFrom(bool value) {
    return Expression('"$columnName" IS DISTINCT FROM $value');
  }
}

/// A [Column] holding an [DateTime]. In the database it is stored as a
/// timestamp without time zone.
class ColumnDateTime extends Column {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDateTime(String name) : super(name, DateTime);

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(DateTime? value) {
    if (value == null) {
      return Expression('"$columnName" IS NULL');
    } else {
      return Expression(
          '"$columnName" = ${DatabasePoolManager.encoder.convert(value)}');
    }
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(DateTime? value) {
    if (value == null) {
      return Expression('"$columnName" IS NOT NULL');
    } else {
      return Expression(
          '"$columnName" != ${DatabasePoolManager.encoder.convert(value)}');
    }
  }
}

/// A [Column] holding [ByteData].
class ColumnByteData extends Column {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnByteData(String name) : super(name, ByteData);
}

/// A [Column] holding an [SerializableEntity]. The entity will be stored in the
/// database as a json column.
class ColumnSerializable extends Column {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnSerializable(String name) : super(name, String);

  // TODO: Add comparisons and possibly other operations
}

/// A constant [Expression].
class Constant extends Expression {
  // TODO: Handle more types

  /// Creates a constant [Expression]. Currently supports [bool] and [String].
  Constant(dynamic value) : super(_formatValue(value));

  static String _formatValue(dynamic value) {
    if (value == null) return 'NULL';
    if (value is bool) {
      return '$value'.toUpperCase();
    } else if (value is String) {
      return '\'$value\'';
    } else {
      throw const FormatException();
    }
  }
}

/// Represents a database table.
class Table {
  /// Name of the table as used in the database.
  final String tableName;
  late List<Column>? _columns;

  /// List of [Column] used by the table.
  List<Column> get columns => _columns!;

  /// Creates a new [Table]. Typically, this is done only by generated code.
  Table({required this.tableName, List<Column>? columns}) {
    _columns = columns;
  }

  @override
  String toString() {
    var str = '$tableName\n';
    for (var col in columns) {
      str += '  ${col.columnName} (${col.type})\n';
    }
    return str;
  }
}
