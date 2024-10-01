import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Accept-Language Header Tests', () {
    test('Given a valid Accept-Language header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-language', 'en-US');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptLanguage, equals(['en-US']));
    });

    test(
        'Given multiple Accept-Language values, it should parse all values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-language', 'en-US, fr-CA');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptLanguage, equals(['en-US', 'fr-CA']));
    });

    test('Given no Accept-Language header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'accept-language' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptLanguage, isNull);
    });

    test('Given an empty Accept-Language header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('accept-language', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptLanguage, isNull);
    });

    test(
        'Given multiple Accept-Language headers, it should combine the values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-language', 'en-US')
        ..headers.add('accept-language', 'fr-CA');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptLanguage, equals(['en-US', 'fr-CA']));
    });

    test(
        'Given mixed-case Accept-Language headers, it should normalize and combine them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Accept-Language', 'en-US')
        ..headers.add('ACCEPT-LANGUAGE', 'fr-CA');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptLanguage, equals(['en-US', 'fr-CA']));
    });

    test(
        'Given an Accept-Language header with multiple values in a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-language', 'en-US, fr-CA');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptLanguage, equals(['en-US', 'fr-CA']));
    });
  });
}
