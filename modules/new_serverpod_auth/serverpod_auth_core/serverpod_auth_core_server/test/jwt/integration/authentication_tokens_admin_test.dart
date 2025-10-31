import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/src/generated/jwt/models/refresh_token.dart';
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
  final authenticationTokensAdmin = authenticationTokens.admin;

  withServerpod('Given an auth user with an authentication token,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await AuthUsers.create(session);
      authUserId = authUser.id;

      await authenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
    });

    test('when calling `deleteExpiredRefreshTokens`, then it is unaffected.',
        () async {
      await authenticationTokensAdmin.deleteExpiredRefreshTokens(session);

      final tokens = await RefreshToken.db.find(session);

      expect(
        tokens.single.authUserId,
        authUserId,
      );
    });

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
    });

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
    });

    test(
        'when calling `findAuthenticationTokens` for another user, then nothing is returned.',
        () async {
      final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
        session,
        authUserId: const Uuid().v4obj(),
      );

      expect(tokens, isEmpty);
    });

    test(
        'when calling `findAuthenticationTokens` with matching method, then it is returned.',
        () async {
      final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
        session,
        method: 'test',
      );

      expect(tokens, hasLength(1));
      expect(tokens.single.authUserId, authUserId);
    });

    test(
        'when calling `findAuthenticationTokens` with non-matching method, then nothing is returned.',
        () async {
      final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
        session,
        method: 'something else',
      );

      expect(tokens, isEmpty);
    });
  });

  withServerpod('Given two auth user with 100 authentication tokens each,',
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

      authUserId1 = (await AuthUsers.create(session)).id;
      authUserId2 = (await AuthUsers.create(session)).id;
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
      final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
        session,
      );

      expect(tokens, hasLength(100));
      expect(
        tokens.map(((final t) => t.id)),
        refreshTokenIdsInOrderOfCreation.take(100),
      );
    });

    test(
        'when calling `listAuthenticationTokens(offset: 50)`, then it returns the next 100 tokens in order of creation date ASC.',
        () async {
      final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
        session,
        offset: 50,
      );

      expect(tokens, hasLength(100));
      expect(
        tokens.map(((final t) => t.id)),
        refreshTokenIdsInOrderOfCreation.skip(50).take(100),
      );
    });

    test(
        "when calling `listAuthenticationTokens(limit: 2)` for a specific auth user, then it returns that user's first 2 tokens in order of creation date ASC.",
        () async {
      final tokens = await authenticationTokensAdmin.listAuthenticationTokens(
        session,
        authUserId: authUserId1,
        limit: 2,
      );

      expect(tokens, hasLength(2));
      expect(
        tokens.map(((final t) => t.id)),
        [
          refreshTokenIdsInOrderOfCreation[0],
          refreshTokenIdsInOrderOfCreation[2],
        ],
      );
    });

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
    });

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
    });

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
    });
  });

  withServerpod('Given an auth user with an expired authentication token,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await AuthUsers.create(
        session,
      );
      authUserId = authUser.id;

      await withClock(
          Clock.fixed(DateTime.now()
              .subtract(authenticationTokens.config.refreshTokenLifetime)),
          () async {
        await authenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );
      });
    });

    test(
        'when calling `deleteExpiredRefreshTokens`, then that token is removed.',
        () async {
      await authenticationTokensAdmin.deleteExpiredRefreshTokens(session);

      final tokens = await RefreshToken.db.find(session);

      expect(tokens, isEmpty);
    });
  });
}
