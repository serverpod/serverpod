import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/table_relation.dart';

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
  const Expression(this._expression);

  @override
  String toString() {
    return '$_expression';
  }

  /// Returns a list of all [Column]s in the expression.
  List<Column> get columns => [];

  /// Returns a list of all [AggregateExpression]s in the expression.
  List<Expression> get aggregateExpressions => [];

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

/// A constant [Expression].
class Constant extends Expression {
  // TODO: Handle more types

  /// Creates a constant [Expression]. Currently supports [bool] and [String].
  @Deprecated('Use Constant.bool or Constant.string instead.')
  Constant(dynamic value) : super(_formatValue(value));

  const Constant._(dynamic value) : super(value);

  /// Creates a constant [String] expression.
  factory Constant.string(String value) => Constant._(EscapedExpression(value));

  /// Creates a constant [bool] expression.
  factory Constant.bool(bool value) => Constant._('$value'.toUpperCase());

  /// Creates a constant [null] expression.
  static Constant nullValue = const Constant._('NULL');

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

/// A database expressions for an aggregate Column.
class AggregateExpression extends Expression {
  /// Expression for the aggregate.
  final Expression aggregateExpression;

  /// Creates a new [AggregateExpression].
  AggregateExpression(
    this.aggregateExpression,
    innerWhere,
  ) : super(innerWhere);

  @override
  List<Expression> get aggregateExpressions => [aggregateExpression];
}

abstract class _TwoPartExpression extends Expression {
  Expression other;

  _TwoPartExpression(super.expression, this.other);

  @override
  List<Column> get columns => [..._expression.columns, ...other.columns];

  @override
  List<Expression> get aggregateExpressions => [
        ..._expression.aggregateExpressions,
        ...other.aggregateExpressions,
      ];
}

class _AndExpression extends _TwoPartExpression {
  _AndExpression(Expression super.value, super.other);

  @override
  String toString() {
    return '($_expression AND $other)';
  }
}

class _OrExpression extends _TwoPartExpression {
  _OrExpression(Expression super.value, super.other);

  @override
  String toString() {
    return '($_expression OR $other)';
  }
}

/// Represents a database table.
class Table {
  /// Name of the table as used in the database.
  final String tableName;

  /// The database id.
  late final ColumnInt id;

  late List<Column>? _columns;

  /// List of [Column] used by the table.
  List<Column> get columns => _columns!;

  /// Query prefix for [Column]s of the table.
  final String queryPrefix;

  /// Table relations for [Column]s of the table.
  final List<TableRelation>? tableRelations;

  /// Creates a new [Table]. Typically, this is done only by generated code.
  Table({
    required this.tableName,
    List<Column>? columns,
    queryPrefix = '',
    this.tableRelations,
  }) : queryPrefix = '$queryPrefix$tableName' {
    _columns = columns;
    id = ColumnInt(
      'id',
      queryPrefix: this.queryPrefix,
      tableRelations: tableRelations,
    );
  }

  /// Returns [TableColumnRelation] for the given [relationField]. If no relation
  /// exists, returns null.
  Table? getRelationTable(String relationField) {
    return null;
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

String _buildRelationQueryPrefix(String queryPrefix, String field) {
  return '${queryPrefix}_${field}_';
}

/// Creates a new [Table] based on a relation between two tables.
/// Information is contained in the table required to query the fields of the
/// table.
T createRelationTable<T>({
  required String queryPrefix,
  required String fieldName,
  required String foreignTableName,
  required Column column,
  required String foreignColumnName,
  required T Function(
    String relationQueryPrefix,
    TableRelation foreignTableRelation,
  ) createTable,
}) {
  var relationQueryPrefix = _buildRelationQueryPrefix(
    queryPrefix,
    fieldName,
  );

  var foreignTableRelation = TableRelation.foreign(
    foreignTableName: foreignTableName,
    column: column,
    foreignColumnName: foreignColumnName,
    relationQueryPrefix: relationQueryPrefix,
  );

  return createTable(
    relationQueryPrefix,
    foreignTableRelation,
  );
}

/// Many relation field between two tables.
class ManyRelation extends Expression {
  /// The table on the many side of the relation.
  final Table _table;

  /// Id column name for foreign table.
  final String _foreignIdColumnName;

  /// Creates a new [ManyRelation].
  ManyRelation({
    /// Where clause for the many side of the relation.
    required Expression<dynamic> where,
    required Table table,
    required String foreignIdColumnName,
  })  : _foreignIdColumnName = foreignIdColumnName,
        _table = table,
        super(where);

  /// Returns a [ColumnCountAggregate] for the number of rows in the relation.
  ColumnCountAggregate get count => ColumnCountAggregate(
        _foreignIdColumnName,
        queryPrefix: _table.queryPrefix,
        tableRelations: _table.tableRelations,
        innerWhere: super._expression,
      );

  /// Returns a list of all [Column]s in the expression.
  @override
  List<Column> get columns => [
        // TODO: This is a hack to make sure that columns used in the where
        // query are joined in the query even if there is no aggregate expression.
        //
        // This will be replaced as part of the work to make the query builder more robust.
        ColumnBool(
          _foreignIdColumnName,
          queryPrefix: _table.queryPrefix,
          tableRelations: _table.tableRelations,
        ),
        ...super._expression.columns
      ];
}
