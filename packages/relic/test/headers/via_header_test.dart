import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Via Header Tests', () {
    test('Given a valid Via header, it should parse correctly as a list', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('via', '1.1 example.com, 1.0 proxy.com');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.via, equals(['1.1 example.com', '1.0 proxy.com']));
    });

    test('Given multiple Via headers, it should parse all values as a list',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('via', '1.1 example.com')
        ..headers.add('via', '1.0 proxy.com');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.via, equals(['1.1 example.com', '1.0 proxy.com']));
    });

    test('Given no Via header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'via' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.via, isNull);
    });

    test('Given an empty Via header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('via', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.via, isNull);
    });

    test(
        'Given a Via header with multiple values as a single string, it should split them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('via', '1.1 example.com, 1.0 proxy.com');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.via, equals(['1.1 example.com', '1.0 proxy.com']));
    });
  });
}
