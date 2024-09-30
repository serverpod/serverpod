import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('AcceptHeader Class Tests', () {
    test('AcceptHeader should parse valid header values correctly', () {
      var headerValue = 'text/html, application/json';
      var acceptHeader = AcceptHeader.fromHeaderValue([headerValue]);

      expect(acceptHeader.mediaTypes.length, equals(2));
      expect(acceptHeader.mediaTypes[0].mimeType, equals('text/html'));
      expect(acceptHeader.mediaTypes[1].mimeType, equals('application/json'));
    });

    test('AcceptHeader should handle MIME types with quality values (q)', () {
      var headerValue = 'text/html; q=0.8, application/json; q=0.9';
      var acceptHeader = AcceptHeader.fromHeaderValue([headerValue]);

      expect(acceptHeader.mediaTypes.length, equals(2));
      expect(acceptHeader.mediaTypes[0].mimeType, equals('text/html'));
      expect(acceptHeader.mediaTypes[0].parameters['q'], equals('0.8'));
      expect(acceptHeader.mediaTypes[1].mimeType, equals('application/json'));
      expect(acceptHeader.mediaTypes[1].parameters['q'], equals('0.9'));
    });

    test('AcceptHeader should return null when trying to parse a null value',
        () {
      var acceptHeader = AcceptHeader.tryParse(null);
      expect(acceptHeader, isNull);
    });

    test('AcceptHeader should handle an empty string as input', () {
      var acceptHeader = AcceptHeader.fromHeaderValue(['']);
      expect(acceptHeader.mediaTypes, isEmpty);
    });

    test('AcceptHeader should return valid string representation of header',
        () {
      var headerValue = 'text/html, application/json';
      var acceptHeader = AcceptHeader.fromHeaderValue([headerValue]);
      var result = acceptHeader.toString();

      expect(result, equals('text/html, application/json'));
    });

    test('AcceptHeader should handle complex MIME types with parameters', () {
      var headerValue =
          'text/html; charset=utf-8, application/json; version=1.0';
      var acceptHeader = AcceptHeader.fromHeaderValue([headerValue]);

      expect(acceptHeader.mediaTypes.length, equals(2));
      expect(acceptHeader.mediaTypes[0].mimeType, equals('text/html'));
      expect(acceptHeader.mediaTypes[0].parameters['charset'], equals('utf-8'));
      expect(acceptHeader.mediaTypes[1].mimeType, equals('application/json'));
      expect(acceptHeader.mediaTypes[1].parameters['version'], equals('1.0'));
    });
  });

  group('AcceptHeader HttpRequestMock Tests', () {
    test('Given headers with multiple values, it should combine them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Accept', 'text/html')
        ..headers.add('Accept', 'application/json');

      var headers = Headers.fromHttpRequest(httpRequest);
      var acceptHeader = headers.accept;

      expect(acceptHeader!.mediaTypes.length, equals(2));
      expect(acceptHeader.mediaTypes[0].mimeType, equals('text/html'));
      expect(acceptHeader.mediaTypes[1].mimeType, equals('application/json'));
    });

    test(
        'Given headers with MIME types and quality values, it should handle them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Accept', 'text/html; q=0.8')
        ..headers.add('Accept', 'application/json; q=0.9');

      var headers = Headers.fromHttpRequest(httpRequest);
      var acceptHeader = headers.accept;

      expect(acceptHeader!.mediaTypes.length, equals(2));
      expect(acceptHeader.mediaTypes[0].mimeType, equals('text/html'));
      expect(acceptHeader.mediaTypes[0].parameters['q'], equals('0.8'));
      expect(acceptHeader.mediaTypes[1].mimeType, equals('application/json'));
      expect(acceptHeader.mediaTypes[1].parameters['q'], equals('0.9'));
    });

    test(
        'Given headers with mixed cases and multiple values, it should normalize and combine values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Accept', 'text/html')
        ..headers.add('ACCEPT', 'application/json');

      var headers = Headers.fromHttpRequest(httpRequest);
      var acceptHeader = headers.accept;

      expect(acceptHeader!.mediaTypes.length, equals(2));
      expect(acceptHeader.mediaTypes[0].mimeType, equals('text/html'));
      expect(acceptHeader.mediaTypes[1].mimeType, equals('application/json'));
    });

    test(
        'Given an empty Accept header, it should return an empty list of media types',
        () {
      var httpRequest = HttpRequestMock()..headers.add('Accept', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      var acceptHeader = headers.accept;

      expect(acceptHeader!.mediaTypes, isEmpty);
    });
  });
}
