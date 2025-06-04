import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnSparseVector', () {
    var columnName = 'sparse_data';
    var dimension = 8;
    var column = ColumnSparseVector(
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

    test('when type is called then SparseVector is returned.', () {
      expect(column.type, SparseVector);
    });

    test('when dimension is accessed then correct dimension is returned.', () {
      expect(column.dimension, dimension);
    });

    group('with _ColumnDefaultOperations mixin', () {
      test(
          'when equals compared to SparseVector value then output is equals expression.',
          () {
        var testVector = SparseVector.fromMap({1: 1.0, 2: 3.0}, dimension);
        var comparisonExpression = column.equals(testVector);

        expect(
          comparisonExpression.toString(),
          "$column = '{1:1.0,2:3.0}/8'",
        );
      });

      test(
          'when NOT equals compared to SparseVector value then output is NOT equals expression.',
          () {
        var testVector = SparseVector.fromMap({1: 1.0, 2: 3.0}, dimension);
        var comparisonExpression = column.notEquals(testVector);

        expect(
          comparisonExpression.toString(),
          "$column != '{1:1.0,2:3.0}/8'",
        );
      });

      test(
          'when checking if expression is in value set then output is IN expression.',
          () {
        var comparisonExpression = column.inSet(<SparseVector>{
          SparseVector.fromMap({1: 1.0, 2: 3.0}, dimension),
          SparseVector.fromMap({2: 4.0, 3: 6.0}, dimension),
          SparseVector.fromMap({1: 7.0, 4: 9.0}, dimension),
        });

        expect(
          comparisonExpression.toString(),
          "$column IN ('{1:1.0,2:3.0}/8', '{2:4.0,3:6.0}/8', '{1:7.0,4:9.0}/8')",
        );
      });

      test(
          'when checking if expression is in empty value set then output is FALSE expression.',
          () {
        var comparisonExpression = column.inSet(<SparseVector>{});

        expect(comparisonExpression.toString(), 'FALSE');
      });

      test(
          'when checking if expression is NOT in value set then output is NOT IN expression.',
          () {
        var comparisonExpression = column.notInSet(<SparseVector>{
          SparseVector.fromMap({1: 1.0, 2: 3.0}, dimension),
          SparseVector.fromMap({2: 4.0, 3: 6.0}, dimension),
          SparseVector.fromMap({1: 7.0, 4: 9.0}, dimension),
        });

        expect(
          comparisonExpression.toString(),
          "$column NOT IN ('{1:1.0,2:3.0}/8', '{2:4.0,3:6.0}/8', '{1:7.0,4:9.0}/8')",
        );
      });

      test(
          'when checking if expression is NOT in empty value set then output is TRUE expression.',
          () {
        var comparisonExpression = column.notInSet(<SparseVector>{});

        expect(comparisonExpression.toString(), 'TRUE');
      });
    });

    group('with _VectorColumnDefaultOperations mixin', () {
      test(
          'when distanceL2 is called then output is correct operator expression.',
          () {
        var testVector = SparseVector.fromMap({1: 1.0, 2: 3.0}, dimension);
        var comparisonExpression = column.distanceL2(testVector);

        expect(
          comparisonExpression.toString(),
          "$column <-> '{1:1.0,2:3.0}/8'",
        );
      });

      test(
          'when distanceInnerProduct is called then output is correct operator expression.',
          () {
        var testVector = SparseVector.fromMap({1: 1.0, 2: 3.0}, dimension);
        var comparisonExpression = column.distanceInnerProduct(testVector);

        expect(
          comparisonExpression.toString(),
          "$column <#> '{1:1.0,2:3.0}/8'",
        );
      });

      test(
          'when distanceCosine is called then output is correct operator expression.',
          () {
        var testVector = SparseVector.fromMap({1: 1.0, 2: 3.0}, dimension);
        var comparisonExpression = column.distanceCosine(testVector);

        expect(
          comparisonExpression.toString(),
          "$column <=> '{1:1.0,2:3.0}/8'",
        );
      });

      test(
          'when distanceL1 is called then output is correct operator expression.',
          () {
        var testVector = SparseVector.fromMap({1: 1.0, 2: 3.0}, dimension);
        var comparisonExpression = column.distanceL1(testVector);

        expect(
          comparisonExpression.toString(),
          "$column <+> '{1:1.0,2:3.0}/8'",
        );
      });

      test(
          'when comparing a distance to a value then output is correct comparison expression.',
          () {
        var testVector = SparseVector.fromMap({1: 1.0, 2: 3.0}, dimension);
        var comparisonExpression = column.distanceL2(testVector) < 0.5;

        expect(
          comparisonExpression.toString(),
          "$column <-> '{1:1.0,2:3.0}/8' < 0.5",
        );
      });
    });
  });
}
