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
    var expressionSerializedAsInteger =
        ColumnEnumSerializedAsInteger<TestEnum>(columnName);
    var expressionSerializedAsString =
        ColumnEnumSerializedAsString<TestEnum>(columnName);

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(expressionSerializedAsInteger.toString(), '"$columnName"');
    });

    test(
        'when columnName getter is called then column name is returned '
        '(serializing as integer).', () {
      expect(expressionSerializedAsInteger.columnName, columnName);
    });

    test(
        'when type is called then TestEnum is returned '
        '(serializing as string).', () {
      expect(expressionSerializedAsString.type, TestEnum);
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expressionSerializedAsInteger.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test(
        'when equals compared to NULL value then output is IS NULL expression.',
        () {
      var comparisonExpression = expressionSerializedAsInteger.equals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NULL');
    });

    test(
        'when equals compared to enum value then output is equals expression '
        '(serializing as integer).', () {
      var comparisonExpression =
          expressionSerializedAsInteger.equals(TestEnum.blue);

      expect(comparisonExpression.toString(), '"$columnName" = 1');
    });

    test(
        'when equals compared to enum value then output is equals expression '
        '(serializing as string).', () {
      var comparisonExpression =
          expressionSerializedAsString.equals(TestEnum.blue);

      expect(comparisonExpression.toString(), '"$columnName" = \'blue\'');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression '
        '(serializing as integer).', () {
      var comparisonExpression = expressionSerializedAsInteger.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to NULL value then output is IS NOT NULL expression '
        '(serializing as string).', () {
      var comparisonExpression = expressionSerializedAsString.notEquals(null);

      expect(comparisonExpression.toString(), '"$columnName" IS NOT NULL');
    });

    test(
        'when NOT equals compared to enum value then output is NOT equals expression '
        '(serializing as integer).', () {
      var comparisonExpression =
          expressionSerializedAsInteger.notEquals(TestEnum.blue);

      expect(comparisonExpression.toString(), '"$columnName" != 1');
    });

    test(
        'when NOT equals compared to enum value then output is NOT equals expression '
        '(serializing as string).', () {
      var comparisonExpression =
          expressionSerializedAsString.notEquals(TestEnum.blue);

      expect(comparisonExpression.toString(), '"$columnName" != \'blue\'');
    });

    test(
        'when checking if expression is in value set then output is IN expression '
        '(serializing as integer).', () {
      var comparisonExpression = expressionSerializedAsInteger.inSet(<TestEnum>{
        TestEnum.red,
        TestEnum.blue,
        TestEnum.green,
      });

      expect(comparisonExpression.toString(), '"$columnName" IN (0, 1, 2)');
    });

    test(
        'when checking if expression is in value set then output is IN expression '
        '(serializing as string).', () {
      var comparisonExpression = expressionSerializedAsString.inSet(<TestEnum>{
        TestEnum.red,
        TestEnum.blue,
        TestEnum.green,
      });

      expect(comparisonExpression.toString(),
          '"$columnName" IN (\'red\', \'blue\', \'green\')');
    });

    test(
        'when checking if expression is NOT in value set then output is NOT IN expression '
        '(serializing as integer).', () {
      var comparisonExpression =
          expressionSerializedAsInteger.notInSet(<TestEnum>{
        TestEnum.red,
        TestEnum.blue,
        TestEnum.green,
      });

      expect(comparisonExpression.toString(), '"$columnName" NOT IN (0, 1, 2)');
    });

    test(
        'when checking if expression is NOT in value set then output is NOT IN expression '
        '(serializing as string).', () {
      var comparisonExpression =
          expressionSerializedAsString.notInSet(<TestEnum>{
        TestEnum.red,
        TestEnum.blue,
        TestEnum.green,
      });

      expect(comparisonExpression.toString(),
          '"$columnName" NOT IN (\'red\', \'blue\', \'green\')');
    });
  });
}
