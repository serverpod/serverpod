import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with nullable values and null value provided when calling fromJson, then it throws an TypeError.',
      () {
    expect(
      () => SimpleData.fromJson({"num": null}),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given a class with nullable values and missing values provided when calling fromJson, then it throws an TypeError',
      () {
    expect(
      () => SimpleData.fromJson({}),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given a class with non nullable values provided when calling fromJson, then it will not throw an TypeError',
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
      'Given a class with non nullable values but different types provided when calling fromJson, then it throws an TypeError',
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
      'Given a class with non nullable DateTune provided when calling fromJson, then expecting values to be deserialized correct',
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
      'Given a class with non nullable Duration provided when calling fromJson, then expecting values to be deserialized correct',
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
      'Given a class with non nullable Enum provided when calling fromJson, then expecting values to be deserialized correct',
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
      'Given a class with non nullable Enum provided but wrong type when calling fromJson, then it throws an TypeError',
      () {
    expect(
      () => Types.fromJson({
        'anEnum': 'one',
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given a class with non nullable Enum provided but invalid data when calling fromJson, then it throws an ArgumentError',
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
      'Given a class with nullable List for a nullable type provided when calling fromJson, then no error is thrown',
      () {
    expect(
      TypesList.fromJson({
        'anInt': null,
      }),
      isA<TypesList>(),
    );
  });

  test(
      'Given a class with non nullable List provided but wrong type when calling fromJson, then it throws an TypeError',
      () {
    expect(
      () => TypesList.fromJson({
        'anInt': ['test'],
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given a class with non nullable List provided when calling fromJson, then expecting values to be deserialized correct',
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
      'Given a class with a List with a nested object when calling fromJson, then expecting values to be deserialized correct',
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
      'Given a class with a List and a nested object that has invalid data type when calling fromJson, then it throws an TypeError',
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
      'Given a class with a List and a nested object that has valid data type when calling fromJson, then expecting values to be deserialized correct',
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
      'Given a class with a List with a nested ByteData that has valid data type when calling fromJson, then expecting values to be deserialized correct',
      () {
    expect(
      TypesList.fromJson({
        'aByteData': ['decode(\'AAECAwQFBgc=\', \'base64\')'],
      }),
      isA<TypesList>(),
    );
  });

  test(
      'Given a class with a null List on a non nullable type when calling fromJson, then it throws an TypeError',
      () {
    expect(
      () => SimpleDataList.fromJson({
        'rows': null,
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given a class with a Map  when calling fromJson, then expecting values to be deserialized correct',
      () {
    expect(
      TypesMap.fromJson({
        'anIntKey': {1: 'test'},
      }),
      isA<TypesMap>(),
    );
  });

  test(
      'Given a class with a Map and invalid data types when calling fromJson, then it throws an TypeError',
      () {
    expect(
      () => TypesMap.fromJson({
        'anIntKey': {"test": 1},
      }),
      throwsA(isA<TypeError>()),
    );

    expect(
      () => TypesMap.fromJson({
        'anIntKey': {"test": null},
      }),
      throwsA(isA<TypeError>()),
    );

    expect(
      () => TypesMap.fromJson({
        'anIntKey': {null: 1},
      }),
      throwsA(isA<TypeError>()),
    );

    expect(
      () => TypesMap.fromJson({
        'anIntKey': {null: null},
      }),
      throwsA(isA<TypeError>()),
    );
  });

  test(
      'Given a class with a null Map on a non nullable type when calling fromJson, then it throws an TypeError',
      () {
    expect(
      () => SimpleDataMap.fromJson({
        'data': null,
      }),
      throwsA(isA<TypeError>()),
    );
  });
}
