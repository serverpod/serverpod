import 'package:test/test.dart';
import '../mocks/http_request_mock.dart';
import 'package:relic/src/headers.dart';

void main() {
  group('Location Header Tests', () {
    test(
        'Given a valid absolute Location header, it should parse correctly as a URI',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('location', 'https://example.com/resource');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(
          headers.location.toString(), equals('https://example.com/resource'));
    });

    test('Given a relative Location header, it should parse correctly as a URI',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('location', '/relative/path');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.location.toString(), equals('/relative/path'));
    });

    test('Given an empty Location header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('location', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.location, isNull);
    });

    test('Given no Location header, it should return null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.location, isNull);
    });
  });
}
