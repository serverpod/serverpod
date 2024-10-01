import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('User-Agent Header Tests', () {
    test('Given a valid User-Agent header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('user-agent', 'Mozilla/5.0');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.userAgent, equals('Mozilla/5.0'));
    });

    test('Given no User-Agent header, it should be null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.userAgent, isNull);
    });

    test('Given an empty User-Agent header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('user-agent', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.userAgent, isNull);
    });

    test('Given multiple User-Agent headers, it should parse the first value',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('user-agent', 'Mozilla/5.0')
        ..headers.add('user-agent', 'Chrome/90.0');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.userAgent, equals('Mozilla/5.0'));
      // Optionally: Check for a warning about multiple headers if implemented
    });
  });
}
