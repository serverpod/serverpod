import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/jwt_util.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import '../utils/authentication_token_secrets_mock.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an existing `AuthUser`,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;
    late final secretsWithHmac = AuthenticationTokenSecretsMock()
      ..setHs512Algorithm()
      ..refreshTokenHashPepper = 'pepper123';

    setUpAll(() {
      AuthenticationTokens.secretsTestOverride = secretsWithHmac;
    });

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await AuthUsers.create(session);
      authUserId = authUser.id;
    });

    tearDownAll(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test('when requesting a new token pair, then one is returned.', () async {
      expect(
        await AuthenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
        ),
        isNotNull,
      );
    });

    test(
        'when requesting a new token pair with scopes, then those are visible on the initial access token.',
        () async {
      final tokenPair = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {const Scope('test')},
      );

      final decodedToken = JwtUtil(secrets: secretsWithHmac).verifyJwt(
        tokenPair.accessToken,
      );
      expect(decodedToken.scopes, hasLength(1));
      expect(decodedToken.scopes.single.name, 'test');
    });

    test(
        'when requesting a new token pair with extra claims, then those are visible on the initial access token.',
        () async {
      final tokenPair = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
        extraClaims: {'test': 123},
      );

      final decodedToken = JWT.decode(tokenPair.accessToken);

      expect((decodedToken.payload as Map)['test'], 123);
    });

    test(
        'when requesting a new token pair with extra claims that conflict with registered claims, then it will throw.',
        () async {
      expect(
        () => AuthenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          extraClaims: {'exp': 123, 'custom': 'hello'},
        ),
        throwsArgumentError,
      );
    });
  });

  withServerpod(
      'Given a valid `TokenPair` for a refresh token with scopes and extra claims,',
      (
    final sessionBuilder,
    final endpoints,
  ) {
    const String scopeName = 'test scope';
    late AuthenticationTokenSecretsMock secrets;
    late Session session;
    late UuidValue authUserId;
    late TokenPair tokenPair;

    setUp(() async {
      secrets = AuthenticationTokenSecretsMock()
        ..setHs512Algorithm()
        ..refreshTokenHashPepper = 'pepper123';
      AuthenticationTokens.secretsTestOverride = secrets;

      session = sessionBuilder.build();

      final authUser = await AuthUsers.create(
        session,
      );
      authUserId = authUser.id;

      tokenPair = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {const Scope(scopeName)},
        extraClaims: {'string': 'foo', 'int': 1},
      );
    });

    tearDown(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test(
        'when rotating the tokens, then a new refresh and access token is returned.',
        () async {
      final newTokenPair = await withClock(
        // Need to more forward the clock, as otherwise the new access token has the same expiry date and thus looks equal.
        Clock.fixed(DateTime.now().add(const Duration(seconds: 2))),
        () => AuthenticationTokens.rotateRefreshToken(
          session,
          refreshToken: tokenPair.refreshToken,
        ),
      );

      expect(newTokenPair.accessToken, isNot(tokenPair.accessToken));
      expect(newTokenPair.refreshToken, isNot(tokenPair.refreshToken));
    });

    test(
        'when rotating the tokens, then the new access token refers to the same refresh token ID.',
        () async {
      final newTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: tokenPair.refreshToken,
      );

      final decodedToken = JWT.decode(tokenPair.accessToken);
      final newDecodedToken = JWT.decode(newTokenPair.accessToken);

      expect(newDecodedToken.jwtId, isNotNull);
      expect(decodedToken.jwtId, newDecodedToken.jwtId);
    });

    test(
        'when rotating the tokens, then the new access token contains the extra claims in the `payload` on the top-level.',
        () async {
      final newTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: tokenPair.refreshToken,
      );

      final newDecodedToken = JWT.decode(newTokenPair.accessToken);

      expect((newDecodedToken.payload as Map)['string'], 'foo');
      expect((newDecodedToken.payload as Map)['int'], 1);
    });

    test(
        'when deleting all refresh tokens for the user, then it can not be rotated anymore.',
        () async {
      await AuthenticationTokens.destroyAllRefreshTokens(
        session,
        authUserId: authUserId,
      );

      await expectLater(
        () => AuthenticationTokens.rotateRefreshToken(
          session,
          refreshToken: tokenPair.refreshToken,
        ),
        throwsA(isA<RefreshTokenNotFoundException>()),
      );
    });

    test(
        'when changing the configured pepper, then attempting to rotate the token throws an error.',
        () async {
      secrets.refreshTokenHashPepper = 'another pepper';

      await expectLater(
        () => AuthenticationTokens.rotateRefreshToken(
          session,
          refreshToken: tokenPair.refreshToken,
        ),
        throwsA(isA<RefreshTokenInvalidSecretException>()),
      );
    });

    test(
        'when trying to rotate the token with a wrong fixed secret, then it throws a "not found" error.',
        () async {
      final tokenParts = tokenPair.refreshToken.split(':');
      tokenParts[2] = 'dGVzdA==';

      final tokenWithUpdatedFixedSecret = tokenParts.join(':');

      await expectLater(
        () => AuthenticationTokens.rotateRefreshToken(
          session,
          refreshToken: tokenWithUpdatedFixedSecret,
        ),
        throwsA(isA<RefreshTokenNotFoundException>()),
      );
    });

    test(
        'when trying to rotate the token with a wrong variable secret, then it throws an error.',
        () async {
      final tokenParts = tokenPair.refreshToken.split(':');
      tokenParts[3] = 'dGVzdA==';

      final tokenWithUpdatedFixedSecret = tokenParts.join(':');

      await expectLater(
        () => AuthenticationTokens.rotateRefreshToken(
          session,
          refreshToken: tokenWithUpdatedFixedSecret,
        ),
        throwsA(isA<RefreshTokenInvalidSecretException>()),
      );
    });

    test(
        'when looking at the auth token via `listAuthenticationTokens`, then the extra claims can be read as a Map.',
        () async {
      final authTokensForUser =
          await AuthenticationTokens.listAuthenticationTokens(
        session,
        authUserId: authUserId,
      );

      expect(
        authTokensForUser.single.extraClaims,
        {'string': 'foo', 'int': 1},
      );
    });
  });

  withServerpod('Given an initial `TokenPair` and its refreshed successor,', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;
    late TokenPair initialTokenPair;
    late TokenPair refreshedTokenPair;

    setUp(() async {
      AuthenticationTokens.secretsTestOverride =
          AuthenticationTokenSecretsMock()
            ..setHs512Algorithm()
            ..refreshTokenHashPepper = 'pepper123';

      session = sessionBuilder.build();

      final authUser = await AuthUsers.create(session);

      initialTokenPair = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUser.id,
        scopes: {},
      );

      refreshedTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: initialTokenPair.refreshToken,
      );
    });

    tearDown(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test(
        'when requesting a rotation with the previous (initial) pair, then the current (refreshed) one becomes unusable as well.',
        () async {
      await expectLater(
        () => AuthenticationTokens.rotateRefreshToken(
          session,
          refreshToken: initialTokenPair.refreshToken,
        ),
        throwsA(isA<RefreshTokenInvalidSecretException>()),
      );

      await expectLater(
        () => AuthenticationTokens.rotateRefreshToken(
          session,
          refreshToken: refreshedTokenPair.refreshToken,
        ),
        throwsA(isA<RefreshTokenNotFoundException>()),
      );
    });
  });

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

      await AuthenticationTokens.createTokens(session,
          authUserId: authUserId, scopes: {});
    });

    tearDownAll(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test('when listing the tokens for that user, then it is returned.',
        () async {
      final tokenInfos = await AuthenticationTokens.listAuthenticationTokens(
        session,
        authUserId: authUserId,
      );

      expect(tokenInfos.single.authUserId, authUserId);
    });
  });

  withServerpod('Given two auth users with an authentication token each,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId1;
    late UuidValue authUserId2;

    setUpAll(() {
      AuthenticationTokens.secretsTestOverride =
          AuthenticationTokenSecretsMock()
            ..setHs512Algorithm()
            ..refreshTokenHashPepper = 'pepper123';
    });

    setUp(() async {
      session = sessionBuilder.build();

      final authUser1 = await AuthUsers.create(session);
      authUserId1 = authUser1.id;

      await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId1,
        scopes: {},
      );

      final authUser2 = await AuthUsers.create(session);
      authUserId2 = authUser2.id;

      await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId2,
        scopes: {},
      );
    });

    tearDownAll(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test(
        'when listing the tokens for one user, then only their tokens are returned.',
        () async {
      final tokenInfos = await AuthenticationTokens.listAuthenticationTokens(
        session,
        authUserId: authUserId1,
      );

      expect(tokenInfos.single.authUserId, authUserId1);
    });
  });
}
