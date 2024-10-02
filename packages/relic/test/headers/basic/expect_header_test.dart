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

  group('Expect Header Tests', () {
    test('Given a valid Expect header, it should parse correctly', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'expect': '100-continue'},
      );

      expect(headers.expect, equals('100-continue'));
    });

    test('Given no Expect header, it should be null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.expect, isNull);
    });

    test('Given an empty Expect header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'expect': ''},
      );

      expect(headers.expect, isNull);
    });

    test('Given a non-empty Expect header, it should return the correct value',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'expect': '200-ok'},
      );

      expect(headers.expect, equals('200-ok'));
    });
  });
}
