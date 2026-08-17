import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/common/models/auth_success.dart';
import 'package:serverpod_auth_core_server/src/session/business/server_side_sessions_token.dart';
import 'package:serverpod_auth_core_server/src/session/util/auth_success_extension.dart';
import 'package:test/test.dart';

void main() {
  group('Given an `AuthSuccess` with a valid server side session token,', () {
    late final serverSideSessionId = const Uuid().v4obj();

    late final sessionToken = buildServerSideSessionToken(
      serverSideSessionId: serverSideSessionId,
      secret: Uint8List.fromList([1, 2, 3, 4, 5]),
    );

    late final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: sessionToken,
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, '
      'then the session ID is returned.',
      () {
        expect(authSuccess.serverSideSessionId, serverSideSessionId);
      },
    );
  });

  group('Given an `AuthSuccess` with an empty token,', () {
    late final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: '',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, '
      'then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with an invalid token format,', () {
    late final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: 'invalid-token-format',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, '
      'then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with a token missing the prefix,', () {
    late final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: 'not-a-valid-session-token',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, '
      'then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with a token with invalid base64,', () {
    late final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: 'c2Fz!!!invalid-base64',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, '
      'then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with a token with invalid UUID,', () {
    // Create a token with valid prefix but invalid UUID bytes
    late final invalidUuidBytes = Uint8List.fromList([1, 2, 3]); // Too short
    late final invalidToken = base64Url.encode([
      ...utf8.encode('sas'),
      ...invalidUuidBytes,
    ]);

    late final authSuccess = AuthSuccess(
      authStrategy: 'session',
      token: invalidToken,
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `serverSideSessionId` field, '
      'then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.serverSideSessionId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}
