import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart';

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
    with _NullableColumnDefaultOperations<E> {
  final EnumSerialization _serialized;

  ColumnEnum._(super.columnName, super.table, this._serialized);

  /// Creates a new [Column], this is typically done in generated code only.
  factory ColumnEnum(
    String columnName,
    Table table,
    EnumSerialization serialized,
  ) = ColumnEnumExtended<E>;

  @override
  Expression _encodeValueForQuery(value) {
    switch (_serialized) {
      case EnumSerialization.byIndex:
        return Expression(value.index);
      case EnumSerialization.byName:
        return EscapedExpression(value.name);
    }
  }
}

class ColumnEnumExtended<E extends Enum> extends ColumnEnum<E> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnEnumExtended(
      String columnName, Table table, EnumSerialization serialized)
      : super._(columnName, table, serialized);

  /// Data type for serialization of the enum.
  EnumSerialization get serialized => _serialized;
}

/// A [Column] holding an [String].
class ColumnString extends _ValueOperatorColumn<String>
    with _NullableColumnDefaultOperations<String> {
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

  /// Creates an [Expression] checking if the value in the column is NOT LIKE the
  /// specified value. See Postgresql docs for more info on the LIKE operator.
  Expression notLike(String value) {
    return _NotLikeExpression(this, _encodeValueForQuery(value)) |
        _IsNullExpression(this);
  }

  /// Creates an [Expression] checking if the value in the column is LIKE the
  /// specified value but ignoring case. See Postgresql docs for more info on
  /// the ILIKE operator.
  Expression ilike(String value) {
    return _ILikeExpression(this, _encodeValueForQuery(value));
  }

  /// Creates an [Expression] checking if the value in the column is NOT LIKE the
  /// specified value but ignoring case. See Postgresql docs for more info on
  /// the NOT ILIKE operator.
  Expression notIlike(String value) {
    return _NotILikeExpression(this, _encodeValueForQuery(value)) |
        _IsNullExpression(this);
  }

  @override
  Expression _encodeValueForQuery(String value) => EscapedExpression(value);
}

/// A [Column] holding an [bool].
class ColumnBool extends _ValueOperatorColumn<bool>
    with _NullableColumnDefaultOperations<bool> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnBool(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(bool value) => Expression(value);
}

/// A [Column] holding an [DateTime]. In the database it is stored as a
/// timestamp without time zone.
class ColumnDateTime extends _ValueOperatorColumn<DateTime>
    with
        _NullableColumnDefaultOperations<DateTime>,
        _ColumnNumberOperations<DateTime> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDateTime(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(DateTime value) => EscapedExpression(value);
}

/// A [Column] holding [Duration].
class ColumnDuration extends _ValueOperatorColumn<Duration>
    with
        _NullableColumnDefaultOperations<Duration>,
        _ColumnNumberOperations<Duration> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDuration(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(Duration value) => EscapedExpression(value);
}

/// A [Column] holding [UuidValue].
class ColumnUuid extends _ValueOperatorColumn<UuidValue>
    with _NullableColumnDefaultOperations<UuidValue> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnUuid(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(UuidValue value) => EscapedExpression(value);
}

/// A [Column] holding an [int].
class ColumnInt extends _ValueOperatorColumn<int>
    with _NullableColumnDefaultOperations<int>, _ColumnNumberOperations<int> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnInt(super.columnName, super.table);

  @override
  Expression _encodeValueForQuery(int value) => Expression(value);
}

/// A [Column] holding an [double].
class ColumnDouble extends _ValueOperatorColumn<double>
    with
        _NullableColumnDefaultOperations<double>,
        _ColumnNumberOperations<double> {
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

  /// Wraps string in Column operation
  String wrapInOperation(String value) {
    return 'COUNT($value)';
  }

  /// Creates a new [Column], this is typically done in generated code only.
  ColumnCount(this.innerWhere, Column column)
      : super(column.columnName, column.table);

  @override
  Expression _encodeValueForQuery(int value) => Expression(value);
}

mixin _ColumnDefaultOperations<T> on _ValueOperatorColumn<T> {
  /// Creates an [Expression] checking if the value in the column equals the
  /// specified value.
  Expression equals(T value) {
    return _EqualsExpression(this, _encodeValueForQuery(value));
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(T value) {
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

mixin _NullableColumnDefaultOperations<T> on _ValueOperatorColumn<T> {
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
  ///
  /// A non null [value] will include rows where the column is null.
  Expression notEquals(T? value) {
    if (value == null) {
      return _IsNotNullExpression(this);
    }

    return _IsDistinctFromExpression(this, _encodeValueForQuery(value));
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

    return _NotInSetExpression(this, valuesAsExpressions) |
        _IsNullExpression(this);
  }
}

mixin _ColumnNumberOperations<T> on _ValueOperatorColumn<T> {
  /// Creates an [Expression] checking if the value in the column inclusively
  /// is between the [min], [max] values.
  Expression between(T min, T max) {
    return _BetweenExpression(
        this, _encodeValueForQuery(min), _encodeValueForQuery(max));
  }

  /// Creates an [Expression] checking if the value in the column inclusively
  /// is NOT between the [min], [max] values.
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

/// Database expression for a column.
abstract class ColumnExpression<T> extends Expression {
  /// Column that the expression is for.
  final Column<T> column;

  /// Index of the expression in the query.
  /// This is used to create unique query aliases for sub queries.
  int? index;

  /// Creates a new [ColumnExpression], this is typically done in generated code only.
  ColumnExpression(this.column) : super(column);

  /// Returns true if the expression operates on a many relation column.
  bool get isManyRelationExpression => column is ColumnCount;

  /// Returns the expression operator as a string.
  String get operator;

  String get _getColumnName {
    if (column is! ColumnCount) {
      return column.toString();
    }

    return _formatColumnName(column as ColumnCount);
  }

  String _formatColumnName(ColumnCount columnCount) {
    var tableRelation = columnCount.table.tableRelation;
    if (tableRelation == null) {
      throw StateError('Table relation is null for ColumnCount.');
    }

    // When ColumnCount appears in an expression it is always expressed as a
    // sub query. Therefore, we reference the column from the last table in
    // the relation without any query alias.
    return columnCount.wrapInOperation(
      tableRelation.lastRelation.foreignFieldNameWithJoins,
    );
  }

  @override
  List<Column> get columns => [column];

  @override
  String toString() {
    return '$_getColumnName $operator';
  }
}

class _IsNullExpression<T> extends ColumnExpression<T> {
  _IsNullExpression(super.column);

  @override
  String get operator => 'IS NULL';
}

/// A database expression that returns all rows where none of the related rows
/// match the filtering criteria.
class NoneExpression<T> extends _IsNotNullExpression<T> {
  /// Creates a new [NoneExpression].
  NoneExpression(super.column);

  @override
  String _formatColumnName(ColumnCount columnCount) {
    var tableRelation = columnCount.table.tableRelation;
    if (tableRelation == null) {
      throw StateError('Table relation is null for ColumnCount.');
    }

    // When ColumnCount appears in a NoneExpression it is always expressed as a
    // sub query. Therefore, we reference the column from the last table in
    // the relation without any query alias.
    return tableRelation.lastRelation.foreignFieldNameWithJoins;
  }
}

/// A database expression that returns all rows where any of the related rows
/// match the filtering criteria.
class AnyExpression<T> extends _IsNotNullExpression<T> {
  /// Creates a new [AnyExpression].
  AnyExpression(super.column);

  @override
  String _formatColumnName(ColumnCount columnCount) {
    var tableRelation = columnCount.table.tableRelation;
    if (tableRelation == null) {
      throw StateError('Table relation is null for ColumnCount.');
    }

    // When ColumnCount appears in a NoneExpression it is always expressed as a
    // sub query. Therefore, we reference the column from the last table in
    // the relation without any query alias.
    return tableRelation.lastRelation.foreignFieldNameWithJoins;
  }
}

/// A database expression that returns all rows where all of the related rows
/// match the filtering criteria.
class EveryExpression<T> extends _IsNullExpression<T> {
  /// Creates a new [EveryExpression].
  EveryExpression(super.column);

  @override
  String _formatColumnName(ColumnCount columnCount) {
    var tableRelation = columnCount.table.tableRelation;
    if (tableRelation == null) {
      throw StateError('Table relation is null for ColumnCount.');
    }

    // When ColumnCount appears in a EveryExpression it is always expressed as a
    // sub query. Therefore, we reference the column from the last table in
    // the relation without any query alias.
    return tableRelation.lastRelation.foreignFieldNameWithJoins;
  }
}

class _IsNotNullExpression<T> extends ColumnExpression<T> {
  _IsNotNullExpression(super.column);

  @override
  String get operator => 'IS NOT NULL';
}

abstract class _TwoPartColumnExpression<T> extends ColumnExpression<T> {
  Expression other;

  _TwoPartColumnExpression(super.column, this.other);

  @override
  List<Column> get columns => [...super.columns, ...other.columns];

  @override
  String toString() {
    return '$_getColumnName $operator $other';
  }
}

class _EqualsExpression<T> extends _TwoPartColumnExpression<T> {
  _EqualsExpression(super.value, super.other);

  @override
  String get operator => '=';
}

class _NotEqualsExpression<T> extends _TwoPartColumnExpression<T> {
  _NotEqualsExpression(super.column, super.other);

  @override
  String get operator => '!=';
}

class _GreaterThanExpression<T> extends _TwoPartColumnExpression<T> {
  _GreaterThanExpression(super.column, super.other);

  @override
  String get operator => '>';
}

class _GreaterOrEqualExpression<T> extends _TwoPartColumnExpression<T> {
  _GreaterOrEqualExpression(super.column, super.other);

  @override
  String get operator => '>=';
}

class _LessThanExpression<T> extends _TwoPartColumnExpression<T> {
  _LessThanExpression(super.column, super.other);

  @override
  String get operator => '<';
}

class _LessThanOrEqualExpression<T> extends _TwoPartColumnExpression<T> {
  _LessThanOrEqualExpression(super.column, super.other);

  @override
  String get operator => '<=';
}

class _LikeExpression<T> extends _TwoPartColumnExpression<T> {
  _LikeExpression(super.column, super.other);

  @override
  String get operator => 'LIKE';
}

class _NotLikeExpression<T> extends _TwoPartColumnExpression<T> {
  _NotLikeExpression(super.column, super.other);

  @override
  String get operator => 'NOT LIKE';
}

class _ILikeExpression<T> extends _TwoPartColumnExpression<T> {
  _ILikeExpression(super.column, super.other);

  @override
  String get operator => 'ILIKE';
}

class _NotILikeExpression<T> extends _TwoPartColumnExpression<T> {
  _NotILikeExpression(super.column, super.other);

  @override
  String get operator => 'NOT ILIKE';
}

class _IsDistinctFromExpression<T> extends _TwoPartColumnExpression<T> {
  _IsDistinctFromExpression(super.column, super.other);

  @override
  String get operator => 'IS DISTINCT FROM';
}

abstract class _MinMaxColumnExpression<T> extends ColumnExpression<T> {
  Expression min;
  Expression max;

  _MinMaxColumnExpression(super.column, this.min, this.max);

  @override
  String toString() {
    return '$_getColumnName $operator $min AND $max';
  }

  @override
  List<Column> get columns =>
      [...super.columns, ...min.columns, ...max.columns];
}

class _BetweenExpression<T> extends _MinMaxColumnExpression<T> {
  _BetweenExpression(super.column, super.min, super.max);

  @override
  String get operator => 'BETWEEN';
}

class _NotBetweenExpression<T> extends _MinMaxColumnExpression<T> {
  _NotBetweenExpression(super.column, super.min, super.max);

  @override
  String get operator => 'NOT BETWEEN';
}

abstract class _SetColumnExpression<T> extends ColumnExpression<T> {
  List<Expression> values;

  _SetColumnExpression(super.column, this.values);

  @override
  List<Column> get columns =>
      [...super.columns, ...values.expand((value) => value.columns)];

  @override
  String toString() {
    return '$_getColumnName $operator ${_expressionSetToQueryString()}';
  }

  String _expressionSetToQueryString() {
    var valueList = values.join(', ');
    return '($valueList)';
  }
}

class _InSetExpression<T> extends _SetColumnExpression<T> {
  _InSetExpression(super.column, super.values);

  @override
  String get operator => 'IN';
}

class _NotInSetExpression extends _SetColumnExpression {
  _NotInSetExpression(super.column, super.values);

  @override
  String get operator => 'NOT IN';
}
