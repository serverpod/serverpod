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

  group('Content-Encoding Header Tests', () {
    test(
        'Given a valid Content-Encoding header with a single value, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-encoding': 'gzip'},
      );

      expect(headers.contentEncoding, equals(['gzip']));
    });

    test(
        'Given a valid Content-Encoding header with multiple values, it should parse all values',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-encoding': 'gzip, compress'},
      );

      expect(headers.contentEncoding, equals(['gzip', 'compress']));
    });

    test(
        'Given a Content-Encoding header with multiple values in a single string, it should split and parse them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-encoding': 'gzip, compress'},
      );

      expect(headers.contentEncoding, equals(['gzip', 'compress']));
    });

    test('Given an empty Content-Encoding header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-encoding': ''},
      );

      expect(headers.contentEncoding, isNull);
    });

    test('Given no Content-Encoding header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.contentEncoding, isNull);
    });
  });
}
