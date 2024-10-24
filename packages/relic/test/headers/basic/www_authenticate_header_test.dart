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

  group('WWW-Authenticate Header Tests', () {
    test('Given a valid WWW-Authenticate header, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'www-authenticate': 'Basic realm="example"'},
      );

      expect(headers.wwwAuthenticate, equals(['Basic realm="example"']));
    });

    test('Given no WWW-Authenticate header, it should return null', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.wwwAuthenticate, isNull);
    });

    test('Given an empty WWW-Authenticate header, it should return null',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'www-authenticate': ''},
      );

      expect(headers.wwwAuthenticate, isNull);
    });

    test(
        'Given a WWW-Authenticate header with complex schemes, it should parse correctly',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'www-authenticate':
              'Digest realm="example", qop="auth", nonce="abc123"',
        },
      );

      expect(
        headers.wwwAuthenticate,
        equals(['Digest realm="example"', 'qop="auth"', 'nonce="abc123"']),
      );
    });
  });
}
