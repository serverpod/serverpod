import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/src/generated/jwt/models/refresh_token.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

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
    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await jwt.authUsers.create(session);
      authUserId = authUser.id;

      final authSuccess = await jwt.createTokens(
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

    test(
      'when calling `listJwtTokens` for all users, then it is returned.',
      () async {
        final tokens = await jwtAdmin.listJwtTokens(
          session,
        );

        expect(
          tokens.single.authUserId,
          authUserId,
        );
      },
    );

    test(
      'when calling `listJwtTokens` for that specific user, then it is returned.',
      () async {
        final tokens = await jwtAdmin.listJwtTokens(
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
      'when calling `listJwtTokens` for another user, then nothing is returned.',
      () async {
        final tokens = await jwtAdmin.listJwtTokens(
          session,
          authUserId: const Uuid().v4obj(),
        );

        expect(tokens, isEmpty);
      },
    );

    test(
      'when calling `listJwtTokens` with matching method, then it is returned.',
      () async {
        final tokens = await jwtAdmin.listJwtTokens(
          session,
          method: 'test',
        );

        expect(tokens, hasLength(1));
        expect(tokens.single.authUserId, authUserId);
      },
    );

    test(
      'when calling `listJwtTokens` with non-matching method, then nothing is returned.',
      () async {
        final tokens = await jwtAdmin.listJwtTokens(
          session,
          method: 'something else',
        );

        expect(tokens, isEmpty);
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
        final remainingTokens = await jwtAdmin.listJwtTokens(
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

        final remainingTokens = await jwtAdmin.listJwtTokens(
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

        final remainingTokens = await jwtAdmin.listJwtTokens(
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

        final remainingTokens = await jwtAdmin.listJwtTokens(
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

        final remainingTokens = await jwtAdmin.listJwtTokens(
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
    'Given two auth user with 100 JWT tokens each,',
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

        authUserId1 = (await jwt.authUsers.create(session)).id;
        authUserId2 = (await jwt.authUsers.create(session)).id;
        refreshTokenIdsInOrderOfCreation = [];

        for (var i = 0; i < 100; i++) {
          for (final authUserId in [authUserId1, authUserId2]) {
            final authSuccess = await jwt.createTokens(
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
        'when calling `listJwtTokens`, then it returns the first 100 tokens in order of creation date ASC.',
        () async {
          final tokens = await jwtAdmin.listJwtTokens(
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
        'when calling `listJwtTokens(offset: 50)`, then it returns the next 100 tokens in order of creation date ASC.',
        () async {
          final tokens = await jwtAdmin.listJwtTokens(
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
        "when calling `listJwtTokens(limit: 2)` for a specific auth user, then it returns that user's first 2 tokens in order of creation date ASC.",
        () async {
          final tokens = await jwtAdmin.listJwtTokens(
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
        'when calling `listJwtTokens` with `limit: 0`, then it throws.',
        () async {
          await expectLater(
            () => jwtAdmin.listJwtTokens(
              session,
              authUserId: authUserId1,
              limit: 0,
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'when calling `listJwtTokens` with `limit: 1001`, then it throws.',
        () async {
          await expectLater(
            () => jwtAdmin.listJwtTokens(
              session,
              authUserId: authUserId1,
              limit: 1001,
            ),
            throwsArgumentError,
          );
        },
      );

      test(
        'when calling `listJwtTokens` with `offset: -1`, then it throws.',
        () async {
          await expectLater(
            () => jwtAdmin.listJwtTokens(
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

  withServerpod('Given an auth user with an expired JWT token,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late UuidValue authUserId;

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
          await jwt.createTokens(
            session,
            authUserId: authUserId,
            scopes: {},
            method: 'test',
          );
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

          final remainingTokens = await jwtAdmin.listJwtTokens(
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
          final remainingTokens = await jwtAdmin.listJwtTokens(
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
          final remainingTokens = await jwtAdmin.listJwtTokens(
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

          final remainingTokens = await jwtAdmin.listJwtTokens(
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

          final remainingTokens = await jwtAdmin.listJwtTokens(
            session,
          );
          expect(remainingTokens, isEmpty);
        },
      );
    },
  );
}
