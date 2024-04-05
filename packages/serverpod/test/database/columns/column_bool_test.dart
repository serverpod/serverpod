import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnBool', () {
    var columnName = 'production';
    var column = ColumnBool(columnName, Table(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then bool is returned.', () {
      expect(column.type, bool);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to NULL value then output is IS NULL expression.',
          () {
        var comparisonExpression = column.equals(null);

        expect(comparisonExpression.toString(), '$column IS NULL');
      });

      test(
          'when equals compared to bool value then output is equals expression.',
          () {
        var comparisonExpression = column.equals(true);

        expect(comparisonExpression.toString(), '$column = true');
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
          () {
        var comparisonExpression = column.notEquals(null);

        expect(comparisonExpression.toString(), '$column IS NOT NULL');
      });

      test(
          'when NOT equals compared to bool value then output is NOT equals expression.',
          () {
        var comparisonExpression = column.notEquals(true);

        expect(
            comparisonExpression.toString(), '$column IS DISTINCT FROM true');
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<bool>{true, false});

        expect(comparisonExpression.toString(), '$column IN (true, false)');
      });

      test(
          'when checking if expression is in empty value set then output is FALSE expression.',
          () {
        var comparisonExpression = column.inSet(<bool>{});

        expect(comparisonExpression.toString(), 'FALSE');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<bool>{true, false});

        expect(comparisonExpression.toString(),
            '($column NOT IN (true, false) OR $column IS NULL)');
      });

      test(
          'when checking if expression is NOT in empty value set then output is TRUE expression.',
          () {
        var comparisonExpression = column.notInSet(<bool>{});

        expect(comparisonExpression.toString(), 'TRUE');
      });
    });
  });
}
