import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

ByteData createByteData() {
  Uint8List ints = Uint8List(256);
  for (int i = 0; i < 256; i++) {
    ints[i] = i;
  }
  return ByteData.view(ints.buffer);
}

void main() {
  Protocol protocol = Protocol();

  group('Serializations', () {
    test('Simple data', () {
      SimpleData data = SimpleData(num: 42);
      String s = jsonEncode(data.serialize());
      SimpleData unpacked = SimpleData.fromSerialization(jsonDecode(s));
      expect(unpacked.num, equals(42));
    });

    test('Basic types with null values', () {
      Types types = Types();
      String s = protocol.serializeEntity(types)!;
      Types unpacked =
          protocol.createEntityFromSerialization(jsonDecode(s)) as Types;
      expect(unpacked.aBool, isNull);
      expect(unpacked.anInt, isNull);
      expect(unpacked.aString, isNull);
      expect(unpacked.aDouble, isNull);
      expect(unpacked.aDateTime, isNull);
      expect(unpacked.aByteData, isNull);
    });

    test('Basic types with values', () {
      Types types = Types(
        aBool: true,
        anInt: 42,
        aString: '42',
        aDouble: 42.42,
        aDateTime: DateTime.utc(1976),
        aByteData: createByteData(),
      );
      String s = protocol.serializeEntity(types)!;
      Types unpacked =
          protocol.createEntityFromSerialization(jsonDecode(s)) as Types;
      expect(unpacked.aBool, equals(true));
      expect(unpacked.anInt, equals(42));
      expect(unpacked.aString, equals('42'));
      expect(unpacked.aDouble, equals(42.42));
      expect(unpacked.aDateTime, equals(DateTime.utc(1976)));
      expect(unpacked.aByteData!.lengthInBytes, equals(256));
      for (int i = 0; i < 256; i++) {
        expect(unpacked.aByteData!.buffer.asUint8List()[i], equals(i));
      }
    });

    test('Nullability with null types', () {
      Nullability nullability = Nullability(
        anInt: 42,
        aDouble: 42.42,
        aBool: true,
        aString: 'foo',
        aDateTime: DateTime.utc(1976),
        anObject: SimpleData(num: 42),
        anIntList: <int>[10, 20],
        aListWithNullableInts: <int?>[10, null],
        anObjectList: <SimpleData>[SimpleData(num: 10), SimpleData(num: 20)],
        aListWithNullableObjects: <SimpleData?>[SimpleData(num: 10), null],
        aDateTimeList: <DateTime>[DateTime.utc(1976), DateTime.utc(1977)],
        aListWithNullableDateTimes: <DateTime?>[DateTime.utc(1976), null],
        aByteData: createByteData(),
        aByteDataList: <ByteData>[createByteData(), createByteData()],
        aListWithNullableByteDatas: <ByteData?>[createByteData(), null],
      );

      String s = protocol.serializeEntity(nullability)!;
      Nullability unpacked =
          protocol.createEntityFromSerialization(jsonDecode(s)) as Nullability;
      expect(unpacked.anInt, equals(42));
      expect(unpacked.aDouble, equals(42.42));
      expect(unpacked.aBool, equals(true));
      expect(unpacked.aString, equals('foo'));
      expect(unpacked.aDateTime, equals(DateTime.utc(1976)));
      expect(unpacked.aByteData.lengthInBytes, equals(256));
      expect(unpacked.anObject.num, equals(42));

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

      expect(unpacked.aNullableInt, isNull);
      expect(unpacked.aNullableDouble, isNull);
      expect(unpacked.aNullableBool, isNull);
      expect(unpacked.aNullableString, isNull);
      expect(unpacked.aNullableDateTime, isNull);
      expect(unpacked.aNullableByteData, isNull);
      expect(unpacked.aNullableObject, isNull);

      expect(unpacked.aNullableListWithNullableInts, isNull);
      expect(unpacked.aNullableIntList, isNull);
      expect(unpacked.aNullableListWithNullableObjects, isNull);
      expect(unpacked.aNullableObjectList, isNull);
      expect(unpacked.aNullableDateTimeList, isNull);
      expect(unpacked.aNullableListWithNullableDateTimes, isNull);
    });

    test('Nullability with values', () {
      Nullability nullability = Nullability(
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
        anIntList: <int>[10, 20],
        aNullableIntList: <int>[10, 20],
        aListWithNullableInts: <int?>[10, null],
        aNullableListWithNullableInts: <int?>[10, null],
        anObjectList: <SimpleData>[SimpleData(num: 10), SimpleData(num: 20)],
        aNullableObjectList: <SimpleData>[
          SimpleData(num: 10),
          SimpleData(num: 20)
        ],
        aListWithNullableObjects: <SimpleData?>[SimpleData(num: 10), null],
        aNullableListWithNullableObjects: <SimpleData?>[
          SimpleData(num: 10),
          null
        ],
        aDateTimeList: <DateTime>[DateTime.utc(1976), DateTime.utc(1977)],
        aNullableDateTimeList: <DateTime>[
          DateTime.utc(1976),
          DateTime.utc(1977)
        ],
        aListWithNullableDateTimes: <DateTime?>[DateTime.utc(1976), null],
        aNullableListWithNullableDateTimes: <DateTime?>[
          DateTime.utc(1976),
          null
        ],
        aByteDataList: <ByteData>[createByteData(), createByteData()],
        aNullableByteDataList: <ByteData>[createByteData(), createByteData()],
        aListWithNullableByteDatas: <ByteData?>[createByteData(), null],
        aNullableListWithNullableByteDatas: <ByteData?>[createByteData(), null],
      );

      String s = protocol.serializeEntity(nullability)!;
      Nullability unpacked =
          protocol.createEntityFromSerialization(jsonDecode(s)) as Nullability;
      expect(unpacked.aNullableInt, equals(42));
      expect(unpacked.aNullableDouble, equals(42.42));
      expect(unpacked.aNullableBool, equals(true));
      expect(unpacked.aNullableString, equals('foo'));
      expect(unpacked.aNullableDateTime, equals(DateTime.utc(1976)));
      expect(unpacked.aNullableByteData!.lengthInBytes, equals(256));
      expect(unpacked.aNullableObject!.num, equals(42));

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
    });
  });
}
