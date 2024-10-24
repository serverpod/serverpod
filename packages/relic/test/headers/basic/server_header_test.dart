import 'dart:io';

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

  group('ServerHeader HttpRequest Tests', () {
    test('Given a valid Server header, it should parse correctly', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Server': 'nginx/1.18.0'},
      );

      expect(headers.server, equals('nginx/1.18.0'));
    });

    test('Given a Server header with only name, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Server': 'Apache'},
      );

      expect(headers.server, equals('Apache'));
    });

    test('Given no Server header, server header should be null', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.server, isNull);
    });

    test('Given an empty Server header, server header should return null',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Server': ''},
      );

      expect(headers.server, isNull);
    });

    test(
        'Given a Server header with additional whitespace, it should trim the value',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Server': '  nginx/1.18.0  '},
      );

      expect(headers.server, equals('nginx/1.18.0'));
    });
  });
}
