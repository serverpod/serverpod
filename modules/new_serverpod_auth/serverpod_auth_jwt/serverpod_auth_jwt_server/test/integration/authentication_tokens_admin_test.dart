import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/generated/refresh_token.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../utils/authentication_token_secrets_mock.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an auth user with an authentication token,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;

    setUpAll(() {
      AuthenticationTokens.secretsTestOverride =
          AuthenticationTokenSecretsMock()
            ..setHs512Algorithm()
            ..refreshTokenHashPepper = 'pepper123';
    });

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await AuthUsers.create(session);
      authUserId = authUser.id;

      await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
      );
    });

    tearDownAll(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test('when calling `deleteExpiredRefreshTokens`, then it is unaffected.',
        () async {
      await AuthenticationTokensAdmin().deleteExpiredRefreshTokens(session);

      final tokens = await RefreshToken.db.find(session);

      expect(
        tokens.single.authUserId,
        authUserId,
      );
    });

    test(
        'when calling `findAuthenticationTokens` for all users, then it is returned.',
        () async {
      final tokens = await AuthenticationTokensAdmin().listAuthenticationTokens(
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
      final tokens = await AuthenticationTokensAdmin().listAuthenticationTokens(
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
      final tokens = await AuthenticationTokensAdmin().listAuthenticationTokens(
        session,
        authUserId: const Uuid().v4obj(),
      );

      expect(tokens, isEmpty);
    });
  });

  withServerpod('Given two auth user with 100 authentication tokens each,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId1;
    late UuidValue authUserId2;
    late List<UuidValue> refreshTokenIdsInOrderOfCreation;

    setUpAll(() {
      AuthenticationTokens.secretsTestOverride =
          AuthenticationTokenSecretsMock()
            ..setHs512Algorithm()
            ..refreshTokenHashPepper = 'pepper123';
    });

    setUp(() async {
      session = sessionBuilder.build();

      authUserId1 = (await AuthUsers.create(session)).id;
      authUserId2 = (await AuthUsers.create(session)).id;
      refreshTokenIdsInOrderOfCreation = [];

      for (var i = 0; i < 100; i++) {
        for (final authUserId in [authUserId1, authUserId2]) {
          final tokenPair = await AuthenticationTokens.createTokens(
            session,
            authUserId: authUserId,
            scopes: {},
          );

          refreshTokenIdsInOrderOfCreation.add(
            UuidValue.fromByteList(
              base64Decode(tokenPair.refreshToken.split(':')[1]),
            ),
          );
        }
      }
    });

    tearDownAll(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test(
        'when calling `listAuthenticationTokens`, then it returns the first 100 tokens in order of creation date ASC.',
        () async {
      final tokens = await AuthenticationTokensAdmin().listAuthenticationTokens(
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
      final tokens = await AuthenticationTokensAdmin().listAuthenticationTokens(
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
      final tokens = await AuthenticationTokensAdmin().listAuthenticationTokens(
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
        () => AuthenticationTokensAdmin().listAuthenticationTokens(
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
        () => AuthenticationTokensAdmin().listAuthenticationTokens(
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
        () => AuthenticationTokensAdmin().listAuthenticationTokens(
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

    setUpAll(() {
      AuthenticationTokens.secretsTestOverride =
          AuthenticationTokenSecretsMock()
            ..setHs512Algorithm()
            ..refreshTokenHashPepper = 'pepper123';
    });

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await AuthUsers.create(
        session,
      );
      authUserId = authUser.id;

      await withClock(
          Clock.fixed(DateTime.now()
              .subtract(AuthenticationTokens.config.refreshTokenLifetime)),
          () async {
        await AuthenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
        );
      });
    });

    tearDownAll(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test(
        'when calling `deleteExpiredRefreshTokens`, then that token is removed.',
        () async {
      await AuthenticationTokensAdmin().deleteExpiredRefreshTokens(session);

      final tokens = await RefreshToken.db.find(session);

      expect(tokens, isEmpty);
    });
  });
}
