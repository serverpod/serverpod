import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Accept-Charset Header Tests', () {
    test('Given a valid Accept-Charset header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-charset', 'utf-8');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptCharset, equals(['utf-8']));
    });

    test(
        'Given multiple Accept-Charset values, it should parse all values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-charset', 'utf-8, iso-8859-1');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptCharset, equals(['utf-8', 'iso-8859-1']));
    });

    test('Given no Accept-Charset header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'accept-charset' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptCharset, isNull);
    });

    test('Given an empty Accept-Charset header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('accept-charset', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptCharset, isNull);
    });

    test(
        'Given multiple Accept-Charset headers, it should combine the values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-charset', 'utf-8')
        ..headers.add('accept-charset', 'iso-8859-1');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptCharset, equals(['utf-8', 'iso-8859-1']));
    });

    test(
        'Given mixed-case Accept-Charset headers, it should normalize and combine them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Accept-Charset', 'utf-8')
        ..headers.add('ACCEPT-CHARSET', 'iso-8859-1');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptCharset, equals(['utf-8', 'iso-8859-1']));
    });

    test(
        'Given an Accept-Charset header with multiple values in a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-charset', 'utf-8, iso-8859-1');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptCharset, equals(['utf-8', 'iso-8859-1']));
    });
  });
}
