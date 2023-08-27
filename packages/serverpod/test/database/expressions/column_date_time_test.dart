import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnDateTime expression', () {
    var columnName = 'age';
    var expression = ColumnDateTime(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expression.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(expression.columnName, columnName);
    });

    test('when type is called then DateTime is returned.', () {
      expect(expression.type, DateTime);
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expression.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test(
        'when equals compared to date time value then output is equals expression.',
        () {
      var comparisonExpression = expression.equals(DateTime.utc(1991, 5, 28));

      expect(comparisonExpression.toString(),
          '"$columnName" = \'"1991-05-28T00:00:00.000Z"\'');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
      var comparisonExpression = expression.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to date time value then output is NOT equals expression.',
        () {
      var comparisonExpression =
          expression.notEquals(DateTime.utc(1991, 5, 28));

      expect(comparisonExpression.toString(),
          '"$columnName" != \'"1991-05-28T00:00:00.000Z"\'');
    });

    test(
        'when checking if expression is between date time values then output is between expression.',
        () {
      var comparisonExpression = expression.between(
          DateTime.utc(1991, 5, 28), DateTime.utc(1991, 5, 29));

      expect(comparisonExpression.toString(),
          '"$columnName" BETWEEN \'"1991-05-28T00:00:00.000Z"\' AND \'"1991-05-29T00:00:00.000Z"\'');
    });

    test(
        'when checking if expression is NOT between date time values then output is NOT between expression.',
        () {
      var comparisonExpression = expression.notBetween(
          DateTime.utc(1991, 5, 28), DateTime.utc(1991, 5, 29));

      expect(comparisonExpression.toString(),
          '"$columnName" NOT BETWEEN \'"1991-05-28T00:00:00.000Z"\' AND \'"1991-05-29T00:00:00.000Z"\'');
    });

    test(
        'when checking if expression is in value set then output is IN expression.',
        () {
      var comparisonExpression = expression.inSet(<DateTime>{
        DateTime.utc(1991, 5, 28),
        DateTime.utc(1991, 5, 29),
        DateTime.utc(1991, 5, 30),
      });

      expect(comparisonExpression.toString(),
          '"$columnName" IN (\'"1991-05-28T00:00:00.000Z"\', \'"1991-05-29T00:00:00.000Z"\', \'"1991-05-30T00:00:00.000Z"\')');
    });

    test(
        'when checking if expression is NOT in value set then output is NOT IN expression.',
        () {
      var comparisonExpression = expression.notInSet(<DateTime>{
        DateTime.utc(1991, 5, 28),
        DateTime.utc(1991, 5, 29),
        DateTime.utc(1991, 5, 30),
      });

      expect(comparisonExpression.toString(),
          '"$columnName" NOT IN (\'"1991-05-28T00:00:00.000Z"\', \'"1991-05-29T00:00:00.000Z"\', \'"1991-05-30T00:00:00.000Z"\')');
    });
  });
}
