import 'package:relic/src/headers.dart';
import 'package:test/test.dart';
import 'package:relic/src/relic_server.dart';
import 'dart:io';
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

  group('X-Powered-By Header Tests', () {
    test('Given a valid X-Powered-By header, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'x-powered-by': 'Dart'},
      );

      expect(headers.xPoweredBy, equals('Dart'));
    });

    test('Given an empty X-Powered-By header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'x-powered-by': ''},
      );

      expect(headers.xPoweredBy, isNull);
    });

    test('Given no X-Powered-By header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.xPoweredBy, isNull);
    });
  });
}
