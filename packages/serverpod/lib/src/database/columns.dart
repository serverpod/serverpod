import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

/// Abstract class representing a database [Column]. Subclassed by the different
/// supported column types such as [ColumnInt] or [ColumnString].
abstract class Column<T> {
  /// Corresponding dart [Type].
  final Type type;

  final String _columnName;

  /// Name of the [Column].
  String get columnName => _columnName;

  /// Table that column belongs to.
  final Table table;

  /// Query alias for the [Column].
  String get queryAlias => '${table.queryPrefix}.$_columnName';

  /// Creates a new [Column], this is typically done in generated code only.
  Column(
    this._columnName,
    this.table,
  ) : type = T;

  @override
  String toString() {
    return '"${table.queryPrefix}"."$_columnName"';
  }
}

/// A [Column] holding [ByteData].
class ColumnByteData extends Column<ByteData> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnByteData(super.columnName, super.table);
}

/// A [Column] holding an [SerializableEntity]. The entity will be stored in the
/// database as a json column.
class ColumnSerializable extends Column<String> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnSerializable(super.columnName, super.table);

// TODO: Add comparisons and possibly other operations
}

abstract class _ValueOperatorColumn<T> extends Column<T> {
  _ValueOperatorColumn(super.columnName, super.table);

  /// Applies encoding to value before it is sent to the database.
  Expression _encodeValueForQuery(T value);
}

/// A [Column] holding an enum.
class ColumnEnum<E extends Enum> extends _ValueOperatorColumn<E>
    with _ColumnDefaultOperations<E> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnEnum(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(value) => Expression(value.index);
}

/// A [Column] holding an [String].
class ColumnString extends _ValueOperatorColumn<String>
    with _ColumnDefaultOperations<String> {
  /// Maximum length for a varchar
  final int? varcharLength;

  /// Creates a new [Column], this is typically done in generated code only.
  ColumnString(
    super.columnName,
    super.table, {
    this.varcharLength,
  });

  /// Creates an [Expression] checking if the value in the column is LIKE the
  /// specified value. See Postgresql docs for more info on the LIKE operator.
  Expression like(String value) {
    return _LikeExpression(this, _encodeValueForQuery(value));
  }

  /// Creates an [Expression] checking if the value in the column is LIKE the
  /// specified value but ignoring case. See Postgresql docs for more info on
  /// the ILIKE operator.
  Expression ilike(String value) {
    return _ILikeExpression(this, _encodeValueForQuery(value));
  }

  @override
  Expression _encodeValueForQuery(String value) => EscapedExpression(value);
}

/// A [Column] holding an [bool].
class ColumnBool extends _ValueOperatorColumn<bool>
    with _ColumnDefaultOperations<bool> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnBool(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(bool value) => Expression(value);
}

/// A [Column] holding an [DateTime]. In the database it is stored as a
/// timestamp without time zone.
class ColumnDateTime extends _ValueOperatorColumn<DateTime>
    with _ColumnDefaultOperations<DateTime>, _ColumnNumberOperations<DateTime> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDateTime(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(DateTime value) => EscapedExpression(value);
}

/// A [Column] holding [Duration].
class ColumnDuration extends _ValueOperatorColumn<Duration>
    with _ColumnDefaultOperations<Duration>, _ColumnNumberOperations<Duration> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDuration(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(Duration value) => EscapedExpression(value);
}

/// A [Column] holding [UuidValue].
class ColumnUuid extends _ValueOperatorColumn<UuidValue>
    with _ColumnDefaultOperations<UuidValue> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnUuid(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(UuidValue value) => EscapedExpression(value);
}

/// A [Column] holding an [int].
class ColumnInt extends _ValueOperatorColumn<int>
    with _ColumnDefaultOperations<int>, _ColumnNumberOperations<int> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnInt(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(int value) => Expression(value);
}

/// A [Column] holding an [double].
class ColumnDouble extends _ValueOperatorColumn<double>
    with _ColumnDefaultOperations<double>, _ColumnNumberOperations<double> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDouble(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(double value) => Expression(value);
}

/// A [Column] holding a count of rows.
class ColumnCount extends _ValueOperatorColumn<int>
    with _ColumnDefaultOperations<int>, _ColumnNumberOperations<int> {
  /// Where expression applied to filter what is counted.
  Expression? innerWhere;

  /// Table without relations to count rows from.
  Table baseTable;

  /// Creates a new [Column], this is typically done in generated code only.
  ColumnCount(this.innerWhere, this.baseTable, Column column)
      : super(column.columnName, column.table);

  @override
  String toString() {
    if (innerWhere != null) {
      return 'COUNT(${table.tableRelation?.lastJoiningForeignFieldQueryAlias})';
    }

    return 'COUNT(${super.toString()})';
  }

  @override
  Expression _encodeValueForQuery(int value) => Expression(value);
}

mixin _ColumnDefaultOperations<T> on _ValueOperatorColumn<T> {
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

  /// Creates an [Expression] checking if the value in the column is distinct
  /// from the specified value.
  Expression isDistinctFrom(T value) {
    return _IsDistinctFromExpression(this, _encodeValueForQuery(value));
  }

  /// Creates an [Expression] checking if the value in the column is distinct
  /// from the specified value.
  Expression isNotDistinctFrom(T value) {
    return _IsNotDistinctFromExpression(this, _encodeValueForQuery(value));
  }
}

mixin _ColumnNumberOperations<T> on _ValueOperatorColumn<T> {
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

  /// Database greater than operator.
  Expression operator >(dynamic other) {
    return _GreaterThanExpression(this, _createValueExpression(other));
  }

  /// Database greater or equal than operator.
  Expression operator >=(dynamic other) {
    return _GreaterOrEqualExpression(this, _createValueExpression(other));
  }

  /// Database less than operator.
  Expression operator <(dynamic other) {
    return _LessThanExpression(this, _createValueExpression(other));
  }

  /// Database less or equal than operator.
  Expression operator <=(dynamic other) {
    return _LessThanOrEqualExpression(this, _createValueExpression(other));
  }

  Expression _createValueExpression(dynamic other) {
    if (other is Expression) {
      return other;
    }

    if (other is T) {
      return _encodeValueForQuery(other);
    }

    if (other is Column) {
      return Expression(other);
    }

    return EscapedExpression(other);
  }
}

abstract class _ColumnExpression<T> extends Expression {
  final Column<T> _column;
  _ColumnExpression(this._column) : super(_column);

  @override
  List<Column> get columns => [_column];
}

class _IsNullExpression<T> extends _ColumnExpression<T> {
  _IsNullExpression(super.column);

  @override
  String toString() {
    return '$_column IS NULL';
  }
}

class _IsNotNullExpression<T> extends _ColumnExpression<T> {
  _IsNotNullExpression(super.column);

  @override
  String toString() {
    return '$_column IS NOT NULL';
  }
}

abstract class _TwoPartColumnExpression<T> extends _ColumnExpression<T> {
  Expression other;

  _TwoPartColumnExpression(super.column, this.other);

  @override
  List<Column> get columns => [...super.columns, ...other.columns];
}

class _EqualsExpression<T> extends _TwoPartColumnExpression<T> {
  _EqualsExpression(super.value, super.other);

  @override
  String toString() {
    return '$_column = $other';
  }
}

class _NotEqualsExpression<T> extends _TwoPartColumnExpression<T> {
  _NotEqualsExpression(super.column, super.other);

  @override
  String toString() {
    return '($_column != $other OR $_column IS NULL)';
  }
}

class _GreaterThanExpression<T> extends _TwoPartColumnExpression<T> {
  _GreaterThanExpression(super.column, super.other);

  @override
  String toString() {
    return '($_column > $other)';
  }
}

class _GreaterOrEqualExpression<T> extends _TwoPartColumnExpression<T> {
  _GreaterOrEqualExpression(super.column, super.other);

  @override
  String toString() {
    return '($_column >= $other)';
  }
}

class _LessThanExpression<T> extends _TwoPartColumnExpression<T> {
  _LessThanExpression(super.column, super.other);

  @override
  String toString() {
    return '($_column < $other)';
  }
}

class _LessThanOrEqualExpression<T> extends _TwoPartColumnExpression<T> {
  _LessThanOrEqualExpression(super.column, super.other);

  @override
  String toString() {
    return '($_column <= $other)';
  }
}

class _LikeExpression<T> extends _TwoPartColumnExpression<T> {
  _LikeExpression(super.column, super.other);

  @override
  String toString() {
    return '$_column LIKE $other';
  }
}

class _ILikeExpression<T> extends _TwoPartColumnExpression<T> {
  _ILikeExpression(super.column, super.other);

  @override
  String toString() {
    return '$_column ILIKE $other';
  }
}

class _IsDistinctFromExpression<T> extends _TwoPartColumnExpression<T> {
  _IsDistinctFromExpression(super.column, super.other);

  @override
  String toString() {
    return '$_column IS DISTINCT FROM $other';
  }
}

class _IsNotDistinctFromExpression<T> extends _TwoPartColumnExpression<T> {
  _IsNotDistinctFromExpression(super.column, super.other);

  @override
  String toString() {
    return '$_column IS NOT DISTINCT FROM $other';
  }
}

abstract class _MinMaxColumnExpression<T> extends _ColumnExpression<T> {
  Expression min;
  Expression max;

  _MinMaxColumnExpression(super.column, this.min, this.max);

  @override
  List<Column> get columns =>
      [...super.columns, ...min.columns, ...max.columns];
}

class _BetweenExpression<T> extends _MinMaxColumnExpression<T> {
  _BetweenExpression(super.column, super.min, super.max);

  @override
  String toString() {
    return '$_column BETWEEN $min AND $max';
  }
}

class _NotBetweenExpression<T> extends _MinMaxColumnExpression<T> {
  _NotBetweenExpression(super.column, super.min, super.max);

  @override
  String toString() {
    return '$_column NOT BETWEEN $min AND $max';
  }
}

abstract class _SetColumnExpression<T> extends _ColumnExpression<T> {
  List<Expression> values;

  _SetColumnExpression(super.column, this.values);

  @override
  List<Column> get columns =>
      [...super.columns, ...values.expand((value) => value.columns)];

  String _expressionSetToQueryString() {
    var valueList = values.join(', ');
    return '($valueList)';
  }
}

class _InSetExpression<T> extends _SetColumnExpression<T> {
  _InSetExpression(super.column, super.values);

  @override
  String toString() {
    return '$_column IN ${_expressionSetToQueryString()}';
  }
}

class _NotInSetExpression extends _SetColumnExpression {
  _NotInSetExpression(super.column, super.values);

  @override
  String toString() {
    return '($_column NOT IN ${_expressionSetToQueryString()} OR $_column IS NULL)';
  }
}
