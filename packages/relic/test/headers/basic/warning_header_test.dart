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

  group('Warning Header Tests', () {
    test('Given a valid Warning header, it should parse correctly', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'warning': '199 example.com "Miscellaneous warning"'},
      );

      expect(
        headers.warning,
        equals(['199 example.com "Miscellaneous warning"']),
      );
    });

    test('Given no Warning header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.warning, isNull);
    });

    test('Given an empty Warning header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'warning': ''},
      );

      expect(headers.warning, isNull);
    });
  });
}
