import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

ByteData createByteData() {
  var ints = Uint8List(256);
  for (var i = 0; i < 256; i++) {
    ints[i] = i;
  }
  return ByteData.view(ints.buffer);
}

void main() {
  var protocol = Protocol();

  group('Serializations', () {
    test('Simple data', () {
      var data = SimpleData(num: 42);
      var s = SerializationManager.encode(data);
      var unpacked = SimpleData.fromJson(jsonDecode(s));
      expect(unpacked.num, equals(42));
    });

    test('Basic types with null values', () {
      var types = Types();
      var s = SerializationManager.encode(types);
      var unpacked = protocol.deserialize<Types>(jsonDecode(s));
      expect(unpacked.aBool, isNull);
      expect(unpacked.anInt, isNull);
      expect(unpacked.aString, isNull);
      expect(unpacked.aDouble, isNull);
      expect(unpacked.aDateTime, isNull);
      expect(unpacked.aByteData, isNull);
      expect(unpacked.aDuration, isNull);
      expect(unpacked.aUuid, isNull);
    });

    test('Basic types with values', () {
      var types = Types(
        aBool: true,
        anInt: 42,
        aString: '42',
        aDouble: 42.42,
        aDateTime: DateTime.utc(1976),
        aByteData: createByteData(),
        aDuration: const Duration(seconds: 1),
        aUuid: UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
      );
      var s = SerializationManager.encode(types);
      var unpacked = protocol.deserialize<Types>(jsonDecode(s));
      expect(unpacked.aBool, equals(true));
      expect(unpacked.anInt, equals(42));
      expect(unpacked.aString, equals('42'));
      expect(unpacked.aDouble, equals(42.42));
      expect(unpacked.aDateTime, equals(DateTime.utc(1976)));
      expect(unpacked.aDuration, equals(const Duration(seconds: 1)));
      expect(unpacked.aByteData!.lengthInBytes, equals(256));
      for (var i = 0; i < 256; i++) {
        expect(unpacked.aByteData!.buffer.asUint8List()[i], equals(i));
      }
      expect(unpacked.aUuid,
          equals(UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11')));
    });

    test('Object with enum', () {
      var object = ObjectWithEnum(
          testEnum: TestEnum.one,
          nullableEnum: null,
          nullableEnumList: [
            TestEnum.one,
            null,
            TestEnum.three
          ],
          enumList: [
            TestEnum.one,
            TestEnum.two,
            TestEnum.three
          ],
          enumListList: [
            [TestEnum.one, TestEnum.two],
            [TestEnum.two, TestEnum.one]
          ]);

      var s = SerializationManager.encode(object);
      var unpacked = protocol.deserialize<ObjectWithEnum>(jsonDecode(s));
      expect(unpacked.testEnum, equals(TestEnum.one));
      expect(unpacked.nullableEnum, isNull);
      expect(unpacked.nullableEnumList.length, equals(3));
      expect(unpacked.nullableEnumList[0], equals(TestEnum.one));
      expect(unpacked.nullableEnumList[1], isNull);
      expect(unpacked.nullableEnumList[2], equals(TestEnum.three));
      expect(unpacked.enumList.length, equals(3));
      expect(unpacked.enumList[0], equals(TestEnum.one));
      expect(unpacked.enumList[1], equals(TestEnum.two));
      expect(unpacked.enumList[2], equals(TestEnum.three));
      expect(unpacked.enumListList.length, equals(2));
      expect(unpacked.enumListList[0].length, equals(2));
      expect(unpacked.enumListList[0][0], equals(TestEnum.one));
      expect(unpacked.enumListList[0][1], equals(TestEnum.two));
      expect(unpacked.enumListList[1].length, equals(2));
      expect(unpacked.enumListList[1][0], equals(TestEnum.two));
      expect(unpacked.enumListList[1][1], equals(TestEnum.one));
    });

    test('Nullability with null types', () {
      var nullability = Nullability(
        anInt: 42,
        aDouble: 42.42,
        aBool: true,
        aString: 'foo',
        aDateTime: DateTime.utc(1976),
        anObject: SimpleData(num: 42),
        anIntList: [10, 20],
        aListWithNullableInts: [10, null],
        anObjectList: [SimpleData(num: 10), SimpleData(num: 20)],
        aListWithNullableObjects: [SimpleData(num: 10), null],
        aDateTimeList: [DateTime.utc(1976), DateTime.utc(1977)],
        aListWithNullableDateTimes: [DateTime.utc(1976), null],
        aByteData: createByteData(),
        aByteDataList: [createByteData(), createByteData()],
        aListWithNullableByteDatas: [createByteData(), null],
        anIntMap: {'0': 0, '1': 1, '2': 2},
        aMapWithNullableInts: {'0': 0, '1': null, '2': 2},
        aDuration: const Duration(seconds: 1),
        aDurationList: const [
          Duration(seconds: 1),
          Duration(minutes: 1),
        ],
        aListWithNullableDurations: const [
          Duration(seconds: 1),
          null,
        ],
        aUuid: UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
        aUuidList: [
          UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
          UuidValue.fromString('6c84fb90-12c4-11e1-840d-7b25c5ee775a')
        ],
        aListWithNullableUuids: [
          UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
          null,
        ],
      );

      var s = SerializationManager.encode(nullability);
      var unpacked = protocol.deserialize<Nullability>(jsonDecode(s));
      expect(unpacked.anInt, equals(42));
      expect(unpacked.aDouble, equals(42.42));
      expect(unpacked.aBool, equals(true));
      expect(unpacked.aString, equals('foo'));
      expect(unpacked.aDateTime, equals(DateTime.utc(1976)));
      expect(unpacked.aByteData.lengthInBytes, equals(256));
      expect(unpacked.anObject.num, equals(42));
      expect(unpacked.aDuration, equals(const Duration(seconds: 1)));

      expect(unpacked.anIntList.length, equals(2));
      expect(unpacked.anIntList[0], equals(10));
      expect(unpacked.anIntList[1], equals(20));

      expect(unpacked.aListWithNullableInts.length, equals(2));
      expect(unpacked.aListWithNullableInts[0], equals(10));
      expect(unpacked.aListWithNullableInts[1], isNull);

      expect(unpacked.anObjectList.length, equals(2));
      expect(unpacked.anObjectList[0].num, equals(10));
      expect(unpacked.anObjectList[1].num, equals(20));

      expect(unpacked.aListWithNullableObjects.length, equals(2));
      expect(unpacked.aListWithNullableObjects[0]!.num, equals(10));
      expect(unpacked.aListWithNullableObjects[1], isNull);

      expect(unpacked.aDateTimeList.length, equals(2));
      expect(unpacked.aDateTimeList[0].year, equals(1976));
      expect(unpacked.aDateTimeList[1].year, equals(1977));

      expect(unpacked.aListWithNullableDateTimes.length, equals(2));
      expect(unpacked.aListWithNullableDateTimes[0]!.year, equals(1976));
      expect(unpacked.aListWithNullableDateTimes[1], isNull);

      expect(unpacked.aListWithNullableByteDatas.length, equals(2));
      expect(
          unpacked.aListWithNullableByteDatas[0]!.lengthInBytes, equals(256));
      expect(unpacked.aListWithNullableByteDatas[1], isNull);

      expect(unpacked.aListWithNullableDurations.length, equals(2));
      expect(unpacked.aListWithNullableDurations[0]!.inSeconds, equals(1));
      expect(unpacked.aListWithNullableDurations[1], isNull);

      expect(unpacked.aListWithNullableUuids.length, equals(2));
      expect(unpacked.aListWithNullableUuids[0],
          equals(UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11')));
      expect(unpacked.aListWithNullableUuids[1], isNull);

      expect(unpacked.aNullableInt, isNull);
      expect(unpacked.aNullableDouble, isNull);
      expect(unpacked.aNullableBool, isNull);
      expect(unpacked.aNullableString, isNull);
      expect(unpacked.aNullableDateTime, isNull);
      expect(unpacked.aNullableByteData, isNull);
      expect(unpacked.aNullableObject, isNull);
      expect(unpacked.aNullableDuration, isNull);
      expect(unpacked.aNullableUuid, isNull);

      expect(unpacked.aNullableListWithNullableInts, isNull);
      expect(unpacked.aNullableIntList, isNull);
      expect(unpacked.aNullableListWithNullableObjects, isNull);
      expect(unpacked.aNullableObjectList, isNull);
      expect(unpacked.aNullableDateTimeList, isNull);
      expect(unpacked.aNullableListWithNullableDateTimes, isNull);
      expect(unpacked.aNullableListWithNullableDurations, isNull);
      expect(unpacked.aNullableListWithNullableUuids, isNull);

      expect(unpacked.anIntMap['0'], equals(0));
      expect(unpacked.anIntMap['1'], equals(1));
      expect(unpacked.anIntMap['2'], equals(2));

      expect(unpacked.aMapWithNullableInts['0'], equals(0));
      expect(unpacked.aMapWithNullableInts['1'], isNull);
      expect(unpacked.aMapWithNullableInts['2'], equals(2));
    });

    test('Nullability with values', () {
      var nullability = Nullability(
        anInt: 42,
        aNullableInt: 42,
        aDouble: 42.42,
        aNullableDouble: 42.42,
        aBool: true,
        aNullableBool: true,
        aString: 'foo',
        aNullableString: 'foo',
        aDateTime: DateTime.utc(1976),
        aNullableDateTime: DateTime.utc(1976),
        aByteData: createByteData(),
        aNullableByteData: createByteData(),
        anObject: SimpleData(num: 42),
        aNullableObject: SimpleData(num: 42),
        anIntList: [10, 20],
        aNullableIntList: [10, 20],
        aListWithNullableInts: [10, null],
        aNullableListWithNullableInts: [10, null],
        anObjectList: [SimpleData(num: 10), SimpleData(num: 20)],
        aNullableObjectList: [SimpleData(num: 10), SimpleData(num: 20)],
        aListWithNullableObjects: [SimpleData(num: 10), null],
        aNullableListWithNullableObjects: [SimpleData(num: 10), null],
        aDateTimeList: [DateTime.utc(1976), DateTime.utc(1977)],
        aNullableDateTimeList: [DateTime.utc(1976), DateTime.utc(1977)],
        aListWithNullableDateTimes: [DateTime.utc(1976), null],
        aNullableListWithNullableDateTimes: [DateTime.utc(1976), null],
        aByteDataList: [createByteData(), createByteData()],
        aNullableByteDataList: [createByteData(), createByteData()],
        aListWithNullableByteDatas: [createByteData(), null],
        aNullableListWithNullableByteDatas: [createByteData(), null],
        anIntMap: {'0': 0, '1': 1, '2': 2},
        aMapWithNullableInts: {'0': 0, '1': null, '2': 2},
        aDurationList: const [
          Duration(seconds: 1),
          Duration(minutes: 1),
        ],
        aListWithNullableDurations: const [
          Duration(seconds: 1),
          null,
        ],
        aNullableDurationList: const [
          Duration(seconds: 1),
          Duration(minutes: 1),
        ],
        aDuration: const Duration(seconds: 1),
        aNullableDuration: const Duration(seconds: 1),
        aNullableListWithNullableDurations: [
          const Duration(seconds: 1),
          null,
        ],
        aUuidList: [
          UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
          UuidValue.fromString('6c84fb90-12c4-11e1-840d-7b25c5ee775a')
        ],
        aListWithNullableUuids: [
          UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
          null,
        ],
        aNullableUuidList: [
          UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
          UuidValue.fromString('6c84fb90-12c4-11e1-840d-7b25c5ee775a')
        ],
        aUuid: UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
        aNullableUuid:
            UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
        aNullableListWithNullableUuids: [
          UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
          null,
        ],
      );

      var s = SerializationManager.encode(nullability);
      var unpacked = protocol.deserialize<Nullability>(jsonDecode(s));
      expect(unpacked.aNullableInt, equals(42));
      expect(unpacked.aNullableDouble, equals(42.42));
      expect(unpacked.aNullableBool, equals(true));
      expect(unpacked.aNullableString, equals('foo'));
      expect(unpacked.aNullableDateTime, equals(DateTime.utc(1976)));
      expect(unpacked.aNullableByteData!.lengthInBytes, equals(256));
      expect(unpacked.aNullableObject!.num, equals(42));
      expect(unpacked.aNullableDuration, equals(const Duration(seconds: 1)));
      expect(unpacked.aNullableUuid,
          equals(UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11')));

      expect(unpacked.aNullableIntList!.length, equals(2));
      expect(unpacked.aNullableIntList![0], equals(10));
      expect(unpacked.aNullableIntList![1], equals(20));

      expect(unpacked.aNullableListWithNullableInts!.length, equals(2));
      expect(unpacked.aNullableListWithNullableInts![0], equals(10));
      expect(unpacked.aNullableListWithNullableInts![1], isNull);

      expect(unpacked.aNullableObjectList!.length, equals(2));
      expect(unpacked.aNullableObjectList![0].num, equals(10));
      expect(unpacked.aNullableObjectList![1].num, equals(20));

      expect(unpacked.aNullableListWithNullableObjects!.length, equals(2));
      expect(unpacked.aNullableListWithNullableObjects![0]!.num, equals(10));
      expect(unpacked.aNullableListWithNullableObjects![1], isNull);

      expect(unpacked.aNullableDateTimeList!.length, equals(2));
      expect(unpacked.aNullableDateTimeList![0].year, equals(1976));
      expect(unpacked.aNullableDateTimeList![1].year, equals(1977));

      expect(unpacked.aNullableListWithNullableDateTimes!.length, equals(2));
      expect(
          unpacked.aNullableListWithNullableDateTimes![0]!.year, equals(1976));
      expect(unpacked.aNullableListWithNullableDateTimes![1], isNull);

      expect(unpacked.aNullableByteDataList!.length, equals(2));
      expect(unpacked.aNullableByteDataList![0].lengthInBytes, equals(256));
      expect(unpacked.aNullableByteDataList![1].lengthInBytes, equals(256));

      expect(unpacked.aNullableListWithNullableByteDatas!.length, equals(2));
      expect(unpacked.aNullableListWithNullableByteDatas![0]!.lengthInBytes,
          equals(256));
      expect(unpacked.aNullableListWithNullableByteDatas![1], isNull);

      expect(unpacked.aNullableDurationList!.length, equals(2));
      expect(unpacked.aNullableDurationList![0].inSeconds, equals(1));
      expect(unpacked.aNullableDurationList![1].inMinutes, equals(1));

      expect(unpacked.aNullableUuidList!.length, equals(2));
      expect(unpacked.aNullableUuidList![0],
          equals(UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11')));
      expect(unpacked.aNullableUuidList![1],
          equals(UuidValue.fromString('6c84fb90-12c4-11e1-840d-7b25c5ee775a')));

      expect(unpacked.aNullableListWithNullableDurations!.length, equals(2));
      expect(unpacked.aNullableListWithNullableDurations![0]!.inSeconds,
          equals(1));
      expect(unpacked.aNullableListWithNullableDurations![1], isNull);

      expect(unpacked.aNullableListWithNullableUuids!.length, equals(2));
      expect(unpacked.aNullableListWithNullableUuids![0],
          equals(UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11')));
      expect(unpacked.aNullableListWithNullableUuids![1], isNull);
    });

    test('Map types', () {
      var maps = ObjectWithMaps(
        dataMap: {
          '0': SimpleData(num: 0),
          '1': SimpleData(num: 1),
          '2': SimpleData(num: 2),
        },
        intMap: {'0': 0, '1': 1, '2': 2},
        stringMap: {'0': 'String 0', '1': 'String 1', '2': 'String 2'},
        dateTimeMap: {
          '2020': DateTime.utc(2020),
          '2021': DateTime.utc(2021),
          '2022': DateTime.utc(2022),
        },
        byteDataMap: {
          '0': createByteData(),
          '1': createByteData(),
        },
        nullableDataMap: {
          '0': SimpleData(num: 0),
          '1': null,
          '2': SimpleData(num: 2),
        },
        nullableIntMap: {'0': 0, '1': null, '2': 2},
        nullableStringMap: {'0': 'null', '1': null, '2': 'String 2'},
        nullableDateTimeMap: {
          '2020': DateTime.utc(2020),
          '2021': null,
          '2022': DateTime.utc(2022),
        },
        nullableByteDataMap: {
          '0': createByteData(),
          '1': null,
        },
        intIntMap: {1: 1, 2: 4, 3: 9},
        durationMap: {
          '0': const Duration(seconds: 1),
          '1': const Duration(minutes: 1),
        },
        nullableDurationMap: {
          '0': const Duration(seconds: 1),
          '1': null,
        },
        uuidMap: {
          '0': UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
          '1': UuidValue.fromString('6c84fb90-12c4-11e1-840d-7b25c5ee775a'),
        },
        nullableUuidMap: {
          '0': UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
          '1': null,
        },
      );

      var s = SerializationManager.encode(maps);
      var unpacked = protocol.deserialize<ObjectWithMaps>(jsonDecode(s));
      expect(unpacked.dataMap['0']!.num, equals(0));
      expect(unpacked.dataMap['1']!.num, equals(1));
      expect(unpacked.dataMap['2']!.num, equals(2));

      expect(unpacked.intMap['0'], equals(0));
      expect(unpacked.intMap['1'], equals(1));
      expect(unpacked.intMap['2'], equals(2));

      expect(unpacked.stringMap['0'], equals('String 0'));
      expect(unpacked.stringMap['1'], equals('String 1'));
      expect(unpacked.stringMap['2'], equals('String 2'));

      expect(unpacked.dateTimeMap['2020'], equals(DateTime.utc(2020)));
      expect(unpacked.dateTimeMap['2021'], equals(DateTime.utc(2021)));
      expect(unpacked.dateTimeMap['2022'], equals(DateTime.utc(2022)));

      expect(unpacked.byteDataMap['0']!.lengthInBytes, equals(256));
      expect(unpacked.byteDataMap['1']!.lengthInBytes, equals(256));

      expect(unpacked.durationMap['0']!.inSeconds, equals(equals(1)));
      expect(unpacked.durationMap['1']!.inMinutes, equals(equals(1)));

      expect(unpacked.uuidMap['0'],
          equals(UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11')));
      expect(unpacked.uuidMap['1'],
          equals(UuidValue.fromString('6c84fb90-12c4-11e1-840d-7b25c5ee775a')));

      expect(unpacked.nullableDataMap['0']!.num, equals(0));
      expect(unpacked.nullableDataMap['1'], isNull);
      expect(unpacked.nullableDataMap['2']!.num, equals(2));

      expect(unpacked.nullableIntMap['0'], equals(0));
      expect(unpacked.nullableIntMap['1'], isNull);
      expect(unpacked.nullableIntMap['2'], equals(2));

      expect(unpacked.nullableStringMap['0'], equals('null'));
      expect(unpacked.nullableStringMap['1'], isNull);
      expect(unpacked.nullableStringMap['2'], equals('String 2'));

      expect(unpacked.nullableDateTimeMap['2020'], equals(DateTime.utc(2020)));
      expect(unpacked.nullableDateTimeMap['2021'], isNull);
      expect(unpacked.nullableDateTimeMap['2022'], equals(DateTime.utc(2022)));

      expect(unpacked.nullableByteDataMap['0']!.lengthInBytes, equals(256));
      expect(unpacked.nullableByteDataMap['1'], isNull);

      expect(unpacked.nullableDurationMap['0']!.inSeconds, equals(1));
      expect(unpacked.nullableDurationMap['1'], isNull);

      expect(unpacked.nullableUuidMap['0']!,
          equals(UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11')));
      expect(unpacked.nullableUuidMap['1'], isNull);

      expect(unpacked.intIntMap.length, equals(3));
      expect(unpacked.intIntMap[1], equals(1));
      expect(unpacked.intIntMap[2], equals(4));
      expect(unpacked.intIntMap[3], equals(9));
    });
  });
}
