import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

/// A database [Expression].
class Expression<T> {
  final T _expression;

  /// Retrieves expression as a string.
  @Deprecated('Use toString instead')
  String get expression => toString();

  /// Creates a new [Expression].
  /// Note that the precedence of operators may not be what you think, so
  /// always use parentheses to make sure that that expressions are executed
  /// in the correct order.
  Expression(this._expression);

  @override
  String toString() {
    return '$_expression';
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
    return DatabasePoolManager.encoder.convert(_expression);
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
    return '($_expression AND $other)';
  }
}

class _OrExpression extends _TwoPartExpression {
  _OrExpression(super.value, super.other);

  @override
  String toString() {
    return '($_expression OR $other)';
  }
}

class _EqualsExpression extends _TwoPartExpression {
  _EqualsExpression(super.value, super.other);

  @override
  String toString() {
    return '$_expression = $other';
  }
}

class _NotEqualsExpression extends _TwoPartExpression {
  _NotEqualsExpression(super.value, super.other);

  @override
  String toString() {
    return '$_expression != $other';
  }
}

class _GreaterThanExpression extends _TwoPartExpression {
  _GreaterThanExpression(super.value, super.other);

  @override
  String toString() {
    return '($_expression > $other)';
  }
}

class _GreaterOrEqualExpression extends _TwoPartExpression {
  _GreaterOrEqualExpression(super.value, super.other);

  @override
  String toString() {
    return '($_expression >= $other)';
  }
}

class _LessThanExpression extends _TwoPartExpression {
  _LessThanExpression(super.value, super.other);

  @override
  String toString() {
    return '($_expression < $other)';
  }
}

class _LessThanOrEqualExpression extends _TwoPartExpression {
  _LessThanOrEqualExpression(super.value, super.other);

  @override
  String toString() {
    return '($_expression <= $other)';
  }
}

class _LikeExpression extends _TwoPartExpression {
  _LikeExpression(super.value, super.other);

  @override
  String toString() {
    return '$_expression LIKE $other';
  }
}

class _ILikeExpression extends _TwoPartExpression {
  _ILikeExpression(super.value, super.other);

  @override
  String toString() {
    return '$_expression ILIKE $other';
  }
}

class _IsDistinctFrom extends _TwoPartExpression {
  _IsDistinctFrom(super.value, super.other);

  @override
  String toString() {
    return '$_expression IS DISTINCT FROM $other';
  }
}

class _IsNullExpression extends Expression {
  _IsNullExpression(super.expression);

  @override
  String toString() {
    return '$_expression IS NULL';
  }
}

class _IsNotNullExpression extends Expression {
  _IsNotNullExpression(super.expression);

  @override
  String toString() {
    return '$_expression IS NOT NULL';
  }
}

abstract class _MinMaxExpression extends Expression {
  Expression min;
  Expression max;

  _MinMaxExpression(super.expression, this.min, this.max);
}

class _BetweenExpression extends _MinMaxExpression {
  _BetweenExpression(super.expression, super.min, super.max);

  @override
  String toString() {
    return '$_expression BETWEEN $min AND $max';
  }
}

class _NotBetweenExpression extends _MinMaxExpression {
  _NotBetweenExpression(super.expression, super.min, super.max);

  @override
  String toString() {
    return '$_expression NOT BETWEEN $min AND $max';
  }
}

class _SetExpression extends Expression {
  List<Expression> values;

  _SetExpression(super.expression, this.values);

  String _expressionSetToQueryString() {
    var valueList = values.join(', ');
    return '($valueList)';
  }
}

class _InSetExpression extends _SetExpression {
  _InSetExpression(super.expression, super.values);

  @override
  String toString() {
    return '$_expression IN ${_expressionSetToQueryString()}';
  }
}

class _NotInSetExpression extends _SetExpression {
  _NotInSetExpression(super.expression, super.values);

  @override
  String toString() {
    return '$_expression NOT IN ${_expressionSetToQueryString()}';
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
    return '$_expression';
  }
}

abstract class _ColumnWithDefaultOperations<T> extends Column<T> {
  _ColumnWithDefaultOperations(super.columnName, {super.varcharLength});

  /// Applies encoding to value before it is sent to the database.
  Expression _encodeValueForQuery(dynamic value) => EscapedExpression(value);

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(T? value) {
    if (value == null) {
      return _IsNullExpression(this);
    }

    return _EqualsExpression(this, _encodeValueForQuery(value));
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(T? value) {
    if (value == null) {
      return _IsNotNullExpression(this);
    }

    return _NotEqualsExpression(this, _encodeValueForQuery(value));
  }

  /// Creates and [Expression] checking if the value in the column is included
  /// in the specified set of values.
  Expression inSet(Set<T> values) {
    var valuesAsExpressions =
        values.map((e) => _encodeValueForQuery(e)).toList();

    return _InSetExpression(this, valuesAsExpressions);
  }

  /// Creates and [Expression] checking if the value in the column is NOT
  /// included in the specified set of values.
  Expression notInSet(Set<T> values) {
    var valuesAsExpressions =
        values.map((e) => _encodeValueForQuery(e)).toList();

    return _NotInSetExpression(this, valuesAsExpressions);
  }
}

abstract class _ColumnNum<T extends num>
    extends _ColumnWithDefaultOperations<T> {
  _ColumnNum(super.columnName);

  @override
  Expression _encodeValueForQuery(value) => Expression(value);

  /// Creates an [Expression] checking if the value in the column is between
  /// the [min], [max] values.
  Expression between(T min, T max) {
    return _BetweenExpression(
        this, _encodeValueForQuery(min), _encodeValueForQuery(max));
  }

  /// Creates an [Expression] checking if the value in the column is NOT between
  /// the [min], [max] values.
  Expression notBetween(T min, T max) {
    return _NotBetweenExpression(
        this, _encodeValueForQuery(min), _encodeValueForQuery(max));
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

/// A [Column] holding an enum which is serialized to the database as an
/// integer (represtenting the enum value index).
abstract class _ColumnEnum<E extends Enum> extends Column<E> {
  /// Creates a new [Column], this is typically done in generated code only.
  _ColumnEnum(String name) : super(name);

  /// Overridden in subclasses
  String _encodeValueForQuery(E value);

  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(E? value) {
    if (value == null) {
      return _IsNullExpression(this);
    }

    return _EqualsExpression(this, Expression(_encodeValueForQuery(value)));
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(E? value) {
    if (value == null) {
      return _IsNotNullExpression(this);
    }

    return _NotEqualsExpression(this, Expression(_encodeValueForQuery(value)));
  }

  /// Creates and [Expression] checking if the value in the column is included
  /// in the specified set of values.
  Expression inSet(Set<E> values) {
    List<Expression> valuesAsExpressions =
        values.map((e) => Expression(_encodeValueForQuery(e))).toList();

    return _InSetExpression(this, valuesAsExpressions);
  }

  /// Creates and [Expression] checking if the value in the column is NOT
  /// included in the specified set of values.
  Expression notInSet(Set<E> values) {
    List<Expression> valuesAsExpressions =
        values.map((e) => Expression(_encodeValueForQuery(e))).toList();

    return _NotInSetExpression(this, valuesAsExpressions);
  }
}

/// A [Column] holding an enum which is serialized to the database as an
/// integer (represtenting the enum value index).
class ColumnEnumSerializedAsInteger<E extends Enum> extends _ColumnEnum<E> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnEnumSerializedAsInteger(String name) : super(name);

  @override
  String _encodeValueForQuery(E enumValue) => enumValue.index.toString();
}

/// A [Column] holding an enum which is serialized to the database as a
/// String (representing the enum value name).
class ColumnEnumSerializedAsString<E extends Enum> extends _ColumnEnum<E> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnEnumSerializedAsString(String name) : super(name);

  @override
  String _encodeValueForQuery(E enumValue) => "'${enumValue.name}'";
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

  @override
  Expression _encodeValueForQuery(value) => Expression(value);

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

  /// Creates an [Expression] checking if the value in the column is between
  /// the [min], [max] values.
  Expression between(DateTime min, DateTime max) {
    return _BetweenExpression(
        this, _encodeValueForQuery(min), _encodeValueForQuery(max));
  }

  /// Creates an [Expression] checking if the value in the column is NOT between
  /// the [min], [max] values.
  Expression notBetween(DateTime min, DateTime max) {
    return _NotBetweenExpression(
        this, _encodeValueForQuery(min), _encodeValueForQuery(max));
  }
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
