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

  group('ETagHeader Class Tests', () {
    test('ETagHeader should parse a strong ETag value correctly', () {
      var headerValue = '"strong-etag"';
      var eTagHeader = ETagHeader.fromHeaderValue(headerValue);

      expect(
        eTagHeader.value,
        equals('strong-etag'),
      );
      expect(eTagHeader.isWeak, isFalse);
    });

    test('ETagHeader should parse a weak ETag value correctly', () {
      var headerValue = 'W/"weak-etag"';
      var eTagHeader = ETagHeader.fromHeaderValue(headerValue);

      expect(
        eTagHeader.value,
        equals('weak-etag'),
      );
      expect(eTagHeader.isWeak, isTrue);
    });

    test('ETagHeader should return null when parsing a null value', () {
      var eTagHeader = ETagHeader.tryParse(null);
      expect(eTagHeader, isNull);
    });

    test('ETagHeader should return valid string representation for strong ETag',
        () {
      var eTagHeader = ETagHeader(value: 'strong-etag');
      var result = eTagHeader.toString();

      expect(
        result,
        equals('"strong-etag"'),
      );
    });

    test('ETagHeader should return valid string representation for weak ETag',
        () {
      var eTagHeader = ETagHeader(value: 'weak-etag', isWeak: true);
      var result = eTagHeader.toString();

      expect(
        result,
        equals('W/"weak-etag"'),
      );
    });

    test('ETagHeader should compare two strong ETags for equality', () {
      var eTag1 = ETagHeader(value: 'etag-value');
      var eTag2 = ETagHeader(value: 'etag-value');

      expect(eTag1.compare(eTag2), isTrue);
    });

    test(
        'ETagHeader should fail comparison if one ETag is weak and the other is strong',
        () {
      var eTag1 = ETagHeader(value: 'etag-value', isWeak: true);
      var eTag2 = ETagHeader(value: 'etag-value');

      expect(eTag1.compare(eTag2), isFalse);
    });

    test('ETagHeader should compare two weak ETags for equality', () {
      var eTag1 = ETagHeader(value: 'etag-value', isWeak: true);
      var eTag2 = ETagHeader(value: 'etag-value', isWeak: true);

      expect(eTag1.compare(eTag2), isTrue);
    });

    test('ETagHeader should fail comparison for different ETag values', () {
      var eTag1 = ETagHeader(value: 'etag-value-1');
      var eTag2 = ETagHeader(value: 'etag-value-2');

      expect(eTag1.compare(eTag2), isFalse);
    });
  });

  group('ETagHeader HttpRequest Tests', () {
    test('Given a valid strong ETag header, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'ETag': '"strong-etag"'},
      );
      var eTagHeader = headers.etag;

      expect(
        eTagHeader!.value,
        equals('strong-etag'),
      );
      expect(eTagHeader.isWeak, isFalse);
    });

    test('Given a valid weak ETag header, it should parse correctly', () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'ETag': 'W/"weak-etag"'},
      );
      var eTagHeader = headers.etag;

      expect(
        eTagHeader!.value,
        equals('weak-etag'),
      );
      expect(eTagHeader.isWeak, isTrue);
    });

    test('Given an invalid ETag header, it should throw FormatException',
        () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'ETag': 'invalid-header'},
        ),
        throwsFormatException,
      );
    });
  });
}
