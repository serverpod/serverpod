import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnBit', () {
    var columnName = 'signature';
    var dimension = 6;
    var column = ColumnBit(
      columnName,
      Table<int?>(tableName: 'test'),
      dimension: dimension,
    );

    test(
        'when toString is called then column name within double quotes is returned.',
        () {
      expect(column.toString(), '"test"."$columnName"');
    });

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then Bit is returned.', () {
      expect(column.type, Bit);
    });

    test('when dimension is accessed then correct dimension is returned.', () {
      expect(column.dimension, dimension);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to bit value then output is equals expression.',
          () {
        var testBit = Bit.fromString('101010');
        var comparisonExpression = column.equals(testBit);

        expect(
          comparisonExpression.toString(),
          "$column = '101010'",
        );
      });

      test(
          'when NOT equals compared to bit value then output is NOT equals expression.',
          () {
        var testBit = Bit.fromString('101010');
        var comparisonExpression = column.notEquals(testBit);

        expect(
          comparisonExpression.toString(),
          "$column != '101010'",
        );
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<Bit>{
          Bit.fromString('101010'),
          Bit.fromString('110011'),
          Bit.fromString('000111'),
        });

        expect(
          comparisonExpression.toString(),
          "$column IN ('101010', '110011', '000111')",
        );
      });

      test(
          'when checking if expression is in empty value set then output is FALSE expression.',
          () {
        var comparisonExpression = column.inSet(<Bit>{});

        expect(comparisonExpression.toString(), 'FALSE');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<Bit>{
          Bit.fromString('101010'),
          Bit.fromString('110011'),
          Bit.fromString('000111'),
        });

        expect(
          comparisonExpression.toString(),
          "$column NOT IN ('101010', '110011', '000111')",
        );
      });

      test(
          'when checking if expression is NOT in empty value set then output is TRUE expression.',
          () {
        var comparisonExpression = column.notInSet(<Bit>{});

        expect(comparisonExpression.toString(), 'TRUE');
      });
    });

    group('with bit-specific distance operations', () {
      test(
          'when distanceHamming is called then output is correct operator expression.',
          () {
        var testBit = Bit.fromString('101010');
        var comparisonExpression = column.distanceHamming(testBit);
        expect(
          comparisonExpression.toString(),
          "$column <~> '$testBit'",
        );
      });

      test(
          'when distanceJaccard is called then output is correct operator expression.',
          () {
        var testBit = Bit.fromString('101010');
        var comparisonExpression = column.distanceJaccard(testBit);
        expect(
          comparisonExpression.toString(),
          "$column <%> '$testBit'",
        );
      });
    });
  });
}
