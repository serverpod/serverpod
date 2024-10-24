import 'dart:io';
import 'package:relic/src/headers.dart';
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';

import '../../test_util.dart';

void main() {
  late RelicServer server;

  setUp(() async {
    try {
      server = await RelicServer.bind(InternetAddress.loopbackIPv6, 0);
    } on SocketException catch (_) {
      server = await RelicServer.bind(InternetAddress.loopbackIPv4, 0);
    }
  });

  tearDown(() => server.close());

  group('Allow Header Tests', () {
    test(
        'Given a valid Allow header with one method, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'allow': 'GET'},
      );

      expect(headers.allow?.length, equals(1));
      expect(headers.allow?.first.value, equals('GET'));
    });

    test(
        'Given a valid Allow header with multiple methods, it should parse all values',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'allow': 'GET, POST, DELETE'},
      );

      var allow = headers.allow;
      expect(allow?.length, equals(3));
      expect(allow?.map((method) => method.value),
          equals(['GET', 'POST', 'DELETE']));
    });

    test(
        'Given an invalid Allow header, it should parse the method as a custom value',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'allow': 'CUSTOM_METHOD'},
      );

      var allow = headers.allow;
      expect(allow?.length, equals(1));
      expect(allow?.first.value, equals('CUSTOM_METHOD'));
    });

    test('Given no Allow header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.allow, isNull);
    });

    test('Given an empty Allow header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'allow': ''},
      );

      expect(headers.allow, isNull);
    });

    test(
        'Given a valid Allow header with multiple values separated by commas, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'allow': 'GET,POST,DELETE'},
      );

      var allow = headers.allow;
      expect(allow?.length, equals(3));
      expect(allow?.map((method) => method.value),
          equals(['GET', 'POST', 'DELETE']));
    });
  });
}
