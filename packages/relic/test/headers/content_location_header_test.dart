import 'package:relic/src/headers.dart';
import 'package:test/test.dart';
import '../mocks/http_request_mock.dart';

void main() {
  group('Content-Location Header Tests', () {
    test('Given a valid absolute Content-Location header, it should parse as a Uri', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('content-location', 'https://example.com/resource');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentLocation, equals(Uri.parse('https://example.com/resource')));
    });

    test('Given a valid relative Content-Location header, it should parse as a Uri', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('content-location', '/relative/path');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentLocation, equals(Uri.parse('/relative/path')));
    });

    test('Given an empty Content-Location header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('content-location', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentLocation, isNull);
    });

    test('Given no Content-Location header, it should return null', () {
      var httpRequest = HttpRequestMock(); // No 'content-location' header

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentLocation, isNull);
    });
  });
}
