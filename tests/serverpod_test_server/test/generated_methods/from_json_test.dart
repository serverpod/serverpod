import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a non-nullable field, when deserializing from JSON with null value, then a TypeError is thrown',
      () {
    expect(
      () => SimpleData.fromJson({"num": null}),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given a class with non-nullable fields, when deserializing from an empty JSON, then a TypeError is thrown',
      () {
    expect(
      () => SimpleData.fromJson({}),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given a class with a nullable integer field, when deserializing from JSON with correct, incorrect, and null values, then proper behavior is observed',
      () {
    expect(
      Types.fromJson({'anInt': 1}).anInt,
      1,
    );

    expect(
      () => Types.fromJson({'anInt': '1'}).anInt,
      throwsA(isA<TypeError>()),
    );

    expect(
      Types.fromJson({'anInt': null}).anInt,
      null,
    );
  });

  test(
      'Given a class with a nullable double field, when deserializing from JSON with correct, incorrect, and null values, then it behaves as expected',
      () {
    expect(
      Types.fromJson({'aDouble': 20.20}).aDouble,
      20.20,
    );

    expect(
      () => Types.fromJson({'aDouble': '20.20'}).aDouble,
      throwsA(isA<TypeError>()),
    );

    expect(
      Types.fromJson({'aDouble': null}).aDouble,
      null,
    );
  });

  test(
      'Given a class with a nullable boolean field, when deserializing from JSON with correct, incorrect, and null values, then it behaves as expected',
      () {
    expect(
      Types.fromJson({'aBool': true}).aBool,
      true,
    );

    expect(
      () => Types.fromJson({'aBool': 'true'}).aBool,
      throwsA(isA<TypeError>()),
    );

    expect(
      Types.fromJson({'aBool': null}).aBool,
      null,
    );
  });

  test(
      'Given non-nullable DateTime, when deserializing with correct value in JSON, then the value is deserialized correctly',
      () {
    expect(
      Types.fromJson({'aDateTime': '2024-01-01T00:00:00.000Z'}).aDateTime,
      DateTime.tryParse('2024-01-01T00:00:00.000Z'),
    );

    expect(
      Types.fromJson(
        {'aDateTime': DateTime.tryParse('2024-01-01T00:00:00.000Z')},
      ).aDateTime,
      DateTime.tryParse('2024-01-01T00:00:00.000Z'),
    );
  });

  test(
      'Given non-nullable Duration, when deserializing with correct value in JSON, then the value is deserialized correctly',
      () {
    expect(
      Types.fromJson({'aDuration': 1000}).aDuration?.inMilliseconds,
      1000,
    );

    expect(
      Types.fromJson({'aDuration': Duration(milliseconds: 1000)})
          .aDuration
          ?.inMilliseconds,
      1000,
    );
  });

  test(
      'Given non-nullable UUID fields, when deserialized from JSON, then the UUID values are deserialized correctly',
      () {
    expect(
      Types.fromJson({'aUuid': '00000000-0000-0000-0000-000000000000'})
          .aUuid
          ?.uuid,
      '00000000-0000-0000-0000-000000000000',
    );

    expect(
      Types.fromJson({
        'aUuid': UuidValue.fromString('00000000-0000-0000-0000-000000000000')
      }).aUuid?.uuid,
      '00000000-0000-0000-0000-000000000000',
    );
  });

  test(
      'Given non-nullable Enum, when deserializing with correct value in JSON, then the value is deserialized correctly',
      () {
    var types = Types.fromJson({'anEnum': 0});
    expect(
      types.anEnum,
      TestEnum.one,
    );
  });

  test(
      'Given a class with non-nullable Enum, when deserializing with wrong value type in JSON, then a TypeError is thrown',
      () {
    expect(
      () => Types.fromJson({'anEnum': 'one'}),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given non-nullable Enum, when deserializing with invalid value in JSON, then an ArgumentError is thrown',
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
      'Given non-nullable List, when deserializing with wrong value type in JSON, then a TypeError is thrown',
      () {
    expect(
      () => TypesList.fromJson({
        'anInt': ['test']
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given non-nullable List, when deserializing with correct value types in JSON, then values are deserialized correctly',
      () {
    var typeList = TypesList.fromJson({
      'anInt': [1, 2]
    });
    expect(typeList.anInt?.length, 2);
    expect(typeList.anInt?.first, 1);
  });

  test(
      'Given a class with a nullable List field, when deserializing with null value provided in JSON, then no error is thrown',
      () {
    expect(
      TypesList.fromJson({'anInt': null}),
      isA<TypesList>(),
    );
  });

  test(
      'Given a List with nested objects, when deserializing with correct value type in JSON, then values are deserialized correctly',
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
      'Given a List with nested objects, when deserializing with wrong value type in JSON, then a TypeError is thrown',
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
      'Given a List containing nested ByteData, when deserializing with valid data types in JSON, then values are deserialized correctly',
      () {
    expect(
      TypesList.fromJson({
        'aByteData': ['decode(\'AAECAwQFBgc=\', \'base64\')'],
      }),
      isA<TypesList>(),
    );
  });

  test(
      'When deserializing a class with a List containing nested ByteData with valid data types in JSON, expecting values to be deserialized correctly.',
      () {
    expect(
      TypesList.fromJson({
        'aByteData': ['decode(\'AAECAwQFBgc=\', \'base64\')'],
      }),
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

  test(
      'Given a Map, when deserializing with correct values provided in JSON, then values are deserialized correctly',
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
      'Given a Map, when deserializing with invalid data type provided in JSON, then a TypeError is thrown',
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
      'Given a non-nullable Map, when deserializing with null value provided in JSON, then a TypeError is thrown',
      () {
    expect(
      () => SimpleDataMap.fromJson({
        'data': null,
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given a Map, when deserializing with a missing key and value in JSON, then a TypeError is thrown',
      () {
    expect(
      () => SimpleDataMap.fromJson({
        'data': [{}],
      }),
      throwsA(isA<TypeError>()),
    );
  });
}
