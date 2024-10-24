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

  group('Access-Control-Request-Headers Tests', () {
    test(
        'Given a valid Access-Control-Request-Headers header, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-request-headers': 'X-Custom-Header'},
      );

      expect(headers.accessControlRequestHeaders, equals(['X-Custom-Header']));
    });

    test(
        'Given multiple Access-Control-Request-Headers values, it should parse all values correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'access-control-request-headers': 'X-Custom-Header, X-Another-Header'
        },
      );

      expect(headers.accessControlRequestHeaders,
          equals(['X-Custom-Header', 'X-Another-Header']));
    });

    test('Given no Access-Control-Request-Headers header, it should be null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.accessControlRequestHeaders, isNull);
    });

    test(
        'Given an empty Access-Control-Request-Headers header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-request-headers': ''},
      );

      expect(headers.accessControlRequestHeaders, isNull);
    });

    test(
        'Given an Access-Control-Request-Headers header with multiple values in a single string, it should split them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'access-control-request-headers': 'X-Custom-Header, X-Another-Header'
        },
      );

      expect(headers.accessControlRequestHeaders,
          equals(['X-Custom-Header', 'X-Another-Header']));
    });
  });
}
