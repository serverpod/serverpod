import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('If-Match Header Tests', () {
    test('Given a single If-Match value, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('if-match', '"etag123"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifMatch, equals(['"etag123"']));
    });

    test('Given multiple If-Match values, it should parse all values as a list', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('if-match', '"etag123"')
        ..headers.add('if-match', '"etag456"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifMatch, equals(['"etag123"', '"etag456"']));
    });

    test('Given no If-Match header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'if-match' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifMatch, isNull);
    });

    test('Given an empty If-Match header, it should return an empty list', () {
      var httpRequest = HttpRequestMock()..headers.add('if-match', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifMatch, isEmpty);
    });

    test('Given If-Match header with multiple values as a single string, it should split them correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('if-match', '"etag123", "etag456"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifMatch, equals(['"etag123"', '"etag456"']));
    });
  });
}
