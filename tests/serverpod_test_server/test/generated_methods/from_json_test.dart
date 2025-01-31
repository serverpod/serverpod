import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given a a class with non-nullable field, ', () {
    test(
        'when deserializing from JSON with a null value, then a TypeError is thrown',
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
        'when deserializing from JSON with a correct value, then the result matches the expected value',
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
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'anInt': null}).anInt,
        isNull,
      );
    });
  });

  group('Given a class with a nullable double field, ', () {
    test(
        'when deserializing from JSON with a correct value, then the result matches the expected value',
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
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'aDouble': null}).aDouble,
        isNull,
      );
    });

    test(
        'when deserializing from JSON with a int type value, then the result matches the expected value',
        () {
      expect(
        Types.fromJson({'aDouble': 1}).aDouble,
        1.0,
      );
    });
  });

  group('Given a class with a nullable boolean field, ', () {
    test(
        'when deserializing from JSON with a correct value, then the result matches the expected value',
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
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'aBool': null}).aBool,
        isNull,
      );
    });
  });

  group('Given a class with a nullable string field, ', () {
    test(
        'when deserializing from JSON with a correct value, then the result matches the expected value',
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
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'aString': null}).aString,
        isNull,
      );
    });
  });

  group('Given a class with a nullable DateTime field, ', () {
    test(
        'when deserializing from a JSON string representing a DateTime, then the result matches the expected value',
        () {
      expect(
        Types.fromJson({'aDateTime': '2024-01-01T00:00:00.000Z'}).aDateTime,
        DateTime.tryParse('2024-01-01T00:00:00.000Z'),
      );
    });

    test(
        'when deserializing from JSON with a DateTime object, then the result matches the expected value',
        () {
      expect(
        Types.fromJson(
                {'aDateTime': DateTime.tryParse('2024-01-01T00:00:00.000Z')})
            .aDateTime,
        DateTime.tryParse('2024-01-01T00:00:00.000Z'),
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'aDateTime': 111}).aString,
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'aDateTime': null}).aDateTime,
        isNull,
      );
    });
  });

  group('Given a class with a nullable Duration field, ', () {
    test(
        'when deserializing from JSON with an integer representing milliseconds, then the result matches the expected value',
        () {
      expect(
        Types.fromJson({'aDuration': 1000}).aDuration?.inMilliseconds,
        1000,
      );
    });

    test(
        'when deserializing from JSON with a Duration object, then the result matches the expected value',
        () {
      expect(
        Types.fromJson({'aDuration': Duration(milliseconds: 1000)})
            .aDuration
            ?.inMilliseconds,
        1000,
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'aDateTime': 111}).aString,
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with an incorrect value, then a FormatException is thrown',
        () {
      expect(
        () => Types.fromJson({'aDateTime': "111"}).aString,
        throwsA(isA<FormatException>()),
      );
    });

    test(
      'when deserializing from JSON with a null value, then the field is correctly set to null',
      () {
        expect(
          Types.fromJson({'aDuration': null}).aDuration?.inMilliseconds,
          isNull,
        );
      },
    );
  });

  group('Given a class with nullable UuidValue field, ', () {
    test(
        'when deserializing from JSON with a UUID string, then the result matches the expected value',
        () {
      expect(
        Types.fromJson({'aUuid': '00000000-0000-0000-0000-000000000000'})
            .aUuid
            ?.uuid,
        '00000000-0000-0000-0000-000000000000',
      );
    });

    test(
        'when deserializing from JSON with a UuidValue object, then the result matches the expected value',
        () {
      expect(
        Types.fromJson({
          'aUuid': UuidValue.fromString('00000000-0000-0000-0000-000000000000')
        }).aUuid?.uuid,
        '00000000-0000-0000-0000-000000000000',
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'aDateTime': 111}).aString,
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'aUuid': null}).aUuid?.uuid,
        isNull,
      );
    });
  });

  group('Given a class with nullable BigInt field, ', () {
    test(
        'when deserializing from JSON with a Big string, then the result matches the expected value',
        () {
      expect(
        Types.fromJson({'aBigInt': '-12345678901234567890'}).aBigInt,
        BigInt.parse('-12345678901234567890'),
      );
    });

    test(
        'when deserializing from JSON with a BigInt object, then the result matches the expected value',
        () {
      expect(
        Types.fromJson({
          'aBigInt': BigInt.parse('12345678901234567890'),
        }).aBigInt,
        BigInt.parse('12345678901234567890'),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'aBigInt': null}).aBigInt,
        isNull,
      );
    });
  });

  group('Given a class with a nullable ByteData field, ', () {
    test(
        'when deserializing from JSON with a base64-encoded string, then the result matches the expected value',
        () {
      expect(
        Types.fromJson({'aByteData': 'decode(\'AAECAwQFBgc=\', \'base64\')'})
            .aByteData
            ?.base64encodedString(),
        'decode(\'AAECAwQFBgc=\', \'base64\')',
      );
    });

    test(
        'when deserializing from JSON with a ByteData object, then the result matches the expected value',
        () {
      ByteData value = ByteData.view(base64Decode('AAECAwQFBgc=').buffer);
      expect(
        Types.fromJson({'aByteData': value}).aByteData?.base64encodedString(),
        'decode(\'AAECAwQFBgc=\', \'base64\')',
      );
    });

    test(
        'when deserializing from JSON with a Uint8List object derived, then the result matches the expected value',
        () {
      Uint8List value = base64Decode('AAECAwQFBgc=');
      expect(
        Types.fromJson({'aByteData': value}).aByteData?.base64encodedString(),
        'decode(\'AAECAwQFBgc=\', \'base64\')',
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'aByteData': 111}).aByteData,
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'aByteData': null}).aByteData,
        isNull,
      );
    });
  });

  group('Given a class with a nullable Enum field serialized as int, ', () {
    test(
        'when deserializing with correct value in JSON, then the result matches the expected value',
        () {
      var types = Types.fromJson({'anEnum': 0});
      expect(
        types.anEnum,
        TestEnum.one,
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'anEnum': 'one'}),
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with an invalid value, then a TypeError is thrown',
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

    test(
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'anEnum': null}).anEnum,
        isNull,
      );
    });
  });

  group('Given a class with a nullable Enum field serialized as String, ', () {
    test(
        'when deserializing with correct value in JSON, then the result matches the expected value',
        () {
      var types = Types.fromJson({'aStringifiedEnum': 'one'});
      expect(
        types.aStringifiedEnum,
        TestEnumStringified.one,
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'aStringifiedEnum': 1}),
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with an invalid value, then a TypeError is thrown',
        () {
      expect(
        () => Types.fromJson({'aStringifiedEnum': 'four'}),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        Types.fromJson({'aStringifiedEnum': null}).aStringifiedEnum,
        isNull,
      );
    });
  });

  group('Given a class with a nullable List field, ', () {
    test(
        'when deserializing with correct value types in JSON, then the result matches the expected value',
        () {
      var typeList = TypesList.fromJson({
        'anInt': [1, 2]
      });
      expect(typeList.anInt?.length, 2);
      expect(typeList.anInt?.first, 1);
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => TypesList.fromJson({
          'anInt': ['test']
        }),
        throwsA(isA<TypeError>()),
      );
    });

    test(
        'when deserializing from JSON with a null value, then the field is correctly set to null',
        () {
      expect(
        TypesList.fromJson({'anInt': null}).anInt,
        isNull,
      );
    });
  });

  test(
      'Given a class with a non-nullable List field when deserializing with null value provided in JSON, then a TypeError is thrown',
      () {
    expect(
      () => SimpleDataList.fromJson({'rows': null}),
      throwsA(isA<TypeError>()),
    );
  });

  group('Given a class with a nullable List and nested objects, ', () {
    test(
        'when deserializing with correct value type in JSON, then the result matches the expected value',
        () {
      var typeList = TypesList.fromJson({
        'anObject': [
          {'aDateTime': '2024-01-01T00:00:00.000Z'}
        ]
      });
      expect(
        typeList.anObject?.first,
        isA<Types>(),
      );
    });

    test(
        'when deserializing from JSON with an incorrect value type, then a TypeError is thrown',
        () {
      expect(
        () => TypesList.fromJson({
          'anObject': [
            {'aDateTime': 1}
          ]
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('Given a class with a nullable Map, ', () {
    test(
        'when deserializing with correct values provided in JSON, then the result matches the expected value',
        () {
      expect(
        TypesMap.fromJson({
          'anIntKey': [
            {'k': 1, 'v': 'test'}
          ]
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
        'when deserializing from JSON with an invalid value types, then a TypeError is thrown',
        () {
      expect(
        () => TypesMap.fromJson({
          'anIntKey': [
            {'k': " test", 'v': 1},
            {'k': 'test', 'v': null},
            {'k': null, 'v': 1},
            {'k': null, 'v': null}
          ]
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });

  test(
      'Given a class with a non-nullable Map when deserializing with null value provided in JSON, then a TypeError is thrown',
      () {
    expect(
      () => SimpleDataMap.fromJson({'data': null}),
      throwsA(isA<TypeError>()),
    );
  });
}
