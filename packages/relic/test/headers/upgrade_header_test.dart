import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Upgrade Header Tests', () {
    test(
        'Given a valid Upgrade header with one value, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()..headers.add('upgrade', 'websocket');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.upgrade, equals(['websocket']));
    });

    test(
        'Given a valid Upgrade header with multiple values, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('upgrade', 'websocket, HTTP/2');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.upgrade, equals(['websocket', 'HTTP/2']));
    });

    test(
        'Given multiple Upgrade headers, it should combine and parse all values',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('upgrade', 'websocket')
        ..headers.add('upgrade', 'HTTP/2');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.upgrade, equals(['websocket', 'HTTP/2']));
    });

    test('Given no Upgrade header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'upgrade' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.upgrade, isNull);
    });

    test('Given an empty Upgrade header, it should return an empty list', () {
      var httpRequest = HttpRequestMock()..headers.add('upgrade', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.upgrade, isEmpty);
    });

    test(
        'Given an Upgrade header with multiple values as a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('upgrade', 'websocket, HTTP/2');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.upgrade, equals(['websocket', 'HTTP/2']));
    });
  });
}
