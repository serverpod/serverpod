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

  group('Location Header Tests', () {
    test(
        'Given a valid absolute Location header, it should parse correctly as a URI',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'location': 'https://example.com/resource'},
      );

      expect(
          headers.location.toString(), equals('https://example.com/resource'));
    });

    test('Given a relative Location header, it should parse correctly as a URI',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'location': '/relative/path'},
      );

      expect(headers.location.toString(), equals('/relative/path'));
    });

    test('Given an empty Location header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'location': ''},
      );

      expect(headers.location, isNull);
    });

    test('Given no Location header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.location, isNull);
    });
  });
}
