import 'dart:io';
import 'package:relic/relic.dart';
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

  group('Accept-Encoding Header Tests', () {
    test('Given a valid Accept-Encoding header, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept-encoding': 'gzip'},
      );

      expect(headers.acceptEncoding, equals(['gzip']));
    });

    test(
        'Given multiple Accept-Encoding values, it should parse all values correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'accept-encoding': 'gzip, deflate',
        },
      );

      expect(headers.acceptEncoding, equals(['gzip', 'deflate']));
    });

    test('Given no Accept-Encoding header, it should default to gzip',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.acceptEncoding, equals(['gzip']));
    });

    test('Given an empty Accept-Encoding header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept-encoding': ''},
      );

      expect(headers.acceptEncoding, isNull);
    });

    test(
        'Given multiple Accept-Encoding headers, it should keep the last value',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'accept-encoding': 'gzip',
          'ACCEPT-ENCODING': 'deflate',
        },
      );

      expect(headers.acceptEncoding, equals(['deflate']));
    });

    test(
        'Given an Accept-Encoding header with multiple values in a single string, it should split them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept-encoding': 'gzip, deflate'},
      );

      expect(headers.acceptEncoding, equals(['gzip', 'deflate']));
    });
  });
}
