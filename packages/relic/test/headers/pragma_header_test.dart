import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('Pragma Header Tests', () {
    test('Given a valid Pragma header, it should parse correctly', () {
      var httpRequest = HttpRequestMock()..headers.add('pragma', 'no-cache');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.mPragma, equals('no-cache'));
    });

    test('Given no Pragma header, it should be null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.mPragma, isNull);
    });

    test('Given an empty Pragma header, it should return null', () {
      var httpRequest = HttpRequestMock()..headers.add('pragma', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.mPragma, isNull);
    });
  });
}
