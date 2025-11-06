import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnString', () {
    var columnName = 'name';
    var column = ColumnString(columnName, Table<int?>(tableName: 'test'));

    test(
      'when toString is called then column name withing double quotes is returned.',
      () {
        expect(column.toString(), '"test"."$columnName"');
      },
    );

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then String is returned.', () {
      expect(column.type, String);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
          var comparisonExpression = column.equals(null);

          expect(comparisonExpression.toString(), '$column IS NULL');
        },
      );

      test(
        'when equals compared to String value then output is escaped equals expression.',
        () {
          var comparisonExpression = column.equals('test');

          expect(comparisonExpression.toString(), '$column = \'test\'');
        },
      );

      test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
          var comparisonExpression = column.notEquals(null);

          expect(comparisonExpression.toString(), '$column IS NOT NULL');
        },
      );

      test(
        'when NOT equals compared to String value then output is escaped NOT equals expression.',
        () {
          var comparisonExpression = column.notEquals('test');

          expect(
            comparisonExpression.toString(),
            '$column IS DISTINCT FROM \'test\'',
          );
        },
      );

      test(
        'when like compared to String value then output is escaped like expression.',
        () {
          var comparisonExpression = column.like('test');

          expect(comparisonExpression.toString(), '$column LIKE \'test\'');
        },
      );

      test(
        'when notLike compared to String value then output is escaped notLike expression.',
        () {
          var comparisonExpression = column.notLike('test');

          expect(
            comparisonExpression.toString(),
            '($column NOT LIKE \'test\' OR $column IS NULL)',
          );
        },
      );

      test(
        'when ilike compared to String value then output is escaped ilike expression.',
        () {
          var comparisonExpression = column.ilike('test');

          expect(comparisonExpression.toString(), '$column ILIKE \'test\'');
        },
      );

      test(
        'when notIlike compared to String value then output is escaped notIlike expression.',
        () {
          var comparisonExpression = column.notIlike('test');

          expect(
            comparisonExpression.toString(),
            '($column NOT ILIKE \'test\' OR $column IS NULL)',
          );
        },
      );

      test(
        'when checking if expression is in value set then output is IN expression.',
        () {
          var comparisonExpression = column.inSet(<String>{'a', 'b', 'c'});

          expect(
            comparisonExpression.toString(),
            '$column IN (\'a\', \'b\', \'c\')',
          );
        },
      );

      test(
        'when checking if expression is in empty value set then output is FALSE expression.',
        () {
          var comparisonExpression = column.inSet(<String>{});

          expect(comparisonExpression.toString(), 'FALSE');
        },
      );

      test(
        'when checking if expression is NOT in empty value set then output is TRUE expression.',
        () {
          var comparisonExpression = column.notInSet(<String>{});

          expect(comparisonExpression.toString(), 'TRUE');
        },
      );
    });

    test(
      'when greater than compared to expression then output is operator expression.',
      () {
        var comparisonExpression = column > const Expression('10');

        expect(comparisonExpression.toString(), '$column > 10');
      },
    );

    test(
      'when greater than compared to column type then output is operator expression.',
      () {
        var comparisonExpression = column > 'test';

        expect(comparisonExpression.toString(), '$column > \'test\'');
      },
    );

    test(
      'when greater than compared to column then output is operator expression.',
      () {
        var comparisonExpression = column > column;

        expect(comparisonExpression.toString(), '$column > $column');
      },
    );

    test(
      'when greater than compared to unhandled type then argument error is thrown.',
      () {
        expect(
          () => column > 10,
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Invalid type for comparison: int, allowed types are Expression, String or Column',
            ),
          ),
        );
      },
    );

    test(
      'when greater or equal than compared to expression then output is operator expression.',
      () {
        var comparisonExpression = column >= const Expression('10');

        expect(comparisonExpression.toString(), '$column >= 10');
      },
    );

    test(
      'when greater or equal than compared to column type then output is operator expression.',
      () {
        var comparisonExpression = column >= 'test';

        expect(comparisonExpression.toString(), '$column >= \'test\'');
      },
    );

    test(
      'when greater or equal than compared to column then output is operator expression.',
      () {
        var comparisonExpression = column >= column;

        expect(comparisonExpression.toString(), '$column >= $column');
      },
    );

    test(
      'when greater or equal than compared to unhandled type then argument error is thrown.',
      () {
        expect(
          () => column >= 10,
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Invalid type for comparison: int, allowed types are Expression, String or Column',
            ),
          ),
        );
      },
    );

    test(
      'when less than compared to expression then output is operator expression.',
      () {
        var comparisonExpression = column < const Expression('10');

        expect(comparisonExpression.toString(), '$column < 10');
      },
    );

    test(
      'when less than compared to column type then output is operator expression.',
      () {
        var comparisonExpression = column < 'test';

        expect(comparisonExpression.toString(), '$column < \'test\'');
      },
    );

    test(
      'when less than compared to column then output is operator expression.',
      () {
        var comparisonExpression = column < column;

        expect(comparisonExpression.toString(), '$column < $column');
      },
    );

    test(
      'when less than compared to unhandled type then argument error is thrown.',
      () {
        expect(
          () => column < 10,
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Invalid type for comparison: int, allowed types are Expression, String or Column',
            ),
          ),
        );
      },
    );

    test(
      'when less or equal than compared to expression then output is operator expression.',
      () {
        var comparisonExpression = column <= const Expression('10');

        expect(comparisonExpression.toString(), '$column <= 10');
      },
    );

    test(
      'when less or equal than compared to column type then output is operator expression.',
      () {
        var comparisonExpression = column <= 'test';

        expect(comparisonExpression.toString(), '$column <= \'test\'');
      },
    );

    test(
      'when less or equal than compared to column then output is operator expression.',
      () {
        var comparisonExpression = column <= column;

        expect(comparisonExpression.toString(), '$column <= $column');
      },
    );

    test(
      'when less or equal than compared to unhandled type then argument error is thrown.',
      () {
        expect(
          () => column <= 10,
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Invalid type for comparison: int, allowed types are Expression, String or Column',
            ),
          ),
        );
      },
    );
  });
}
