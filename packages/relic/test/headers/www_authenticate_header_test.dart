import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('WWW-Authenticate Header Tests', () {
    test('Given a valid WWW-Authenticate header, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('www-authenticate', 'Basic realm="example"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.wwwAuthenticate, equals(['Basic realm="example"']));
    });

    test(
        'Given multiple WWW-Authenticate headers, it should parse all values as a list',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('www-authenticate', 'Basic realm="example"')
        ..headers.add('www-authenticate', 'Bearer realm="example"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.wwwAuthenticate,
          equals(['Basic realm="example"', 'Bearer realm="example"']));
    });

    test('Given no WWW-Authenticate header, it should return null', () {
      var httpRequest = HttpRequestMock(); // No 'www-authenticate' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.wwwAuthenticate, isNull);
    });

    test(
        'Given an empty WWW-Authenticate header, it should return an empty list',
        () {
      var httpRequest = HttpRequestMock()..headers.add('www-authenticate', '');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.wwwAuthenticate?.isEmpty, isTrue);
    });

    test(
        'Given a WWW-Authenticate header with complex schemes, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('www-authenticate',
            'Digest realm="example", qop="auth", nonce="abc123"');

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(
        headers.wwwAuthenticate,
        equals(['Digest realm="example", qop="auth", nonce="abc123"']),
      );
    });
  });
}
