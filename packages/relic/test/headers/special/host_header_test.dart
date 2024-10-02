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

  group('HostHeader Class Tests', () {
    test('HostHeader should parse valid host with port correctly', () {
      var headerValue = 'example.com:8080';
      var hostHeader = HostHeader.fromHeaderValue(headerValue);

      expect(
        hostHeader.host,
        equals('example.com'),
      );
      expect(
        hostHeader.port,
        equals(8080),
      );
    });

    test('HostHeader should parse valid host without port correctly', () {
      var headerValue = 'example.com';
      var hostHeader = HostHeader.fromHeaderValue(headerValue);

      expect(
        hostHeader.host,
        equals('example.com'),
      );
      expect(hostHeader.port, isNull);
    });

    test('HostHeader should handle invalid port and throw FormatException', () {
      var headerValue = 'example.com:invalid';

      expect(
        () => HostHeader.fromHeaderValue(headerValue),
        throwsFormatException,
      );
    });

    test(
        'HostHeader should return valid string representation of host and port',
        () {
      var hostHeader = HostHeader.fromHeaderValue('example.com:8080');
      var result = hostHeader.toString();

      expect(
        result,
        equals('example.com:8080'),
      );
    });

    test(
        'HostHeader should return valid string representation of host without port',
        () {
      var hostHeader = HostHeader.fromHeaderValue('example.com');
      var result = hostHeader.toString();

      expect(
        result,
        equals('example.com'),
      );
    });

    test('HostHeader should return null when trying to parse null value', () {
      var hostHeader = HostHeader.tryParse(null);
      expect(hostHeader, isNull);
    });
  });

  group('HostHeader HttpRequest Tests', () {
    test('Given a valid Host header with port, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Host': 'example.com:8080'},
      );
      var hostHeader = headers.host;

      expect(
        hostHeader?.host,
        equals('example.com'),
      );
      expect(
        hostHeader?.port,
        equals(8080),
      );
    });

    test('Given a valid Host header without port, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Host': 'example.com'},
      );
      var hostHeader = headers.host;

      expect(
        hostHeader?.host,
        equals('example.com'),
      );
      expect(
        hostHeader?.port,
        isNotNull,
      );
    });

    test(
        'Given an invalid port in Host header, it should throw a FormatException',
        () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'Host': 'example.com:invalid'},
        ),
        throwsFormatException,
      );
    });
  });
}
