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

  group('VaryHeader Class Tests', () {
    test('VaryHeader should parse multiple vary fields', () {
      var headerValue = 'Accept-Encoding, User-Agent';
      var varyHeader = VaryHeader.fromHeaderValue([headerValue]);

      expect(varyHeader.fields.length, equals(2));
      expect(varyHeader.fields.contains('Accept-Encoding'), isTrue);
      expect(varyHeader.fields.contains('User-Agent'), isTrue);
    });

    test('VaryHeader should parse a single vary field', () {
      var headerValue = 'Accept-Encoding';
      var varyHeader = VaryHeader.fromHeaderValue([headerValue]);

      expect(varyHeader.fields.length, equals(1));
      expect(varyHeader.fields.contains('Accept-Encoding'), isTrue);
    });

    test('VaryHeader should handle empty string as input', () {
      var varyHeader = VaryHeader.fromHeaderValue(['']);
      expect(varyHeader.fields, isEmpty);
    });

    test('VaryHeader should return null when parsing a null value', () {
      var varyHeader = VaryHeader.tryParse(null);
      expect(varyHeader, isNull);
    });

    test('VaryHeader should add a new field if not already present', () {
      var headerValue = 'Accept-Encoding';
      var varyHeader = VaryHeader.fromHeaderValue([headerValue]);

      var updatedVaryHeader = varyHeader.addField('User-Agent');
      expect(updatedVaryHeader.fields.length, equals(2));
      expect(updatedVaryHeader.fields.contains('User-Agent'), isTrue);
    });

    test('VaryHeader should not add a duplicate field', () {
      var headerValue = 'Accept-Encoding';
      var varyHeader = VaryHeader.fromHeaderValue([headerValue]);

      var updatedVaryHeader = varyHeader.addField('Accept-Encoding');
      expect(updatedVaryHeader.fields.length, equals(1));
    });

    test('VaryHeader should remove a field', () {
      var headerValue = 'Accept-Encoding, User-Agent';
      var varyHeader = VaryHeader.fromHeaderValue([headerValue]);

      var updatedVaryHeader = varyHeader.removeField('User-Agent');
      expect(updatedVaryHeader.fields.length, equals(1));
      expect(updatedVaryHeader.fields.contains('User-Agent'), isFalse);
    });

    test('VaryHeader should contain a specific field', () {
      var headerValue = 'Accept-Encoding, User-Agent';
      var varyHeader = VaryHeader.fromHeaderValue([headerValue]);

      expect(varyHeader.containsField('User-Agent'), isTrue);
      expect(varyHeader.containsField('Authorization'), isFalse);
    });

    test('VaryHeader should return valid string representation', () {
      var varyHeader = VaryHeader(fields: ['Accept-Encoding', 'User-Agent']);
      var result = varyHeader.toString();

      expect(result, equals('Accept-Encoding, User-Agent'));
    });
  });

  group('VaryHeader HttpRequest Tests', () {
    test('Given a valid Vary header, it should parse correctly', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Vary': 'Accept-Encoding, User-Agent'},
      );
      var varyHeader = headers.vary;

      expect(varyHeader!.fields.length, equals(2));
      expect(varyHeader.fields.contains('Accept-Encoding'), isTrue);
      expect(varyHeader.fields.contains('User-Agent'), isTrue);
    });

    test('Given a Vary header with a single field, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Vary': 'Accept-Encoding'},
      );
      var varyHeader = headers.vary;

      expect(varyHeader!.fields.length, equals(1));
      expect(varyHeader.fields.contains('Accept-Encoding'), isTrue);
    });

    test('Given an empty Vary header, it should return null', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Vary': ''},
      );
      var varyHeader = headers.vary;

      expect(varyHeader?.fields, isNull);
    });
  });
}
