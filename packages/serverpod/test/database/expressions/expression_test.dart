import 'package:serverpod/src/database/expressions.dart';
import 'package:test/test.dart';

void main() {
  group('Given one expression', () {
    var expressionString = 'test expression';
    var expression = Expression(expressionString);
    test('when toString is called then expression is returned', () {
      expect(expression.toString(), expressionString);
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
  });

  group('Given three expressions', () {
    var expression1 = Expression('test expression 1');
    var expression2 = Expression('test expression 2');
    var expression3 = Expression('test expression 3');
    test('when combined using the AND operator then output is AND expression.',
        () {
      var combinedExpression = expression1 & (expression2 & expression3);

      expect(combinedExpression.toString(),
          '($expression1 AND ($expression2 AND $expression3))');
    });

    test('when combined using the AND operator then output is AND expression.',
        () {
      var combinedExpression = expression1 | (expression2 | expression3);

      expect(combinedExpression.toString(),
          '($expression1 OR ($expression2 OR $expression3))');
    });
  });

  group('Given escaped expression containing symbols that should be escaped',
      () {
    var expressionToEscape = '; DROP TABLE users;';
    var expression = EscapedExpression(expressionToEscape);
    test('when toString is called then escaped expression is returned', () {
      expect(expression.toString(), '\'; DROP TABLE users;\'');
    });
  });
}
