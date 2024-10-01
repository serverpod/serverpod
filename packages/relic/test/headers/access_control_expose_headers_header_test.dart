import 'package:relic/src/headers.dart';
import 'package:test/test.dart';
import '../mocks/http_request_mock.dart';

void main() {
  group('Access-Control-Expose-Headers Tests', () {
    test(
        'Given valid Access-Control-Expose-Headers, it should parse as a list of values',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-expose-headers',
            'X-Custom-Header1, X-Custom-Header2');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlExposeHeaders,
          equals(['X-Custom-Header1', 'X-Custom-Header2']));
    });

    test(
        'Given multiple Access-Control-Expose-Headers, it should combine them into a single list',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-expose-headers', 'X-Custom-Header1')
        ..headers.add('access-control-expose-headers', 'X-Custom-Header2');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlExposeHeaders,
          equals(['X-Custom-Header1', 'X-Custom-Header2']));
    });

    test(
        'Given an empty Access-Control-Expose-Headers, it should return an empty list',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-expose-headers', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlExposeHeaders, isEmpty);
    });

    test('Given no Access-Control-Expose-Headers, it should return null', () {
      var httpRequest =
          HttpRequestMock(); // No 'access-control-expose-headers' header

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlExposeHeaders, isNull);
    });
  });
}
