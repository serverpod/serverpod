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
abstract class Column<T> extends Expression {
  /// Corresponding dart [Type].
  final Type type;

  /// Maximum length for a varchar
  final int? varcharLength;

  final String _columnName;

  /// Name of the [Column].
  String get columnName => _columnName;

  /// Encode a value for inclusion in a database query.
  String encodeValueForQuery(T value);

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(T? value) {
    if (value == null) {
      return Expression('"$columnName" IS NULL');
    } else {
      return Expression('"$columnName" = ${encodeValueForQuery(value)}');
    }
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(T? value) {
    if (value == null) {
      return Expression('"$columnName" IS NOT NULL');
    } else {
      return Expression('"$columnName" != ${encodeValueForQuery(value)}');
    }
  }

  /// Creates an [Expression] checking if the value in the column equals one of
  /// the values in the provided set. The provided set must not be empty.
  Expression inSet(Set<T> values) {
    assert(values.isNotEmpty);
    return Expression('"$columnName" IN '
        '(${values.map(encodeValueForQuery).join(',')})');
  }

  /// Creates an [Expression] checking if the value in the column is not equal
  /// to any of the values in the provided set. The provided set must not be
  /// empty.
  Expression notInSet(Set<T> values) {
    assert(values.isNotEmpty);
    return Expression('"$columnName" NOT IN '
        '(${values.map(encodeValueForQuery).join(',')})');
  }

  /// Creates a new [Column], this is typically done in generated code only.
  Column(this._columnName, {this.varcharLength})
      : type = T,
        super('"$_columnName"');
}

abstract class _ColumnEscaped<T> extends Column<T> {
  /// Creates a new [_ColumnEscaped], this is called internally only.
  _ColumnEscaped(super.columnName, {super.varcharLength});

  /// Escape the provided value for inclusion in an SQL query.
  @override
  String encodeValueForQuery(T value) =>
      DatabasePoolManager.encoder.convert(value);
}

abstract class _ColumnUnescaped<T> extends Column<T> {
  /// Creates a new [_ColumnEscaped], this is called internally only.
  _ColumnUnescaped(super.columnName, {super.varcharLength});

  /// Convert the provided value (such as an int or double) directly into
  /// a String, without escaping it first for use in a SQL statement.
  @override
  String encodeValueForQuery(T value) => value.toString();
}

/// A [Column] holding a [num].
class _ColumnNum<T extends num> extends _ColumnUnescaped<T> {
  /// Creates a new [_ColumnNum], this is typically done in generated code only.
  _ColumnNum(String name) : super(name);

  /// Creates an [Expression] checking if the value in the column is between
  /// a minimum and a maximum value (inclusive of the endpoints of the range).
  Expression between(T min, T max) {
    assert(min <= max);
    return Expression('"$columnName" BETWEEN '
        '${encodeValueForQuery(min)} AND ${encodeValueForQuery(max)}');
  }

  /// Creates an [Expression] checking if the value in the column is not between
  /// a minimum and a maximum value (i.e. is strictly less than the minimum
  /// or strictly greater than the maximum).
  Expression notBetween(T min, T max) {
    assert(min <= max);
    return Expression('"$columnName" NOT BETWEEN '
        '${encodeValueForQuery(min)} AND ${encodeValueForQuery(max)}');
  }
}

/// A [Column] holding an [int].
class ColumnInt extends _ColumnNum<int> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnInt(String name) : super(name);
}

/// A [Column] holding an [double].
class ColumnDouble extends _ColumnNum<double> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDouble(String name) : super(name);
}

/// A [Column] holding an enum.
class ColumnEnum<E extends Enum> extends Column<E> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnEnum(String name) : super(name);

  /// Encode enum as int.
  /// TODO conflicts with #1080, need to add a separate version for serializing
  /// enums to String.
  @override
  String encodeValueForQuery(E value) => value.index.toString();
}

/// A [Column] holding an [String].
class ColumnString extends _ColumnEscaped<String> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnString(String name, {int? varcharLength})
      : super(name, varcharLength: varcharLength);

  /// Creates an [Expression] checking if the value in the column is LIKE the
  /// specified value. See Postgresql docs for more info on the LIKE operator.
  Expression like(String value) {
    return Expression('"$columnName" LIKE ${encodeValueForQuery(value)}');
  }

  /// Creates an [Expression] checking if the value in the column is LIKE the
  /// specified value but ignoring case. See Postgresql docs for more info on
  /// the ILIKE operator.
  Expression ilike(String value) {
    return Expression('"$columnName" ILIKE ${encodeValueForQuery(value)}');
  }
}

/// A [Column] holding an [bool].
class ColumnBool extends _ColumnUnescaped<bool> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnBool(String name) : super(name);

  /// Creates an [Expression] checking if the value in the column is distinct
  /// from the specified value.
  Expression isDistinctFrom(bool value) {
    return Expression(
        '"$columnName" IS DISTINCT FROM ${encodeValueForQuery(value)}}');
  }
}

/// A [Column] holding an [DateTime]. In the database it is stored as a
/// timestamp without time zone.
class ColumnDateTime extends _ColumnEscaped<DateTime> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDateTime(String name) : super(name);

  /// Creates an [Expression] checking if the value in the column is between
  /// a minimum and a maximum [DateTime] (inclusive of the endpoints of the
  /// range).
  Expression between(DateTime min, DateTime max) {
    assert(min.isBefore(max));
    return Expression('"$columnName" BETWEEN '
        '${encodeValueForQuery(min)} AND ${encodeValueForQuery(max)}');
  }

  /// Creates an [Expression] checking if the value in the column is not between
  /// a minimum and a maximum [DateTime] (i.e. is strictly less than the minimum
  /// or strictly greater than the maximum).
  Expression notBetween(DateTime min, DateTime max) {
    assert(min.isBefore(max));
    return Expression('"$columnName" NOT BETWEEN '
        '${encodeValueForQuery(min)} AND ${encodeValueForQuery(max)}');
  }

  /// Creates an [Expression] checking if the value in the column is strictly
  /// less than a maximum [DateTime] (i.e. exclusive of the maximum).
  Expression before(DateTime dateTime) {
    return Expression('"$columnName" < ${encodeValueForQuery(dateTime)}');
  }

  /// Creates an [Expression] checking if the value in the column is
  /// less than or equal to a maximum [DateTime] (i.e. inclusive of the
  /// maximum).
  Expression equalsOrBefore(DateTime dateTime) {
    return Expression('"$columnName" <= ${encodeValueForQuery(dateTime)}');
  }

  /// Creates an [Expression] checking if the value in the column is strictly
  /// greater than a maximum [DateTime] (i.e. exclusive of the maximum).
  Expression after(DateTime dateTime) {
    return Expression('"$columnName" > ${encodeValueForQuery(dateTime)}');
  }

  /// Creates an [Expression] checking if the value in the column is
  /// greater than or equal to a maximum [DateTime] (i.e. inclusive of the
  /// maximum).
  Expression equalsOrAfter(DateTime dateTime) {
    return Expression('"$columnName" >= ${encodeValueForQuery(dateTime)}');
  }
}

/// A [Column] holding [ByteData].
class ColumnByteData extends _ColumnEscaped<ByteData> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnByteData(String name) : super(name);
}

/// A [Column] holding [Duration].
class ColumnDuration extends _ColumnEscaped<Duration> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDuration(String name) : super(name);
}

/// A [Column] holding [UuidValue].
class ColumnUuid extends _ColumnEscaped<UuidValue> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnUuid(String name) : super(name);
}

/// A [Column] holding an [SerializableEntity]. The entity will be stored in the
/// database as a json column.
class ColumnSerializable extends _ColumnEscaped<String> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnSerializable(String name) : super(name);

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
