import 'package:relic/src/headers.dart';
import 'package:test/test.dart';
import '../mocks/http_request_mock.dart';

void main() {
  group('Content-Encoding Header Tests', () {
    test(
        'Given a valid Content-Encoding header with a single value, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('content-encoding', 'gzip');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentEncoding, equals(['gzip']));
    });

    test(
        'Given a valid Content-Encoding header with multiple values, it should parse all values',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('content-encoding', 'gzip')
        ..headers.add('content-encoding', 'compress');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentEncoding, equals(['gzip', 'compress']));
    });

    test(
        'Given a Content-Encoding header with multiple values in a single string, it should split and parse them correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('content-encoding', 'gzip, compress');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentEncoding, equals(['gzip', 'compress']));
    });

    test('Given an empty Content-Encoding header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('content-encoding', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentEncoding, isNull);
    });

    test('Given no Content-Encoding header, it should return null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.contentEncoding, isNull);
    });
  });
}
