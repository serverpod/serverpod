import 'package:relic/src/headers.dart';
import 'package:test/test.dart';
import '../mocks/http_request_mock.dart';

void main() {
  group('Content-Language Header Tests', () {
    test(
        'Given a valid Content-Language header with a single value, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('content-language', 'en');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentLanguage, equals(['en']));
    });

    test(
        'Given a valid Content-Language header with multiple values, it should parse all values',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('content-language', 'en')
        ..headers.add('content-language', 'fr');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentLanguage, equals(['en', 'fr']));
    });

    test(
        'Given a Content-Language header with multiple values in a single string, it should split and parse them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('content-language', 'en, fr');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentLanguage, equals(['en', 'fr']));
    });

    test('Given an empty Content-Language header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('content-language', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentLanguage, isNull);
    });

    test('Given no Content-Language header, it should return null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentLanguage, isNull);
    });
  });
}
