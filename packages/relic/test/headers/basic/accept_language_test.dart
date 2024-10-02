import 'dart:io';
import 'package:relic/src/headers.dart';
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';

import '../../static/test_util.dart';

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

  group('Accept-Language Header Tests', () {
    test('Given a valid Accept-Language header, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept-language': 'en-US'},
      );

      expect(headers.acceptLanguage, equals(['en-US']));
    });

    test(
        'Given multiple Accept-Language values in a single string, it should parse and normalize correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept-language': 'en-US, fr-CA'},
      );

      expect(headers.acceptLanguage, equals(['en-US', 'fr-CA']));
    });

    test('Given no Accept-Language header, it should be null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.acceptLanguage, isNull);
    });

    test('Given an empty Accept-Language header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept-language': ''},
      );

      expect(headers.acceptLanguage, isNull);
    });
  });
}
