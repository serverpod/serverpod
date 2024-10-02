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

  group('Referer Header Tests', () {
    test('Given a valid Referer header, it should parse correctly as a URI',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Referer': 'https://example.com/page'},
      );

      expect(headers.referer, equals(Uri.parse('https://example.com/page')));
    });

    test('Given no Referer header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.referer, isNull);
    });

    test('Given an empty Referer header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'Referer': ''},
      );

      expect(headers.referer, isNull);
    });
  });
}
