import 'dart:io';
import 'package:relic/relic.dart';
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

  group('Access-Control-Allow-Origin Header Tests', () {
    test(
        'Given a valid Access-Control-Allow-Origin header, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-allow-origin': 'https://example.com'},
      );

      expect(headers.accessControlAllowOrigin,
          equals(Uri.parse('https://example.com')));
    });

    test('Given no Access-Control-Allow-Origin header, it should be null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.accessControlAllowOrigin, isNull);
    });

    test(
        'Given an empty Access-Control-Allow-Origin header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-allow-origin': ''},
      );

      expect(headers.accessControlAllowOrigin, isNull);
    });

    test(
        'Given mixed-case Access-Control-Allow-Origin headers, it should normalize and the last one should take precedence',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'Access-Control-Allow-Origin': 'https://example.com',
          'ACCESS-CONTROL-ALLOW-ORIGIN': 'https://sub.example.com',
        },
      );

      expect(
        headers.accessControlAllowOrigin,
        equals(Uri.parse('https://sub.example.com')),
      );
    });
  });
}
