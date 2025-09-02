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

  group('Given declared ObjectWithObject class', () {
    test('then custom class fields are generated as ColumnSerializable.', () {
      expect(ObjectWithObject.t.data, isA<ColumnSerializable<SimpleData>>());
      expect(
        ObjectWithObject.t.nullableData,
        isA<ColumnSerializable<SimpleData>>(),
      );
    });

    test('then container fields are generated as ColumnSerializable.', () {
      expect(
        ObjectWithObject.t.dataList,
        isA<ColumnSerializable<List<SimpleData>>>(),
      );
      expect(
        ObjectWithObject.t.nullableDataList,
        isA<ColumnSerializable<List<SimpleData>>>(),
      );
      expect(
        ObjectWithObject.t.listWithNullableData,
        isA<ColumnSerializable<List<SimpleData?>>>(),
      );
      expect(
        ObjectWithObject.t.nullableListWithNullableData,
        isA<ColumnSerializable<List<SimpleData?>>>(),
      );
    });

    test('then nested container fields are generated as ColumnSerializable.',
        () {
      expect(
        ObjectWithObject.t.nestedDataList,
        isA<ColumnSerializable<List<List<SimpleData>>>>(),
      );
      expect(
        ObjectWithObject.t.nestedDataListInMap,
        isA<
            ColumnSerializable<
                Map<String, List<List<Map<int, SimpleData>>?>>>>(),
      );
      expect(
        ObjectWithObject.t.nestedDataMap,
        isA<ColumnSerializable<Map<String, Map<int, SimpleData>>>>(),
      );
    });
  });

  group('Given declared Types class', () {
    test('then record field is generated as ColumnSerializable.', () {
      expect(
        Types.t.aRecord,
        isA<ColumnSerializable<(String, {Uri? optionalUri})>>(),
      );
    });

    test('then container fields are generated as ColumnSerializable.', () {
      expect(Types.t.aList, isA<ColumnSerializable<List<int>>>());
      expect(Types.t.aMap, isA<ColumnSerializable<Map<int, int>>>());
      expect(Types.t.aSet, isA<ColumnSerializable<Set<int>>>());
    });

    test('then record field has encoder function for record serialization.',
        () {
      expect(Types.t.aRecord.encodeFn, isNotNull);
    });

    test(
        'then container fields do not have encoder function (use DatabasePoolManager.encoder.convert).',
        () {
      expect(Types.t.aList.encodeFn, isNull);
      expect(Types.t.aMap.encodeFn, isNull);
      expect(Types.t.aSet.encodeFn, isNull);
    });
  });

  group('Given ColumnSerializable encoder function behavior', () {
    test('then record field encoder function works correctly with all fields.',
        () {
      var optionalUri = Uri.parse('https://example.com');
      var record = ('test', optionalUri: optionalUri);
      var encoded = Types.t.aRecord.encodeFn!(record);
      expect(encoded, isA<Map<String, dynamic>>());

      expect(encoded['p'], isA<List>());
      expect(encoded['p'][0], 'test');

      expect(encoded['n'], isA<Map<String, dynamic>>());
      expect(encoded['n']['optionalUri'], optionalUri);
    });

    test(
        'then record field encoder function works correctly with null named field.',
        () {
      var record = ('test', optionalUri: null);
      var encoded = Types.t.aRecord.encodeFn!(record);
      expect(encoded, isA<Map<String, dynamic>>());

      expect(encoded['p'], isA<List>());
      expect(encoded['p'][0], 'test');

      expect(encoded['n'], isA<Map<String, dynamic>>());
      expect(encoded['n']['optionalUri'], isNull);
    });
  });
}
