import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/table_relation.dart';

/// Abstract class representing a database [Column]. Subclassed by the different
/// supported column types such as [ColumnInt] or [ColumnString].
abstract class Column<T> {
  /// Corresponding dart [Type].
  final Type type;

  final String _columnName;

  /// Name of the [Column].
  String get columnName => _columnName;

  /// Query prefix for the [Column].
  final String queryPrefix;

  /// Query alias for the [Column].
  String get queryAlias => '$queryPrefix.$_columnName';

  /// Table relations for the [Column].
  final List<TableRelation>? tableRelations;

  /// Creates a new [Column], this is typically done in generated code only.
  Column(
    this._columnName, {
    this.queryPrefix = '',
    this.tableRelations,
  }) : type = T;

  @override
  String toString() {
    if (queryPrefix.isEmpty) {
      return '"$_columnName"';
    }

    return '$queryPrefix."$_columnName"';
  }
}

/// A [Column] holding [ByteData].
class ColumnByteData extends Column<ByteData> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnByteData(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });
}

/// A [Column] holding an [SerializableEntity]. The entity will be stored in the
/// database as a json column.
class ColumnSerializable extends Column<String> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnSerializable(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });

// TODO: Add comparisons and possibly other operations
}

abstract class _ValueOperatorColumn<T> extends Column<T> {
  _ValueOperatorColumn(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });

  /// Applies encoding to value before it is sent to the database.
  Expression _encodeValueForQuery(T value);
}

/// A [Column] holding an enum.
class ColumnEnum<E extends Enum> extends _ValueOperatorColumn<E>
    with _ColumnDefaultOperations<E> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnEnum(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });

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
    super.columnName, {
    this.varcharLength,
    super.queryPrefix,
    super.tableRelations,
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
  ColumnBool(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });

  @override
  Expression _encodeValueForQuery(bool value) => Expression(value);
}

/// A [Column] holding an [DateTime]. In the database it is stored as a
/// timestamp without time zone.
class ColumnDateTime extends _ValueOperatorColumn<DateTime>
    with _ColumnDefaultOperations<DateTime>, _ColumnNumberOperations<DateTime> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDateTime(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });

  @override
  Expression _encodeValueForQuery(DateTime value) => EscapedExpression(value);
}

/// A [Column] holding [Duration].
class ColumnDuration extends _ValueOperatorColumn<Duration>
    with _ColumnDefaultOperations<Duration>, _ColumnNumberOperations<Duration> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDuration(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });

  @override
  Expression _encodeValueForQuery(Duration value) => EscapedExpression(value);
}

/// A [Column] holding [UuidValue].
class ColumnUuid extends _ValueOperatorColumn<UuidValue>
    with _ColumnDefaultOperations<UuidValue> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnUuid(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });

  @override
  Expression _encodeValueForQuery(UuidValue value) => EscapedExpression(value);
}

/// A [Column] holding an [int].
class ColumnInt extends _ValueOperatorColumn<int>
    with _ColumnDefaultOperations<int>, _ColumnNumberOperations<int> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnInt(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });

  @override
  Expression _encodeValueForQuery(int value) => Expression(value);
}

/// A [Column] holding an [double].
class ColumnDouble extends _ValueOperatorColumn<double>
    with _ColumnDefaultOperations<double>, _ColumnNumberOperations<double> {
  /// Creates a new [Column], this is typically done in generated code only.
  ColumnDouble(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
  });

  @override
  Expression _encodeValueForQuery(double value) => Expression(value);
}

/// An aggregate [Column] holding count of rows.
class ColumnCountAggregate extends _ValueOperatorColumn<int>
    with _ColumnDefaultOperations<int>, _ColumnNumberOperations<int> {
  /// Where expression used to filter the aggregated table.
  final Expression innerWhere;

  /// Creates a new [Column], this is typically done in generated code only.
  ColumnCountAggregate(
    super.columnName, {
    super.queryPrefix,
    super.tableRelations,
    required this.innerWhere,
  });

  @override
  String toString() {
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
      return _ColumnExpression.create(
        column: this,
        constructor: _IsNullExpression._,
      );
    }

    return _TwoPartColumnExpression.create(
      column: this,
      other: _encodeValueForQuery(value),
      constructor: _EqualsExpression._,
    );
  }

  /// Creates an [Expression] checking if the value in the column does not equal
  /// the specified value.
  Expression notEquals(T? value) {
    if (value == null) {
      return _ColumnExpression.create(
        column: this,
        constructor: _IsNotNullExpression._,
      );
    }

    return _TwoPartColumnExpression.create(
      column: this,
      other: _encodeValueForQuery(value),
      constructor: _NotEqualsExpression._,
    );
  }

  /// Creates and [Expression] checking if the value in the column is included
  /// in the specified set of values.
  Expression inSet(Set<T> values) {
    var valuesAsExpressions =
        values.map((e) => _encodeValueForQuery(e)).toList();

    return _SetColumnExpression.create(
      column: this,
      values: valuesAsExpressions,
      constructor: _InSetExpression._,
    );
  }

  /// Creates and [Expression] checking if the value in the column is NOT
  /// included in the specified set of values.
  Expression notInSet(Set<T> values) {
    var valuesAsExpressions =
        values.map((e) => _encodeValueForQuery(e)).toList();

    return _SetColumnExpression.create(
      column: this,
      values: valuesAsExpressions,
      constructor: _NotInSetExpression._,
    );
  }

  /// Creates an [Expression] checking if the value in the column is distinct
  /// from the specified value.
  Expression isDistinctFrom(T value) {
    return _TwoPartColumnExpression.create(
      column: this,
      other: _encodeValueForQuery(value),
      constructor: _IsDistinctFromExpression._,
    );
  }

  /// Creates an [Expression] checking if the value in the column is distinct
  /// from the specified value.
  Expression isNotDistinctFrom(T value) {
    return _TwoPartColumnExpression.create(
      column: this,
      other: _encodeValueForQuery(value),
      constructor: _IsNotDistinctFromExpression._,
    );
  }
}

mixin _ColumnNumberOperations<T> on _ValueOperatorColumn<T> {
  /// Creates an [Expression] checking if the value in the column is between
  /// the [min], [max] values.
  Expression between(T min, T max) {
    return _MinMaxColumnExpression.create(
      column: this,
      min: _encodeValueForQuery(min),
      max: _encodeValueForQuery(max),
      constructor: _BetweenExpression._,
    );
  }

  /// Creates an [Expression] checking if the value in the column is NOT between
  /// the [min], [max] values.
  Expression notBetween(T min, T max) {
    return _MinMaxColumnExpression.create(
      column: this,
      min: _encodeValueForQuery(min),
      max: _encodeValueForQuery(max),
      constructor: _NotBetweenExpression._,
    );
  }

  /// Database greater than operator.
  Expression operator >(dynamic other) {
    return _TwoPartColumnExpression.create(
      column: this,
      other: _createValueExpression(other),
      constructor: _GreaterThanExpression._,
    );
  }

  /// Database greater or equal than operator.
  Expression operator >=(dynamic other) {
    return _TwoPartColumnExpression.create(
      column: this,
      other: _createValueExpression(other),
      constructor: _GreaterOrEqualExpression._,
    );
  }

  /// Database less than operator.
  Expression operator <(dynamic other) {
    return _TwoPartColumnExpression.create(
      column: this,
      other: _createValueExpression(other),
      constructor: _LessThanExpression._,
    );
  }

  /// Database less or equal than operator.
  Expression operator <=(dynamic other) {
    return _TwoPartColumnExpression.create(
      column: this,
      other: _createValueExpression(other),
      constructor: _LessThanOrEqualExpression._,
    );
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

typedef _ColumnExpressionConstructor = _ColumnExpression Function(
    Column column);

abstract class _ColumnExpression<T> extends Expression {
  final Column<T> _column;
  _ColumnExpression(this._column) : super(_column);

  static Expression create(
      {required Column column,
      required _ColumnExpressionConstructor constructor}) {
    if (column is ColumnCountAggregate) {
      return _AggregateColumnExpression(column, constructor(column));
    }

    return constructor(column);
  }

  @override
  List<Column> get columns => [_column];
}

class _IsNullExpression<T> extends _ColumnExpression<T> {
  _IsNullExpression._(super.column);

  @override
  String toString() {
    return '$_column IS NULL';
  }
}

class _IsNotNullExpression<T> extends _ColumnExpression<T> {
  _IsNotNullExpression._(super.column);

  @override
  String toString() {
    return '$_column IS NOT NULL';
  }
}

class _AggregateColumnExpression<T> extends AggregateExpression {
  final ColumnCountAggregate _aggregateColumn;

  _AggregateColumnExpression(
    this._aggregateColumn,
    aggregateExpression,
  ) : super(
          aggregateExpression,
          _aggregateColumn.innerWhere,
        );

  @override
  List<Column> get columns => [
        _aggregateColumn,
        ..._aggregateColumn.innerWhere.columns,
      ];
}

typedef _TwoPartColumnExpressionConstructor = _TwoPartColumnExpression Function(
    Column column, Expression other);

abstract class _TwoPartColumnExpression<T> extends _ColumnExpression<T> {
  Expression other;

  _TwoPartColumnExpression(super.column, this.other);

  static Expression create(
      {required Column column,
      required Expression other,
      required _TwoPartColumnExpressionConstructor constructor}) {
    if (column is ColumnCountAggregate) {
      return _AggregateColumnExpression(column, constructor(column, other));
    }

    return constructor(column, other);
  }

  @override
  List<Column> get columns => [...super.columns, ...other.columns];
}

class _EqualsExpression<T> extends _TwoPartColumnExpression<T> {
  _EqualsExpression._(super.value, super.other);

  @override
  String toString() {
    return '$_column = $other';
  }
}

class _NotEqualsExpression<T> extends _TwoPartColumnExpression<T> {
  _NotEqualsExpression._(super.column, super.other);

  @override
  String toString() {
    return '($_column != $other OR $_column IS NULL)';
  }
}

class _GreaterThanExpression<T> extends _TwoPartColumnExpression<T> {
  _GreaterThanExpression._(super.column, super.other);

  @override
  String toString() {
    return '($_column > $other)';
  }
}

class _GreaterOrEqualExpression<T> extends _TwoPartColumnExpression<T> {
  _GreaterOrEqualExpression._(super.column, super.other);

  @override
  String toString() {
    return '($_column >= $other)';
  }
}

class _LessThanExpression<T> extends _TwoPartColumnExpression<T> {
  _LessThanExpression._(super.column, super.other);

  @override
  String toString() {
    return '($_column < $other)';
  }
}

class _LessThanOrEqualExpression<T> extends _TwoPartColumnExpression<T> {
  _LessThanOrEqualExpression._(super.column, super.other);

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
  _IsDistinctFromExpression._(super.column, super.other);

  @override
  String toString() {
    return '$_column IS DISTINCT FROM $other';
  }
}

class _IsNotDistinctFromExpression<T> extends _TwoPartColumnExpression<T> {
  _IsNotDistinctFromExpression._(super.column, super.other);

  @override
  String toString() {
    return '$_column IS NOT DISTINCT FROM $other';
  }
}

typedef _MinMaxColumnExpressionConstructor = _MinMaxColumnExpression Function(
    Column column, Expression min, Expression max);

abstract class _MinMaxColumnExpression<T> extends _ColumnExpression<T> {
  Expression min;
  Expression max;

  _MinMaxColumnExpression(super.column, this.min, this.max);

  static Expression create(
      {required Column column,
      required Expression min,
      required Expression max,
      required _MinMaxColumnExpressionConstructor constructor}) {
    if (column is ColumnCountAggregate) {
      return _AggregateColumnExpression(column, constructor(column, min, max));
    }

    return constructor(column, min, max);
  }

  @override
  List<Column> get columns =>
      [...super.columns, ...min.columns, ...max.columns];
}

class _BetweenExpression<T> extends _MinMaxColumnExpression<T> {
  _BetweenExpression._(super.column, super.min, super.max);

  @override
  String toString() {
    return '$_column BETWEEN $min AND $max';
  }
}

class _NotBetweenExpression<T> extends _MinMaxColumnExpression<T> {
  _NotBetweenExpression._(super.column, super.min, super.max);

  @override
  String toString() {
    return '$_column NOT BETWEEN $min AND $max';
  }
}

typedef _SetColumnExpressionConstructor = _SetColumnExpression Function(
    Column column, List<Expression> values);

abstract class _SetColumnExpression<T> extends _ColumnExpression<T> {
  List<Expression> values;

  _SetColumnExpression(super.column, this.values);

  static Expression create(
      {required Column column,
      required List<Expression> values,
      required _SetColumnExpressionConstructor constructor}) {
    if (column is ColumnCountAggregate) {
      return _AggregateColumnExpression(column, constructor(column, values));
    }

    return constructor(column, values);
  }

  @override
  List<Column> get columns =>
      [...super.columns, ...values.expand((value) => value.columns)];

  String _expressionSetToQueryString() {
    var valueList = values.join(', ');
    return '($valueList)';
  }
}

class _InSetExpression<T> extends _SetColumnExpression<T> {
  _InSetExpression._(super.column, super.values);

  @override
  String toString() {
    return '$_column IN ${_expressionSetToQueryString()}';
  }
}

class _NotInSetExpression extends _SetColumnExpression {
  _NotInSetExpression._(super.column, super.values);

  @override
  String toString() {
    return '($_column NOT IN ${_expressionSetToQueryString()} OR $_column IS NULL)';
  }
}
