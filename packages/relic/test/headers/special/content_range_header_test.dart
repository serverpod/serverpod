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

  group('ContentRangeHeader Class Tests', () {
    test('ContentRangeHeader should parse valid Content-Range header correctly',
        () {
      var headerValue = 'bytes 0-499/1234';
      var contentRangeHeader = ContentRangeHeader.fromHeaderValue(headerValue);

      expect(contentRangeHeader.start, equals(0));
      expect(contentRangeHeader.end, equals(499));
      expect(contentRangeHeader.totalSize, equals(1234));
    });

    test('ContentRangeHeader should handle unknown total size (*)', () {
      var headerValue = 'bytes 0-499/*';
      var contentRangeHeader = ContentRangeHeader.fromHeaderValue(headerValue);

      expect(contentRangeHeader.start, equals(0));
      expect(contentRangeHeader.end, equals(499));
      expect(contentRangeHeader.totalSize, isNull);
    });

    test('ContentRangeHeader should throw FormatException for invalid header',
        () {
      var headerValue = 'invalid-header';
      expect(
        () => ContentRangeHeader.fromHeaderValue(headerValue),
        throwsFormatException,
      );
    });

    test(
        'ContentRangeHeader should throw FormatException for negative start value',
        () {
      var headerValue = 'bytes -1-499/1234';
      expect(
        () => ContentRangeHeader.fromHeaderValue(headerValue),
        throwsFormatException,
      );
    });

    test(
        'ContentRangeHeader should throw FormatException for end value less than start',
        () {
      var headerValue = 'bytes 500-499/1234';
      expect(
        () => ContentRangeHeader.fromHeaderValue(headerValue),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
        'ContentRangeHeader should return null when trying to parse a null value',
        () {
      var contentRangeHeader = ContentRangeHeader.tryParse(null);
      expect(contentRangeHeader, isNull);
    });

    test(
        'ContentRangeHeader should return valid string representation of the header',
        () {
      var contentRangeHeader = ContentRangeHeader(
        start: 0,
        end: 499,
        totalSize: 1234,
      );
      var result = contentRangeHeader.toString();

      expect(result, equals('bytes 0-499/1234'));
    });

    test(
        'ContentRangeHeader should return valid string when total size is unknown',
        () {
      var contentRangeHeader = ContentRangeHeader(
        start: 0,
        end: 499,
        totalSize: null,
      );
      var result = contentRangeHeader.toString();

      expect(result, equals('bytes 0-499/*'));
    });
  });

  group('ContentRangeHeader HttpRequest Tests', () {
    test('Given a valid Content-Range header, it should parse correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Content-Range': 'bytes 0-499/1234'},
      );
      var contentRangeHeader = headers.contentRange;

      expect(contentRangeHeader!.start, equals(0));
      expect(contentRangeHeader.end, equals(499));
      expect(contentRangeHeader.totalSize, equals(1234));
    });

    test(
        'Given a Content-Range header with unknown total size, it should handle it correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'Content-Range': 'bytes 0-499/*'},
      );
      var contentRangeHeader = headers.contentRange;

      expect(contentRangeHeader!.start, equals(0));
      expect(contentRangeHeader.end, equals(499));
      expect(contentRangeHeader.totalSize, isNull);
    });

    test(
        'Given an invalid Content-Range header, it should throw FormatException',
        () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'Content-Range': 'invalid-header'},
        ),
        throwsFormatException,
      );
    });
  });
}
