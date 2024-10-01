import 'package:test/test.dart';
import '../mocks/http_request_mock.dart';
import 'package:relic/src/headers.dart';

void main() {
  group('X-Powered-By Header Tests', () {
    test('Given a valid X-Powered-By header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()..headers.add('x-powered-by', 'Dart');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.xPoweredBy, equals('Dart'));
    });

    test('Given an empty X-Powered-By header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('x-powered-by', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.xPoweredBy, isNull);
    });

    test('Given no X-Powered-By header, it should return null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.xPoweredBy, isNull);
    });
  });
}
