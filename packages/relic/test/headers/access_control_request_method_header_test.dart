import 'package:relic/src/headers.dart';
import 'package:relic/src/method/method.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Access-Control-Request-Method Tests', () {
    test('Given a valid Access-Control-Request-Method header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-method', 'POST');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestMethod?.value, equals(Method.post.value));
    });

    test('Given a custom Access-Control-Request-Method header, it should parse as a new method', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-method', 'CUSTOM');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestMethod?.value, equals('CUSTOM'));
    });

    test('Given no Access-Control-Request-Method header, it should be null', () {
      var httpRequest = HttpRequestMock(); // No 'access-control-request-method' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestMethod, isNull);
    });

    test('Given an empty Access-Control-Request-Method header, it should be null', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-method', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestMethod, isNull);
    });

    test('Given a method that is not predefined, it should be parsed as a new method', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-method', 'customMethod');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestMethod?.value, equals('CUSTOMMETHOD'));
    });

    test('Given mixed-case method name, it should normalize to the correct predefined method', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-method', 'get');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestMethod?.value, equals(Method.get.value));
    });

    test('Given multiple Access-Control-Request-Method headers, it should parse the first one', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-request-method', 'POST')
        ..headers.add('access-control-request-method', 'GET');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlRequestMethod?.value, equals(Method.post.value));
    });
  });
}
