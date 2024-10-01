import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('If-None-Match Header Tests', () {
    test('Given a single If-None-Match value, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('if-none-match', '"etag123"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifNoneMatch, equals(['"etag123"']));
    });

    test('Given multiple If-None-Match values, it should parse all values as a list', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('if-none-match', '"etag123"')
        ..headers.add('if-none-match', '"etag456"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifNoneMatch, equals(['"etag123"', '"etag456"']));
    });

    test('Given no If-None-Match header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'if-none-match' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifNoneMatch, isNull);
    });

    test('Given an empty If-None-Match header, it should return an empty list', () {
      var httpRequest = HttpRequestMock()..headers.add('if-none-match', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifNoneMatch, isEmpty);
    });

    test('Given If-None-Match header with multiple values as a single string, it should split them correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('if-none-match', '"etag123", "etag456"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.ifNoneMatch, equals(['"etag123"', '"etag456"']));
    });
  });
}
