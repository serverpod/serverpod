import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnInt', () {
    var columnName = 'age';
    var column = ColumnInt(columnName, Table(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then int is returned.', () {
      expect(column.type, int);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to NULL value then output is IS NULL expression.',
          () {
        var comparisonExpression = column.equals(null);

        expect(comparisonExpression.toString(), '$column IS NULL');
      });

      test(
          'when equals compared to int value then output is equals expression.',
          () {
        var comparisonExpression = column.equals(10);

        expect(comparisonExpression.toString(), '$column = 10');
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
          () {
        var comparisonExpression = column.notEquals(null);

        expect(comparisonExpression.toString(), '$column IS NOT NULL');
      });

      test(
          'when NOT equals compared to int value then output is NOT equals expression.',
          () {
        var comparisonExpression = column.notEquals(10);

        expect(comparisonExpression.toString(),
            '($column != 10 OR $column IS NULL)');
      });

      test(
          'when checking if expression is between int values then output is between expression.',
          () {
        var comparisonExpression = column.between(10, 20);

        expect(comparisonExpression.toString(), '$column BETWEEN 10 AND 20');
      });

      test(
          'when checking if expression is NOT between int value then output is NOT between expression.',
          () {
        var comparisonExpression = column.notBetween(10, 20);

        expect(
            comparisonExpression.toString(), '$column NOT BETWEEN 10 AND 20');
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<int>{10, 11, 12});

        expect(comparisonExpression.toString(), '$column IN (10, 11, 12)');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<int>{10, 11, 12});

        expect(comparisonExpression.toString(),
            '($column NOT IN (10, 11, 12) OR $column IS NULL)');
      });

      test(
          'when is distinct from compared to int value then output is IS DISTINCT FROM expression.',
          () {
        var comparisonExpression = column.isDistinctFrom(10);

        expect(comparisonExpression.toString(), '$column IS DISTINCT FROM 10');
      });

      test(
          'when is NOT distinct from compared to int value then output is IS NOT DISTINCT FROM expression.',
          () {
        var comparisonExpression = column.isNotDistinctFrom(10);

        expect(
            comparisonExpression.toString(), '$column IS NOT DISTINCT FROM 10');
      });
    });

    group('with _ColumnNumberOperations mixin', () {
      test(
          'when checking if expression is between int values then output is between expression.',
          () {
        var comparisonExpression = column.between(10, 20);

        expect(comparisonExpression.toString(), '$column BETWEEN 10 AND 20');
      });

      test(
          'when checking if expression is NOT between int values then output is NOT between expression.',
          () {
        var comparisonExpression = column.notBetween(10, 20);

        expect(
            comparisonExpression.toString(), '$column NOT BETWEEN 10 AND 20');
      });

      test(
          'when greater than compared to expression then output is operator expression.',
          () {
        var comparisonExpression = column > const Expression('10');

        expect(comparisonExpression.toString(), '$column > 10');
      });

      test(
          'when greater than compared to column type then output is operator expression.',
          () {
        var comparisonExpression = column > 10;

        expect(comparisonExpression.toString(), '$column > 10');
      });

      test(
          'when greater than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column > column;

        expect(comparisonExpression.toString(), '$column > $column');
      });

      test(
          'when greater than compared to unhandled type then output is escaped operator expression.',
          () {
        var comparisonExpression = column > 'string is unhandled';

        expect(comparisonExpression.toString(),
            '$column > \'string is unhandled\'');
      });

      test(
          'when greater or equal than compared to expression then output is operator expression.',
          () {
        var comparisonExpression = column >= const Expression('10');

        expect(comparisonExpression.toString(), '$column >= 10');
      });

      test(
          'when greater or equal than compared to column type then output is operator expression.',
          () {
        var comparisonExpression = column >= 10;

        expect(comparisonExpression.toString(), '$column >= 10');
      });

      test(
          'when greater or equal than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column >= column;

        expect(comparisonExpression.toString(), '$column >= $column');
      });

      test(
          'when greater or equal than compared to unhandled type then output is escaped operator expression.',
          () {
        var comparisonExpression = column >= 'string is unhandled';

        expect(comparisonExpression.toString(),
            '$column >= \'string is unhandled\'');
      });

      test(
          'when less than compared to expression then output is operator expression.',
          () {
        var comparisonExpression = column < const Expression('10');

        expect(comparisonExpression.toString(), '$column < 10');
      });

      test(
          'when less than compared to column type then output is operator expression.',
          () {
        var comparisonExpression = column < 10;

        expect(comparisonExpression.toString(), '$column < 10');
      });

      test(
          'when less than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column < column;

        expect(comparisonExpression.toString(), '$column < $column');
      });

      test(
          'when less than compared to unhandled type then output is escaped operator expression.',
          () {
        var comparisonExpression = column < 'string is unhandled';

        expect(comparisonExpression.toString(),
            '$column < \'string is unhandled\'');
      });

      test(
          'when less or equal than compared to expression then output is operator expression.',
          () {
        var comparisonExpression = column <= const Expression('10');

        expect(comparisonExpression.toString(), '$column <= 10');
      });

      test(
          'when less or equal than compared to column type then output is operator expression.',
          () {
        var comparisonExpression = column <= 10;

        expect(comparisonExpression.toString(), '$column <= 10');
      });

      test(
          'when less or equal than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column <= column;

        expect(comparisonExpression.toString(), '$column <= $column');
      });

      test(
          'when less or equal than compared to unhandled type then output is escaped operator expression.',
          () {
        var comparisonExpression = column <= 'string is unhandled';

        expect(comparisonExpression.toString(),
            '$column <= \'string is unhandled\'');
      });
    });
  });
}
