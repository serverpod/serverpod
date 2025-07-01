import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Test UUID', () {
    test('Ensure ObjectWithUuid is generated correctly.', () {
      expect(ObjectWithUuid.t.uuid, isA<ColumnUuid>());
      expect(ObjectWithUuid.t.uuidNullable, isA<ColumnUuid>());
    });
  });

  group('Given declared ObjectWithVector class', () {
    test('then vector fields are generated correctly.', () {
      expect(ObjectWithVector.t.vector, isA<ColumnVector>());
      expect(ObjectWithVector.t.vectorNullable, isA<ColumnVector>());
    });

    test('then vector fields have correct dimension.', () {
      expect(ObjectWithVector.t.vector.dimension, 512);
      expect(ObjectWithVector.t.vectorNullable.dimension, 512);
    });
  });

  group('Given declared ObjectWithHalfVector class', () {
    test('then half vector fields are generated correctly.', () {
      expect(ObjectWithHalfVector.t.halfVector, isA<ColumnHalfVector>());
      expect(
          ObjectWithHalfVector.t.halfVectorNullable, isA<ColumnHalfVector>());
    });

    test('then half vector fields have correct dimension.', () {
      expect(ObjectWithHalfVector.t.halfVector.dimension, 512);
      expect(ObjectWithHalfVector.t.halfVectorNullable.dimension, 512);
    });
  });

  group('Given declared ObjectWithSparseVector class', () {
    test('then sparse vector fields are generated correctly.', () {
      expect(ObjectWithSparseVector.t.sparseVector, isA<ColumnSparseVector>());
      expect(ObjectWithSparseVector.t.sparseVectorNullable,
          isA<ColumnSparseVector>());
    });

    test('then sparse vector fields have correct dimension.', () {
      expect(ObjectWithSparseVector.t.sparseVector.dimension, 512);
      expect(ObjectWithSparseVector.t.sparseVectorNullable.dimension, 512);
    });
  });

  group('Given declared ObjectWithBit class', () {
    test('then bit fields are generated correctly.', () {
      expect(ObjectWithBit.t.bit, isA<ColumnBit>());
      expect(ObjectWithBit.t.bitNullable, isA<ColumnBit>());
    });

    test('then bit fields have correct dimension.', () {
      expect(ObjectWithBit.t.bit.dimension, 512);
      expect(ObjectWithBit.t.bitNullable.dimension, 512);
    });
  });
}
