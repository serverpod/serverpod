import 'dart:typed_data';

import 'package:serverpod/protocol.dart' as serverpod;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:test/test.dart';

void main() {
  var protocol = Protocol();
  var serverProtocol = server.Protocol();

  test(
      'Given an enum serialized as string with a null value when serializing then the value is null',
      () {
    var types = Types();

    var encoded = SerializationManager.encode(types);
    var unpacked = protocol.decode<Types>(encoded);

    expect(unpacked.aStringifiedEnum, isNull);
  });

  test(
      'Given a server-side enum serialized as string value when serializing then the value is unpacked correctly',
      () {
    var types = server.Types(aStringifiedEnum: server.TestEnumStringified.one);

    var encoded = SerializationManager.encode(types);
    var unpacked = serverProtocol.decode<server.Types>(encoded);

    expect(unpacked.aStringifiedEnum, server.TestEnumStringified.one);
  });

  test(
      'Given a server-side enum serialized as string with a null value when serializing then the value is null',
      () {
    var types = server.Types();

    var encoded = SerializationManager.encode(types);
    var unpacked = serverProtocol.decode<server.Types>(encoded);

    expect(unpacked.aStringifiedEnum, isNull);
  });

  test(
      'Given an enum serialized as string value when serializing then the value is unpacked correctly',
      () {
    var types = Types(aStringifiedEnum: TestEnumStringified.one);

    var encoded = SerializationManager.encode(types);
    var unpacked = protocol.decode<Types>(encoded);

    expect(unpacked.aStringifiedEnum, TestEnumStringified.one);
  });

  test(
      'Given a serializable object as a key in a map when serializing and unpacking the original object remains unchanged.',
      () {
    var type = Types(anInt: 123);
    var object = TypesMap(anObjectKey: {type: 'value'});

    var encodedString = SerializationManager.encode(object);
    var typesMap = Protocol().decode<TypesMap>(encodedString);

    expect(typesMap.anObjectKey?.entries.first.key.anInt, 123);
  });

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
  });

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
  });

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
  });

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
  });

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
  });

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
  });

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
  });

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
  });

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
  });

  test(
      'Given a List as a key in a map when serializing and unpacking the original object remains unchanged.',
      () {
    var type = Types(anInt: 1);
    var object = TypesMap(
      aListKey: {
        [type]: 'value'
      },
    );

    var encodedString = SerializationManager.encode(object);
    var typesMap = Protocol().decode<TypesMap>(encodedString);

    expect(
      typesMap.aListKey?.entries.first.key.first.anInt,
      1,
    );
  });

  test(
      'Given an empty map with an int key when serializing and unpacking the empty map is preserved.',
      () {
    var object = TypesMap(anIntKey: {});

    var encodedString = SerializationManager.encode(object);
    var typesMap = Protocol().decode<TypesMap>(encodedString);

    expect(typesMap.anIntKey, {});
  });

  test(
      'Given an empty map with an SerializableModel key when serializing and unpacking the empty map is preserved.',
      () {
    var object = TypesMap(anObjectKey: {});

    var encodedString = SerializationManager.encode(object);
    var typesMap = Protocol().decode<TypesMap>(encodedString);

    expect(typesMap.anObjectKey, {});
  });

  test(
      'Given a Serverpod defined model when encoding it with type then it is encoded',
      () {
    var serverProtocol = server.Protocol();
    var serverpodDefinedModel =
        serverpod.ClusterServerInfo(serverId: 'Hello World');
    var encoded = serverProtocol.encodeWithType(serverpodDefinedModel);

    expect(encoded, isA<String>());
  });
}
