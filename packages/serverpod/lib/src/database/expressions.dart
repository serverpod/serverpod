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

  /// Iterator for all [Expression]s in the expression.
  /// Iterates elements deterministically depth first.
  Iterable<Expression> get depthFirst sync* {
    yield this;
  }

  /// Takes an action for each element.
  ///
  /// Calls [action] for each element along with the index in the
  /// iteration order.
  void forEachDepthFirstIndexed(
      void Function(int index, Expression expression) action) {
    var index = 0;
    for (var expression in depthFirst) {
      action(index, expression);
      index++;
    }
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

/// A database expression to invert the result of another expression.
class NotExpression extends Expression {
  /// Creates a new [NotExpression].
  NotExpression(Expression super.expression);

  @override
  Iterable<Expression> get depthFirst sync* {
    yield* super.depthFirst;
    yield* super._expression.depthFirst;
  }

  /// Returns the expression wrapped in NOT.
  Expression get subExpression => _expression;

  @override
  List<Column> get columns => _expression.columns;

  /// Returns the expression as a string wrapped in NOT.
  String wrapExpression(String expression) {
    return 'NOT $_expression';
  }

  @override
  String toString() {
    return 'NOT $_expression';
  }
}

/// A database expression with two parts.
abstract class TwoPartExpression extends Expression {
  final Expression _other;

  /// Creates a new [TwoPartExpression].
  TwoPartExpression(super.expression, this._other);

  @override
  List<Column> get columns => [..._expression.columns, ..._other.columns];

  /// Returns sub expressions for this expression
  List<Expression> get subExpressions => [_expression, _other];

  /// Returns the expression operator as a string.
  String get operator;

  @override
  Iterable<Expression> get depthFirst sync* {
    yield* super.depthFirst;
    yield* _expression.depthFirst;
    yield* _other.depthFirst;
  }

  @override
  String toString() {
    return '($_expression $operator $_other)';
  }
}

class _AndExpression extends TwoPartExpression {
  _AndExpression(Expression super.value, super.other);

  @override
  String get operator => 'AND';
}

class _OrExpression extends TwoPartExpression {
  _OrExpression(Expression super.value, super.other);

  @override
  String get operator => 'OR';
}

/// Represents a database table.
class Table {
  /// Name of the table as used in the database.
  final String tableName;

  /// The database id.
  late final ColumnInt id;

  /// List of [Column] used by the table.
  List<Column> get columns => [id];

  /// Query prefix for [Column]s of the table.
  String get queryPrefix {
    return tableRelation?.relationQueryAlias ?? tableName;
  }

  /// Table relation for [Column]s of the table.
  final TableRelation? tableRelation;

  /// Creates a new [Table]. Typically, this is done only by generated code.
  Table({
    required this.tableName,
    this.tableRelation,
  }) {
    id = ColumnInt(
      'id',
      this,
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

/// Creates a new [Table] containing [TableRelation] with information
/// about how the tables are joined.
///
/// [relationFieldName] is the reference name of the table join.
/// [field] is the [Column] of the table that is used to join the tables.
/// [foreignField] is the [Column] of the foreign table that is used to join
/// table.
/// [tableRelation] is the [TableRelation] of the table that is used to join
/// the tables.
T createRelationTable<T>({
  required String relationFieldName,
  required Column field,
  required Column foreignField,
  TableRelation? tableRelation,
  required T Function(
    TableRelation foreignTableRelation,
  ) createTable,
}) {
  var relationDefinition = TableRelationEntry(
    relationAlias: relationFieldName,
    field: field,
    foreignField: foreignField,
  );

  if (tableRelation == null) {
    return createTable(TableRelation([relationDefinition]));
  }

  return createTable(
    tableRelation.copyAndAppend(relationDefinition),
  );
}
