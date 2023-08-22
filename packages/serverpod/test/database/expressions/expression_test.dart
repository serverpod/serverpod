import 'package:serverpod/src/database/expressions.dart';
import 'package:test/test.dart';

void main() {
  group('Given one expression', () {
    var expressionString = 'test expression';
    var expression = Expression(expressionString);
    test('when toString is called then expression is returned', () {
      expect(expression.toString(), expressionString);
    });

    test(
        'when greater than compared to int then output is operator expression.',
        () {
      var comparisonExpression = expression > 10;

      expect(comparisonExpression.toString(), '($expressionString > 10)');
    });

    test(
        'when greater than compared to string then output is operator expression.',
        () {
      var comparisonExpression = expression > '10';

      expect(comparisonExpression.toString(), '($expressionString > \'10\')');
    });

    test(
        'when greater or equal than compared to int then output is operator expression.',
        () {
      var comparisonExpression = expression >= 10;

      expect(comparisonExpression.toString(), '($expressionString >= 10)');
    });

    test(
        'when greater or equal than compared to string then output is operator expression.',
        () {
      var comparisonExpression = expression >= '10';

      expect(comparisonExpression.toString(), '($expressionString >= \'10\')');
    });

    test('when less than compared to int then output is operator expression.',
        () {
      var comparisonExpression = expression < 10;

      expect(comparisonExpression.toString(), '($expressionString < 10)');
    });

    test(
        'when less than compared to string then output is operator expression.',
        () {
      var comparisonExpression = expression < '10';

      expect(comparisonExpression.toString(), '($expressionString < \'10\')');
    });

    test(
        'when less or equal than compared to int then output is operator expression.',
        () {
      var comparisonExpression = expression <= 10;

      expect(comparisonExpression.toString(), '($expressionString <= 10)');
    });

    test(
        'when less or equal than compared to string then output is operator expression.',
        () {
      var comparisonExpression = expression <= '10';

      expect(comparisonExpression.toString(), '($expressionString <= \'10\')');
    });
  });

  group('Given two expressions', () {
    var expression1 = Expression('test expression 1');
    var expression2 = Expression('test expression 2');
    test('when combined using the AND operator then output is AND expression.',
        () {
      var combinedExpression = expression1 & expression2;

      expect(combinedExpression.toString(), '($expression1 AND $expression2)');
    });

    test('when combined using the AND operator then output is AND expression.',
        () {
      var combinedExpression = expression1 | expression2;

      expect(combinedExpression.toString(), '($expression1 OR $expression2)');
    });

    test('when greater than compared then values are NOT escaped in output.',
        () {
      var comparisonExpression = expression1 > expression2;

      expect(comparisonExpression.toString(), '($expression1 > $expression2)');
    });

    test(
        'when greater or equal than compared then values are NOT escaped in output.',
        () {
      var comparisonExpression = expression1 >= expression2;

      expect(comparisonExpression.toString(), '($expression1 >= $expression2)');
    });

    test('when less than compared then values are NOT escaped in output.', () {
      var comparisonExpression = expression1 < expression2;

      expect(comparisonExpression.toString(), '($expression1 < $expression2)');
    });

    test(
        'when less or equal than compared then values are NOT escaped in output.',
        () {
      var comparisonExpression = expression1 <= expression2;

      expect(comparisonExpression.toString(), '($expression1 <= $expression2)');
    });
  });
}
