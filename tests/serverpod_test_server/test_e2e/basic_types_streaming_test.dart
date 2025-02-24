import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

import '../test/serialization_legacy_test.dart' show createByteData;

void main() {
  var client = Client(serverUrl);

  test(
      'Given the test server, when an int stream is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypesStreaming
        .testInt(Stream.fromIterable([0, null, 1]))
        .toList();

    expect(result, equals([0, null, 1]));
  });

  test(
      'Given the test server, when a double stream is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypesStreaming
        .testDouble(Stream.fromIterable([1.2, null, 3.4]))
        .toList();

    expect(result, equals([1.2, null, 3.4]));
  });

  test(
      'Given the test server, when a boolean stream is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypesStreaming
        .testBool(Stream.fromIterable([true, null, false]))
        .toList();

    expect(result, equals([true, null, false]));
  });

  test(
      'Given the test server, when a string stream is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.basicTypesStreaming
        .testString(Stream.fromIterable(['first', 'null', null, 'last']))
        .toList();

    expect(result, equals(['first', 'null', null, 'last']));
  });

  test(
      'Given the test server, when a `DateTime` stream is sent to the server, then it is returned verbatim',
      () async {
    var dateTime = DateTime.utc(1976, 9, 10, 2, 10);

    var result = await client.basicTypesStreaming
        .testDateTime(Stream.fromIterable([dateTime, null]))
        .toList();

    expect(result, equals([dateTime, null]));
  });

  test(
      'Given the test server, when some `ByteData` stream is sent to the server, then it is returned verbatim',
      () async {
    final byteData1 = createByteData();
    final byteData2 = createByteData();

    var result = await client.basicTypesStreaming
        .testByteData(Stream.fromIterable([byteData1, null, byteData2]))
        .toList();

    expect(result, hasLength(3));
    expect(result.first!.lengthInBytes, byteData1.lengthInBytes);
    expect(result.elementAt(1), isNull);
    expect(result.last!.lengthInBytes, byteData1.lengthInBytes);
  });

  test(
      'Given the test server, when a `Duration` stream is sent to the server, then it is returned verbatim',
      () async {
    var duration = const Duration(seconds: 1);

    var result = await client.basicTypesStreaming
        .testDuration(Stream.fromIterable([duration, null]))
        .toList();

    expect(result, equals([duration, null]));
  });

  test(
      'Given the test server, when a UUID stream is sent to the server, then it is returned verbatim',
      () async {
    var uuid = UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11');

    var result = await client.basicTypesStreaming
        .testUuid(Stream.fromIterable([uuid, null]))
        .toList();

    expect(result, equals([uuid, null]));
  });

  test(
      'Given the test server, when a `Uri` stream is sent to the server, then it is returned verbatim',
      () async {
    var uri =
        Uri.parse('https://docs.serverpod.dev/contribute#working-on-serverpod');

    var result = await client.basicTypesStreaming
        .testUri(Stream.fromIterable([uri, null]))
        .toList();

    expect(result, equals([uri, null]));
  });

  test(
      'Given the test server, when a `BigInt` stream is sent to the server, then it is returned verbatim',
      () async {
    var bigInt = BigInt.parse('-12345678901234567890');
    var bigInt2 = BigInt.parse('12345678901234567890');

    var result = await client.basicTypesStreaming
        .testBigInt(Stream.fromIterable([bigInt, null, bigInt2]))
        .toList();

    expect(result, equals([bigInt, null, bigInt2]));
  });
}
