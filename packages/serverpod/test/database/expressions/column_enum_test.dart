import 'package:serverpod/database.dart';
import 'package:test/test.dart';

enum TestEnum {
  red,
  blue,
  green,
}

void main() {
  group('Given a ColumnEnum expression', () {
    var columnName = 'color';
    var expression = ColumnEnum<TestEnum>(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expression.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(expression.columnName, columnName);
    });

    test('when type is called then TestEnum is returned.', () {
      expect(expression.type, TestEnum);
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expression.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test('when equals compared to enum value then output is equals expression.',
        () {
      var comparisonExpression = expression.equals(TestEnum.blue);

      expect(comparisonExpression.toString(), '"$columnName" = 1');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
      var comparisonExpression = expression.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to enum value then output is NOT equals expression.',
        () {
      var comparisonExpression = expression.notEquals(TestEnum.blue);

      expect(comparisonExpression.toString(), '"$columnName" != 1');
    });
  });
}
