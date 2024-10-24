import 'dart:io';

import 'package:relic/src/headers.dart';
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

  group('AcceptHeader Class Tests', () {
    test('AcceptHeader should parse valid header values correctly', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept': 'text/html, application/json'},
      );

      var acceptHeader = headers.accept;

      expect(acceptHeader!.mediaTypes.length, equals(2));
      expect(acceptHeader.mediaTypes[0].mimeType, equals('text/html'));
      expect(acceptHeader.mediaTypes[1].mimeType, equals('application/json'));
    });

    test('AcceptHeader should handle MIME types with quality values (q)',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept': 'text/html; q=0.8, application/json; q=0.9'},
      );

      var acceptHeader = headers.accept;

      expect(acceptHeader!.mediaTypes.length, equals(2));
      expect(acceptHeader.mediaTypes[0].mimeType, equals('text/html'));
      expect(acceptHeader.mediaTypes[0].parameters['q'], equals('0.8'));
      expect(acceptHeader.mediaTypes[1].mimeType, equals('application/json'));
      expect(acceptHeader.mediaTypes[1].parameters['q'], equals('0.9'));
    });

    test('AcceptHeader should return null when trying to parse a null value',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.accept, isNull);
    });

    test('AcceptHeader should handle an empty Accept header', () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept': ''},
      );

      expect(headers.accept, isNull);
    });

    test('AcceptHeader should return valid string representation of header',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {'accept': 'text/html, application/json'},
      );

      var acceptHeader = headers.accept;
      var result = acceptHeader.toString();

      expect(result, equals('text/html, application/json'));
    });

    test('AcceptHeader should handle complex MIME types with parameters',
        () async {
      Headers headers = await getServerRequestHeaders(
        server: server,
        headers: {
          'accept': 'text/html; charset=utf-8, application/json; version=1.0'
        },
      );

      var acceptHeader = headers.accept;

      expect(acceptHeader!.mediaTypes.length, equals(2));
      expect(acceptHeader.mediaTypes[0].mimeType, equals('text/html'));
      expect(acceptHeader.mediaTypes[0].parameters['charset'], equals('utf-8'));
      expect(acceptHeader.mediaTypes[1].mimeType, equals('application/json'));
      expect(acceptHeader.mediaTypes[1].parameters['version'], equals('1.0'));
    });
  });
}
