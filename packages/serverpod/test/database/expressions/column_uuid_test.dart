import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnUuid expression', () {
    var columnName = 'id';
    var expression = ColumnUuid(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expression.toString(), '"$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(expression.columnName, columnName);
    });

    test('when type is called then UuidValue is returned.', () {
      expect(expression.type, UuidValue);
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expression.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test('when equals compared to uuid value then output is equals expression.',
        () {
      var comparisonExpression = expression.equals(
          UuidValue('testUuid', false /* Disable validation for test */));

      expect(comparisonExpression.toString(), '"$columnName" = \'testuuid\'');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression.',
        () {
      var comparisonExpression = expression.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to uuid value then output is NOT equals expression.',
        () {
      var comparisonExpression = expression.notEquals(
          UuidValue('testUuid', false /* Disable validation for test */));

      expect(comparisonExpression.toString(), '"$columnName" != \'testuuid\'');
    });

    test(
        'when checking if expression is in value set then output is IN expression.',
        () {
      var comparisonExpression = expression.inSet(<UuidValue>{
        UuidValue('testUuid1', false /* Disable validation for test */),
        UuidValue('testUuid2', false /* Disable validation for test */),
        UuidValue('testUuid3', false /* Disable validation for test */),
      });

      expect(comparisonExpression.toString(),
          '"$columnName" IN (\'testuuid1\', \'testuuid2\', \'testuuid3\')');
    });

    test(
        'when checking if expression is NOT in value set then output is NOT IN expression.',
        () {
      var comparisonExpression = expression.notInSet(<UuidValue>{
        UuidValue('testUuid1', false /* Disable validation for test */),
        UuidValue('testUuid2', false /* Disable validation for test */),
        UuidValue('testUuid3', false /* Disable validation for test */),
      });

      expect(comparisonExpression.toString(),
          '"$columnName" NOT IN (\'testuuid1\', \'testuuid2\', \'testuuid3\')');
    });
  });
}
