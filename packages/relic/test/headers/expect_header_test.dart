import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Expect Header Tests', () {
    test('Given a valid Expect header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('expect', '100-continue');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.expect, equals('100-continue'));
    });

    test('Given no Expect header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'expect' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.expect, isNull);
    });

    test('Given an empty Expect header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('expect', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.expect, isNull);
    });

    test('Given a non-empty Expect header, it should return the correct value', () {
      var httpRequest = HttpRequestMock()..headers.add('expect', '200-ok');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.expect, equals('200-ok'));
    });
  });
}
