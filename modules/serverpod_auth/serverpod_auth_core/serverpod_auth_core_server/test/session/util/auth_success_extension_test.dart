import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/common/models/auth_success.dart';
import 'package:serverpod_auth_core_server/src/session/business/server_side_sessions_token.dart';
import 'package:serverpod_auth_core_server/src/session/util/auth_success_extension.dart';
import 'package:test/test.dart';

void main() {
  group('Given an `AuthSuccess` with a valid server side session token', () {
    final serverSideSessionId = const Uuid().v4obj();

    final sessionToken = buildServerSideSessionToken(
      serverSideSessionId: serverSideSessionId,
      secret: Uint8List.fromList([1, 2, 3, 4, 5]),
    );

    final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: sessionToken,
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, then the session ID is returned.',
      () {
        expect(authSuccess.serverSideSessionId, serverSideSessionId);
      },
    );
  });

  group('Given an `AuthSuccess` with an empty token', () {
    final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: '',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with an invalid token format', () {
    final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: 'invalid-token-format',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with a token missing the prefix', () {
    final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: 'not-a-valid-session-token',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with a token with invalid base64', () {
    final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: 'c2Fz!!!invalid-base64',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with a token with invalid UUID', () {
    // Create a token with valid prefix but invalid UUID bytes
    final invalidUuidBytes = Uint8List.fromList([1, 2, 3]); // Too short
    final invalidToken = base64Url.encode([
      ...utf8.encode('sas'),
      ...invalidUuidBytes,
    ]);

    final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: invalidToken,
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}
