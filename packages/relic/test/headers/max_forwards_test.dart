import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Max-Forwards Header Tests', () {
    test(
        'Given a valid Max-Forwards header, it should parse correctly as an integer',
        () {
      var httpRequest = HttpRequestMock()..headers.add('Max-Forwards', '10');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.maxForwards, equals(10));
    });

    test(
        'Given an invalid Max-Forwards header (non-integer), it should return null',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Max-Forwards', 'invalid-number');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.maxForwards, isNull);
    });

    test('Given no Max-Forwards header, it should return null', () {
      var httpRequest = HttpRequestMock(); // No 'Max-Forwards' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.maxForwards, isNull);
    });

    test('Given an empty Max-Forwards header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('Max-Forwards', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.maxForwards, isNull);
    });
  });
}
