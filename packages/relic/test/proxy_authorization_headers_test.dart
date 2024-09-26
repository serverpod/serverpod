import 'dart:convert';
import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import 'mocks/http_request_mock.dart';

void main() {
  group('BearerProxyAuthorizationHeader', () {
    test(
        'Given a valid token in the proxy-authorization header, it correctly constructs a BearerProxyAuthorizationHeader',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', 'Bearer token.value.here');

      var headers = Headers.fromHttpRequest(httpRequest);
      var header = headers.proxyAuthorization as BearerProxyAuthorizationHeader;

      expect(header.token, equals("token.value.here"));
      expect(
        header.toString(),
        equals('proxy-authorization: Bearer token.value.here'),
      );
      expect(header.headerValue, equals('Bearer token.value.here'));
    });

    test(
        'Given an empty token in the proxy-authorization header, it throws a FormatException',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', '');

      expect(
        () => Headers.fromHttpRequest(httpRequest),
        throwsA(isA<FormatException>()),
      );
    });

    test('Given no proxy-authorization header, it returns null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);

      expect(headers.proxyAuthorization, isNull);
    });

    test(
        'Given an invalid token value without the Bearer prefix in the proxy-authorization header, it throws a FormatException',
        () {
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', 'invalidTokenValue');

      expect(
        () => Headers.fromHttpRequest(httpRequest),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'Given a very long token value in the proxy-authorization header, it correctly handles the token',
        () {
      var longToken = 'a' * 1000; // 1000 'a' characters
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', 'Bearer $longToken');

      var headers = Headers.fromHttpRequest(httpRequest);
      var header = headers.proxyAuthorization as BearerProxyAuthorizationHeader;

      expect(header.token, equals(longToken));
      expect(
        header.toString(),
        equals('proxy-authorization: Bearer $longToken'),
      );
      expect(header.headerValue, equals('Bearer $longToken'));
    });

    test(
        'Given a token with the default prefix, it extracts the token value correctly',
        () {
      var token = "Bearer token.value.here";
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', token);

      var headers = Headers.fromHttpRequest(httpRequest);
      var header = headers.proxyAuthorization as BearerProxyAuthorizationHeader;

      expect(header.token, equals('token.value.here'));
      expect(header.headerValue, equals('Bearer token.value.here'));
    });
  });

  group('BasicProxyAuthorizationHeader', () {
    test(
        'Given a valid username and password, it encodes them with the Basic prefix in the proxy-authorization header',
        () {
      var credentials = base64Encode(utf8.encode('username:password'));
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', 'Basic $credentials');

      var headers = Headers.fromHttpRequest(httpRequest);
      var header = headers.proxyAuthorization as BasicProxyAuthorizationHeader;

      expect(header.username, equals('username'));
      expect(header.password, equals("password"));
      expect(
        header.toString(),
        equals(
          'proxy-authorization: Basic $credentials',
        ),
      );
      expect(
        header.headerValue,
        equals(
          'Basic $credentials',
        ),
      );
    });

    test('Given no proxy-authorization header, it returns null', () {
      var httpRequest = HttpRequestMock();

      var headers = Headers.fromHttpRequest(httpRequest);

      expect(headers.proxyAuthorization, isNull);
    });

    test(
        'Given an invalid Basic proxy-authorization header, it throws a FormatException',
        () {
      var invalidToken = 'Basic invalidBase64';
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', invalidToken);

      expect(
        () => Headers.fromHttpRequest(httpRequest),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'Given a Basic proxy-authorization header without the Basic prefix, it throws a FormatException',
        () {
      var encoded = base64Encode(utf8.encode('username:password'));
      var token = 'NotBasic $encoded';
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', token);

      expect(
        () => Headers.fromHttpRequest(httpRequest),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'Given special characters in username and password, it encodes them correctly in the proxy-authorization header',
        () {
      var credentials = base64Encode(utf8.encode('user@name:p@ssw0rd!'));
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', 'Basic $credentials');

      var headers = Headers.fromHttpRequest(httpRequest);
      var header = headers.proxyAuthorization as BasicProxyAuthorizationHeader;

      expect(header.username, equals('user@name'));
      expect(header.password, equals("p@ssw0rd!"));
      expect(
        header.toString(),
        equals(
          'proxy-authorization: Basic $credentials',
        ),
      );
      expect(
        header.headerValue,
        equals(
          'Basic $credentials',
        ),
      );
    });

    test(
        'Given an invalid Base64-encoded token in proxy-authorization, it throws a FormatException',
        () {
      var invalidBase64Token = 'Basic invalid==base64';
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', invalidBase64Token);

      expect(
        () => Headers.fromHttpRequest(httpRequest),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'Given a valid Base64-encoded token without a colon, it throws a FormatException in proxy-authorization',
        () {
      var encoded = base64Encode(utf8.encode('usernamepassword')); // No colon
      var token = 'Basic $encoded';
      var httpRequest = HttpRequestMock()
        ..headers.add('proxy-authorization', token);

      expect(
        () => Headers.fromHttpRequest(httpRequest),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
