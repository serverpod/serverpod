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

  group('ServerHeader Class Tests', () {
    test('ServerHeader should parse server name and version', () {
      var headerValue = 'nginx/1.18.0';
      var serverHeader = ServerHeader.fromHeaderValue(headerValue);

      expect(serverHeader.name, equals('nginx'));
      expect(serverHeader.version, equals('1.18.0'));
    });

    test('ServerHeader should parse server name without version', () {
      var headerValue = 'Apache';
      var serverHeader = ServerHeader.fromHeaderValue(headerValue);

      expect(serverHeader.name, equals('Apache'));
      expect(serverHeader.version, isNull);
    });

    test('ServerHeader should return null when parsing a null value', () {
      var serverHeader = ServerHeader.tryParse(null);
      expect(serverHeader, isNull);
    });

    test('ServerHeader should return valid string representation with version',
        () {
      var serverHeader = ServerHeader(name: 'nginx', version: '1.18.0');
      var result = serverHeader.toString();

      expect(result, equals('nginx/1.18.0'));
    });

    test(
        'ServerHeader should return valid string representation without version',
        () {
      var serverHeader = ServerHeader(name: 'Apache');
      var result = serverHeader.toString();

      expect(result, equals('Apache'));
    });
  });

  group('ServerHeader HttpRequest Tests', () {
    test('Given a valid Server header, it should parse correctly', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Server': 'nginx/1.18.0'},
      );
      var serverHeader = headers.server;

      expect(serverHeader!.name, equals('nginx'));
      expect(serverHeader.version, equals('1.18.0'));
    });

    test('Given a Server header with only name, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Server': 'Apache'},
      );
      var serverHeader = headers.server;

      expect(serverHeader!.name, equals('Apache'));
      expect(serverHeader.version, isNull);
    });
  });
}
