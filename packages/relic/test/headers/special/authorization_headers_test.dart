import 'dart:convert';
import 'dart:io';

import 'package:relic/src/headers.dart';
import 'package:relic/src/relic_server.dart';
import 'package:test/test.dart';

import '../../test_util.dart';

void main() {
  late RelicServer server;

  setUp(() async {
    try {
      server = await RelicServer.bind(InternetAddress.loopbackIPv6, 0);
    } on SocketException catch (_) {
      server = await RelicServer.bind(InternetAddress.loopbackIPv4, 0);
    }
  });

  tearDown(() => server.close());

  group('BearerAuthorizationHeader', () {
    test(
        'Given a valid token in the authorization header, it correctly constructs a BearerAuthorizationHeader',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'authorization': 'Bearer token.value.here'},
      );
      var header = headers.authorization as BearerAuthorizationHeader;

      expect(header.token, equals('token.value.here'));
      expect(
        header.toString(),
        equals('authorization: Bearer token.value.here'),
      );
      expect(header.headerValue, equals('Bearer token.value.here'));
    });

    test(
        'Given an empty token in the authorization header, it throws a FormatException',
        () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'authorization': ''},
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'Given an invalid token value without the Bearer prefix, it throws a FormatException',
        () async {
      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'authorization': 'invalidTokenValue'},
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'Given a very long token value in the authorization header, it correctly handles the token',
        () async {
      var longToken = 'a' * 1000; // 1000 'a' characters
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'authorization': 'Bearer $longToken'},
      );
      var header = headers.authorization as BearerAuthorizationHeader;

      expect(header.token, equals(longToken));
      expect(
        header.toString(),
        equals('authorization: Bearer $longToken'),
      );
      expect(header.headerValue, equals('Bearer $longToken'));
    });

    test(
        'Given a token with the default prefix, it extracts the token value correctly',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'authorization': 'Bearer token.value.here'},
      );
      var header = headers.authorization as BearerAuthorizationHeader;

      expect(header.token, equals('token.value.here'));
      expect(header.headerValue, equals('Bearer token.value.here'));
    });

    test(
        'Given a missing authorization header, it returns null for the authorization header',
        () async {
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {},
      );

      expect(headers.authorization, isNull);
    });
  });

  group('BasicAuthorizationHeader', () {
    test(
        'Given a valid username and password, it encodes them with the Basic prefix',
        () async {
      var credentials = base64Encode(utf8.encode('username:password'));
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'authorization': 'Basic $credentials'},
      );
      var header = headers.authorization as BasicAuthorizationHeader;

      expect(header.username, equals('username'));
      expect(header.password, equals("password"));
      expect(
        header.toString(),
        equals(
          'authorization: Basic $credentials',
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
        'Given an invalid Basic authorization header, it throws a FormatException',
        () async {
      var invalidToken = 'Basic invalidBase64';

      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'authorization': invalidToken},
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'Given a Basic authorization header without the Basic prefix, it throws a FormatException',
        () async {
      var encoded = base64Encode(utf8.encode('username:password'));
      var token = 'NotBasic $encoded';

      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'authorization': token},
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'Given special characters in username and password, it encodes them correctly',
        () async {
      var credentials = base64Encode(utf8.encode('user@name:p@ssw0rd!'));
      var headers = await getServerRequestHeaders(
        server: server,
        headers: {'authorization': 'Basic $credentials'},
      );
      var header = headers.authorization as BasicAuthorizationHeader;

      expect(header.username, equals('user@name'));
      expect(header.password, equals("p@ssw0rd!"));
      expect(
        header.toString(),
        equals(
          'authorization: Basic $credentials',
        ),
      );
      expect(
        header.headerValue,
        equals(
          'Basic $credentials',
        ),
      );
    });

    test('Given an invalid Base64-encoded token, it throws a FormatException',
        () async {
      var invalidBase64Token = 'Basic invalid==base64';

      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'authorization': invalidBase64Token},
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test(
        'Given a valid Base64-encoded token without a colon, it throws a FormatException',
        () async {
      var encoded = base64Encode(utf8.encode('usernamepassword')); // No colon
      var token = 'Basic $encoded';

      expect(
        () async => await getServerRequestHeaders(
          server: server,
          headers: {'authorization': token},
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
