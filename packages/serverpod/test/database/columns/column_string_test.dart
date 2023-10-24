import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnString', () {
    var columnName = 'name';
    var column = ColumnString(columnName, Table(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

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
      });

      test(
          'when equals compared to String value then output is escaped equals expression.',
          () {
        var comparisonExpression = column.equals('test');

        expect(comparisonExpression.toString(), '$column = \'test\'');
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
          () {
        var comparisonExpression = column.notEquals(null);

        expect(comparisonExpression.toString(), '$column IS NOT NULL');
      });

      test(
          'when NOT equals compared to String value then output is escaped NOT equals expression.',
          () {
        var comparisonExpression = column.notEquals('test');

        expect(comparisonExpression.toString(),
            '($column != \'test\' OR $column IS NULL)');
      });

      test(
          'when like compared to String value then output is escaped like expression.',
          () {
        var comparisonExpression = column.like('test');

        expect(comparisonExpression.toString(), '$column LIKE \'test\'');
      });

      test(
          'when notLike compared to String value then output is escaped notLike expression.',
          () {
        var comparisonExpression = column.notLike('test');

        expect(
          comparisonExpression.toString(),
          '($column NOT LIKE \'test\' OR $column IS NULL)',
        );
      });

      test(
          'when ilike compared to String value then output is escaped ilike expression.',
          () {
        var comparisonExpression = column.ilike('test');

        expect(comparisonExpression.toString(), '$column ILIKE \'test\'');
      });

      test(
          'when notIlike compared to String value then output is escaped notIlike expression.',
          () {
        var comparisonExpression = column.notIlike('test');

        expect(
          comparisonExpression.toString(),
          '($column NOT ILIKE \'test\' OR $column IS NULL)',
        );
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<String>{'a', 'b', 'c'});

        expect(comparisonExpression.toString(),
            '$column IN (\'a\', \'b\', \'c\')');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<String>{'a', 'b', 'c'});

        expect(comparisonExpression.toString(),
            '($column NOT IN (\'a\', \'b\', \'c\') OR $column IS NULL)');
      });

      test(
          'when checking if expression is distinct from value then output is DISTINCT FROM expression.',
          () {
        var comparisonExpression = column.isDistinctFrom('test');

        expect(comparisonExpression.toString(),
            '$column IS DISTINCT FROM \'test\'');
      });

      test(
          'when checking if expression is NOT distinct from value then output is NOT DISTINCT FROM expression.',
          () {
        var comparisonExpression = column.isNotDistinctFrom('test');

        expect(comparisonExpression.toString(),
            '$column IS NOT DISTINCT FROM \'test\'');
      });
    });
  });
}
