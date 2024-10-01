import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Age Header Tests', () {
    test('Given a valid Age header, it should parse correctly as an integer', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('age', '3600');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.age, equals(3600));
    });

    test('Given a non-integer Age header, it should return null', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('age', 'invalid-age');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.age, isNull);
    });

    test('Given no Age header, it should return null', () {
      var httpRequest = HttpRequestMock(); // No 'age' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.age, isNull);
    });

    test('Given an empty Age header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('age', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.age, isNull);
    });

    test('Given a valid Age header with multiple values, it should parse the first value', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('age', '3600')
        ..headers.add('age', '7200');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.age, equals(3600));
    });
  });
}
