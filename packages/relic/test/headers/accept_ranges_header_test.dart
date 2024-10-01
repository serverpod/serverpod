import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Accept-Ranges Header Tests', () {
    test('Given a valid Accept-Ranges header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-ranges', 'bytes');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptRanges, equals(['bytes']));
    });

    test(
        'Given multiple Accept-Ranges headers, it should parse all values as a list',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-ranges', 'bytes')
        ..headers.add('accept-ranges', 'none');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptRanges, equals(['bytes', 'none']));
    });

    test('Given no Accept-Ranges header, it should return null', () {
      var httpRequest = HttpRequestMock(); // No 'accept-ranges' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptRanges, isNull);
    });

    test('Given an empty Accept-Ranges header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('accept-ranges', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptRanges, isNull);
    });

    test(
        'Given a complex Accept-Ranges header with multiple values in a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('accept-ranges', 'bytes, none');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.acceptRanges, equals(['bytes', 'none']));
    });
  });
}
