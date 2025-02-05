import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

import '../test/serialization_legacy_test.dart' show createByteData;

void main() {
  var client = Client(serverUrl);

  test(
      'Given the test server, when an int is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypes.testInt(10);
    expect(result, equals(10));
  });

  test(
      'Given the test server, when a `null` `int?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testInt(null);
    expect(result, isNull);
  });

  test(
      'Given the test server, when a double is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypes.testDouble(10.0);
    expect(result, equals(10.0));
  });

  test(
      'Given the test server, when a `null` `double?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testDouble(null);
    expect(result, isNull);
  });

  test(
      'Given the test server, when a boolean is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypes.testBool(true);
    expect(result, equals(true));
  });

  test(
      'Given the test server, when a `null` `bool?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testBool(null);
    expect(result, isNull);
  });

  test(
      'Given the test server, when a string is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypes.testString('test');
    expect(result, 'test');
  });

  test(
      'Given the test server, when a string "null" is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypes.testString('null');
    expect(result, 'null');
  });

  test(
      'Given the test server, when a `null` `String?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testString(null);
    expect(result, isNull);
  });

  test(
      'Given the test server, when a `DateTime` is sent to the server, then it is returned verbatim',
      () async {
    var dateTime = DateTime.utc(1976, 9, 10, 2, 10);

    var result = await client.basicTypes.testDateTime(dateTime);
    expect(result!, equals(dateTime));
  });

  test(
      'Given the test server, when a `null` `DateTime?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testDateTime(null);
    expect(result, isNull);
  });

  test(
      'Given the test server, when some binary data is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypes.testByteData(createByteData());
    expect(result!.lengthInBytes, equals(256));
  });

  test(
      'Given the test server, when a `null` `ByteData?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testByteData(null);
    expect(result, isNull);
  });

  test(
      'Given the test server, when a `Duration` is sent to the server, then it is returned verbatim',
      () async {
    var duration = const Duration(seconds: 1);

    var result = await client.basicTypes.testDuration(duration);
    expect(result, equals(duration));
  });

  test(
      'Given the test server, when a `null` `Duration?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testDuration(null);
    expect(result, isNull);
  });

  test(
      'Given the test server, when a UUID is sent to the server, then it is returned verbatim',
      () async {
    var uuid = UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11');

    var result = await client.basicTypes.testUuid(uuid);
    expect(result, equals(uuid));
  });

  test(
      'Given the test server, when a `null` `UuidValue?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testUuid(null);
    expect(result, isNull);
  });

  test(
      'Given the test server, when a `Uri` is sent to the server, then it is returned verbatim',
      () async {
    var uri =
        Uri.parse('https://docs.serverpod.dev/contribute#working-on-serverpod');

    var result = await client.basicTypes.testUri(uri);
    expect(result, equals(uri));
  });

  test(
      'Given the test server, when a `null` `Uri?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testUri(null);
    expect(result, isNull);
  });

  test(
      'Given the test server, when a `BigInt` is sent to the server, then it is returned verbatim',
      () async {
    var bigInt = BigInt.parse('-12345678901234567890');

    var result = await client.basicTypes.testBigInt(bigInt);
    expect(result, equals(bigInt));
  });

  test(
      'Given the test server, when a `null` `BigInt?` is sent to the server, then `null` is returned',
      () async {
    var result = await client.basicTypes.testBigInt(null);
    expect(result, isNull);
  });
}
