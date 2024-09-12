import 'package:relic/relic.dart';
import 'package:test/test.dart';

import 'mocks/http_request_mock.dart';

void main() {
  group('CustomHeaders', () {
    test('Given headers with multiple values, it should combine them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('FoO', 'x')
        ..headers.add('FoO', 'y')
        ..headers.add('bAr', 'z');

      var headers = Headers.fromHttpRequest(httpRequest);
      var customHeaders = headers.custom;

      // The 'foo' header should have combined values ['x', 'y']
      expect(customHeaders['foo'], equals(['x', 'y']));
      // 'bar' should have a single value
      expect(customHeaders['bar'], equals(['z']));
    });

    test(
        'Given headers with multiple values and empty lists, it should combine the non-empty ones and ignore the empty ones',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('FoO', 'x')
        ..headers.add('FoO', '') // Empty value, should be ignored
        ..headers.add('bAr', 'z');

      var headers = Headers.fromHttpRequest(httpRequest);
      var customHeaders = headers.custom;

      // The 'foo' header should only include the non-empty value ['x']
      expect(customHeaders['foo'], equals(['x']));
      // 'bar' should have a single value
      expect(customHeaders['bar'], equals(['z']));
    });

    test(
        'Given headers with multiple managed and custom values, it should correctly separate and handle them',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Content-Type', 'application/json') // Managed header
        ..headers.add(
            'Content-Type', 'text/html') // Managed header, should be combined
        ..headers.add('Custom-Header1', 'value1') // Custom header
        ..headers.add(
            'Custom-Header1', 'value2') // Custom header, should be combined
        ..headers.add('bAr', 'z');

      var headers = Headers.fromHttpRequest(httpRequest);
      var customHeaders = headers.custom;

      // Managed headers should be excluded from custom headers
      expect(customHeaders['content-type'], isNull);
      // Custom headers should have combined values
      expect(customHeaders['custom-header1'], equals(['value1', 'value2']));
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

      // All headers should be treated as custom and combined correctly
      expect(customHeaders['x-custom-header1'],
          equals(['customValue1', 'customValue2']));
    });

    test(
        'Given headers with mixed cases and multiple values, it should normalize keys and combine values correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('FoO', 'x')
        ..headers.add('foo', 'y') // Same header as 'FoO', different case
        ..headers.add('bAr', 'z')
        ..headers.add('Bar', 'w'); // Same header as 'bAr', different case

      var headers = Headers.fromHttpRequest(httpRequest);
      var customHeaders = headers.custom;

      // The 'foo' header should have combined values ['x', 'y']
      expect(customHeaders['foo'], equals(['x', 'y']));
      // 'bar' should have combined values ['z', 'w']
      expect(customHeaders['bar'], equals(['z', 'w']));
    });
  });
}
