import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnInt expression', () {
    var columnName = 'age';
    var expression = ColumnInt(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expression.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(expression.columnName, columnName);
    });

    test('when type is called then int is returned.', () {
      expect(expression.type, int);
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expression.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test('when equals compared to int value then output is equals expression.',
        () {
      var comparisonExpression = expression.equals(10);

      expect(comparisonExpression.toString(), '"$columnName" = 10');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
      var comparisonExpression = expression.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to int value then output is NOT equals expression.',
        () {
      var comparisonExpression = expression.notEquals(10);

      expect(comparisonExpression.toString(), '"$columnName" != 10');
    });

    test(
        'when checking if expression is between int values then output is between expression.',
        () {
      var comparisonExpression = expression.between(10, 20);

      expect(
          comparisonExpression.toString(), '"$columnName" BETWEEN 10 AND 20');
    });

    test(
        'when checking if expression is NOT between int value then output is NOT between expression.',
        () {
      var comparisonExpression = expression.notBetween(10, 20);

      expect(comparisonExpression.toString(),
          '"$columnName" NOT BETWEEN 10 AND 20');
    });
  });
}
