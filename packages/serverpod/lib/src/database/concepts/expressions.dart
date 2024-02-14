import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';

/// A function that returns an [Expression] for a [Table] to be used with where
/// clauses.
typedef WhereExpressionBuilder<T extends Table> = Expression Function(T);

/// A database [Expression].
class Expression<T> {
  final T _expression;

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
  const Constant._(super.value);

  /// Creates a constant [String] expression.
  factory Constant.string(String value) => Constant._(EscapedExpression(value));

  /// Creates a constant [bool] expression.
  factory Constant.bool(bool value) => Constant._('$value'.toUpperCase());

  /// Creates a constant [null] expression.
  static Constant nullValue = const Constant._('NULL');
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
