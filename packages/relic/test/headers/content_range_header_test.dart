import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
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

  group('ContentRangeHeader HttpRequestMock Tests', () {
    test('Given a valid Content-Range header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Content-Range', 'bytes 0-499/1234');

      var headers = Headers.fromHttpRequest(httpRequest);
      var contentRangeHeader = headers.contentRange;

      expect(contentRangeHeader!.start, equals(0));
      expect(contentRangeHeader.end, equals(499));
      expect(contentRangeHeader.totalSize, equals(1234));
    });

    test(
        'Given a Content-Range header with unknown total size, it should handle it correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Content-Range', 'bytes 0-499/*');

      var headers = Headers.fromHttpRequest(httpRequest);
      var contentRangeHeader = headers.contentRange;

      expect(contentRangeHeader!.start, equals(0));
      expect(contentRangeHeader.end, equals(499));
      expect(contentRangeHeader.totalSize, isNull);
    });

    test(
        'Given an invalid Content-Range header, it should throw FormatException',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Content-Range', 'invalid-header');

      expect(
        () => Headers.fromHttpRequest(httpRequest).contentRange,
        throwsFormatException,
      );
    });
  });
}
