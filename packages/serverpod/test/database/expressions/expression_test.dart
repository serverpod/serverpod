import 'package:serverpod/src/database/columns.dart';
import 'package:serverpod/src/database/expressions.dart';
import 'package:test/test.dart';

void main() {
  group('Given one expression', () {
    var expressionString = 'true = true';
    var expression = Expression(expressionString);
    test('when toString is called then expression is returned', () {
      expect(expression.toString(), expressionString);
    });
  });

  group('Given two expressions', () {
    var expression1 = const Expression('true = true');
    var expression2 = const Expression('"A" = "A"');
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
    var expression1 = const Expression('true = true');
    var expression2 = const Expression('"A" = "A"');
    var expression3 = const Expression('"B" = "B"');
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

  group(
      'Given two columns right combined using two part expressions when retrieving columns',
      () {
    ColumnString firstColumn = ColumnString('test 1');
    ColumnString secondColumn = ColumnString('test 2');
    Expression expression = firstColumn.equals('test 1') &
        (secondColumn.like('test 2') | firstColumn.equals('test 1'));

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

  group(
      'Given two columns left combined using two part expressions when retrieving columns',
      () {
    ColumnString firstColumn = ColumnString('test 1');
    ColumnString secondColumn = ColumnString('test 2');
    Expression expression =
        (secondColumn.like('test 2') | firstColumn.equals('test 1')) &
            firstColumn.equals('test 1');

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
  });

  group('Given column BETWEEN expression when retrieving columns', () {
    ColumnInt column = ColumnInt('test 1');
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
    ColumnInt column = ColumnInt('test 1');
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
    ColumnInt column = ColumnInt('test 1');
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

  group('Given ColumnCountAggregate expression', () {
    Expression innerWhere = Constant.bool(true);
    ColumnCountAggregate column =
        ColumnCountAggregate('test', innerWhere: innerWhere);
    Expression expression = column.equals(10);

    test('when checking expression type then expression is AggregateExpression',
        () {
      expect(expression, isA<AggregateExpression>());
    });

    group('when retrieving columns', () {
      List<Column> columns = expression.columns;

      test('then column is represented.', () {
        expect(columns, hasLength(1));
      });

      test('then first is column.', () {
        expect(columns.first, column);
      }, skip: columns.length != 1);
    });

    group('when retrieving aggregate expressions', () {
      List<AggregateExpression> aggregateExpressions =
          expression.aggregateExpressions;

      test('then aggregate expression is represented.', () {
        expect(aggregateExpressions, hasLength(1));
      });

      test('then first is aggregate expression.', () {
        expect(aggregateExpressions.first, expression);
      }, skip: aggregateExpressions.length != 1);
    });
  });

  group('Given ColumnCountAggregate expression with column in inner where', () {
    var innerColumn = ColumnInt('inner');
    Expression innerWhere = innerColumn.equals(20);
    ColumnCountAggregate aggregateColumn =
        ColumnCountAggregate('outer', innerWhere: innerWhere);
    Expression expression = aggregateColumn.equals(10);

    test('when checking expression type then expression is AggregateExpression',
        () {
      expect(expression, isA<AggregateExpression>());
    });

    group('when retrieving columns', () {
      List<Column> columns = expression.columns;

      test('then columns represented are represented.', () {
        expect(columns, hasLength(2));
      });

      test('then first is aggregateColumn.', () {
        expect(columns.first, aggregateColumn);
      }, skip: columns.length != 2);

      test('then last is inner column.', () {
        expect(columns.last, innerColumn);
      }, skip: columns.length != 2);
    });

    group('when retrieving aggregate expressions', () {
      List<AggregateExpression> aggregateExpressions =
          expression.aggregateExpressions;

      test('then aggregate expression is represented.', () {
        expect(aggregateExpressions, hasLength(1));
      });

      test('then first is aggregate expression.', () {
        expect(aggregateExpressions.first, expression);
      }, skip: aggregateExpressions.length != 1);
    });
  });

  group('Given ColumnCountAggregate combined with Column expression', () {
    var intColumn = ColumnInt('column');
    Expression innerWhere = Constant.bool(true);
    ColumnCountAggregate aggregateColumn =
        ColumnCountAggregate('aggregate', innerWhere: innerWhere);
    Expression columnAggregateExpression = aggregateColumn.equals(10);
    Expression expression = columnAggregateExpression & intColumn.equals(20);

    group('when retrieving columns', () {
      List<Column> columns = expression.columns;

      test('then columns are represented.', () {
        expect(columns, hasLength(2));
      });

      test('then first is aggregateColumn.', () {
        expect(columns.first, aggregateColumn);
      }, skip: columns.length != 2);

      test('then last is int column.', () {
        expect(columns.last, intColumn);
      }, skip: columns.length != 2);
    });

    group('when retrieving aggregate expressions', () {
      List<AggregateExpression> aggregateExpressions =
          expression.aggregateExpressions;

      test('then aggregate expression is represented.', () {
        expect(aggregateExpressions, hasLength(1));
      });

      test('then first is aggregate expression.', () {
        expect(aggregateExpressions.first, columnAggregateExpression);
      }, skip: aggregateExpressions.length != 1);
    });
  });

  group('Given Multiple ColumnCountAggregate combined with Column expression',
      () {
    var intColumn = ColumnInt('inner');
    Expression innerWhere = Constant.bool(true);
    ColumnCountAggregate firstAggregateColumn =
        ColumnCountAggregate('first', innerWhere: innerWhere);
    ColumnCountAggregate secondAggregateColumn =
        ColumnCountAggregate('second', innerWhere: innerWhere);
    Expression firstColumnAggregateExpression = firstAggregateColumn.equals(10);
    Expression secondColumnAggregateExpression =
        secondAggregateColumn.equals(20);
    Expression expression = firstColumnAggregateExpression &
        (secondColumnAggregateExpression & intColumn.equals(30));

    group('when retrieving columns', () {
      List<Column> columns = expression.columns;

      test('then columns are represented.', () {
        expect(columns, hasLength(3));
      });

      test('then first is firstAggregateColumn.', () {
        expect(columns.first, firstAggregateColumn);
      }, skip: columns.length != 3);

      test('then second is secondAggregateColumn.', () {
        expect(columns[1], secondAggregateColumn);
      }, skip: columns.length != 3);

      test('then last is int column.', () {
        expect(columns.last, intColumn);
      }, skip: columns.length != 3);
    });

    group('when retrieving aggregate expressions', () {
      List<AggregateExpression> aggregateExpressions =
          expression.aggregateExpressions;

      test('then aggregate expressions are represented.', () {
        expect(aggregateExpressions, hasLength(2));
      });

      test('then first is firstColumnAggregateExpression.', () {
        expect(aggregateExpressions.first, firstColumnAggregateExpression);
      }, skip: aggregateExpressions.length != 2);

      test('then last is secondColumnAggregateExpression.', () {
        expect(aggregateExpressions.last, secondColumnAggregateExpression);
      }, skip: aggregateExpressions.length != 2);
    });
  });
}
