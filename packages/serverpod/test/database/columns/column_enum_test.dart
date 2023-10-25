import 'package:serverpod/database.dart';
import 'package:test/test.dart';

enum TestEnum {
  red,
  blue,
  green,
}

void main() {
  group('Given a ColumnEnum', () {
    var columnName = 'color';
    var column = ColumnEnum<TestEnum>(columnName, Table(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then TestEnum is returned.', () {
      expect(column.type, TestEnum);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to NULL value then output is IS NULL expression.',
          () {
        var comparisonExpression = column.equals(null);

        expect(comparisonExpression.toString(), '$column IS NULL');
      });

      test(
          'when equals compared to enum value then output is equals expression.',
          () {
        var comparisonExpression = column.equals(TestEnum.blue);

        expect(comparisonExpression.toString(), '$column = 1');
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
          () {
        var comparisonExpression = column.notEquals(null);

        expect(comparisonExpression.toString(), '$column IS NOT NULL');
      });

      test(
          'when NOT equals compared to enum value then output is NOT equals expression.',
          () {
        var comparisonExpression = column.notEquals(TestEnum.blue);

        expect(comparisonExpression.toString(), '$column IS DISTINCT FROM 1');
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<TestEnum>{
          TestEnum.red,
          TestEnum.blue,
          TestEnum.green,
        });

        expect(comparisonExpression.toString(), '$column IN (0, 1, 2)');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<TestEnum>{
          TestEnum.red,
          TestEnum.blue,
          TestEnum.green,
        });

        expect(comparisonExpression.toString(),
            '($column NOT IN (0, 1, 2) OR $column IS NULL)');
      });
    });
  });
}
