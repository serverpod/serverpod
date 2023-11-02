import 'package:serverpod/database.dart';
import 'package:test/test.dart';

enum TestEnum {
  red,
  blue,
  green,
}

void main() {
  group('Given a ColumnEnumSerializedAsString', () {
    var columnName = 'color';
    var columnSerializedAsString = ColumnEnumSerializedAsString<TestEnum>(
        columnName, Table(tableName: 'test'));
    var columnSerializedAsInteger = ColumnEnumSerializedAsInteger<TestEnum>(
        columnName, Table(tableName: 'test'));

    test(
        'when toString is called then column name withing double quotes is returned.',
        () {
      expect(columnSerializedAsString.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(columnSerializedAsString.columnName, columnName);
    });

    test('when type is called then TestEnum is returned.', () {
      expect(columnSerializedAsString.type, TestEnum);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to NULL value then output is IS NULL expression.'
          ' (serializeEnumValuesAsStrings == true)', () {
        var comparisonExpression = columnSerializedAsString.equals(null);

        expect(comparisonExpression.toString(),
            '$columnSerializedAsString IS NULL');
      });

      test(
          'when equals compared to NULL value then output is IS NULL expression.'
          ' (serializeEnumValuesAsStrings == false)', () {
        var comparisonExpression = columnSerializedAsInteger.equals(null);

        expect(comparisonExpression.toString(),
            '$columnSerializedAsInteger IS NULL');
      });

      test(
          'when equals compared to enum value then output is equals expression.'
          ' (serializeEnumValuesAsStrings == true)', () {
        var comparisonExpression =
            columnSerializedAsString.equals(TestEnum.blue);

        expect(comparisonExpression.toString(),
            '$columnSerializedAsString = \'blue\'');
      });

      test(
          'when equals compared to enum value then output is equals expression.'
          ' (serializeEnumValuesAsStrings == false)', () {
        var comparisonExpression =
            columnSerializedAsInteger.equals(TestEnum.blue);

        expect(
            comparisonExpression.toString(), '$columnSerializedAsInteger = 1');
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.'
          ' (serializeEnumValuesAsStrings == true)', () {
        var comparisonExpression = columnSerializedAsString.notEquals(null);

        expect(comparisonExpression.toString(),
            '$columnSerializedAsString IS NOT NULL');
      });

      test(
          'when NOT equals compared to NULL value then output is IS NOT NULL expression.'
          ' (serializeEnumValuesAsStrings == false)', () {
        var comparisonExpression = columnSerializedAsInteger.notEquals(null);

        expect(comparisonExpression.toString(),
            '$columnSerializedAsInteger IS NOT NULL');
      });

      test(
          'when NOT equals compared to enum value then output is NOT equals expression.'
          ' (serializeEnumValuesAsStrings == true)', () {
        var comparisonExpression =
            columnSerializedAsString.notEquals(TestEnum.blue);

        expect(comparisonExpression.toString(),
            '$columnSerializedAsString IS DISTINCT FROM \'blue\'');
      });

      test(
          'when NOT equals compared to enum value then output is NOT equals expression.'
          ' (serializeEnumValuesAsStrings == false)', () {
        var comparisonExpression =
            columnSerializedAsInteger.notEquals(TestEnum.blue);

        expect(comparisonExpression.toString(),
            '$columnSerializedAsInteger IS DISTINCT FROM 1');
      });

      test(
          'when checking if expression is in value set then output is IN expression.'
          ' (serializeEnumValuesAsStrings == true)', () {
        var comparisonExpression = columnSerializedAsString.inSet(<TestEnum>{
          TestEnum.red,
          TestEnum.blue,
          TestEnum.green,
        });

        expect(comparisonExpression.toString(),
            '$columnSerializedAsString IN (\'red\', \'blue\', \'green\')');
      });

      test(
          'when checking if expression is in value set then output is IN expression.'
          ' (serializeEnumValuesAsStrings == false)', () {
        var comparisonExpression = columnSerializedAsInteger.inSet(<TestEnum>{
          TestEnum.red,
          TestEnum.blue,
          TestEnum.green,
        });

        expect(comparisonExpression.toString(),
            '$columnSerializedAsString IN (0, 1, 2)');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.'
          ' (serializeEnumValuesAsStrings == true)', () {
        var comparisonExpression = columnSerializedAsString.notInSet(<TestEnum>{
          TestEnum.red,
          TestEnum.blue,
          TestEnum.green,
        });

        expect(
            comparisonExpression.toString(),
            '($columnSerializedAsString NOT IN (\'red\', \'blue\', \'green\') '
            'OR $columnSerializedAsString IS NULL)');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.'
          ' (serializeEnumValuesAsStrings == false)', () {
        var comparisonExpression =
            columnSerializedAsInteger.notInSet(<TestEnum>{
          TestEnum.red,
          TestEnum.blue,
          TestEnum.green,
        });

        expect(
            comparisonExpression.toString(),
            '($columnSerializedAsInteger NOT IN (0, 1, 2) '
            'OR $columnSerializedAsInteger IS NULL)');
      });
    });
  });
}
