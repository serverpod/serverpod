import 'package:serverpod_cli/src/database/extensions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given int and big int column definition', () {
    ColumnDefinition intColumn = ColumnDefinition(
      name: 'id',
      columnType: ColumnType.integer,
      isNullable: false,
      dartType: 'int',
    );

    ColumnDefinition bigIntColumn = ColumnDefinition(
      name: 'id',
      columnType: ColumnType.bigint,
      isNullable: false,
      dartType: 'int',
    );
    test(
      'when like checking int column to big int column then check returns true.',
      () {
        expect(intColumn.like(bigIntColumn), isTrue);
      },
    );

    test(
      'when like checking big int column to int column then check returns true.',
      () {
        expect(bigIntColumn.like(intColumn), isTrue);
      },
    );
  });

  group('Given vector column definition', () {
    ColumnDefinition vectorColumn = ColumnDefinition(
      name: 'vector_field',
      columnType: ColumnType.vector,
      isNullable: false,
      dartType: 'Vector(3)',
      vectorDimension: 3,
    );

    test(
      'when like checking vector column with same properties then check returns true.',
      () {
        ColumnDefinition sameVectorColumn = ColumnDefinition(
          name: 'vector_field',
          columnType: ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(3)',
          vectorDimension: 3,
        );

        expect(vectorColumn.like(sameVectorColumn), isTrue);
      },
    );

    test(
      'when like checking vector column with different dimension then check returns false.',
      () {
        ColumnDefinition differentDimensionColumn = ColumnDefinition(
          name: 'vector_field',
          columnType: ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(4)',
          vectorDimension: 4,
        );

        expect(vectorColumn.like(differentDimensionColumn), isFalse);
      },
    );
  });

  group('Given half vector column definition', () {
    ColumnDefinition halfVectorColumn = ColumnDefinition(
      name: 'half_vector_field',
      columnType: ColumnType.halfvec,
      isNullable: false,
      dartType: 'HalfVector(3)',
      vectorDimension: 3,
    );

    test(
      'when like checking half vector column with same properties then check returns true.',
      () {
        ColumnDefinition sameHalfVectorColumn = ColumnDefinition(
          name: 'half_vector_field',
          columnType: ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(3)',
          vectorDimension: 3,
        );

        expect(halfVectorColumn.like(sameHalfVectorColumn), isTrue);
      },
    );

    test(
      'when like checking half vector column with different dimension then check returns false.',
      () {
        ColumnDefinition differentDimensionColumn = ColumnDefinition(
          name: 'half_vector_field',
          columnType: ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(4)',
          vectorDimension: 4,
        );

        expect(halfVectorColumn.like(differentDimensionColumn), isFalse);
      },
    );
  });

  group('Given sparse vector column definition', () {
    ColumnDefinition sparseVectorColumn = ColumnDefinition(
      name: 'sparse_vector_field',
      columnType: ColumnType.sparsevec,
      isNullable: false,
      dartType: 'SparseVector(100)',
      vectorDimension: 100,
    );

    test(
      'when like checking sparse vector column with same properties then check returns true.',
      () {
        ColumnDefinition sameSparseVectorColumn = ColumnDefinition(
          name: 'sparse_vector_field',
          columnType: ColumnType.sparsevec,
          isNullable: false,
          dartType: 'SparseVector(100)',
          vectorDimension: 100,
        );

        expect(sparseVectorColumn.like(sameSparseVectorColumn), isTrue);
      },
    );

    test(
      'when like checking sparse vector column with different dimension then check returns false.',
      () {
        ColumnDefinition differentDimensionColumn = ColumnDefinition(
          name: 'sparse_vector_field',
          columnType: ColumnType.sparsevec,
          isNullable: false,
          dartType: 'SparseVector(200)',
          vectorDimension: 200,
        );

        expect(sparseVectorColumn.like(differentDimensionColumn), isFalse);
      },
    );
  });

  group('Given bit vector column definition', () {
    ColumnDefinition bitColumn = ColumnDefinition(
      name: 'bit_field',
      columnType: ColumnType.bit,
      isNullable: false,
      dartType: 'Bit(8)',
      vectorDimension: 8,
    );

    test(
      'when like checking bit vector column with same properties then check returns true.',
      () {
        ColumnDefinition sameBitColumn = ColumnDefinition(
          name: 'bit_field',
          columnType: ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(8)',
          vectorDimension: 8,
        );

        expect(bitColumn.like(sameBitColumn), isTrue);
      },
    );

    test(
      'when like checking bit vector column with different dimension then check returns false.',
      () {
        ColumnDefinition differentDimensionColumn = ColumnDefinition(
          name: 'bit_field',
          columnType: ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(16)',
          vectorDimension: 16,
        );

        expect(bitColumn.like(differentDimensionColumn), isFalse);
      },
    );
  });

  group('Given Decimal column definition with precision and scale', () {
    ColumnDefinition decimalColumn = ColumnDefinition(
      name: 'price',
      columnType: ColumnType.decimal,
      isNullable: false,
      dartType: 'Decimal(10,2)',
      decimalPrecision: 10,
      decimalScale: 2,
    );

    test(
      'when like checking Decimal column with same precision and scale then check returns true.',
      () {
        ColumnDefinition sameDecimalColumn = ColumnDefinition(
          name: 'price',
          columnType: ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal(10,2)',
          decimalPrecision: 10,
          decimalScale: 2,
        );

        expect(decimalColumn.like(sameDecimalColumn), isTrue);
      },
    );

    test(
      'when like checking Decimal column with different precision then check returns false.',
      () {
        ColumnDefinition differentPrecisionColumn = ColumnDefinition(
          name: 'price',
          columnType: ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal(19,2)',
          decimalPrecision: 19,
          decimalScale: 2,
        );

        expect(decimalColumn.like(differentPrecisionColumn), isFalse);
      },
    );

    test(
      'when like checking Decimal column with different scale then check returns false.',
      () {
        ColumnDefinition differentScaleColumn = ColumnDefinition(
          name: 'price',
          columnType: ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal(10,4)',
          decimalPrecision: 10,
          decimalScale: 4,
        );

        expect(decimalColumn.like(differentScaleColumn), isFalse);
      },
    );
  });

  group('Given unbounded Decimal column definition', () {
    ColumnDefinition unboundedDecimalColumn = ColumnDefinition(
      name: 'amount',
      columnType: ColumnType.decimal,
      isNullable: false,
      dartType: 'Decimal',
    );

    test(
      'when like checking with another unbounded Decimal column then check returns true.',
      () {
        ColumnDefinition sameUnboundedColumn = ColumnDefinition(
          name: 'amount',
          columnType: ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal',
        );

        expect(unboundedDecimalColumn.like(sameUnboundedColumn), isTrue);
      },
    );

    test(
      'when like checking unbounded Decimal with bounded Decimal then check returns false.',
      () {
        ColumnDefinition boundedColumn = ColumnDefinition(
          name: 'amount',
          columnType: ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal(10,2)',
          decimalPrecision: 10,
          decimalScale: 2,
        );

        expect(unboundedDecimalColumn.like(boundedColumn), isFalse);
      },
    );
  });
}
