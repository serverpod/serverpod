import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Access-Control-Request-Headers Tests', () {
    test(
        'Given a valid Access-Control-Request-Headers header, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-headers', 'X-Custom-Header');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestHeaders, equals(['X-Custom-Header']));
    });

    test(
        'Given multiple Access-Control-Request-Headers values, it should parse all values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-headers',
            'X-Custom-Header, X-Another-Header');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestHeaders,
          equals(['X-Custom-Header', 'X-Another-Header']));
    });

    test('Given no Access-Control-Request-Headers header, it should be null',
        () {
      var httpRequest =
          HttpRequestMock(); // No 'access-control-request-headers' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestHeaders, isNull);
    });

    test(
        'Given an empty Access-Control-Request-Headers header, it should return an empty list',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-headers', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestHeaders, equals([]));
    });

    test(
        'Given multiple Access-Control-Request-Headers headers, it should combine the values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-headers', 'X-Custom-Header')
        ..headers.add('access-control-request-headers', 'X-Another-Header');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestHeaders,
          equals(['X-Custom-Header', 'X-Another-Header']));
    });

    test(
        'Given mixed-case Access-Control-Request-Headers headers, it should normalize and combine them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Access-Control-Request-Headers', 'X-Custom-Header')
        ..headers.add('ACCESS-CONTROL-REQUEST-HEADERS', 'X-Another-Header');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestHeaders,
          equals(['X-Custom-Header', 'X-Another-Header']));
    });

    test(
        'Given an Access-Control-Request-Headers header with multiple values in a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-headers',
            'X-Custom-Header, X-Another-Header');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestHeaders,
          equals(['X-Custom-Header', 'X-Another-Header']));
    });
  });
}
