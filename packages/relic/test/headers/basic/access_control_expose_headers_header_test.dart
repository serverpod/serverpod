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

  group('Access-Control-Expose-Headers Tests', () {
    test(
        'Given valid Access-Control-Expose-Headers, it should parse as a list of values',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'access-control-expose-headers': 'X-Custom-Header1, X-Custom-Header2',
        },
      );

      expect(headers.accessControlExposeHeaders,
          equals(['X-Custom-Header1', 'X-Custom-Header2']));
    });

    test(
        'Given a single Access-Control-Expose-Headers value with multiple entries, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'access-control-expose-headers': 'X-Custom-Header1, X-Custom-Header2',
        },
      );

      expect(headers.accessControlExposeHeaders,
          equals(['X-Custom-Header1', 'X-Custom-Header2']));
    });

    test('Given an empty Access-Control-Expose-Headers, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-expose-headers': ''},
      );

      expect(headers.accessControlExposeHeaders, isNull);
    });

    test('Given no Access-Control-Expose-Headers, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.accessControlExposeHeaders, isNull);
    });
  });
}
