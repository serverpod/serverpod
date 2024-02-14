import 'package:serverpod/src/database/concepts/columns.dart';
import 'package:serverpod/src/database/concepts/expressions.dart';
import 'package:serverpod/src/database/concepts/table.dart';
import 'package:test/test.dart';

void main() {
  var testTable = Table(tableName: 'test');
  group('Given one expression', () {
    var expressionString = 'true = true';
    var expression = Expression(expressionString);
    test('when toString is called then expression is returned', () {
      expect(expression.toString(), expressionString);
    });

    group('when iterating expressions', () {
      test('then only first expression is returned.', () {
        expect(expression.depthFirst, hasLength(1));
        expect(expression.depthFirst.first, expression);
      });

      test('then forEachDepthFirstIndexed only has one element.', () {
        expression.forEachDepthFirstIndexed((index, innerExpression) {
          expect(index, 0);
          expect(expression, innerExpression);
        });
      });
    });
  });

  group('Given one expression wrapped in NOT expression', () {
    var expression = const Expression('TRUE');
    var notWrappedExpression = NotExpression(expression);

    test('when toString is called then string matches expected.', () {
      expect(notWrappedExpression.toString(), 'NOT TRUE');
    });

    test('when subExpression is called then wrapped expression is returned',
        () {
      expect(notWrappedExpression.subExpression, expression);
    });

    group('when iterating not wrapped expression', () {
      test('then both expressions are represented.', () {
        expect(notWrappedExpression.depthFirst, hasLength(2));
      });

      test('then first expression is NOT expression.', () {
        expect(notWrappedExpression.depthFirst.first, notWrappedExpression);
      });

      test('then last expression is wrapped expression.', () {
        expect(notWrappedExpression.depthFirst.last, expression);
      });
    });
  });

  group('Given a combined expression wrapped in NOT expression', () {
    var expression1 = const Expression('true = true');
    var expression2 = const Expression('"A" = "A"');
    var combinedExpression = expression1 & expression2;
    var notWrappedExpression = NotExpression(combinedExpression);

    test('when toString is called then expression is returned', () {
      expect(
        notWrappedExpression.toString(),
        'NOT (true = true AND "A" = "A")',
      );
    });

    group('when iterating not wrapped expression', () {
      test('then all expressions are represented.', () {
        expect(notWrappedExpression.depthFirst, hasLength(4));
      });

      test('then order matches expressions.', () {
        var expectedExpressions = [
          notWrappedExpression,
          combinedExpression,
          expression1,
          expression2,
        ];

        var i = 0;
        for (var expression in notWrappedExpression.depthFirst) {
          expect(expression, expectedExpressions[i]);
          i++;
        }
      });
    });
  });

  group('Given two AND operator combined expressions', () {
    var expression1 = const Expression('true = true');
    var expression2 = const Expression('"A" = "A"');
    var combinedExpression = expression1 & expression2;

    test('when printing expression then output is AND expression.', () {
      expect(combinedExpression.toString(), '($expression1 AND $expression2)');
    });

    test('when checking expression type then type is TwoPartExpression', () {
      expect(combinedExpression, isA<TwoPartExpression>());
    });

    group('when retrieving sub expression then two are returned', () {
      var subExpressions =
          (combinedExpression as TwoPartExpression).subExpressions;

      test('then two are returned', () {
        expect(subExpressions, hasLength(2));
      });

      test('then first expression matches', () {
        expect(subExpressions.first, expression1);
      });

      test('then last expression matches', () {
        expect(subExpressions.last, expression2);
      });
    }, skip: combinedExpression is! TwoPartExpression);

    group('when iterating expressions', () {
      test('then the expression depth is 3.', () {
        expect(combinedExpression.depthFirst, hasLength(3));
      });

      test('then order matches expressions.', () {
        var expectedExpressions = [
          combinedExpression,
          expression1,
          expression2,
        ];

        var i = 0;
        for (var expression in combinedExpression.depthFirst) {
          expect(expression, expectedExpressions[i]);
          i++;
        }
      });

      test('then forEachDepthFirstIndexed is indexed as expected.', () {
        var expectedExpressions = [
          combinedExpression,
          expression1,
          expression2,
        ];

        combinedExpression.forEachDepthFirstIndexed((index, innerExpression) {
          expect(innerExpression, expectedExpressions[index]);
        });
      });
    });
  });

  group('Given two OR operator combined expressions', () {
    var expression1 = const Expression('true = true');
    var expression2 = const Expression('"A" = "A"');
    var combinedExpression = expression1 | expression2;
    test('when printing expression then output is AND expression.', () {
      expect(combinedExpression.toString(), '($expression1 OR $expression2)');
    });

    test('when checking expression type then type is TwoPartExpression', () {
      expect(combinedExpression, isA<TwoPartExpression>());
    });

    group('when retrieving sub expression then two are returned', () {
      var subExpressions =
          (combinedExpression as TwoPartExpression).subExpressions;

      test('then two are returned', () {
        expect(subExpressions, hasLength(2));
      });

      test('then first expression matches', () {
        expect(subExpressions.first, expression1);
      });

      test('then last expression matches', () {
        expect(subExpressions.last, expression2);
      });
    }, skip: combinedExpression is! TwoPartExpression);
  });

  group('Given three expressions', () {
    var expression1 = const Expression('true = true');
    var expression2 = const Expression('"A" = "A"');
    var expression3 = const Expression('"B" = "B"');
    group('combined using the AND operator', () {
      var partCombined = (expression2 & expression3);
      var combinedExpression = expression1 & partCombined;
      test('when printing expression then output is AND expression.', () {
        expect(combinedExpression.toString(),
            '($expression1 AND ($expression2 AND $expression3))');
      });

      test('when checking expression type then type is TwoPartExpression', () {
        expect(combinedExpression, isA<TwoPartExpression>());
      });

      group('when retrieving sub expression then two are returned', () {
        var subExpressions =
            (combinedExpression as TwoPartExpression).subExpressions;

        test('then two are returned', () {
          expect(subExpressions, hasLength(2));
        });

        test('then first expression matches', () {
          expect(subExpressions.first, expression1);
        });

        test('then last expression matches', () {
          expect(subExpressions.last, partCombined);
        });
      }, skip: combinedExpression is! TwoPartExpression);

      group('when iterating expressions', () {
        test('then order matches expressions.', () {
          var expectedExpressions = [
            combinedExpression,
            expression1,
            partCombined,
            expression2,
            expression3,
          ];

          var i = 0;
          for (var expression in combinedExpression.depthFirst) {
            expect(expression, expectedExpressions[i]);
            i++;
          }
        });

        test('then forEachDepthFirstIndexed is indexed as expected.', () {
          var expectedExpressions = [
            combinedExpression,
            expression1,
            partCombined,
            expression2,
            expression3,
          ];

          combinedExpression.forEachDepthFirstIndexed((index, innerExpression) {
            expect(innerExpression, expectedExpressions[index]);
          });
        });
      });
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

  group('Given column in expression wrapped in NotExpression', () {
    ColumnString column = ColumnString('test', testTable);
    var expression = column.ilike('s%');
    var notWrappedExpression = NotExpression(expression);

    test('when retrieving columns then wrapped expression column is returned',
        () {
      expect(notWrappedExpression.columns, hasLength(1));
      expect(notWrappedExpression.columns.first, column);
    });
  });

  group('Given two columns right combined using two part expressions', () {
    ColumnString firstColumn = ColumnString('test 1', testTable);
    ColumnString secondColumn = ColumnString('test 2', testTable);
    Expression expression = firstColumn.equals('test 1') &
        (secondColumn.like('test 2') | firstColumn.equals('test 1'));

    group('when retrieveing columns', () {
      List<Column> columns = expression.columns;

      test('then all columns are represented.', () {
        expect(columns.length, 3);
      });

      test('then first columns is leftmost column.', () {
        expect(columns.first, firstColumn);
      }, skip: columns.length != 3);

      test('then second column is middle column.', () {
        expect(columns[1], secondColumn);
      }, skip: columns.length != 3);

      test('then last column is rightmost column.', () {
        expect(columns.last, firstColumn);
      }, skip: columns.length != 3);
    });
  });

  group(
      'Given two columns left combined using two part expressions when retrieving columns',
      () {
    ColumnString firstColumn = ColumnString('test 1', testTable);
    ColumnString secondColumn = ColumnString('test 2', testTable);
    var expression1 = secondColumn.like('test 2');
    var expression2 = firstColumn.equals('test 1');
    var firstPart = (expression1 | expression2);
    Expression expression = firstPart & expression2;

    List<Column> columns = expression.columns;

    test('then all columns are represented.', () {
      expect(columns.length, 3);
    });

    test('then first column is leftmost expression.', () {
      expect(columns.first, secondColumn);
    }, skip: columns.length != 3);

    test('then second expression is middle expression.', () {
      expect(columns[1], firstColumn);
    }, skip: columns.length != 3);

    test('then last expression is rightmost expression.', () {
      expect(columns.last, firstColumn);
    }, skip: columns.length != 3);

    group('when iterating expressions', () {
      test('then order matches expressions.', () {
        var expectedExpressions = [
          expression,
          firstPart,
          expression1,
          expression2,
          expression2,
        ];

        var i = 0;
        for (var expression in expression.depthFirst) {
          expect(expression, expectedExpressions[i]);
          i++;
        }
      });

      test('then forEachDepthFirstIndexed is indexed as expected.', () {
        var expectedExpressions = [
          expression,
          firstPart,
          expression1,
          expression2,
          expression2,
        ];

        expression.forEachDepthFirstIndexed((index, innerExpression) {
          expect(innerExpression, expectedExpressions[index]);
        });
      });
    });
  });

  group('Given column BETWEEN expression when retrieving columns', () {
    ColumnInt column = ColumnInt('test 1', testTable);
    Expression expression = column.between(1, 2);

    List<Column> columns = expression.columns;

    test('then column is represented.', () {
      expect(columns.length, 1);
    });

    test('then first is column.', () {
      expect(columns.first, column);
    }, skip: columns.length != 1);
  });

  group('Given column IN SET expression when retrieving columns', () {
    ColumnInt column = ColumnInt('test 1', testTable);
    Expression expression = column.inSet(<int>{1, 2});

    List<Column> columns = expression.columns;

    test('then column is represented.', () {
      expect(columns.length, 1);
    });

    test('then first is column.', () {
      expect(columns.first, column);
    }, skip: columns.length != 1);
  });

  group(
      'Given column in BETWEEN and two part expression when retrieving columns',
      () {
    ColumnInt column = ColumnInt('test 1', testTable);
    Expression constant = Constant.bool(true);
    Expression expression = column.between(1, 2) & constant;

    List<Column> columns = expression.columns;

    test('then all columns are represented.', () {
      expect(columns.length, 1);
    });

    test('then first is column.', () {
      expect(columns.first, column);
    }, skip: columns.length != 1);
  });
}
