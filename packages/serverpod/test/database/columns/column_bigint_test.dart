import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given ColumnBigInt', () {
    var columnName = 'bigint';
    var column = ColumnBigInt(columnName, Table(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then BigInt is returned.', () {
      expect(column.type, BigInt);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to NULL value then output is IS NULL expression.',
          () {
        var comparisonExpression = column.equals(null);

        expect(comparisonExpression.toString(), '$column IS NULL');
      });

      test(
          'when equals compared to BigInt value then output is equals expression.',
          () {
        var comparisonExpression =
            column.equals(BigInt.parse('-12345678901234567890'));

        expect(comparisonExpression.toString(),
            '$column = \'-12345678901234567890\'');
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
          () {
        var comparisonExpression = column.notEquals(null);

        expect(comparisonExpression.toString(), '$column IS NOT NULL');
      });

      test(
          'when NOT equals compared to BigInt value then output is NOT equals expression.',
          () {
        var comparisonExpression = column.notEquals(BigInt.one);

        expect(
            comparisonExpression.toString(), '$column IS DISTINCT FROM \'1\'');
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<BigInt>{
          BigInt.zero,
          BigInt.one,
        });

        expect(comparisonExpression.toString(), '$column IN (\'0\', \'1\')');
      });

      test(
          'when checking if expression is in empty value set then output is FALSE expression.',
          () {
        var comparisonExpression = column.inSet(<BigInt>{});

        expect(comparisonExpression.toString(), 'FALSE');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<BigInt>{
          BigInt.zero,
          BigInt.one,
        });

        expect(comparisonExpression.toString(),
            '($column NOT IN (\'0\', \'1\') OR $column IS NULL)');
      });

      test(
          'when checking if expression is NOT in empty value set then output is TRUE expression.',
          () {
        var comparisonExpression = column.notInSet(<BigInt>{});

        expect(comparisonExpression.toString(), 'TRUE');
      });
    });
  });
}
