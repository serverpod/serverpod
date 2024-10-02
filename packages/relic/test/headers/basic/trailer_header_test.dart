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

  group('Trailer Header Tests', () {
    test('Given a valid Trailer header, it should parse correctly as a list',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'trailer': 'content-md5, etag'},
      );

      expect(headers.trailer, equals(['content-md5', 'etag']));
    });

    test('Given no Trailer header, it should be null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.trailer, isNull);
    });

    test('Given an empty Trailer header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'trailer': ''},
      );

      expect(headers.trailer, isNull);
    });

    test(
        'Given a Trailer header with multiple values as a single string, it should split them correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'trailer': 'content-md5, etag'},
      );

      expect(headers.trailer, equals(['content-md5', 'etag']));
    });
  });
}
