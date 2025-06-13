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
      final tokens = await AuthenticationTokensAdmin().findAuthenticationTokens(
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
      final tokens = await AuthenticationTokensAdmin().findAuthenticationTokens(
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
      final tokens = await AuthenticationTokensAdmin().findAuthenticationTokens(
        session,
        authUserId: const Uuid().v4obj(),
      );

      expect(tokens, isEmpty);
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
