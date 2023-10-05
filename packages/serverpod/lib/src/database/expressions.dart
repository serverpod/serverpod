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

abstract class _TwoPartExpression extends Expression {
  Expression other;

  _TwoPartExpression(super.expression, this.other);

  @override
  List<Column> get columns => [..._expression.columns, ...other.columns];
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
  String get queryPrefix {
    return tableRelation?.relationQueryAlias ?? tableName;
  }

  /// Table relation for [Column]s of the table.
  final TableRelation? tableRelation;

  /// Creates a new [Table]. Typically, this is done only by generated code.
  Table({
    required this.tableName,
    List<Column>? columns,
    this.tableRelation,
  }) {
    _columns = columns;
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
    relationFieldName: relationFieldName,
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
