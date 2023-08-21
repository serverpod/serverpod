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
  });
}
