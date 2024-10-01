import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('AccessControlAllowCredentials Header Tests', () {
    test(
        'Given a valid Access-Control-Allow-Credentials header, it should parse true',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-allow-credentials', 'true');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlAllowCredentials, isTrue);
    });

    test(
        'Given an invalid Access-Control-Allow-Credentials header, it should return null',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('access-control-allow-credentials', 'invalid-value');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlAllowCredentials, isNull);
    });

    test(
        'Given no Access-Control-Allow-Credentials header, it should return null',
        () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.accessControlAllowCredentials, isNull);
    });
  });
}
