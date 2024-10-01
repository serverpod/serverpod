import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Accept-Encoding Header Tests', () {
    test('Given a valid Accept-Encoding header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-encoding', 'gzip');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptEncoding, equals(['gzip']));
    });

    test(
        'Given multiple Accept-Encoding values, it should parse all values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-encoding', 'gzip, deflate');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptEncoding, equals(['gzip', 'deflate']));
    });

    test('Given no Accept-Encoding header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'accept-encoding' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptEncoding, isNull);
    });

    test('Given an empty Accept-Encoding header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('accept-encoding', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptEncoding, isNull);
    });

    test(
        'Given multiple Accept-Encoding headers, it should combine the values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-encoding', 'gzip')
        ..headers.add('accept-encoding', 'deflate');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptEncoding, equals(['gzip', 'deflate']));
    });

    test(
        'Given mixed-case Accept-Encoding headers, it should normalize and combine them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Accept-Encoding', 'gzip')
        ..headers.add('ACCEPT-ENCODING', 'deflate');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptEncoding, equals(['gzip', 'deflate']));
    });

    test(
        'Given an Accept-Encoding header with multiple values in a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-encoding', 'gzip, deflate');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptEncoding, equals(['gzip', 'deflate']));
    });
  });
}
