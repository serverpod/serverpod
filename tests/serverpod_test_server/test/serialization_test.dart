import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/protocol.dart' as serverpod;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:test/test.dart';

void main() {
  var protocol = Protocol();
  var serverProtocol = server.Protocol();

  group('Given SerializationManager.toEncodable', () {
    final toEncodable = SerializationManager.toEncodable;

    test('when encoding null then returns null', () {
      expect(toEncodable(null), null);
    });

    test('when encoding bool true then returns true', () {
      expect(toEncodable(true), true);
    });

    test('when encoding bool false then returns false', () {
      expect(toEncodable(false), false);
    });

    test('when encoding int then returns int', () {
      expect(toEncodable(42), 42);
    });

    test('when encoding double then returns double', () {
      expect(toEncodable(3.14), 3.14);
    });

    test('when encoding String then returns String', () {
      expect(toEncodable('hello'), 'hello');
    });

    test('when encoding List<dynamic> then recursively encodes elements', () {
      expect(
        toEncodable([
          'hello',
          true,
          42,
          DateTime.utc(1974),
          [1, 2, 3],
        ]),
        [
          'hello',
          true,
          42,
          '1974-01-01T00:00:00.000Z',
          [1, 2, 3],
        ],
      );
    });

    test(
      'when encoding Map<String, dynamic> then recursively encodes values',
      () {
        expect(
          toEncodable({
            'key': 'value',
            'key2': true,
            'key3': 42,
            'key4': DateTime.utc(1974),
            'key5': {'a': 1},
          }),
          {
            'key': 'value',
            'key2': true,
            'key3': 42,
            'key4': '1974-01-01T00:00:00.000Z',
            'key5': {'a': 1},
          },
        );
      },
    );

    test(
      'when encoding Map<DateTime, DateTime> then returns list of encoded k/v pairs',
      () {
        expect(
          toEncodable({DateTime.utc(1974): DateTime.utc(1993)}),
          [
            {'k': '1974-01-01T00:00:00.000Z', 'v': '1993-01-01T00:00:00.000Z'},
          ],
        );
      },
    );

    test('when encoding DateTime then returns ISO8601 UTC string', () {
      expect(
        toEncodable(DateTime.utc(2024, 1, 15, 10, 30)),
        '2024-01-15T10:30:00.000Z',
      );
    });

    test('when encoding Duration then returns milliseconds', () {
      expect(toEncodable(Duration(seconds: 5)), 5000);
    });

    test('when encoding UuidValue then returns string', () {
      // ignore: deprecated_member_use
      expect(
        toEncodable(UuidValue.nil),
        '00000000-0000-0000-0000-000000000000',
      );
    });

    test('when encoding Uri then returns string', () {
      expect(
        toEncodable(Uri.parse('https://serverpod.dev')),
        'https://serverpod.dev',
      );
    });

    test('when encoding BigInt then returns string', () {
      expect(toEncodable(BigInt.from(123456789)), '123456789');
    });

    test('when encoding Vector then returns list', () {
      expect(toEncodable(Vector([1.0, 2.0, 3.0])), [1.0, 2.0, 3.0]);
    });

    test('when encoding HalfVector then returns list', () {
      expect(toEncodable(HalfVector([1.0, 2.0, 3.0])), [1.0, 2.0, 3.0]);
    });

    test('when encoding Set<dynamic> then recursively encodes to list', () {
      expect(
        toEncodable({
          'hello',
          true,
          42,
          DateTime.utc(1974),
          {1, 2, 3},
        }),
        [
          'hello',
          true,
          42,
          '1974-01-01T00:00:00.000Z',
          [1, 2, 3],
        ],
      );
    });

    test('when encoding ByteData then returns base64 encoded string', () {
      final bytes = Uint8List.fromList([0, 1, 2, 3]);
      final byteData = ByteData.view(bytes.buffer);
      final result = toEncodable(byteData);

      expect(result, isA<String>());
      expect(result, "decode('AAECAw==', 'base64')");
    });

    test('when encoding SparseVector then returns list representation', () {
      final vector = SparseVector.fromMap({1: 1.0, 3: 2.0}, 5);
      final result = toEncodable(vector);

      expect(result, isA<List>());
    });

    test('when encoding Bit then returns list representation', () {
      final bit = Bit.fromString('10101');
      final result = toEncodable(bit);

      expect(result, isA<List>());
    });

    test(
      'when encoding Map with non-String keys then returns list of k/v pairs',
      () {
        final map = {1: 'one', 2: 'two'};
        final result = toEncodable(map);

        expect(result, [
          {'k': 1, 'v': 'one'},
          {'k': 2, 'v': 'two'},
        ]);
      },
    );

    test('when encoding SerializableModel then calls toJson', () {
      final model = SimpleData(num: 42);
      final result = toEncodable(model);

      expect(result, isA<Map>());
      expect((result as Map)['num'], 42);
    });

    test('when encoding Record then throws Exception', () {
      final record = (1, 'two');

      expect(
        () => toEncodable(record),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Records are not supported'),
          ),
        ),
      );
    });

    test(
      'when encoding object with toJson (not SerializableModel) then calls toJson',
      () {
        final obj = _ObjectWithToJson(42);
        final result = toEncodable(obj);

        expect(result, {'value': 42});
      },
    );

    test(
      'when encoding object without toJson then returns object unchanged',
      () {
        final obj = _ObjectWithoutToJson(42);
        final result = toEncodable(obj);

        expect(result, same(obj));
      },
    );
  });

  group('Given SerializationManager.toEncodableForProtocol', () {
    test(
      'when encoding ProtocolSerialization then calls toJsonForProtocol',
      () {
        final model = SimpleData(num: 42);
        final result = SerializationManager.toEncodableForProtocol(model);

        expect(result, isA<Map>());
        // ProtocolSerialization excludes certain fields - just verify it works
        expect((result as Map)['num'], 42);
      },
    );
  });

  test(
    'Given an enum serialized as string with a null value when serializing then the value is null',
    () {
      var types = Types();

      var encoded = SerializationManager.encode(types);
      var unpacked = protocol.decode<Types>(encoded);

      expect(unpacked.aStringifiedEnum, isNull);
    },
  );

  test(
    'Given a server-side enum serialized as string value when serializing then the value is unpacked correctly',
    () {
      var types = server.Types(
        aStringifiedEnum: server.TestEnumStringified.one,
      );

      var encoded = SerializationManager.encode(types);
      var unpacked = serverProtocol.decode<server.Types>(encoded);

      expect(unpacked.aStringifiedEnum, server.TestEnumStringified.one);
    },
  );

  test(
    'Given a server-side enum serialized as string with a null value when serializing then the value is null',
    () {
      var types = server.Types();

      var encoded = SerializationManager.encode(types);
      var unpacked = serverProtocol.decode<server.Types>(encoded);

      expect(unpacked.aStringifiedEnum, isNull);
    },
  );

  test(
    'Given an enum serialized as string value when serializing then the value is unpacked correctly',
    () {
      var types = Types(aStringifiedEnum: TestEnumStringified.one);

      var encoded = SerializationManager.encode(types);
      var unpacked = protocol.decode<Types>(encoded);

      expect(unpacked.aStringifiedEnum, TestEnumStringified.one);
    },
  );

  test(
    'Given a serializable object as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var type = Types(anInt: 123);
      var object = TypesMap(anObjectKey: {type: 'value'});

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(typesMap.anObjectKey?.entries.first.key.anInt, 123);
    },
  );

  test(
    'Given a DateTime as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var object = TypesMap(
        aDateTimeKey: {DateTime.parse('2024-01-01T00:00:00.000Z'): 'value'},
      );

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aDateTimeKey?.entries.first.key,
        DateTime.parse('2024-01-01T00:00:00.000Z'),
      );
    },
  );

  test(
    'Given a UuidValue as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      // ignore: deprecated_member_use
      var object = TypesMap(aUuidKey: {UuidValue.nil: 'value'});

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aUuidKey?.entries.first.key,
        // ignore: deprecated_member_use
        UuidValue.nil,
      );
    },
  );

  test(
    'Given a Uri as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var object = TypesMap(
        aUriKey: {Uri.parse('https://serverpod.dev'): 'value'},
      );

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aUriKey?.entries.first.key,
        Uri.parse('https://serverpod.dev'),
      );
    },
  );

  test(
    'Given a BigInt as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var object = TypesMap(aBigIntKey: {BigInt.two: 'value'});

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aBigIntKey?.entries.first.key,
        BigInt.two,
      );
    },
  );

  test(
    'Given a BigInt as a value in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var object = TypesMap(aBigIntValue: {'2': BigInt.two});

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aBigIntValue?['2'],
        BigInt.two,
      );
    },
  );

  test(
    'Given a ByteData as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var intList = Uint8List(8);
      for (var i = 0; i < intList.length; i++) {
        intList[i] = i;
      }

      var object = TypesMap(
        aByteDataKey: {ByteData.view(intList.buffer): 'value'},
      );

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aByteDataKey?.entries.first.key.buffer.asUint8List(),
        Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7]),
      );
    },
  );

  test(
    'Given a Duration as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var object = TypesMap(
        aDurationKey: {Duration(seconds: 1): 'value'},
      );

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aDurationKey?.entries.first.key.inMilliseconds,
        Duration(seconds: 1).inMilliseconds,
      );
    },
  );

  test(
    'Given a index serialized Enum as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var object = TypesMap(
        anEnumKey: {TestEnum.one: 'value'},
      );

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.anEnumKey?.entries.first.key,
        TestEnum.one,
      );
    },
  );

  test(
    'Given a name serialized Enum as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var object = TypesMap(
        aStringifiedEnumKey: {TestEnumStringified.one: 'value'},
      );

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aStringifiedEnumKey?.entries.first.key,
        TestEnumStringified.one,
      );
    },
  );

  test(
    'Given a Map as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var object = TypesMap(
        aMapKey: {
          {Types(anInt: 123): 'value'}: 'value',
        },
      );

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aMapKey?.entries.first.key.entries.first.key.anInt,
        123,
      );
    },
  );

  test(
    'Given a List as a key in a map when serializing and unpacking the original object remains unchanged.',
    () {
      var type = Types(anInt: 1);
      var object = TypesMap(
        aListKey: {
          [type]: 'value',
        },
      );

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(
        typesMap.aListKey?.entries.first.key.first.anInt,
        1,
      );
    },
  );

  test(
    'Given an empty map with an int key when serializing and unpacking the empty map is preserved.',
    () {
      var object = TypesMap(anIntKey: {});

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(typesMap.anIntKey, {});
    },
  );

  test(
    'Given an empty map with an SerializableModel key when serializing and unpacking the empty map is preserved.',
    () {
      var object = TypesMap(anObjectKey: {});

      var encodedString = SerializationManager.encode(object);
      var typesMap = Protocol().decode<TypesMap>(encodedString);

      expect(typesMap.anObjectKey, {});
    },
  );

  test(
    'Given a Serverpod defined model when encoding it with type then it is encoded',
    () {
      var serverProtocol = server.Protocol();
      var serverpodDefinedModel = serverpod.ClusterServerInfo(
        serverId: 'Hello World',
      );
      var encoded = serverProtocol.encodeWithType(serverpodDefinedModel);

      expect(encoded, isA<String>());
    },
  );

  test(
    'Given a project-defined Record type, when encoding it using `mapRecordToJson` then it is encoded',
    () {
      var recordAsJSON = Protocol().mapRecordToJson(
        (
          (1, '2'),
          namedSubRecord: (SimpleData(num: 3), 4.5),
        ),
      );

      expect(
        recordAsJSON,
        equals({
          'p': [
            {
              'p': [1, '2'],
            },
          ],
          'n': {
            'namedSubRecord': {
              'p': [
                {'__className__': 'SimpleData', 'num': 3},
                4.5,
              ],
            },
          },
        }),
      );
    },
  );

  test(
    'Given a Map with String keys and optional project-defined Record value type, when encoding it using `mapRecordContainingContainerToJson` then it is converted to a JSON map without records',
    () {
      var jsonMap = Protocol().mapContainerToJson(
        {
          'foo': (1, SimpleData(num: 2)),
          'bar': null,
        },
      );

      expect(
        jsonMap,
        isA<Map<String, dynamic>>()
            .having(
              (m) => m.length,
              'length',
              2,
            )
            .having((m) => m['foo'], 'foo entry', {
              "p": [
                1,
                {'__className__': 'SimpleData', 'num': 2},
              ],
            })
            .having(
              (m) => m['bar'],
              'bar entry',
              isNull,
            ),
      );

      // ensure this can be encoded as well
      expect(jsonEncode(jsonMap), isNotEmpty);
    },
  );

  test(
    'Given a List with optional project-defined Record value type, when encoding it using `mapRecordContainingContainerToJson` then it is converted to a JSON map without records',
    () {
      var jsonList = Protocol().mapContainerToJson([
        null,
        (1, SimpleData(num: 2)),
      ]);

      expect(
        jsonList,
        isA<List>()
            .having(
              (m) => m.length,
              'length',
              2,
            )
            .having(
              (m) => m.first,
              'first entry',
              isNull,
            )
            .having((m) => m.last, 'last entry', {
              "p": [
                1,
                {'__className__': 'SimpleData', 'num': 2},
              ],
            }),
      );

      // ensure this can be encoded as well
      expect(jsonEncode(jsonList), isNotEmpty);
    },
  );

  test(
    'Given a Set with optional project-defined Record value type, when encoding it using `mapRecordContainingContainerToJson` then it is converted to a JSON map without records',
    () {
      var jsonList = Protocol().mapContainerToJson({
        null,
        (1, SimpleData(num: 2)),
      });

      expect(
        jsonList,
        isA<List>()
            .having(
              (m) => m.length,
              'length',
              2,
            )
            .having(
              (m) => m.first,
              'first entry',
              isNull,
            )
            .having((m) => m.last, 'last entry', {
              "p": [
                1,
                {'__className__': 'SimpleData', 'num': 2},
              ],
            }),
      );

      // ensure this can be encoded as well
      expect(jsonEncode(jsonList), isNotEmpty);
    },
  );

  test(
    'Given a List containing Sets with optional project-defined Record value type, when encoding it using `mapRecordContainingContainerToJson` then it is converted to a JSON map without records',
    () {
      var jsonList = Protocol().mapContainerToJson([
        {
          null,
          (1, SimpleData(num: 2)),
        },
      ]);

      expect(
        jsonList,
        [
          [
            isNull,
            {
              "p": [
                1,
                {'__className__': 'SimpleData', 'num': 2},
              ],
            },
          ],
        ],
      );

      // ensure this can be encoded as well
      expect(jsonEncode(jsonList), isNotEmpty);
    },
  );

  test(
    'Given a leaf class in a hierarchy, when serializing it, then all its values are restored on decode.',
    () {
      final object = server.ParentClass(
        grandParentField: 'grand parent value',
        parentField: 'parent value',
      );

      var encodedString = server.Protocol().encodeWithType(object);
      var decodedObject = server.Protocol().decodeWithType(encodedString);

      expect(
        decodedObject,
        isA<server.ParentClass>()
            .having(
              (c) => c.grandParentField,
              'grandParentField',
              'grand parent value',
            )
            .having((c) => c.parentField, 'parentField', 'parent value'),
      );
    },
  );

  test(
    'Given a class with a empty `Map`s, when serializing it, then the empty maps are restored on decode.',
    () {
      final object = server.ObjectWithMaps(
        dataMap: {},
        intMap: {},
        stringMap: {},
        dateTimeMap: {},
        byteDataMap: {},
        nullableDataMap: {},
        nullableIntMap: {},
        nullableStringMap: {},
        nullableDateTimeMap: {},
        nullableByteDataMap: {},
        intIntMap: {},
        durationMap: {},
        nullableDurationMap: {},
        uuidMap: {},
        nullableUuidMap: {},
      );

      var encodedString = server.Protocol().encodeWithType(object);
      var decodedObject = server.Protocol().decodeWithType(encodedString);

      expect(
        decodedObject,
        isA<server.ObjectWithMaps>()
            .having((o) => o.dataMap, 'dataMap', isEmpty)
            .having((o) => o.intMap, 'intMap', isEmpty)
            .having((o) => o.stringMap, 'stringMap', isEmpty)
            .having((o) => o.dateTimeMap, 'dateTimeMap', isEmpty)
            .having((o) => o.byteDataMap, 'byteDataMap', isEmpty)
            .having((o) => o.durationMap, 'durationMap', isEmpty)
            .having((o) => o.uuidMap, 'uuidMap', isEmpty)
            .having((o) => o.nullableDataMap, 'nullableDataMap', isEmpty)
            .having((o) => o.nullableIntMap, 'nullableIntMap', isEmpty)
            .having((o) => o.nullableStringMap, 'nullableStringMap', isEmpty)
            .having(
              (o) => o.nullableDateTimeMap,
              'nullableDateTimeMap',
              isEmpty,
            )
            .having(
              (o) => o.nullableByteDataMap,
              'nullableByteDataMap',
              isEmpty,
            )
            .having(
              (o) => o.nullableDurationMap,
              'nullableDurationMap',
              isEmpty,
            )
            .having((o) => o.intIntMap, 'intIntMap', isEmpty),
      );
    },
  );
}

/// Test helper: object with toJson() but not implementing SerializableModel.
class _ObjectWithToJson {
  final int value;
  _ObjectWithToJson(this.value);

  Map<String, dynamic> toJson() => {'value': value};
}

/// Test helper: object without toJson() method.
class _ObjectWithoutToJson {
  final int value;
  _ObjectWithoutToJson(this.value);
}
