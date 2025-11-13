import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/src/generated/jwt/models/refresh_token.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import '../../test_tags.dart';

void main() {
  final authenticationTokens = AuthenticationTokens(
    config: AuthenticationTokenConfig(
      algorithm: AuthenticationTokenAlgorithm.hmacSha512(
        SecretKey('test-private-key-for-HS512'),
      ),
      refreshTokenHashPepper: 'test-pepper',
    ),
  );
  final authenticationTokensAdmin = authenticationTokens.admin;

  withServerpod('Given an auth user with an authentication token,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late UuidValue tokenId;
    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await authenticationTokens.authUsers.create(session);
      authUserId = authUser.id;

      final authSuccess = await authenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
      tokenId = authenticationTokens.jwtUtil
          .verifyJwt(authSuccess.token)
          .refreshTokenId;
    });

    test(
      'when calling `deleteExpiredRefreshTokens`, then it is unaffected.',
      () async {
        await authenticationTokensAdmin.deleteExpiredRefreshTokens(session);

        final tokens = await RefreshToken.db.find(session);

        expect(
          tokens.single.authUserId,
          authUserId,
        );
      },
    );

    test(
      'when calling `findAuthenticationTokens` for all users, then it is returned.',
      () async {
        final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
          session,
        );

        expect(
          tokens.single.authUserId,
          authUserId,
        );
      },
    );

    test(
      'when calling `findAuthenticationTokens` for that specific user, then it is returned.',
      () async {
        final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
          session,
          authUserId: authUserId,
        );

        expect(
          tokens.single.authUserId,
          authUserId,
        );
      },
    );

    test(
      'when calling `findAuthenticationTokens` for another user, then nothing is returned.',
      () async {
        final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
          session,
          authUserId: const Uuid().v4obj(),
        );

        expect(tokens, isEmpty);
      },
    );

    test(
      'when calling `findAuthenticationTokens` with matching method, then it is returned.',
      () async {
        final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
          session,
          method: 'test',
        );

        expect(tokens, hasLength(1));
        expect(tokens.single.authUserId, authUserId);
      },
    );

    test(
      'when calling `findAuthenticationTokens` with non-matching method, then nothing is returned.',
      () async {
        final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
          session,
          method: 'something else',
        );

        expect(tokens, isEmpty);
      },
    );

    group('when calling `deleteRefreshTokens` with that refreshTokenId', () {
      late List<DeletedRefreshToken> deletedTokens;
      setUp(() async {
        deletedTokens = await authenticationTokensAdmin.deleteRefreshTokens(
          session,
          refreshTokenId: tokenId,
        );
      });

      test('then that token is deleted.', () async {
        final remainingTokens = await authenticationTokensAdmin
            .listAuthenticationTokens(
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
        await authenticationTokensAdmin.deleteRefreshTokens(
          session,
          refreshTokenId: tokenId,
          authUserId: authUserId,
          method: 'test',
        );

        final remainingTokens = await authenticationTokensAdmin
            .listAuthenticationTokens(
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
        final deletedTokens = await authenticationTokensAdmin
            .deleteRefreshTokens(
              session,
              refreshTokenId: nonExistentId,
            );

        final remainingTokens = await authenticationTokensAdmin
            .listAuthenticationTokens(
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

        final deletedTokens = await authenticationTokensAdmin
            .deleteRefreshTokens(
              session,
              authUserId: nonExistentUserId,
            );

        final remainingTokens = await authenticationTokensAdmin
            .listAuthenticationTokens(
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
        final deletedTokens = await authenticationTokensAdmin
            .deleteRefreshTokens(
              session,
              method: 'non-existent-method',
            );

        final remainingTokens = await authenticationTokensAdmin
            .listAuthenticationTokens(
              session,
              authUserId: authUserId,
            );
        expect(deletedTokens, isEmpty);
        expect(remainingTokens, hasLength(1));
        expect(remainingTokens.single.id, tokenId);
      },
    );
  });

  withServerpod(
    'Given two auth user with 100 authentication tokens each,',
    // Creating authentication tokens takes time, so we do it once in
    // setUpAll and then rollback the database after all tests in the group are complete.
    rollbackDatabase: RollbackDatabase.afterAll,
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId1;
      late UuidValue authUserId2;
      late List<UuidValue> refreshTokenIdsInOrderOfCreation;

      setUpAll(() async {
        session = sessionBuilder.build();

        authUserId1 = (await authenticationTokens.authUsers.create(session)).id;
        authUserId2 = (await authenticationTokens.authUsers.create(session)).id;
        refreshTokenIdsInOrderOfCreation = [];

        for (var i = 0; i < 100; i++) {
          for (final authUserId in [authUserId1, authUserId2]) {
            final authSuccess = await authenticationTokens.createTokens(
              session,
              authUserId: authUserId,
              scopes: {},
              method: 'test',
            );

            refreshTokenIdsInOrderOfCreation.add(
              UuidValue.fromByteList(
                base64Decode(authSuccess.refreshToken!.split(':')[1]),
              ),
            );
          }
        }
      });

      test(
        'when calling `listAuthenticationTokens`, then it returns the first 100 tokens in order of creation date ASC.',
        () async {
          final tokens = await authenticationTokensAdmin
              .listAuthenticationTokens(
                session,
              );

          expect(tokens, hasLength(100));
          expect(
            tokens.map((final t) => t.id),
            refreshTokenIdsInOrderOfCreation.take(100),
          );
        },
      );

      test(
        'when calling `listAuthenticationTokens(offset: 50)`, then it returns the next 100 tokens in order of creation date ASC.',
        () async {
          final tokens = await authenticationTokensAdmin
              .listAuthenticationTokens(
                session,
                offset: 50,
              );

          expect(tokens, hasLength(100));
          expect(
            tokens.map((final t) => t.id),
            refreshTokenIdsInOrderOfCreation.skip(50).take(100),
          );
        },
      );

      test(
        "when calling `listAuthenticationTokens(limit: 2)` for a specific auth user, then it returns that user's first 2 tokens in order of creation date ASC.",
        () async {
          final tokens = await authenticationTokensAdmin
              .listAuthenticationTokens(
                session,
                authUserId: authUserId1,
                limit: 2,
              );

          expect(tokens, hasLength(2));
          expect(
            tokens.map((final t) => t.id),
            [
              refreshTokenIdsInOrderOfCreation[0],
              refreshTokenIdsInOrderOfCreation[2],
            ],
          );
        },
      );

      test(
        'when calling `listAuthenticationTokens` with `limit: 0`, then it throws.',
        () async {
          await expectLater(
            () => authenticationTokensAdmin.listAuthenticationTokens(
              session,
              authUserId: authUserId1,
              limit: 0,
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'when calling `listAuthenticationTokens` with `limit: 1001`, then it throws.',
        () async {
          await expectLater(
            () => authenticationTokensAdmin.listAuthenticationTokens(
              session,
              authUserId: authUserId1,
              limit: 1001,
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'when calling `listAuthenticationTokens` with `offset: -1`, then it throws.',
        () async {
          await expectLater(
            () => authenticationTokensAdmin.listAuthenticationTokens(
              session,
              authUserId: authUserId1,
              offset: -1,
            ),
            throwsArgumentError,
          );
        },
      );
    },
  );

  withServerpod('Given an auth user with an expired authentication token,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;
    late AuthSuccess authSuccess;
    late UuidValue tokenId;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await authenticationTokens.authUsers.create(
        session,
      );
      authUserId = authUser.id;

      await withClock(
        Clock.fixed(
          DateTime.now().subtract(
            authenticationTokens.config.refreshTokenLifetime,
          ),
        ),
        () async {
          authSuccess = await authenticationTokens.createTokens(
            session,
            authUserId: authUserId,
            scopes: {},
            method: 'test',
          );

          tokenId = authenticationTokens.jwtUtil
              .verifyJwt(authSuccess.token)
              .refreshTokenId;
        },
      );
    });

    test(
      'when calling `deleteExpiredRefreshTokens`, then that token is removed.',
      () async {
        await authenticationTokensAdmin.deleteExpiredRefreshTokens(session);

        final tokens = await RefreshToken.db.find(session);

        expect(tokens, isEmpty);
      },
    );

    test(
      'when calling `rotateRefreshToken` with the expired token, then it throws RefreshTokenExpiredException with correct refreshTokenId.',
      () async {
        await expectLater(
          () => authenticationTokensAdmin.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          ),
          throwsA(
            isA<RefreshTokenExpiredException>().having(
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

        final authUser = await authenticationTokens.authUsers.create(session);
        authUserId = authUser.id;

        final authSuccess1 = await authenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );
        tokenId1 = authenticationTokens.jwtUtil
            .verifyJwt(authSuccess1.token)
            .refreshTokenId;

        final authSuccess2 = await authenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );
        tokenId2 = authenticationTokens.jwtUtil
            .verifyJwt(authSuccess2.token)
            .refreshTokenId;

        await authenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'google',
        );
      });

      test(
        'when calling `deleteRefreshTokens` with a specific refreshTokenId, then only that token is deleted.',
        () async {
          await authenticationTokensAdmin.deleteRefreshTokens(
            session,
            refreshTokenId: tokenId1,
          );

          final remainingTokens = await authenticationTokensAdmin
              .listAuthenticationTokens(
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
          deletedTokens = await authenticationTokensAdmin.deleteRefreshTokens(
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
          final remainingTokens = await authenticationTokensAdmin
              .listAuthenticationTokens(
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

        final authUser1 = await authenticationTokens.authUsers.create(session);
        firstUserAuthUserId = authUser1.id;

        final authUser2 = await authenticationTokens.authUsers.create(session);
        authUserId2 = authUser2.id;

        final authSuccess1 = await authenticationTokens.createTokens(
          session,
          authUserId: firstUserAuthUserId,
          scopes: {},
          method: 'test',
        );
        firstUserTestTokenID = authenticationTokens.jwtUtil
            .verifyJwt(authSuccess1.token)
            .refreshTokenId;

        await authenticationTokens.createTokens(
          session,
          authUserId: firstUserAuthUserId,
          scopes: {},
          method: 'google',
        );

        await authenticationTokens.createTokens(
          session,
          authUserId: authUserId2,
          scopes: {},
          method: 'test',
        );

        await authenticationTokens.createTokens(
          session,
          authUserId: authUserId2,
          scopes: {},
          method: 'google',
        );
      });

      test(
        "when calling `deleteRefreshTokens` with authUserId for the first user, then only that user's tokens are deleted.",
        () async {
          final deletedTokens = await authenticationTokensAdmin
              .deleteRefreshTokens(
                session,
                authUserId: firstUserAuthUserId,
              );

          expect(deletedTokens, hasLength(2));
          final remainingTokens = await authenticationTokensAdmin
              .listAuthenticationTokens(
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
          final deletedTokens = await authenticationTokensAdmin
              .deleteRefreshTokens(
                session,
                authUserId: firstUserAuthUserId,
                method: 'test',
              );

          expect(deletedTokens, hasLength(1));
          expect(deletedTokens.first.refreshTokenId, firstUserTestTokenID);
          expect(deletedTokens.first.authUserId, firstUserAuthUserId);

          final remainingTokens = await authenticationTokensAdmin
              .listAuthenticationTokens(
                session,
              );
          expect(remainingTokens, hasLength(3));
        },
      );

      test(
        'when calling `deleteRefreshTokens` with no filters, then all tokens are deleted.',
        () async {
          await authenticationTokensAdmin.deleteRefreshTokens(
            session,
          );

          final remainingTokens = await authenticationTokensAdmin
              .listAuthenticationTokens(
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

        final authUser = await authenticationTokens.authUsers.create(
          session,
        );
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
        'when rotating the tokens, then a new refresh and access token is returned.',
        () async {
          final newTokenPair = await authenticationTokensAdmin
              .rotateRefreshToken(
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
                (final _) => authenticationTokensAdmin.rotateRefreshToken(
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
          final newTokenPair = await authenticationTokensAdmin
              .rotateRefreshToken(
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
          final newTokenPair = await authenticationTokensAdmin
              .rotateRefreshToken(
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
          final newTokenPair = await authenticationTokensAdmin
              .rotateRefreshToken(
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
          final differentPepperAuthenticationTokens = AuthenticationTokens(
            config: AuthenticationTokenConfig(
              algorithm: authenticationTokens.config.algorithm,
              refreshTokenHashPepper:
                  '${authenticationTokens.config.refreshTokenHashPepper}-addition',
            ),
          );

          await expectLater(
            () => differentPepperAuthenticationTokens.admin.rotateRefreshToken(
              session,
              refreshToken: authSuccess.refreshToken!,
            ),
            throwsA(isA<RefreshTokenInvalidSecretException>()),
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
            () => authenticationTokensAdmin.rotateRefreshToken(
              session,
              refreshToken: tokenWithUpdatedFixedSecret,
            ),
            throwsA(isA<RefreshTokenNotFoundException>()),
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
            () => authenticationTokensAdmin.rotateRefreshToken(
              session,
              refreshToken: tokenWithUpdatedFixedSecret,
            ),
            throwsA(isA<RefreshTokenInvalidSecretException>()),
          );
        },
      );
    },
  );
}

UuidValue _extractRefreshTokenId(final String accessToken) {
  final jwt = JWT.decode(accessToken);
  const claimName = 'dev.serverpod.refreshTokenId';
  final refreshTokenIdClaim = (jwt.payload as Map)[claimName] as String;
  return UuidValue.withValidation(refreshTokenIdClaim);
}
