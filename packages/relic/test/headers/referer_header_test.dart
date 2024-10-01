import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Referer Header Tests', () {
    test('Given a valid Referer header, it should parse correctly as a URI',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Referer', 'https://example.com/page');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.referer, equals(Uri.parse('https://example.com/page')));
    });

    test('Given an invalid Referer header, it should return null', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Referer', 'invalid-uri');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.referer, isNull);
    });

    test('Given no Referer header, it should return null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.referer, isNull);
    });

    test('Given an empty Referer header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('Referer', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.referer, isNull);
    });
  });
}
