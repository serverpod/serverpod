import 'dart:typed_data';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  group('Copy behavior', () {
    group('Given an object with an int when copying with a new value', () {
      var types = Types(anInt: 1);
      var typesCopy = types.copyWith(anInt: 2);

      test('then the original object is unmodified.', () {
        expect(types.anInt, 1);
      });

      test('then the copy has the new value.', () {
        expect(typesCopy.anInt, 2);
      });

      test('then the copy is not the same object as the original.', () {
        expect(identical(types, typesCopy), false);
      });
    });

    test(
        'Given an object with an int when copying the object without giving a new value then the copy has the same value.',
        () {
      var types = Types(anInt: 1);
      var typesCopy = types.copyWith();

      expect(typesCopy.anInt, 1);
    });

    test(
        'Given an object with a nullable int when copying the object setting it to null then the copy is null but not the original.',
        () {
      var types = Types(anInt: 1);
      var typesCopy = types.copyWith(anInt: null);

      expect(typesCopy.anInt, isNull);
      expect(types.anInt, 1);
    });
  });

  group('mutability', () {
    test(
        'Given an object with an int and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(anInt: 1);
      var typesCopy = types.copyWith();
      types.anInt = 3;

      expect(typesCopy.anInt, 1);
    });

    test(
        'Given an object with an double and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(aDouble: 1);
      var typesCopy = types.copyWith();
      types.aDouble = 3;

      expect(typesCopy.aDouble, 1.0);
    });

    test(
        'Given an object with an bool and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(aBool: false);
      var typesCopy = types.copyWith();
      types.aBool = true;

      expect(typesCopy.aBool, false);
    });

    test(
        'Given an object with an String and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(aString: 'hello');
      var typesCopy = types.copyWith();
      types.aString = 'world';

      expect(typesCopy.aString, 'hello');
    });

    test(
        'Given an object with an Duration and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var types = Types(aDuration: Duration(seconds: 1));
      var typesCopy = types.copyWith();
      types.aDuration = Duration(seconds: 3);

      expect(
        typesCopy.aDuration?.inMilliseconds,
        Duration(seconds: 1).inMilliseconds,
      );
    });

    test(
        'Given an object with an BigInt and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var bigInt = BigInt.one;

      var types = Types(aBigInt: bigInt);
      var typesCopy = types.copyWith();
      types.aBigInt = BigInt.two;

      expect(
        typesCopy.aBigInt,
        BigInt.one,
      );
    });

    test(
        'Given an object with an Uuid and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      // ignore: deprecated_member_use
      var uuid = UuidValue.fromString(Uuid.NAMESPACE_NIL);

      var types = Types(aUuid: uuid);
      var typesCopy = types.copyWith();
      types.aUuid = UuidValue.fromString(Uuid().v4());

      expect(
        typesCopy.aUuid?.uuid,
        // ignore: deprecated_member_use
        UuidValue.fromString(Uuid.NAMESPACE_NIL).uuid,
      );
    });

    test(
        'Given an object with an DateTime and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(1000);

      var types = Types(aDateTime: dateTime);
      var typesCopy = types.copyWith();
      types.aDateTime = DateTime.fromMillisecondsSinceEpoch(3000);

      expect(
        typesCopy.aDateTime?.millisecondsSinceEpoch,
        DateTime.fromMillisecondsSinceEpoch(1000).millisecondsSinceEpoch,
      );
    });

    test(
        'Given an object with an ByteData and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var byteData = Uint8List.fromList([0, 1, 2, 3, 4]).buffer.asByteData();

      var types = Types(aByteData: byteData);
      var typesCopy = types.copyWith();
      types.aByteData?.setInt8(0, 9);

      expect(
        typesCopy.aByteData?.buffer.asUint8List(),
        Uint8List.fromList([0, 1, 2, 3, 4]),
      );
    });

    test(
        'Given an object with an ByteData and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var byteData = Uint64List.fromList([0, 1, 2, 3, 4]).buffer.asByteData();

      var types = Types(aByteData: byteData);
      var typesCopy = types.copyWith();
      types.aByteData?.setInt64(0, 9);

      expect(
        typesCopy.aByteData?.buffer.asUint64List(),
        Uint64List.fromList([0, 1, 2, 3, 4]),
      );
    });

    test(
        'Given an object with an ByteData and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var byteData = Float32List.fromList([0, 1, 2, 3, 4]).buffer.asByteData();

      var types = Types(aByteData: byteData);
      var typesCopy = types.copyWith();
      types.aByteData?.setInt64(0, 9);

      expect(
        typesCopy.aByteData?.buffer.asFloat32List(),
        Float32List.fromList([0, 1, 2, 3, 4]),
      );
    });

    test(
        'Given an object with a List and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var list = [SimpleData(num: 1), SimpleData(num: 2)];

      var listData = SimpleDataList(rows: list);
      var listDataCopy = listData.copyWith();
      listData.rows.add(SimpleData(num: 3));

      // Inspecting each value as the expect compares the references otherwise.
      expect(listDataCopy.rows, hasLength(2));
      expect(listDataCopy.rows[0].num, 1);
      expect(listDataCopy.rows[0].id, null);
      expect(listDataCopy.rows[1].num, 2);
      expect(listDataCopy.rows[1].id, null);
    });

    test(
        'Given an object with a List and a copy of that object when mutating an object in the list then the copy is unmodified.',
        () {
      var list = [SimpleData(num: 1), SimpleData(num: 2)];

      var listData = SimpleDataList(rows: list);
      var listDataCopy = listData.copyWith();
      listData.rows[0].num = 3;

      // Inspecting each value as the expect compares the references otherwise.
      expect(listDataCopy.rows, hasLength(2));
      expect(listDataCopy.rows[0].num, 1);
      expect(listDataCopy.rows[0].id, null);
      expect(listDataCopy.rows[1].num, 2);
      expect(listDataCopy.rows[1].id, null);
    });

    test(
        'Given an object with a Map and a copy of that object when mutating the original then the copy is unmodified.',
        () {
      var map = {'a': SimpleData(num: 1), 'b': SimpleData(num: 2)};

      var mapData = SimpleDataMap(data: map);
      var mapDataCopy = mapData.copyWith();
      mapData.data['c'] = SimpleData(num: 3);

      expect(mapDataCopy.data, hasLength(2));
      expect(mapDataCopy.data['a']?.num, 1);
      expect(mapDataCopy.data['a']?.id, null);
      expect(mapDataCopy.data['b']?.num, 2);
      expect(mapDataCopy.data['b']?.id, null);
    });

    test(
        'Given an object with a Map and a copy of that object when mutating an object in the map then the copy is unmodified.',
        () {
      var map = {'a': SimpleData(num: 1), 'b': SimpleData(num: 2)};

      var mapData = SimpleDataMap(data: map);
      var mapDataCopy = mapData.copyWith();
      mapData.data['a']?.num = 3;

      expect(mapDataCopy.data, hasLength(2));
      expect(mapDataCopy.data['a']?.num, 1);
      expect(mapDataCopy.data['a']?.id, null);
      expect(mapDataCopy.data['b']?.num, 2);
      expect(mapDataCopy.data['b']?.id, null);
    });

    group('Given an object with nested Lists and Maps when calling copyWith',
        () {
      var objectWithNestedObjects = ObjectWithObject(
        data: SimpleData(num: 1),
        dataList: [SimpleData(num: 2)],
        listWithNullableData: [],
        nestedDataListInMap: {
          'firstKey': [
            [
              {111: SimpleData(num: 111)}
            ],
            [
              {222: SimpleData(num: 222)}
            ],
          ],
        },
        nestedDataList: [
          [SimpleData(num: 88), SimpleData(num: 99)],
        ],
        nestedDataMap: {
          'firstKey': {
            333: SimpleData(num: 333),
          },
        },
      );

      test('then a nested map is deeply cloned', () {
        var copy = objectWithNestedObjects.copyWith();
        copy.nestedDataMap?['firstKey']?[333]?.num = 12345;

        expect(objectWithNestedObjects.nestedDataMap?['firstKey']?[333]?.num,
            equals(333));
        expect(copy.nestedDataMap?['firstKey']?[333]?.num, equals(12345));
      });

      test('then a nested list is deeply cloned', () {
        var copy = objectWithNestedObjects.copyWith();
        copy.nestedDataList?.first[1].num = 12345;

        expect(copy.nestedDataList, hasLength(1));
        expect(copy.nestedDataList?.first, hasLength(2));
        expect(copy.nestedDataList?.first.first.num, equals(88));

        expect(
            objectWithNestedObjects.nestedDataList?.first[1].num, equals(99));
        expect(copy.nestedDataList?.first[1].num, equals(12345));
      });

      test('then a nested list in a map is deeply cloned', () {
        var copy = objectWithNestedObjects.copyWith();
        copy.nestedDataListInMap?['firstKey']?[1]?.first[222]?.num = 12345;

        expect(copy.nestedDataListInMap?['firstKey'], hasLength(2));
        expect(copy.nestedDataListInMap?['firstKey']?.first, hasLength(1));
        expect(copy.nestedDataListInMap?['firstKey']?.first?.first[111]?.num,
            equals(111));

        expect(
            objectWithNestedObjects
                .nestedDataListInMap?['firstKey']?[1]?.first[222]?.num,
            equals(222));
        expect(copy.nestedDataListInMap?['firstKey']?[1]?.first[222]?.num,
            equals(12345));
      });
    });

    test(
        'Given an object with an Enum in a nested List when calling copyWith then the Enum is copied',
        () {
      var objectWithEnum =
          ObjectWithEnum(testEnum: TestEnum.two, nullableEnum: null, enumList: [
        TestEnum.one,
      ], nullableEnumList: [
        TestEnum.one,
        null,
        TestEnum.three
      ], enumListList: [
        [TestEnum.one, TestEnum.two],
        [TestEnum.two, TestEnum.one]
      ]);

      var copy = objectWithEnum.copyWith();
      copy.enumListList[1] = [TestEnum.three];

      expect(copy.enumListList, hasLength(2));
      expect(copy.enumListList.first, equals([TestEnum.one, TestEnum.two]));

      expect(
          objectWithEnum.enumListList[1], equals([TestEnum.two, TestEnum.one]));
      expect(copy.enumListList[1], equals([TestEnum.three]));
    });
  });
}
