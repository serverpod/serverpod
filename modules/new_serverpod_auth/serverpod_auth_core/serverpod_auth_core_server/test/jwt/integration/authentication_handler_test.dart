import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

void main() {
  final authenticationTokens = AuthenticationTokens(
    config: AuthenticationTokenConfig(
      algorithm: AuthenticationTokenAlgorithm.hmacSha512(
        SecretKey('test-private-key-for-HS512'),
      ),
      refreshTokenHashPepper: 'test-pepper',
    ),
  );
  withServerpod('Given no active JWT sessions,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;

    setUp(() async {
      session = sessionBuilder.build();
    });

    test(
      'when calling the authentication handler with an non-JWT String, then it returns `null`.',
      () async {
        final authInfo = await authenticationTokens.authenticationHandler(
          session,
          'yolo',
        );

        expect(authInfo, isNull);
      },
    );

    test(
      'when calling the authentication handler with an invalid JWT String, then it returns `null`.',
      () async {
        final authInfo = await authenticationTokens.authenticationHandler(
          session,
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
        );

        expect(authInfo, isNull);
      },
    );
  });

  withServerpod(
    'Given a valid `TokenPair` for a refresh token with scopes and extra claims,',
    (
      final sessionBuilder,
      final endpoints,
    ) {
      const String scopeName = 'test scope';
      late Session session;
      late UuidValue authUserId;
      late AuthSuccess authSuccess;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await authenticationTokens.authUsers.create(session);
        authUserId = authUser.id;

        authSuccess = await authenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {const Scope(scopeName)},
          extraClaims: {'string': 'foo', 'int': 1},
          method: 'test',
        );
      });

      test(
        'when calling the authentication handler, then it returns the user and scopes.',
        () async {
          final authInfo = await authenticationTokens.authenticationHandler(
            session,
            authSuccess.token,
          );

          expect(authInfo, isNotNull);
          expect(authInfo!.authUserId, authUserId);
          expect(authInfo.scopes, {const Scope(scopeName)});
        },
      );

      test(
        'when calling the authentication handler, then the extra claims are available on the auth info.',
        () async {
          final authInfo = await authenticationTokens.authenticationHandler(
            session,
            authSuccess.token,
          );

          expect(authInfo?.extraClaims, equals({'string': 'foo', 'int': 1}));
        },
      );

      test(
        'when calling the authentication handler after the expiration time has elapsed, then it returns `null`.',
        () async {
          final authInfo = await withClock(
            Clock.fixed(DateTime.now().add(const Duration(minutes: 11))),
            () => authenticationTokens.authenticationHandler(
              session,
              authSuccess.token,
            ),
          );

          expect(authInfo, isNull);
        },
      );

      test(
        'when calling the authentication handler after the secret key has been changed, then it returns `null`.',
        () async {
          final differentAuthenticationTokens = AuthenticationTokens(
            config: AuthenticationTokenConfig(
              algorithm: AuthenticationTokenAlgorithm.hmacSha512(
                SecretKey('test-private-key-for-HS512-different'),
              ),
              refreshTokenHashPepper: 'test-pepper',
            ),
          );
          final authInfo = await differentAuthenticationTokens
              .authenticationHandler(
                session,
                authSuccess.token,
              );

          expect(authInfo, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given a valid `TokenPair` for a refresh token with scopes and extra claims,',
    (
      final sessionBuilder,
      final endpoints,
    ) {
      const String scopeName = 'test scope';
      late Session session;
      late UuidValue authUserId;
      late AuthSuccess authSuccess;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await authenticationTokens.authUsers.create(session);
        authUserId = authUser.id;

        authSuccess = await authenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {const Scope(scopeName)},
          extraClaims: {'string': 'foo', 'int': 1},
          method: 'test',
        );
      });

      test(
        'when rotating the tokens, then both the old (non-expired) and new access token are valid.',
        () async {
          final newTokenPair = await authenticationTokens.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );

          expect(
            await authenticationTokens.authenticationHandler(
              session,
              authSuccess.token,
            ),
            isNotNull,
          );

          expect(
            await authenticationTokens.authenticationHandler(
              session,
              newTokenPair.accessToken,
            ),
            isNotNull,
          );
        },
      );

      test(
        'when deleting all refresh tokens for the user, then the access token is still valid until it expires.',
        () async {
          await authenticationTokens.destroyAllRefreshTokens(
            session,
            authUserId: authUserId,
          );

          final authInfo = await authenticationTokens.authenticationHandler(
            session,
            authSuccess.token,
          );

          expect(authInfo, isNotNull);
        },
      );
    },
  );
}
