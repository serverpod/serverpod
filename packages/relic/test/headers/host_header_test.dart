import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import '../mocks/http_request_mock.dart';

void main() {
  group('HostHeader Class Tests', () {
    test('HostHeader should parse valid host with port correctly', () {
      var headerValue = 'example.com:8080';
      var hostHeader = HostHeader.fromHeaderValue(headerValue);

      expect(hostHeader.host, equals('example.com'));
      expect(hostHeader.port, equals(8080));
    });

    test('HostHeader should parse valid host without port correctly', () {
      var headerValue = 'example.com';
      var hostHeader = HostHeader.fromHeaderValue(headerValue);

      expect(hostHeader.host, equals('example.com'));
      expect(hostHeader.port, isNull);
    });

    test('HostHeader should handle invalid port and throw FormatException', () {
      var headerValue = 'example.com:invalid';

      expect(
          () => HostHeader.fromHeaderValue(headerValue), throwsFormatException);
    });

    test(
        'HostHeader should return valid string representation of host and port',
        () {
      var hostHeader = HostHeader.fromHeaderValue('example.com:8080');
      var result = hostHeader.toString();

      expect(result, equals('example.com:8080'));
    });

    test(
        'HostHeader should return valid string representation of host without port',
        () {
      var hostHeader = HostHeader.fromHeaderValue('example.com');
      var result = hostHeader.toString();

      expect(result, equals('example.com'));
    });

    test('HostHeader should return null when trying to parse null value', () {
      var hostHeader = HostHeader.tryParse(null);
      expect(hostHeader, isNull);
    });
  });

  group('HostHeader HttpRequestMock Tests', () {
    test('Given a valid Host header with port, it should parse correctly', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Host', 'example.com:8080');

      var headers = Headers.fromHttpRequest(httpRequest);
      var hostHeader = headers.host;

      expect(hostHeader?.host, equals('example.com'));
      expect(hostHeader?.port, equals(8080));
    });

    test('Given a valid Host header without port, it should parse correctly',
        () {
      var httpRequest = HttpRequestMock()..headers.add('Host', 'example.com');

      var headers = Headers.fromHttpRequest(httpRequest);
      var hostHeader = headers.host;

      expect(hostHeader?.host, equals('example.com'));
      expect(hostHeader?.port, isNull);
    });

    test(
        'Given an invalid port in Host header, it should throw a FormatException',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Host', 'example.com:invalid');

      expect(() => Headers.fromHttpRequest(httpRequest).host,
          throwsFormatException);
    });

    test('Given multiple Host headers, it should parse the first value', () {
      var httpRequest = HttpRequestMock()
        ..headers.add('Host', 'example.com:8080')
        ..headers.add('Host', 'other.com:9090');

      var headers = Headers.fromHttpRequest(httpRequest);
      var hostHeader = headers.host;

      expect(hostHeader?.host, equals('example.com'));
      expect(hostHeader?.port, equals(8080));
    });

    test('Given no Host header, it should return null', () {
      var httpRequest = HttpRequestMock(); // No 'Host' header added

      var headers = Headers.fromHttpRequest(httpRequest);
      expect(headers.host, isNull);
    });
  });
}
