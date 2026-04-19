import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  ValueEncoder.set(const PostgresValueEncoder());

  group('Given ColumnDecimal', () {
    var columnName = 'price';
    var column = ColumnDecimal(columnName, Table<int?>(tableName: 'test'));

    test(
      'when toString is called then column name withing double quotes is returned.',
      () {
        expect(column.toString(), '"test"."$columnName"');
      },
    );

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then Decimal is returned.', () {
      expect(column.type, Decimal);
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
        'when equals compared to Decimal value then output is equals expression.',
        () {
          var comparisonExpression = column.equals(
            Decimal.parse('123.456'),
          );

          expect(
            comparisonExpression.toString(),
            '$column = 123.456',
          );
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
        'when NOT equals compared to Decimal value then output is NOT equals expression.',
        () {
          var comparisonExpression = column.notEquals(Decimal.parse('10.5'));

          expect(
            comparisonExpression.toString(),
            '$column IS DISTINCT FROM 10.5',
          );
        },
      );

      test(
        'when checking if expression is in value set then output is IN expression.',
        () {
          var comparisonExpression = column.inSet(<Decimal>{
            Decimal.parse('1.1'),
            Decimal.parse('2.2'),
          });

          expect(
            comparisonExpression.toString(),
            '$column IN (1.1, 2.2)',
          );
        },
      );

      test(
        'when checking if expression is in empty value set then output is FALSE expression.',
        () {
          var comparisonExpression = column.inSet(<Decimal>{});

          expect(comparisonExpression.toString(), 'FALSE');
        },
      );

      test(
        'when checking if expression is NOT in value set then output is NOT IN expression.',
        () {
          var comparisonExpression = column.notInSet(<Decimal>{
            Decimal.parse('1.1'),
            Decimal.parse('2.2'),
          });

          expect(
            comparisonExpression.toString(),
            '($column NOT IN (1.1, 2.2) OR $column IS NULL)',
          );
        },
      );

      test(
        'when checking if expression is NOT in empty value set then output is TRUE expression.',
        () {
          var comparisonExpression = column.notInSet(<Decimal>{});

          expect(comparisonExpression.toString(), 'TRUE');
        },
      );
    });

    group('with _ColumnComparisonBetweenOperations mixin', () {
      test(
        'when checking if expression is between Decimal values then output is between expression.',
        () {
          var comparisonExpression = column.between(
            Decimal.parse('10.5'),
            Decimal.parse('20.5'),
          );

          expect(
            comparisonExpression.toString(),
            '$column BETWEEN 10.5 AND 20.5',
          );
        },
      );

      test(
        'when checking if expression is NOT between Decimal values then output is NOT between expression.',
        () {
          var comparisonExpression = column.notBetween(
            Decimal.parse('10.5'),
            Decimal.parse('20.5'),
          );

          expect(
            comparisonExpression.toString(),
            '$column NOT BETWEEN 10.5 AND 20.5',
          );
        },
      );
    });

    group('with _ColumnComparisonDefaultOperations mixin', () {
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
          var comparisonExpression = column > Decimal.parse('10.5');

          expect(comparisonExpression.toString(), '$column > 10.5');
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
            () => column > 'string is unhandled',
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Invalid type for comparison: String, allowed types are Expression, Decimal or Column',
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
          var comparisonExpression = column >= Decimal.parse('10.5');

          expect(comparisonExpression.toString(), '$column >= 10.5');
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
            () => column >= 'string is unhandled',
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Invalid type for comparison: String, allowed types are Expression, Decimal or Column',
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
          var comparisonExpression = column < Decimal.parse('10.5');

          expect(comparisonExpression.toString(), '$column < 10.5');
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
            () => column < 'string is unhandled',
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Invalid type for comparison: String, allowed types are Expression, Decimal or Column',
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
          var comparisonExpression = column <= Decimal.parse('10.5');

          expect(comparisonExpression.toString(), '$column <= 10.5');
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
            () => column <= 'string is unhandled',
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Invalid type for comparison: String, allowed types are Expression, Decimal or Column',
              ),
            ),
          );
        },
      );
    });
  });
}
