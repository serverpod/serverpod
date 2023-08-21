import 'package:serverpod/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnBool expression', () {
    var columnName = 'production';
    var expression = ColumnBool(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expression.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(expression.columnName, columnName);
    });

    test('when type is called then bool is returned.', () {
      expect(expression.type, bool);
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expression.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test('when equals compared to bool value then output is equals expression.',
        () {
      var comparisonExpression = expression.equals(true);

      expect(comparisonExpression.toString(), '"$columnName" = true');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
      var comparisonExpression = expression.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to bool value then output is NOT equals expression.',
        () {
      var comparisonExpression = expression.notEquals(true);

      expect(comparisonExpression.toString(), '"$columnName" != true');
    });

    test(
        'when is distinct from compared to bool value then output is IS DISTINCT FROM expression.',
        () {
      var comparisonExpression = expression.isDistinctFrom(true);

      expect(comparisonExpression.toString(),
          '"$columnName" IS DISTINCT FROM true');
    });
  });
}
