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

  group('Access-Control-Max-Age Header Tests', () {
    test(
        'Given a valid Access-Control-Max-Age header, it should parse correctly as an integer',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-max-age': '3600'},
      );

      expect(headers.accessControlMaxAge, equals(3600));
    });

    test(
        'Given an invalid Access-Control-Max-Age header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-max-age': 'invalid-value'},
      );

      expect(headers.accessControlMaxAge, isNull);
    });

    test('Given an empty Access-Control-Max-Age header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'access-control-max-age': ''},
      );

      expect(headers.accessControlMaxAge, isNull);
    });

    test('Given no Access-Control-Max-Age header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.accessControlMaxAge, isNull);
    });
  });
}
