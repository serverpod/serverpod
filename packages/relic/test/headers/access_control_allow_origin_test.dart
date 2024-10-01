import 'package:relic/src/headers.dart';
import 'package:test/test.dart';
import '../mocks/http_request_mock.dart';

void main() {
  group('Access-Control-Allow-Origin Header Tests', () {
    test(
        'Given a valid Access-Control-Allow-Origin header, it should parse correctly as a URI',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-allow-origin', 'https://example.com');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(
        headers.accessControlAllowOrigin,
        equals(Uri.parse('https://example.com')),
      );
    });

    test(
        'Given a relative Access-Control-Allow-Origin header, it should return the relative URI',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-allow-origin', '/relative/path');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(
        headers.accessControlAllowOrigin,
        equals(Uri.parse('/relative/path')),
      );
    });

    test('Given no Access-Control-Allow-Origin header, it should return null',
        () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlAllowOrigin, isNull);
    });

    test(
        'Given an empty Access-Control-Allow-Origin header, it should return null',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-allow-origin', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlAllowOrigin, isNull);
    });
  });
}
