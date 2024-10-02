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

  group('Upgrade Header Tests', () {
    test(
        'Given a valid Upgrade header with one value, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'upgrade': 'websocket'},
      );

      expect(headers.upgrade, equals(['websocket']));
    });

    test(
        'Given a valid Upgrade header with multiple values, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'upgrade': 'websocket, HTTP/2'},
      );

      expect(headers.upgrade, equals(['websocket', 'HTTP/2']));
    });

    test('Given no Upgrade header, it should be null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.upgrade, isNull);
    });

    test('Given an empty Upgrade header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'upgrade': ''},
      );

      expect(headers.upgrade, isNull);
    });

    test(
        'Given an Upgrade header with multiple values as a single string, it should split them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'upgrade': 'websocket, HTTP/2'},
      );

      expect(headers.upgrade, equals(['websocket', 'HTTP/2']));
    });
  });
}
