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

  group('Content-Location Header Tests', () {
    test(
        'Given a valid absolute Content-Location header, it should parse as a Uri',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-location': 'https://example.com/resource'},
      );

      expect(
        headers.contentLocation,
        equals(Uri.parse('https://example.com/resource')),
      );
    });

    test(
        'Given a valid relative Content-Location header, it should parse as a Uri',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-location': '/relative/path'},
      );

      expect(headers.contentLocation, equals(Uri.parse('/relative/path')));
    });

    test('Given an empty Content-Location header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'content-location': ''},
      );

      expect(headers.contentLocation, isNull);
    });

    test('Given no Content-Location header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.contentLocation, isNull);
    });
  });
}
