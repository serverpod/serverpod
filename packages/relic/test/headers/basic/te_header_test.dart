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

  group('TE Header Tests', () {
    test('Given a valid TE header with one value, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'te': 'gzip'},
      );

      expect(headers.te, equals(['gzip']));
    });

    test(
        'Given a valid TE header with multiple values, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'te': 'gzip, deflate'},
      );

      expect(headers.te, equals(['gzip', 'deflate']));
    });

    test('Given no TE header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.te, isNull);
    });

    test('Given an empty TE header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'te': ''},
      );

      expect(headers.te, isNull);
    });

    test(
        'Given a TE header with multiple values as a single string, it should split them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'te': 'gzip, chunked'},
      );

      expect(headers.te, equals(['gzip', 'chunked']));
    });
  });
}
