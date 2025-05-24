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
}
