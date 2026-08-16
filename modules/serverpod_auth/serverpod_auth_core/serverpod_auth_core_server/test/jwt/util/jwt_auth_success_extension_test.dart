import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/generated/common/models/auth_success.dart';
import 'package:serverpod_auth_core_server/src/generated/jwt/models/refresh_token.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/refresh_token_string.dart';
import 'package:serverpod_auth_core_server/src/jwt/util/jwt_auth_success_extension.dart';
import 'package:test/test.dart';

void main() {
  group('Given an `AuthSuccess` with a valid JWT refresh token', () {
    final refreshTokenId = const Uuid().v4obj();

    final refreshTokenString = RefreshTokenString.buildRefreshTokenString(
      refreshToken: RefreshToken(
        id: refreshTokenId,
        authUserId: const Uuid().v4obj(),
        scopeNames: {},
        fixedSecret: ByteData.sublistView(Uint8List.fromList([1, 2, 3, 4])),
        rotatingSecretHash: '',
        method: 'test',
      ),
      rotatingSecret: Uint8List.fromList([5, 6, 7, 8]),
    );

    final authSuccess = AuthSuccess(
      authStrategy: 'jwt',
      token: 'access-token',
      refreshToken: refreshTokenString,
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `jwtRefreshTokenId` field, then the refresh token ID is returned.',
      () {
        expect(authSuccess.jwtRefreshTokenId, refreshTokenId);
      },
    );
  });

  group('Given an `AuthSuccess` with a null refresh token', () {
    final authSuccess = AuthSuccess(
      authStrategy: 'jwt',
      token: 'access-token',
      refreshToken: null,
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `jwtRefreshTokenId` field, then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.jwtRefreshTokenId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with an invalid refresh token format', () {
    final authSuccess = AuthSuccess(
      authStrategy: 'jwt',
      token: 'access-token',
      refreshToken: 'invalid-refresh-token-format',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `jwtRefreshTokenId` field, then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.jwtRefreshTokenId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with a refresh token missing the prefix', () {
    final authSuccess = AuthSuccess(
      authStrategy: 'jwt',
      token: 'access-token',
      refreshToken: 'not-sajrt:some:token:parts',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `jwtRefreshTokenId` field, then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.jwtRefreshTokenId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });

  group('Given an `AuthSuccess` with a refresh token with invalid UUID', () {
    final authSuccess = AuthSuccess(
      authStrategy: 'jwt',
      token: 'access-token',
      refreshToken: 'sajrt:invalid-base64-uuid:some:parts',
      authUserId: const Uuid().v4obj(),
      scopeNames: {},
    );

    test(
      'when reading the `jwtRefreshTokenId` field, then it throws a FormatException.',
      () {
        expect(
          () => authSuccess.jwtRefreshTokenId,
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}
