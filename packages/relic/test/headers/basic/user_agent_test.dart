import 'package:relic/src/headers.dart';
import 'package:test/test.dart';
import 'package:relic/src/relic_server.dart';
import 'dart:io';
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

  group('User-Agent Header Tests', () {
    test('Given a valid User-Agent header, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'user-agent': 'Mozilla/5.0'},
      );

      expect(headers.userAgent, equals('Mozilla/5.0'));
    });

    test('Given no User-Agent header, it should be empty', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.userAgent, isNotEmpty);
    });

    test('Given an empty User-Agent header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'user-agent': ''},
      );

      expect(headers.userAgent, isNull);
    });
  });
}
