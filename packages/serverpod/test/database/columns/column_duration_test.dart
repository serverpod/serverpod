import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnDuration', () {
    var columnName = 'age';
    var column = ColumnDuration(columnName, Table(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then Duration is returned.', () {
      expect(column.type, Duration);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to NULL value then output is IS NULL expression.',
          () {
        var comparisonExpression = column.equals(null);

        expect(comparisonExpression.toString(), '$column IS NULL');
      });

      test(
          'when equals compared to duration value then output is equals expression.',
          () {
        var comparisonExpression = column.equals(const Duration(hours: 10));

        expect(comparisonExpression.toString(), '$column = \'36000000\'');
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
          () {
        var comparisonExpression = column.notEquals(null);

        expect(comparisonExpression.toString(), '$column IS NOT NULL');
      });

      test(
          'when NOT equals compared to duration value then output is NOT equals expression.',
          () {
        var comparisonExpression = column.notEquals(const Duration(hours: 10));

        expect(comparisonExpression.toString(),
            '($column != \'36000000\' OR $column IS NULL)');
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<Duration>{
          const Duration(hours: 10),
          const Duration(hours: 11),
          const Duration(hours: 12),
        });

        expect(comparisonExpression.toString(),
            '$column IN (\'36000000\', \'39600000\', \'43200000\')');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<Duration>{
          const Duration(hours: 10),
          const Duration(hours: 11),
          const Duration(hours: 12),
        });

        expect(comparisonExpression.toString(),
            '($column NOT IN (\'36000000\', \'39600000\', \'43200000\') OR $column IS NULL)');
      });
    });

    group('with _ColumnNumberOperations mixin', () {
      test(
          'when checking if expression is between duration values then output is between expression.',
          () {
        var comparisonExpression = column.between(
            const Duration(hours: 10), const Duration(hours: 11));

        expect(comparisonExpression.toString(),
            '$column BETWEEN \'36000000\' AND \'39600000\'');
      });

      test(
          'when checking if expression is NOT between duration values then output is NOT between expression.',
          () {
        var comparisonExpression = column.notBetween(
            const Duration(hours: 10), const Duration(hours: 11));

        expect(comparisonExpression.toString(),
            '$column NOT BETWEEN \'36000000\' AND \'39600000\'');
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
        var comparisonExpression = column > const Duration(hours: 10);

        expect(comparisonExpression.toString(), '$column > \'36000000\'');
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
        var comparisonExpression = column >= const Duration(hours: 10);

        expect(comparisonExpression.toString(), '$column >= \'36000000\'');
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
        var comparisonExpression = column < const Duration(hours: 10);

        expect(comparisonExpression.toString(), '$column < \'36000000\'');
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
        var comparisonExpression = column <= const Duration(hours: 10);

        expect(comparisonExpression.toString(), '$column <= \'36000000\'');
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
