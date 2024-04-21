import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
      'When deserializing a class with nullable values and providing null values in JSON, it should throw a TypeError.',
      () {
    expect(
      () => SimpleData.fromJson({"num": null}),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'When deserializing a class with nullable values and missing values in JSON, it should throw a TypeError.',
      () {
    expect(
      () => SimpleData.fromJson({}),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'When deserializing a class with non-nullable values in JSON, it should not throw a TypeError.',
      () {
    expect(
      SimpleData.fromJson({
        "id": 1,
        "num": 1,
      }),
      isA<SimpleData>(),
    );
  });

  test(
      'When deserializing a class with non-nullable values but different types in JSON, it should throw a TypeError.',
      () {
    expect(
      () => SimpleData.fromJson({
        "id": "test",
        "num": "test",
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'When deserializing a class with non-nullable DateTime provided in JSON, expecting values to be deserialized correctly.',
      () {
    var types = Types.fromJson({
      'aDateTime': '2024-01-01T00:00:00.000Z',
    });
    expect(
      types.aDateTime,
      DateTime.tryParse('2024-01-01T00:00:00.000Z'),
    );
  });

  test(
      'When deserializing a class with non-nullable Duration provided in JSON, expecting values to be deserialized correctly.',
      () {
    var types = Types.fromJson({
      'aDuration': 1000,
    });

    expect(
      types.aDuration?.inMilliseconds,
      1000,
    );
  });

  test(
      'When deserializing a class with non-nullable Enum provided in JSON, expecting values to be deserialized correctly.',
      () {
    var types = Types.fromJson({
      'anEnum': 0,
    });

    expect(
      types.anEnum,
      TestEnum.one,
    );
  });

  test(
      'When deserializing a class with non-nullable Enum provided but wrong type in JSON, it should throw a TypeError.',
      () {
    expect(
      () => Types.fromJson({
        'anEnum': 'one',
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'When deserializing a class with non-nullable Enum provided but invalid data in JSON, it should throw an ArgumentError.',
      () {
    expect(
      () => Types.fromJson({
        'anEnum': -1,
      }),
      throwsA(isA<ArgumentError>()),
    );

    expect(
      () => Types.fromJson({
        'anEnum': TestEnum.values.length,
      }),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
      'When deserializing a class with a nullable List for a nullable type provided in JSON, no error should be thrown.',
      () {
    expect(
      TypesList.fromJson({
        'anInt': null,
      }),
      isA<TypesList>(),
    );
  });

  test(
      'When deserializing a class with non-nullable List provided but wrong type in JSON, it should throw a TypeError.',
      () {
    expect(
      () => TypesList.fromJson({
        'anInt': ['test'],
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'When deserializing a class with non-nullable List provided in JSON, expecting values to be deserialized correctly.',
      () {
    var typeList = TypesList.fromJson({
      'anInt': [1, 2],
    });
    expect(
      typeList.anInt?.length,
      2,
    );

    expect(
      typeList.anInt?.first,
      1,
    );
  });

  test(
      'When deserializing a class with a List containing nested objects in JSON, expecting values to be deserialized correctly.',
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
      'When deserializing a class with a List containing nested objects with invalid data types in JSON, it should throw a TypeError.',
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
      'When deserializing a class with a List containing nested objects with valid data types in JSON, expecting values to be deserialized correctly.',
      () {
    expect(
      TypesList.fromJson({
        'anObject': [
          {'aDateTime': '2024-01-01T00:00:00.000Z'}
        ],
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
      'When deserializing a class with a null List on a non-nullable type in JSON, it should throw a TypeError.',
      () {
    expect(
      () => SimpleDataList.fromJson({
        'rows': null,
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'When deserializing a class with a Map in JSON, expecting values to be deserialized correctly.',
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
      'When deserializing a class with a Map containing invalid data types in JSON, it should throw a TypeError.',
      () {
    expect(
      () => TypesMap.fromJson({
        'anIntKey': [
          {'k': " test", 'v': 1}
        ],
      }),
      throwsA(isA<TypeError>()),
    );

    expect(
      () => TypesMap.fromJson({
        'anIntKey': [
          {'k': 'test', 'v': null}
        ],
      }),
      throwsA(isA<TypeError>()),
    );

    expect(
      () => TypesMap.fromJson({
        'anIntKey': [
          {'k': null, 'v': 1}
        ],
      }),
      throwsA(isA<TypeError>()),
    );

    expect(
      () => TypesMap.fromJson({
        'anIntKey': [
          {'k': null, 'v': null}
        ],
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'When deserializing a class with a null Map on a non-nullable type in JSON, it should throw a TypeError.',
      () {
    expect(
      () => SimpleDataMap.fromJson({
        'data': null,
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'When deserializing a class with a missing Map key and value in JSON, it should throw a TypeError.',
      () {
    expect(
      () => SimpleDataMap.fromJson({
        'data': [{}],
      }),
      throwsA(isA<TypeError>()),
    );
  });
}
