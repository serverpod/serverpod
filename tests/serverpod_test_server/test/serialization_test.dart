import 'dart:convert';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

void main() {
  var protocol = Protocol();

  test(
      'Given an enum serialized as string with a null value when serializing then the value is null',
      () {
    var types = Types();

    var encoded = SerializationManager.encode(types);
    var unpacked = protocol.deserialize<Types>(jsonDecode(encoded));

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
}
