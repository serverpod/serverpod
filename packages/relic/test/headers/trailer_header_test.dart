import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Trailer Header Tests', () {
    test('Given a valid Trailer header, it should parse correctly as a list',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('trailer', 'content-md5, etag');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.trailer, equals(['content-md5', 'etag']));
    });

    test('Given multiple Trailer headers, it should parse all values as a list',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('trailer', 'content-md5')
        ..headers.add('trailer', 'etag');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.trailer, equals(['content-md5', 'etag']));
    });

    test('Given no Trailer header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'trailer' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.trailer, isNull);
    });

    test('Given an empty Trailer header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('trailer', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.trailer, isNull);
    });

    test(
        'Given a Trailer header with multiple values as a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('trailer', 'content-md5, etag');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.trailer, equals(['content-md5', 'etag']));
    });
  });
}
