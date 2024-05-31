import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnDateTime', () {
    var columnName = 'age';
    var column = ColumnDateTime(columnName, Table(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then DateTime is returned.', () {
      expect(column.type, DateTime);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to NULL value then output is IS NULL expression.',
          () {
        var comparisonExpression = column.equals(null);

        expect(comparisonExpression.toString(), '$column IS NULL');
      });

      test(
          'when equals compared to date time value then output is equals expression.',
          () {
        var comparisonExpression = column.equals(DateTime.utc(1991, 5, 28));

        expect(comparisonExpression.toString(),
            '$column = \'"1991-05-28T00:00:00.000Z"\'');
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
          () {
        var comparisonExpression = column.notEquals(null);

        expect(comparisonExpression.toString(), '$column IS NOT NULL');
      });

      test(
          'when NOT equals compared to date time value then output is NOT equals expression.',
          () {
        var comparisonExpression = column.notEquals(DateTime.utc(1991, 5, 28));

        expect(comparisonExpression.toString(),
            '$column IS DISTINCT FROM \'"1991-05-28T00:00:00.000Z"\'');
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<DateTime>{
          DateTime.utc(1991, 5, 28),
          DateTime.utc(1991, 5, 29),
          DateTime.utc(1991, 5, 30),
        });

        expect(comparisonExpression.toString(),
            '$column IN (\'"1991-05-28T00:00:00.000Z"\', \'"1991-05-29T00:00:00.000Z"\', \'"1991-05-30T00:00:00.000Z"\')');
      });

      test(
          'when checking if expression is in empty value set then output is FALSE expression.',
          () {
        var comparisonExpression = column.inSet(<DateTime>{});

        expect(comparisonExpression.toString(), 'FALSE');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<DateTime>{
          DateTime.utc(1991, 5, 28),
          DateTime.utc(1991, 5, 29),
          DateTime.utc(1991, 5, 30),
        });

        expect(comparisonExpression.toString(),
            '($column NOT IN (\'"1991-05-28T00:00:00.000Z"\', \'"1991-05-29T00:00:00.000Z"\', \'"1991-05-30T00:00:00.000Z"\') OR $column IS NULL)');
      });

      test(
          'when checking if expression is NOT in empty value set then output is TRUE expression.',
          () {
        var comparisonExpression = column.notInSet(<DateTime>{});

        expect(
          comparisonExpression.toString(),
          'TRUE',
        );
      });
    });

    group('with _ColumnNumberOperations mixin', () {
      test(
          'when checking if expression is between date time values then output is between expression.',
          () {
        var comparisonExpression = column.between(
            DateTime.utc(1991, 5, 28), DateTime.utc(1991, 5, 29));

        expect(comparisonExpression.toString(),
            '$column BETWEEN \'"1991-05-28T00:00:00.000Z"\' AND \'"1991-05-29T00:00:00.000Z"\'');
      });

      test(
          'when checking if expression is NOT between date time values then output is NOT between expression.',
          () {
        var comparisonExpression = column.notBetween(
            DateTime.utc(1991, 5, 28), DateTime.utc(1991, 5, 29));

        expect(comparisonExpression.toString(),
            '$column NOT BETWEEN \'"1991-05-28T00:00:00.000Z"\' AND \'"1991-05-29T00:00:00.000Z"\'');
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
        var comparisonExpression = column > DateTime.utc(1991, 5, 28);

        expect(comparisonExpression.toString(),
            '$column > \'"1991-05-28T00:00:00.000Z"\'');
      });

      test(
          'when greater than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column > column;

        expect(comparisonExpression.toString(), '$column > $column');
      });

      test(
          'when greater than compared to unhandled type then argument error is thrown.',
          () {
        expect(
          () => column > 'string is unhandled',
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Invalid type for comparison: String, allowed types are Expression, DateTime or Column',
            ),
          ),
        );
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
        var comparisonExpression = column >= DateTime.utc(1991, 5, 28);

        expect(comparisonExpression.toString(),
            '$column >= \'"1991-05-28T00:00:00.000Z"\'');
      });

      test(
          'when greater or equal than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column >= column;

        expect(comparisonExpression.toString(), '$column >= $column');
      });

      test(
          'when greater or equal than compared to unhandled type then argument error is thrown.',
          () {
        expect(
          () => column >= 'string is unhandled',
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Invalid type for comparison: String, allowed types are Expression, DateTime or Column',
            ),
          ),
        );
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
        var comparisonExpression = column < DateTime.utc(1991, 5, 28);

        expect(comparisonExpression.toString(),
            '$column < \'"1991-05-28T00:00:00.000Z"\'');
      });

      test(
          'when less than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column < column;

        expect(comparisonExpression.toString(), '$column < $column');
      });

      test(
          'when less than compared to unhandled type then argument error is thrown.',
          () {
        expect(
          () => column < 'string is unhandled',
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Invalid type for comparison: String, allowed types are Expression, DateTime or Column',
            ),
          ),
        );
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
        var comparisonExpression = column <= DateTime.utc(1991, 5, 28);

        expect(comparisonExpression.toString(),
            '$column <= \'"1991-05-28T00:00:00.000Z"\'');
      });

      test(
          'when less or equal than compared to column then output is operator expression.',
          () {
        var comparisonExpression = column <= column;

        expect(comparisonExpression.toString(), '$column <= $column');
      });

      test(
          'when less or equal than compared to unhandled type then argument error is thrown.',
          () {
        expect(
          () => column <= 'string is unhandled',
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Invalid type for comparison: String, allowed types are Expression, DateTime or Column',
            ),
          ),
        );
      });
    });
  });
}
