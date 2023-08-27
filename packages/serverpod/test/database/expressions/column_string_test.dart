import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnString expression', () {
    var columnName = 'name';
    var expression = ColumnString(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expression.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(expression.columnName, columnName);
    });

    test('when type is called then String is returned.', () {
      expect(expression.type, String);
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expression.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test(
        'when equals compared to String value then output is escaped equals expression.',
        () {
      var comparisonExpression = expression.equals('test');

      expect(comparisonExpression.toString(), '"$columnName" = \'test\'');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
      var comparisonExpression = expression.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to String value then output is escaped NOT equals expression.',
        () {
      var comparisonExpression = expression.notEquals('test');

      expect(comparisonExpression.toString(), '"$columnName" != \'test\'');
    });

    test(
        'when like compared to String value then output is escaped like expression.',
        () {
      var comparisonExpression = expression.like('test');

      expect(comparisonExpression.toString(), '"$columnName" LIKE \'test\'');
    });

    test(
        'when ilike compared to String value then output is escaped like expression.',
        () {
      var comparisonExpression = expression.ilike('test');

      expect(comparisonExpression.toString(), '"$columnName" ILIKE \'test\'');
    });

    test(
        'when checking if expression is in value set then output is IN expression.',
        () {
      var comparisonExpression = expression.inSet(<String>{'a', 'b', 'c'});

      expect(comparisonExpression.toString(),
          '"$columnName" IN (\'a\', \'b\', \'c\')');
    });

    test(
        'when checking if expression is NOT in value set then output is NOT IN expression.',
        () {
      var comparisonExpression = expression.notInSet(<String>{'a', 'b', 'c'});

      expect(comparisonExpression.toString(),
          '"$columnName" NOT IN (\'a\', \'b\', \'c\')');
    });
  });
}
