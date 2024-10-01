import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Allow Header Tests', () {
    test(
        'Given a valid Allow header with one method, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()..headers.add('allow', 'GET');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.allow?.length, equals(1));
      expect(headers.allow?.first.value, equals('GET'));
    });

    test(
        'Given a valid Allow header with multiple methods, it should parse all values',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('allow', 'GET, POST, DELETE');

      var headers = Headers.fromHttpRequest(httpRequest);
      var allow = headers.allow;

      expect(allow?.length, equals(3));
      expect(allow?.map((method) => method.value),
          equals(['GET', 'POST', 'DELETE']));
    });

    test(
        'Given an invalid Allow header, it should parse the method as a custom value',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('allow', 'CUSTOM_METHOD');

      var headers = Headers.fromHttpRequest(httpRequest);
      var allow = headers.allow;

      expect(allow?.length, equals(1));
      expect(allow?.first.value, equals('CUSTOM_METHOD'));
    });

    test('Given no Allow header, it should return null', () {
      var httpRequest = HttpRequestMock(); // No 'allow' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.allow, isNull);
    });

    test('Given an empty Allow header, it should return an empty list', () {
      var httpRequest = HttpRequestMock()..headers.add('allow', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.allow, isEmpty);
    });

    test(
        'Given a valid Allow header with multiple values separated by commas, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('allow', 'GET,POST,DELETE');

      var headers = Headers.fromHttpRequest(httpRequest);
      var allow = headers.allow;

      expect(allow?.length, equals(3));
      expect(allow?.map((method) => method.value),
          equals(['GET', 'POST', 'DELETE']));
    });
  });
}
