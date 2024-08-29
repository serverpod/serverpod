import 'dart:convert';

import 'package:relic/src/headers/authorization_header.dart';
import 'package:test/test.dart';

void main() {
  group('BearerAuthorizationHeader', () {
    test('Default prefix and token value', () {
      var header = BearerAuthorizationHeader(
        tokenValue: "token.value.here",
      );

      expect(header.prefixValue, equals('Bearer '));
      expect(header.tokenValue, equals("token.value.here"));
      expect(
          header.toString(), equals('authorization: Bearer token.value.here'));
      expect(header.headerValue(), equals('Bearer token.value.here'));
    });

    test('Custom prefix and token value', () {
      var header = BearerAuthorizationHeader(
        prefixValue: 'Updated ',
        tokenValue: "token.value.here",
      );

      expect(header.prefixValue, equals('Updated '));
      expect(header.tokenValue, equals("token.value.here"));
      expect(
          header.toString(), equals('authorization: Updated token.value.here'));
      expect(header.headerValue(), equals('Updated token.value.here'));
    });
  });

  group('BasicAuthorizationHeader', () {
    test('Default prefix with username and password', () {
      var header = BasicAuthorizationHeader(
        username: "username",
        password: "password",
      );

      expect(header.prefixValue, equals('Basic '));
      expect(header.username, equals('username'));
      expect(header.password, equals("password"));
      expect(
        header.toString(),
        equals(
          'authorization: Basic ${base64Encode(utf8.encode('username:password'))}',
        ),
      );
      expect(
        header.headerValue(),
        equals(
          'Basic ${base64Encode(utf8.encode('username:password'))}',
        ),
      );
    });

    test('Custom prefix with username and password', () {
      var header = BasicAuthorizationHeader(
        prefixValue: 'Updated ',
        username: "username",
        password: "password",
      );

      expect(header.prefixValue, equals('Updated '));
      expect(header.username, equals('username'));
      expect(header.password, equals("password"));
      expect(
        header.toString(),
        equals(
          'authorization: Updated ${base64Encode(utf8.encode('username:password'))}',
        ),
      );
      expect(
        header.headerValue(),
        equals(
          'Updated ${base64Encode(utf8.encode('username:password'))}',
        ),
      );
    });
  });
}
