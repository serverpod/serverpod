import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import '../../test_tags.dart';

void main() {
  final jwt = Jwt(
    config: JwtConfig(
      algorithm: JwtAlgorithm.hmacSha512(
        SecretKey('test-private-key-for-HS512'),
      ),
      refreshTokenHashPepper: 'test-pepper',
    ),
  );
  final jwtAdmin = jwt.admin;

  withServerpod('Given an auth user with an authentication token,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late UuidValue tokenId;
    late AuthSuccess authSuccess;
    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await jwt.authUsers.create(session);
      authUserId = authUser.id;

      authSuccess = await jwt.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
      tokenId = jwt.jwtUtil.verifyJwt(authSuccess.token).refreshTokenId;
    });

    test(
      'when calling `deleteExpiredRefreshTokens`, then it is unaffected.',
      () async {
        await jwtAdmin.deleteExpiredRefreshTokens(session);

        final tokens = await RefreshToken.db.find(session);

        expect(
          tokens.single.authUserId,
          authUserId,
        );
      },
    );

    group('when calling `deleteRefreshTokens` with that refreshTokenId', () {
      late List<DeletedRefreshToken> deletedTokens;
      setUp(() async {
        deletedTokens = await jwtAdmin.deleteRefreshTokens(
          session,
          refreshTokenId: tokenId,
        );
      });

      test('then that token is deleted.', () async {
        final remainingTokens = await jwt.listJwtTokens(
          session,
          authUserId: authUserId,
        );

        expect(remainingTokens, isEmpty);
      });

      test('then that token is returned from deleteRefreshTokens.', () async {
        expect(deletedTokens, hasLength(1));
        expect(deletedTokens.first.refreshTokenId, tokenId);
        expect(deletedTokens.first.authUserId, authUserId);
      });
    });

    test(
      'when calling `deleteRefreshTokens` with refreshTokenId, authUserId, and method all matching, then that token is deleted.',
      () async {
        await jwtAdmin.deleteRefreshTokens(
          session,
          refreshTokenId: tokenId,
          authUserId: authUserId,
          method: 'test',
        );

        final remainingTokens = await jwt.listJwtTokens(
          session,
          authUserId: authUserId,
        );

        expect(remainingTokens, isEmpty);
      },
    );

    test(
      'when calling `deleteRefreshTokens` with a non-existent refreshTokenId then no tokens are deleted.',
      () async {
        final nonExistentId = const Uuid().v4obj();
        final deletedTokens = await jwtAdmin.deleteRefreshTokens(
          session,
          refreshTokenId: nonExistentId,
        );

        final remainingTokens = await jwt.listJwtTokens(
          session,
          authUserId: authUserId,
        );
        expect(deletedTokens, isEmpty);
        expect(remainingTokens, hasLength(1));
        expect(remainingTokens.single.id, tokenId);
      },
    );

    test(
      'when calling `deleteRefreshTokens` with a non-matching authUserId, then no tokens are deleted.',
      () async {
        final nonExistentUserId = const Uuid().v4obj();

        final deletedTokens = await jwtAdmin.deleteRefreshTokens(
          session,
          authUserId: nonExistentUserId,
        );

        final remainingTokens = await jwt.listJwtTokens(
          session,
          authUserId: authUserId,
        );
        expect(deletedTokens, isEmpty);
        expect(remainingTokens, hasLength(1));
        expect(remainingTokens.single.id, tokenId);
      },
    );

    test(
      'when calling `deleteRefreshTokens` with a non-matching method, then no tokens are deleted.',
      () async {
        final deletedTokens = await jwtAdmin.deleteRefreshTokens(
          session,
          method: 'non-existent-method',
        );

        final remainingTokens = await jwt.listJwtTokens(
          session,
          authUserId: authUserId,
        );
        expect(deletedTokens, isEmpty);
        expect(remainingTokens, hasLength(1));
        expect(remainingTokens.single.id, tokenId);
      },
    );

    test(
      'when deleting all refresh tokens for the user, then it can not be rotated anymore.',
      () async {
        await jwtAdmin.deleteRefreshTokens(
          session,
          authUserId: authUserId,
        );

        await expectLater(
          () => jwtAdmin.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          ),
          throwsA(isA<RefreshTokenNotFoundServerException>()),
        );
      },
    );
  });

  withServerpod('Given an auth user with an expired JWT token,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late AuthSuccess authSuccess;
    late UuidValue tokenId;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await jwt.authUsers.create(
        session,
      );
      authUserId = authUser.id;

      await withClock(
        Clock.fixed(
          DateTime.now().subtract(
            jwt.config.refreshTokenLifetime,
          ),
        ),
        () async {
          authSuccess = await jwt.createTokens(
            session,
            authUserId: authUserId,
            scopes: {},
            method: 'test',
          );

          tokenId = jwt.jwtUtil.verifyJwt(authSuccess.token).refreshTokenId;
        },
      );
    });

    test(
      'when calling `deleteExpiredRefreshTokens`, then that token is removed.',
      () async {
        await jwtAdmin.deleteExpiredRefreshTokens(session);

        final tokens = await RefreshToken.db.find(session);

        expect(tokens, isEmpty);
      },
    );

    test(
      'when calling `rotateRefreshToken` with the expired token, then it throws RefreshTokenExpiredServerException with correct refreshTokenId.',
      () async {
        await expectLater(
          () => jwtAdmin.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          ),
          throwsA(
            isA<RefreshTokenExpiredServerException>().having(
              (final e) => e.refreshTokenId,
              'refreshTokenId',
              tokenId,
            ),
          ),
        );
      },
    );
  });

  withServerpod(
    'Given an auth user with multiple authentication tokens (two with method "test", one with method "google"),',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late UuidValue tokenId1;
      late UuidValue tokenId2;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await jwt.authUsers.create(session);
        authUserId = authUser.id;

        final authSuccess1 = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );
        tokenId1 = jwt.jwtUtil.verifyJwt(authSuccess1.token).refreshTokenId;

        final authSuccess2 = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );
        tokenId2 = jwt.jwtUtil.verifyJwt(authSuccess2.token).refreshTokenId;

        await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'google',
        );
      });

      test(
        'when calling `deleteRefreshTokens` with a specific refreshTokenId, then only that token is deleted.',
        () async {
          await jwtAdmin.deleteRefreshTokens(
            session,
            refreshTokenId: tokenId1,
          );

          final remainingTokens = await jwt.listJwtTokens(
            session,
          );
          expect(remainingTokens, hasLength(2));
          expect(
            remainingTokens.map((final t) => t.id),
            isNot(contains(tokenId1)),
          );
        },
      );

      group('when calling `deleteRefreshTokens` with method "test"', () {
        late List<DeletedRefreshToken> deletedTokens;
        setUp(() async {
          deletedTokens = await jwtAdmin.deleteRefreshTokens(
            session,
            method: 'test',
          );
        });

        test('then returned tokens contains all matching tokens.', () async {
          expect(deletedTokens, hasLength(2));
          expect(
            deletedTokens.map((final t) => t.refreshTokenId),
            containsAll([tokenId1, tokenId2]),
          );
        });

        test('then only tokens not matching the method remains.', () async {
          final remainingTokens = await jwt.listJwtTokens(
            session,
          );
          expect(remainingTokens, hasLength(1));
          expect(
            remainingTokens.map((final t) => t.method),
            isNot(contains('test')),
          );
        });
      });
    },
  );

  withServerpod(
    'Given two auth users, each with two authentication tokens (one with method "test" and one with method "google"),',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue firstUserAuthUserId;
      late UuidValue authUserId2;
      late UuidValue firstUserTestTokenID;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser1 = await jwt.authUsers.create(session);
        firstUserAuthUserId = authUser1.id;

        final authUser2 = await jwt.authUsers.create(session);
        authUserId2 = authUser2.id;

        final authSuccess1 = await jwt.createTokens(
          session,
          authUserId: firstUserAuthUserId,
          scopes: {},
          method: 'test',
        );
        firstUserTestTokenID = jwt.jwtUtil
            .verifyJwt(authSuccess1.token)
            .refreshTokenId;

        await jwt.createTokens(
          session,
          authUserId: firstUserAuthUserId,
          scopes: {},
          method: 'google',
        );

        await jwt.createTokens(
          session,
          authUserId: authUserId2,
          scopes: {},
          method: 'test',
        );

        await jwt.createTokens(
          session,
          authUserId: authUserId2,
          scopes: {},
          method: 'google',
        );
      });

      test(
        "when calling `deleteRefreshTokens` with authUserId for the first user, then only that user's tokens are deleted.",
        () async {
          final deletedTokens = await jwtAdmin.deleteRefreshTokens(
            session,
            authUserId: firstUserAuthUserId,
          );

          expect(deletedTokens, hasLength(2));
          final remainingTokens = await jwt.listJwtTokens(
            session,
          );
          expect(remainingTokens, hasLength(2));
          expect(
            remainingTokens.map((final t) => t.authUserId),
            everyElement(authUserId2),
          );
        },
      );

      test(
        "when calling `deleteRefreshTokens` with authUserId and method 'test' for the first user, then only that user's 'test' tokens are deleted",
        () async {
          final deletedTokens = await jwtAdmin.deleteRefreshTokens(
            session,
            authUserId: firstUserAuthUserId,
            method: 'test',
          );

          expect(deletedTokens, hasLength(1));
          expect(deletedTokens.first.refreshTokenId, firstUserTestTokenID);
          expect(deletedTokens.first.authUserId, firstUserAuthUserId);

          final remainingTokens = await jwt.listJwtTokens(
            session,
          );
          expect(remainingTokens, hasLength(3));
        },
      );

      test(
        'when calling `deleteRefreshTokens` with no filters, then all tokens are deleted.',
        () async {
          await jwtAdmin.deleteRefreshTokens(
            session,
          );

          final remainingTokens = await jwt.listJwtTokens(
            session,
          );
          expect(remainingTokens, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given an auth user with a refresh token with scopes and extra claims,',
    testGroupTagsOverride: TestTags.concurrencyOneTestTags,
    (final sessionBuilder, final endpoints) {
      const String scopeName = 'test scope';
      late Session session;
      late UuidValue authUserId;
      late AuthSuccess authSuccess;

      setUp(() async {
        session = sessionBuilder.build();

        final authUser = await jwt.authUsers.create(
          session,
        );
        authUserId = authUser.id;

        authSuccess = await jwt.createTokens(
          session,
          authUserId: authUserId,
          scopes: {const Scope(scopeName)},
          extraClaims: {'string': 'foo', 'int': 1},
          method: 'test',
        );
      });

      test(
        'when rotating the tokens, then a new refresh and access token is returned.',
        () async {
          final newTokenPair = await jwtAdmin.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );

          expect(newTokenPair.accessToken, isNot(authSuccess.token));
          expect(newTokenPair.refreshToken, isNot(authSuccess.refreshToken));
        },
      );

      test(
        'when rotating tokens multiple times within the same second, then new tokens are returned.',
        () async {
          final newTokenPairs = await withClock(
            Clock.fixed(DateTime.now()),
            () => Future.wait(
              List.generate(
                3,
                (final _) => jwtAdmin.rotateRefreshToken(
                  session,
                  refreshToken: authSuccess.refreshToken!,
                ),
              ),
            ),
          );

          final tokens = newTokenPairs.map((final t) => t.accessToken).toSet();
          expect(tokens, hasLength(3));
          expect(tokens.add(authSuccess.token), isTrue);

          final refreshTokens = newTokenPairs
              .map((final t) => t.refreshToken)
              .toSet();
          expect(refreshTokens, hasLength(3));
          expect(refreshTokens.add(authSuccess.refreshToken!), isTrue);
        },
      );

      test(
        'when rotating the tokens, then the new access token refers to the same refresh token ID.',
        () async {
          final newTokenPair = await jwtAdmin.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );

          expect(
            _extractRefreshTokenId(authSuccess.token),
            _extractRefreshTokenId(newTokenPair.accessToken),
          );
        },
      );

      test(
        'when rotating the tokens, then the new access token has a different `jwtId`.',
        () async {
          final newTokenPair = await jwtAdmin.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );

          final decodedToken = JWT.decode(authSuccess.token);
          final newDecodedToken = JWT.decode(newTokenPair.accessToken);

          expect(newDecodedToken.jwtId, isNotNull);
          expect(decodedToken.jwtId, isNot(newDecodedToken.jwtId));
        },
      );

      test(
        'when rotating the tokens, then the new access token contains the extra claims in the `payload` on the top-level.',
        () async {
          final newTokenPair = await jwtAdmin.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );

          final newDecodedToken = JWT.decode(newTokenPair.accessToken);

          expect((newDecodedToken.payload as Map)['string'], 'foo');
          expect((newDecodedToken.payload as Map)['int'], 1);
        },
      );

      test(
        'when changing the configured pepper, then attempting to rotate the token throws an error.',
        () async {
          final differentPepperJwt = Jwt(
            config: JwtConfig(
              algorithm: jwt.config.algorithm,
              refreshTokenHashPepper:
                  '${jwt.config.refreshTokenHashPepper}-addition',
            ),
          );

          await expectLater(
            () => differentPepperJwt.admin.rotateRefreshToken(
              session,
              refreshToken: authSuccess.refreshToken!,
            ),
            throwsA(isA<RefreshTokenInvalidSecretServerException>()),
          );
        },
      );

      test(
        'when trying to rotate the token with a wrong fixed secret, then it throws a "not found" error.',
        () async {
          final tokenParts = authSuccess.refreshToken!.split(':');
          tokenParts[2] = 'dGVzdA==';

          final tokenWithUpdatedFixedSecret = tokenParts.join(':');

          await expectLater(
            () => jwtAdmin.rotateRefreshToken(
              session,
              refreshToken: tokenWithUpdatedFixedSecret,
            ),
            throwsA(isA<RefreshTokenNotFoundServerException>()),
          );
        },
      );

      test(
        'when trying to rotate the token with a wrong variable secret, then it throws an error.',
        () async {
          final tokenParts = authSuccess.refreshToken!.split(':');
          tokenParts[3] = 'dGVzdA==';

          final tokenWithUpdatedFixedSecret = tokenParts.join(':');

          await expectLater(
            () => jwtAdmin.rotateRefreshToken(
              session,
              refreshToken: tokenWithUpdatedFixedSecret,
            ),
            throwsA(isA<RefreshTokenInvalidSecretServerException>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an auth user with tokens created using extraClaimsProvider,',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();

        const authUsers = AuthUsers();
        final authUser = await authUsers.create(session);
        authUserId = authUser.id;
      });

      test(
        'when rotating tokens created with a provider, then provider claims are preserved.',
        () async {
          final jwtWithHook = Jwt(
            config: JwtConfig(
              algorithm: JwtAlgorithm.hmacSha512(
                SecretKey('test-private-key-for-HS512'),
              ),
              refreshTokenHashPepper: 'test-pepper',
              extraClaimsProvider: (final session, final context) async {
                return {'hookClaim': 'persistsAcrossRotation'};
              },
            ),
          );

          final authSuccess = await jwtWithHook.createTokens(
            session,
            authUserId: authUserId,
            scopes: {},
            method: 'test',
          );

          final rotatedTokenPair = await jwtWithHook.admin.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );

          final decodedToken = JWT.decode(rotatedTokenPair.accessToken);
          final payload = decodedToken.payload as Map;

          expect(payload['hookClaim'], 'persistsAcrossRotation');
        },
      );
    },
  );

  withServerpod('Given an initial TokenPair and its refreshed successor,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late AuthSuccess initialAuthSuccess;
    late TokenPair refreshedTokenPair;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await jwt.authUsers.create(session);

      initialAuthSuccess = await jwt.createTokens(
        session,
        authUserId: authUser.id,
        scopes: {},
        method: 'test',
      );

      refreshedTokenPair = await jwtAdmin.rotateRefreshToken(
        session,
        refreshToken: initialAuthSuccess.refreshToken!,
      );
    });

    test(
      'when requesting a rotation with the previous (initial) pair, then the current (refreshed) one becomes unusable as well.',
      () async {
        await expectLater(
          () => jwtAdmin.rotateRefreshToken(
            session,
            refreshToken: initialAuthSuccess.refreshToken!,
          ),
          throwsA(isA<RefreshTokenInvalidSecretServerException>()),
        );

        await expectLater(
          () => jwtAdmin.rotateRefreshToken(
            session,
            refreshToken: refreshedTokenPair.refreshToken,
          ),
          throwsA(isA<RefreshTokenNotFoundServerException>()),
        );
      },
    );
  });
}

UuidValue _extractRefreshTokenId(final String accessToken) {
  final jwt = JWT.decode(accessToken);
  const claimName = 'dev.serverpod.refreshTokenId';
  final refreshTokenIdClaim = (jwt.payload as Map)[claimName] as String;
  return UuidValue.withValidation(refreshTokenIdClaim);
}
