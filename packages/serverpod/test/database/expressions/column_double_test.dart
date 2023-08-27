import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnDouble expression', () {
    var columnName = 'age';
    var expression = ColumnDouble(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expression.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(expression.columnName, columnName);
    });

    test('when type is called then double is returned.', () {
      expect(expression.type, double);
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expression.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test(
        'when equals compared to double value then output is equals expression.',
        () {
      var comparisonExpression = expression.equals(10.0);

      expect(comparisonExpression.toString(), '"$columnName" = 10.0');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
      var comparisonExpression = expression.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to double value then output is NOT equals expression.',
        () {
      var comparisonExpression = expression.notEquals(10.0);

      expect(comparisonExpression.toString(), '"$columnName" != 10.0');
    });

    test(
        'when checking if expression is between double values then output is between expression.',
        () {
      var comparisonExpression = expression.between(10.0, 20.0);

      expect(comparisonExpression.toString(),
          '"$columnName" BETWEEN 10.0 AND 20.0');
    });

    test(
        'when checking if expression is NOT between double value then output is NOT between expression.',
        () {
      var comparisonExpression = expression.notBetween(10.0, 20.0);

      expect(comparisonExpression.toString(),
          '"$columnName" NOT BETWEEN 10.0 AND 20.0');
    });

    test(
        'when checking if expression is in value set then output is IN expression.',
        () {
      var comparisonExpression = expression.inSet(<double>{10.0, 11.0, 12.0});

      expect(comparisonExpression.toString(),
          '"$columnName" IN (10.0, 11.0, 12.0)');
    });

    test(
        'when checking if expression is NOT in value set then output is NOT IN expression.',
        () {
      var comparisonExpression =
          expression.notInSet(<double>{10.0, 11.0, 12.0});

      expect(comparisonExpression.toString(),
          '"$columnName" NOT IN (10.0, 11.0, 12.0)');
    });
  });
}
