import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnCountAggregate', () {
    var columnName = 'employees';
    var innerWhere = const Expression('true = true');
    var column = ColumnCountAggregate(columnName, innerWhere: innerWhere);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), 'COUNT("$columnName")');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then int is returned.', () {
      expect(column.type, int);
    });

    group('with _ColumnDefaultOperations mixin', () {
      group('when equals compared to NULL value', () {
        var comparisonExpression = column.equals(null);

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is IS NULL expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column IS NULL');
        });
      });

      group('when equals compared to int value', () {
        var comparisonExpression = column.equals(10);
        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is equals comparison.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column = 10');
        });
      });

      group('when NOT equals compared to NULL value', () {
        var comparisonExpression = column.notEquals(null);

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is IS NOT NULL expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column IS NOT NULL');
        });
      });

      group('when NOT equals compared to int value', () {
        var comparisonExpression = column.notEquals(10);

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is NOT equals expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column != 10 OR $column IS NULL)');
        });
      });

      group('when checking if expression is between int values', () {
        var comparisonExpression = column.between(10, 20);

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is between expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column BETWEEN 10 AND 20');
        });
      });

      group('when checking if expression is NOT between int value', () {
        var comparisonExpression = column.notBetween(10, 20);

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is NOT between expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;
          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column NOT BETWEEN 10 AND 20');
        });
      });

      group('when checking if expression is in value set', () {
        var comparisonExpression = column.inSet(<int>{10, 11, 12});

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is IN expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column IN (10, 11, 12)');
        });
      });

      group('when checking if expression is NOT in value set', () {
        var comparisonExpression = column.notInSet(<int>{10, 11, 12});

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is NOT IN expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column NOT IN (10, 11, 12) OR $column IS NULL)');
        });
      });

      group('when is distinct from compared to int value', () {
        var comparisonExpression = column.isDistinctFrom(10);

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is IS DISTINCT FROM expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column IS DISTINCT FROM 10');
        });
      });

      group('when is NOT distinct from compared to int value', () {
        var comparisonExpression = column.isNotDistinctFrom(10);

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is IS NOT DISTINCT FROM expression.',
            () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column IS NOT DISTINCT FROM 10');
        });
      });
    });

    group('with _ColumnNumberOperations mixin', () {
      group('when checking if expression is between int values', () {
        var comparisonExpression = column.between(10, 20);

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is between expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column BETWEEN 10 AND 20');
        });
      });

      group('when checking if expression is NOT between int values', () {
        var comparisonExpression = column.notBetween(10, 20);

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is NOT between expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '$column NOT BETWEEN 10 AND 20');
        });
      });

      group('when greater than compared to expression', () {
        var comparisonExpression = column > const Expression('10');

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column > 10)');
        });
      });

      group('when greater than compared to column type', () {
        var comparisonExpression = column > 10;

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column > 10)');
        });
      });

      group('when greater than compared to column', () {
        var comparisonExpression = column > column;

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column > $column)');
        });
      });

      group('when greater than compared to unhandled type', () {
        var comparisonExpression = column > 'string is unhandled';

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test(
            'then aggregateExpressionExpression is escaped operator expression.',
            () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column > \'string is unhandled\')');
        });
      });

      group('when greater or equal than compared to expression', () {
        var comparisonExpression = column >= const Expression('10');

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column >= 10)');
        });
      });

      group('when greater or equal than compared to column type', () {
        var comparisonExpression = column >= 10;

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpressionExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column >= 10)');
        });
      });

      group('when greater or equal than compared to column', () {
        var comparisonExpression = column >= column;

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column >= $column)');
        });
      });

      group('when greater or equal than compared to unhandled type', () {
        var comparisonExpression = column >= 'string is unhandled';

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is escaped operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column >= \'string is unhandled\')');
        });
      });

      group('when less than compared to expression', () {
        var comparisonExpression = column < const Expression('10');

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column < 10)');
        });
      });

      group('when less than compared to column type', () {
        var comparisonExpression = column < 10;

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column < 10)');
        });
      });

      group('when less than compared to column', () {
        var comparisonExpression = column < column;

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column < $column)');
        });
      });

      group('when less than compared to unhandled type', () {
        var comparisonExpression = column < 'string is unhandled';

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is escaped operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column < \'string is unhandled\')');
        });
      });

      group('when less or equal than compared to expression', () {
        var comparisonExpression = column <= const Expression('10');

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpressionExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column <= 10)');
        });
      });

      group('when less or equal than compared to column type', () {
        var comparisonExpression = column <= 10;

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column <= 10)');
        });
      });

      group('when less or equal than compared to column', () {
        var comparisonExpression = column <= column;

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column <= $column)');
        });
      });

      group('when less or equal than compared to unhandled type', () {
        var comparisonExpression = column <= 'string is unhandled';

        test('then expression output is inner where.', () {
          expect(comparisonExpression.toString(), innerWhere.toString());
        });

        test('then expression is AggregateExpression.', () {
          expect(comparisonExpression, isA<AggregateExpression>());
        });

        test('then aggregateExpression is escaped operator expression.', () {
          var asAggregateExpression =
              comparisonExpression as AggregateExpression;

          expect(asAggregateExpression.aggregateExpression.toString(),
              '($column <= \'string is unhandled\')');
        });
      });
    });
  });
}
