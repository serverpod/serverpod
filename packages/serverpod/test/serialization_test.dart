import 'dart:convert';

import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

void main() {
  var protocol = Protocol();

  group('Serializations', () {
    test('Simple data', () {
      var data = SimpleData(num: 42);
      var s = jsonEncode(data.serialize());
      var unpacked = SimpleData.fromSerialization(jsonDecode(s));
      expect(unpacked.num, equals(42));
    });

    test('Basic types with null values', () {
      var types = Types();
      var s = protocol.serializeEntity(types)!;
      var unpacked = protocol.createEntityFromSerialization(jsonDecode(s)) as Types;
      expect(unpacked.aBool, isNull);
      expect(unpacked.anInt, isNull);
      expect(unpacked.aString, isNull);
      expect(unpacked.aDouble, isNull);
      expect(unpacked.aDateTime, isNull);
    });

    test('Basic types with values', () {
      var types = Types(
        aBool: true,
        anInt: 42,
        aString: '42',
        aDouble: 42.42,
        aDateTime: DateTime.utc(1976),
      );
      var s = protocol.serializeEntity(types)!;
      var unpacked = protocol.createEntityFromSerialization(jsonDecode(s)) as Types;
      expect(unpacked.aBool, equals(true));
      expect(unpacked.anInt, equals(42));
      expect(unpacked.aString, equals('42'));
      expect(unpacked.aDouble, equals(42.42));
      expect(unpacked.aDateTime, equals(DateTime.utc(1976)));
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
      );

      var s = protocol.serializeEntity(nullability)!;
      var unpacked = protocol.createEntityFromSerialization(jsonDecode(s)) as Nullability;
      expect(unpacked.anInt, equals(42));
      expect(unpacked.aDouble, equals(42.42));
      expect(unpacked.aBool, equals(true));
      expect(unpacked.aString, equals('foo'));
      expect(unpacked.aDateTime, equals(DateTime.utc(1976)));
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

      expect(unpacked.aNullableInt, isNull);
      expect(unpacked.aNullableDouble, isNull);
      expect(unpacked.aNullableBool, isNull);
      expect(unpacked.aNullableString, isNull);
      expect(unpacked.aNullableDateTime, isNull);
      expect(unpacked.aNullableObject, isNull);

      expect(unpacked.aNullableListWithNullableInts, isNull);
      expect(unpacked.aNullableIntList, isNull);
      expect(unpacked.aNullableListWithNullableObjects, isNull);
      expect(unpacked.aNullableObjectList, isNull);
      expect(unpacked.aNullableDateTimeList, isNull);
      expect(unpacked.aNullableListWithNullableDateTimes, isNull);
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
      );

      var s = protocol.serializeEntity(nullability)!;
      var unpacked = protocol.createEntityFromSerialization(jsonDecode(s)) as Nullability;
      expect(unpacked.aNullableInt, equals(42));
      expect(unpacked.aNullableDouble, equals(42.42));
      expect(unpacked.aNullableBool, equals(true));
      expect(unpacked.aNullableString, equals('foo'));
      expect(unpacked.aNullableDateTime, equals(DateTime.utc(1976)));
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
      expect(unpacked.aNullableListWithNullableDateTimes![0]!.year, equals(1976));
      expect(unpacked.aNullableListWithNullableDateTimes![1], isNull);
    });
  });
}