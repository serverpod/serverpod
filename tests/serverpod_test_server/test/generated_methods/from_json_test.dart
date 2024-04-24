import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given a non-nullable field, ', () {
    test(
        'when deserializing from JSON with null value, then a TypeError is thrown',
        () {
      expect(
        () => SimpleData.fromJson({"num": null}),
        throwsA(isA<TypeError>()),
      );
    });

    test('when deserializing from an empty JSON, then a TypeError is thrown',
        () {
      expect(
        () => SimpleData.fromJson({}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('Given a class with a nullable integer field, ', () {
    test(
        'when deserializing from JSON with a correct integer value, then the integer is deserialized correctly',
        () {
      expect(
        Types.fromJson({'anInt': 1}).anInt,
        1,
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'anInt': '1'}).anInt,
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the integer field is set to null as expected',
        () {
      expect(
        Types.fromJson({'anInt': null}).anInt,
        null,
      );
    });
  });

  group('Given a class with a nullable double field, ', () {
    test(
        'when deserializing from JSON with a correct double value, then the double is deserialized correctly',
        () {
      expect(
        Types.fromJson({'aDouble': 20.20}).aDouble,
        20.20,
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'aDouble': '20.20'}).aDouble,
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the double field is set to null as expected',
        () {
      expect(
        Types.fromJson({'aDouble': null}).aDouble,
        null,
      );
    });
  });

  group('Given a class with a nullable boolean field, ', () {
    test(
        'when deserializing from JSON with a correct boolean value, then the boolean is deserialized correctly',
        () {
      expect(
        Types.fromJson({'aBool': true}).aBool,
        true,
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'aBool': 'true'}).aBool,
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the boolean field is set to null as expected',
        () {
      expect(
        Types.fromJson({'aBool': null}).aBool,
        null,
      );
    });
  });

  group('Given a class with a nullable string field, ', () {
    test(
        'when deserializing from JSON with a correct string value, then the string is deserialized correctly',
        () {
      expect(
        Types.fromJson({'aString': 'test'}).aString,
        'test',
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'aString': 111}).aString,
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the string field is set to null as expected',
        () {
      expect(
        Types.fromJson({'aString': null}).aString,
        null,
      );
    });
  });

  group('Given a class with a DateTime field, ', () {
    test(
        'when deserializing from a JSON string representing a DateTime, then the resulting DateTime matches the expected value',
        () {
      expect(
        Types.fromJson({'aDateTime': '2024-01-01T00:00:00.000Z'}).aDateTime,
        DateTime.tryParse('2024-01-01T00:00:00.000Z'),
      );
    });

    test(
        'when a DateTime object is embedded directly in JSON data and processed, then the resulting DateTime matches the expected value',
        () {
      expect(
        Types.fromJson(
                {'aDateTime': DateTime.tryParse('2024-01-01T00:00:00.000Z')})
            .aDateTime,
        DateTime.tryParse('2024-01-01T00:00:00.000Z'),
      );
    });
  });

  group('Given a class with a non-nullable Duration field, ', () {
    test(
        'when deserializing from JSON with an integer representing milliseconds, then the Duration is deserialized correctly',
        () {
      expect(
        Types.fromJson({'aDuration': 1000}).aDuration?.inMilliseconds,
        1000,
      );
    });

    test(
        'when deserializing from JSON with a Duration object, then the Duration is deserialized correctly',
        () {
      expect(
        Types.fromJson({'aDuration': Duration(milliseconds: 1000)})
            .aDuration
            ?.inMilliseconds,
        1000,
      );
    });
  });

  group('Given a class with non-nullable UUID fields, ', () {
    test(
        'when deserializing from JSON with a UUID string, then the UUID is deserialized correctly',
        () {
      expect(
        Types.fromJson({'aUuid': '00000000-0000-0000-0000-000000000000'})
            .aUuid
            ?.uuid,
        '00000000-0000-0000-0000-000000000000',
      );
    });

    test(
        'when deserializing from JSON with a UuidValue object, then the UUID is deserialized correctly',
        () {
      expect(
        Types.fromJson({
          'aUuid': UuidValue.fromString('00000000-0000-0000-0000-000000000000')
        }).aUuid?.uuid,
        '00000000-0000-0000-0000-000000000000',
      );
    });
  });

  group('Given non-nullable Enum, ', () {
    test(
        'when deserializing with correct value in JSON, then the value is deserialized correctly',
        () {
      var types = Types.fromJson({'anEnum': 0});
      expect(
        types.anEnum,
        TestEnum.one,
      );
    });

    test(
        'when deserializing with wrong value type in JSON, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'anEnum': 'one'}),
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing with invalid value in JSON, then an ArgumentError is thrown',
        () {
      expect(
        () => Types.fromJson({'anEnum': -1}),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => Types.fromJson({'anEnum': TestEnum.values.length}),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Given non-nullable List', () {
    test(
        ', when deserializing with wrong value type in JSON, then a TypeError is thrown',
        () {
      expect(
        () => TypesList.fromJson({
          'anInt': ['test']
        }),
        throwsA(isA<TypeError>()),
      );
    });

    test(
        ', when deserializing with correct value types in JSON, then values are deserialized correctly',
        () {
      var typeList = TypesList.fromJson({
        'anInt': [1, 2]
      });
      expect(typeList.anInt?.length, 2);
      expect(typeList.anInt?.first, 1);
    });

    test(
        ' field, when deserializing with null value provided in JSON, then no error is thrown',
        () {
      expect(
        TypesList.fromJson({'anInt': null}),
        isA<TypesList>(),
      );
    });

    test(
        'Given a nullable List, when deserializing with null value provided in JSON, then a TypeError is thrown',
        () {
      expect(
        () => SimpleDataList.fromJson({
          'rows': null,
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('Given a List ', () {
    test(
        'with nested objects, when deserializing with correct value type in JSON, then values are deserialized correctly',
        () {
      var typeList = TypesList.fromJson({
        'anObject': [
          {'aDateTime': '2024-01-01T00:00:00.000Z'}
        ],
      });
      expect(
        typeList.anObject?.first,
        isA<Types>(),
      );
    });

    test(
        'with nested objects, when deserializing with wrong value type in JSON, then a TypeError is thrown',
        () {
      expect(
        () => TypesList.fromJson({
          'anObject': [
            {'aDateTime': 1}
          ],
        }),
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'containing nested ByteData, when deserializing with valid data types in JSON, then values are deserialized correctly',
        () {
      expect(
        TypesList.fromJson({
          'aByteData': ['decode(\'AAECAwQFBgc=\', \'base64\')'],
        }),
        isA<TypesList>(),
      );
    });

    test(
        'containing nested ByteData with valid data types in JSON, expecting values to be deserialized correctly.',
        () {
      expect(
        TypesList.fromJson({
          'aByteData': ['decode(\'AAECAwQFBgc=\', \'base64\')'],
        }),
        isA<TypesList>(),
      );
    });
  });

  group('Given a non-nullable Map, ', () {
    test(
        'when deserializing with correct values provided in JSON, then values are deserialized correctly',
        () {
      expect(
        TypesMap.fromJson({
          'anIntKey': [
            {'k': 1, 'v': 'test'}
          ],
        }),
        isA<TypesMap>(),
      );
    });

    test(
        'when deserializing with a missing key and value in JSON, then a TypeError is thrown',
        () {
      expect(
        () => SimpleDataMap.fromJson({
          'data': [{}],
        }),
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing with invalid data type provided in JSON, then a TypeError is thrown',
        () {
      expect(
        () => TypesMap.fromJson({
          'anIntKey': [
            {'k': " test", 'v': 1},
            {'k': 'test', 'v': null},
            {'k': null, 'v': 1},
            {'k': null, 'v': null}
          ],
        }),
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing with null value provided in JSON, then a TypeError is thrown',
        () {
      expect(
        () => SimpleDataMap.fromJson({
          'data': null,
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
