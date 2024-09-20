import 'package:relic/relic.dart';
import 'package:test/test.dart';

import 'mocks/http_request_mock.dart';

void main() {
  group('CustomHeaders', () {
    test('CustomHeaders should allow adding new headers', () {
      var headers = CustomHeaders.empty();
      var updatedHeaders =
          headers.add('X-Custom-Authorization', ['Bearer token']);

      expect(
          updatedHeaders['x-custom-authorization'], equals(['Bearer token']));
    });

    test('CustomHeaders should allow updating existing headers', () {
      var headers = CustomHeaders({
        'X-Custom-Header': ['custom-value']
      });
      var updatedHeaders = headers.add('X-Custom-Header', ['updated-value']);

      expect(updatedHeaders['x-custom-header'], equals(['updated-value']));
    });

    test('CustomHeaders should allow removing headers', () {
      var headers = CustomHeaders({
        'X-Custom-Header1': ['custom-value1'],
        'X-Custom-Header2': ['custom-value2']
      });
      var updatedHeaders = headers.removeKey('X-Custom-Header2');

      expect(updatedHeaders['x-custom-header2'], isNull);
      expect(updatedHeaders['x-custom-header1'], equals(['custom-value1']));
    });

    test('CustomHeaders copyWith should allow modifying headers', () {
      var headers = CustomHeaders({
        'X-Custom-Header': ['custom-value']
      });
      var copiedHeaders = headers.copyWith(newHeaders: {
        'X-Custom-Header': ['new-value'],
        'X-Custom-Authorization': ['Bearer token']
      });

      expect(copiedHeaders['x-custom-header'], equals(['new-value']));
      expect(copiedHeaders['x-custom-authorization'], equals(['Bearer token']));
    });

    test('Given headers with multiple values, it should combine them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('FoO', 'x')
        ..headers.add('FoO', 'y')
        ..headers.add('bAr', 'z');

      var headers = Headers.fromHttpRequest(httpRequest);
      var customHeaders = headers.custom;

      expect(customHeaders['foo'], equals(['x', 'y']));
      expect(customHeaders['bar'], equals(['z']));
    });

    test(
        'Given headers with multiple values and empty lists, it should combine the non-empty ones and ignore the empty ones',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('FoO', 'x')
        ..headers.add('FoO', '')
        ..headers.add('bAr', 'z');

      var headers = Headers.fromHttpRequest(httpRequest);
      var customHeaders = headers.custom;

      expect(customHeaders['foo'], equals(['x']));
      expect(customHeaders['bar'], equals(['z']));
    });

    test(
        'Given headers with multiple managed and custom values, it should correctly separate and handle them',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('X-Custom-Header1', 'value1')
        ..headers.add('X-Custom-Header1', 'value2')
        ..headers.add('bAr', 'z');

      var headers = Headers.fromHttpRequest(httpRequest);
      var customHeaders = headers.custom;

      expect(customHeaders['x-custom-header1'], equals(['value1', 'value2']));
      expect(customHeaders['bar'], equals(['z']));
    });

    test(
        'Given headers with a normal format and multiple values, it should handle all custom headers without interference',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('X-Custom-Header1', 'customValue1')
        ..headers.add('X-Custom-Header1', 'customValue2');

      var headers = Headers.fromHttpRequest(httpRequest);
      var customHeaders = headers.custom;

      expect(customHeaders['x-custom-header1'],
          equals(['customValue1', 'customValue2']));
    });

    test(
        'Given headers with mixed cases and multiple values, it should normalize keys and combine values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('FoO', 'x')
        ..headers.add('foo', 'y')
        ..headers.add('bAr', 'z')
        ..headers.add('Bar', 'w');

      var headers = Headers.fromHttpRequest(httpRequest);
      var customHeaders = headers.custom;

      expect(customHeaders['foo'], equals(['x', 'y']));
      expect(customHeaders['bar'], equals(['z', 'w']));
    });
  });
}
