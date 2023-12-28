import 'dart:convert';

import 'package:serverpod/serverpod.dart';
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
    var unpacked = protocol.deserialize<Types>(jsonDecode(encoded));

    expect(unpacked.aStringifiedEnum, isNull);
  });

  test(
      'Given a server-side enum serialized as string value when serializing then the value is unpacked correctly',
      () {
    var types = server.Types(aStringifiedEnum: server.TestEnumStringified.one);

    var encoded = SerializationManager.encode(types);
    var unpacked = serverProtocol.deserialize<server.Types>(jsonDecode(encoded));

    expect(unpacked.aStringifiedEnum, server.TestEnumStringified.one);
  });

  test(
      'Given a server-side enum serialized as string with a null value when serializing then the value is null',
      () {
    var types = server.Types();

    var encoded = SerializationManager.encode(types);
    var unpacked = serverProtocol.deserialize<server.Types>(jsonDecode(encoded));

    expect(unpacked.aStringifiedEnum, isNull);
  });

  test(
      'Given an enum serialized as string value when serializing then the value is unpacked correctly',
      () {
    var types = Types(aStringifiedEnum: TestEnumStringified.one);

    var encoded = SerializationManager.encode(types);
    var unpacked = protocol.deserialize<Types>(jsonDecode(encoded));

    expect(unpacked.aStringifiedEnum, TestEnumStringified.one);
  });

  test(
      'Given a class with a nested serverpod object when serializing and unpacking then the origin value remains unchanged.',
      () {
    var type = server.ObjectWithServerpodObject(
      logLevel1: LogLevel.debug,
      logLevel2: LogLevel.error,
    );

    var encoded = SerializationManager.encode(type);
    var unpacked = serverProtocol
        .deserialize<server.ObjectWithServerpodObject>(jsonDecode(encoded));

    expect(unpacked.logLevel1, LogLevel.debug);
    expect(unpacked.logLevel2, LogLevel.error);
  });
}
