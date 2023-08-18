import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

/// A database [Expression].
class Expression {
  /// The [dynamic] representation of the [Expression]. Note that the precedence
  /// of operators may not be what you think, so always use parentheses to make
  /// sure that that expressions are executed in the correct order.
  final dynamic expression;

  /// Creates a new [Expression].
  Expression(this.expression);

  @override
  String toString() {
    return '$expression';
  }

  /// Database AND operator.
  Expression operator &(dynamic other) {
    if (other is Expression) {
      return _AndExpression(this, other);
    }

    return _AndExpression(this, EscapedExpression(other));
  }

  /// Database OR operator.
  Expression operator |(dynamic other) {
    if (other is Expression) {
      return _OrExpression(this, other);
    }

    return _OrExpression(this, EscapedExpression(other));
  }

  /// Database greater than operator.
  Expression operator >(dynamic other) {
    if (other is Expression) {
      return _GreaterThanExpression(this, other);
    }

    return _GreaterThanExpression(this, EscapedExpression(other));
  }

  /// Database greater or equal than operator.
  Expression operator >=(dynamic other) {
    if (other is Expression) {
      return _GreaterOrEqualExpression(this, other);
    }

    return _GreaterOrEqualExpression(this, EscapedExpression(other));
  }

  /// Database less than operator.
  Expression operator <(dynamic other) {
    if (other is Expression) {
      return _LessThanExpression(this, other);
    }

    return _LessThanExpression(this, EscapedExpression(other));
  }

  /// Database less or equal than operator.
  Expression operator <=(dynamic other) {
    if (other is Expression) {
      return _LessThanOrEqualExpression(this, other);
    }

    return _LessThanOrEqualExpression(this, EscapedExpression(other));
  }
}

/// A database expression that is escaped. This is used to escape values that
/// are not expressions, such as strings and numbers.
class EscapedExpression extends Expression {
  /// Creates a new [EscapedExpression].
  EscapedExpression(super.expression);

  @override
  String toString() {
    return DatabasePoolManager.encoder.convert(expression);
  }
}

abstract class _TwoPartExpression extends Expression {
  Expression other;

  _TwoPartExpression(super.expression, this.other);
}

class _AndExpression extends _TwoPartExpression {
  _AndExpression(super.value, super.other);

  @override
  String toString() {
    return '($expression AND $other)';
  }
}

class _OrExpression extends _TwoPartExpression {
  _OrExpression(super.value, super.other);

  @override
  String toString() {
    return '($expression OR $other)';
  }
}

class _EqualsExpression extends _TwoPartExpression {
  _EqualsExpression(super.value, super.other);

  @override
  String toString() {
    return '$expression = $other';
  }
}

class _NotEqualsExpression extends _TwoPartExpression {
  _NotEqualsExpression(super.value, super.other);

  @override
  String toString() {
    return '$expression != $other';
  }
}

class _GreaterThanExpression extends _TwoPartExpression {
  _GreaterThanExpression(super.value, super.other);

  @override
  String toString() {
    return '($expression > $other)';
  }
}

class _GreaterOrEqualExpression extends _TwoPartExpression {
  _GreaterOrEqualExpression(super.value, super.other);

  @override
  String toString() {
    return '($expression >= $other)';
  }
}

class _LessThanExpression extends _TwoPartExpression {
  _LessThanExpression(super.value, super.other);

  @override
  String toString() {
    return '($expression < $other)';
  }
}

class _LessThanOrEqualExpression extends _TwoPartExpression {
  _LessThanOrEqualExpression(super.value, super.other);

  @override
  String toString() {
    return '($expression <= $other)';
  }
}

class _LikeExpression extends _TwoPartExpression {
  _LikeExpression(super.value, super.other);

  @override
  String toString() {
    return '$expression LIKE $other';
  }
}

class _ILikeExpression extends _TwoPartExpression {
  _ILikeExpression(super.value, super.other);

  @override
  String toString() {
    return '$expression ILIKE $other';
  }
}

class _IsDistinctFrom extends _TwoPartExpression {
  _IsDistinctFrom(super.value, super.other);

  @override
  String toString() {
    return '$expression IS DISTINCT FROM $other';
  }
}

class _IsNullExpression extends Expression {
  _IsNullExpression(super.expression);

  @override
  String toString() {
    return '$expression IS NULL';
  }
}

class _IsNotNullExpression extends Expression {
  _IsNotNullExpression(super.expression);

  @override
  String toString() {
    return '$expression IS NOT NULL';
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

  /// Creates a new [Column], this is typically done in generated code only.
  Column(
    this._columnName, {
    this.varcharLength,
  })  : type = T,
        super('"$_columnName"');

  @override
  String toString() {
    return '$expression';
  }
}

abstract class _ColumnWithDefaultOperations<T> extends Column<T> {
  _ColumnWithDefaultOperations(super.columnName, {super.varcharLength});

  /// Applies encoding to value before it is sent to the database.
  Expression encodeValueForQuery(dynamic value) => EscapedExpression(value);

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(T? value) {
    if (value == null) {
      return _IsNullExpression(this);
    }

    return _EqualsExpression(this, encodeValueForQuery(value));
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(T? value) {
    if (value == null) {
      return _IsNotNullExpression(this);
    }

    return _NotEqualsExpression(this, encodeValueForQuery(value));
  }
}

abstract class _ColumnNum<T extends num>
    extends _ColumnWithDefaultOperations<T> {
  _ColumnNum(super.columnName);

  /// Applies encoding to value before it is sent to the database.
  @override
  Expression encodeValueForQuery(value) => Expression(value);
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

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(E? value) {
    if (value == null) {
      return _IsNullExpression(this);
    }

    return _EqualsExpression(this, Expression(value.index));
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(E? value) {
    if (value == null) {
      return _IsNotNullExpression(this);
    }

    return _NotEqualsExpression(this, Expression(value.index));
  }
}

/// A [Column] holding an [String].
class ColumnString extends _ColumnWithDefaultOperations<String> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnString(String name, {int? varcharLength})
      : super(name, varcharLength: varcharLength);

  /// Creates an [Expression] checking if the value in the column is LIKE the
  /// specified value. See Postgresql docs for more info on the LIKE operator.
  Expression like(String value) {
    return _LikeExpression(this, EscapedExpression(value));
  }

  /// Creates an [Expression] checking if the value in the column is LIKE the
  /// specified value but ignoring case. See Postgresql docs for more info on
  /// the ILIKE operator.
  Expression ilike(String value) {
    return _ILikeExpression(this, EscapedExpression(value));
  }
}

/// A [Column] holding an [bool].
class ColumnBool extends _ColumnWithDefaultOperations<bool> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnBool(String name) : super(name);

  /// Applies encoding to value before it is sent to the database.
  @override
  Expression encodeValueForQuery(value) => Expression(value);

  /// Creates an [Expression] checking if the value in the column is distinct
  /// from the specified value.
  Expression isDistinctFrom(bool value) {
    return _IsDistinctFrom(this, Expression(value));
  }
}

/// A [Column] holding an [DateTime]. In the database it is stored as a
/// timestamp without time zone.
class ColumnDateTime extends _ColumnWithDefaultOperations<DateTime> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDateTime(String name) : super(name);
}

/// A [Column] holding [ByteData].
class ColumnByteData extends Column<ByteData> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnByteData(String name) : super(name);
}

/// A [Column] holding [Duration].
class ColumnDuration extends _ColumnWithDefaultOperations<Duration> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDuration(String name) : super(name);
}

/// A [Column] holding [UuidValue].
class ColumnUuid extends _ColumnWithDefaultOperations<UuidValue> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnUuid(String name) : super(name);
}

/// A [Column] holding an [SerializableEntity]. The entity will be stored in the
/// database as a json column.
class ColumnSerializable extends Column<String> {
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
