import 'package:relic/src/headers.dart';
import 'package:test/test.dart';
import '../mocks/http_request_mock.dart';

void main() {
  group('Access-Control-Max-Age Header Tests', () {
    test('Given a valid Access-Control-Max-Age header, it should parse correctly as an integer', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-max-age', '3600');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlMaxAge, equals(3600));
    });

    test('Given an invalid Access-Control-Max-Age header, it should return null', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-max-age', 'invalid-value');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlMaxAge, isNull);
    });

    test('Given an empty Access-Control-Max-Age header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('access-control-max-age', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlMaxAge, isNull);
    });

    test('Given no Access-Control-Max-Age header, it should return null', () {
      var httpRequest = HttpRequestMock(); // No 'access-control-max-age' header

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlMaxAge, isNull);
    });
  });
}
