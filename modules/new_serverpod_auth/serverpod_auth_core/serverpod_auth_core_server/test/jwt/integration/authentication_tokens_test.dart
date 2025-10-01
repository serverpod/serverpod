import 'package:clock/clock.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/jwt_util.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import '../utils/authentication_token_secrets_mock.dart';

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
          method: 'test',
        ),
        isNotNull,
      );
    });

    test('when requesting a new token pair, then expiration date is returned.',
        () async {
      final now = DateTime.now();
      late AuthSuccess authSuccess;

      await withClock(Clock.fixed(now), () async {
        authSuccess = await AuthenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        );
      });

      final expirationExpected = now
          .toUtc()
          .add(AuthenticationTokens.config.accessTokenLifetime)
          .truncatedToSecond();

      expect(authSuccess.tokenExpiresAt, isA<DateTime>());
      expect(authSuccess.tokenExpiresAt, expirationExpected);
    });

    test(
        'when requesting a new token pair with scopes, then those are visible on the initial access token.',
        () async {
      final authSuccess = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {const Scope('test')},
        method: 'test',
      );

      final decodedToken = JwtUtil(secrets: secretsWithHmac).verifyJwt(
        authSuccess.token,
      );
      expect(decodedToken.scopes, hasLength(1));
      expect(decodedToken.scopes.single.name, 'test');
    });

    test(
        'when requesting a new token pair with extra claims, then those are visible on the initial access token.',
        () async {
      final authSuccess = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
        extraClaims: {'test': 123},
        method: 'test',
      );

      final decodedToken = JWT.decode(authSuccess.token);

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
          method: 'test',
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
    late AuthSuccess authSuccess;

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

      authSuccess = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {const Scope(scopeName)},
        extraClaims: {'string': 'foo', 'int': 1},
        method: 'test',
      );
    });

    tearDown(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test(
        'when rotating the tokens, then a new refresh and access token is returned.',
        () async {
      final newTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: authSuccess.refreshToken!,
      );

      expect(newTokenPair.accessToken, isNot(authSuccess.token));
      expect(newTokenPair.refreshToken, isNot(authSuccess.refreshToken));
    });

    test(
        'when rotating tokens multiple times within the same second, then new tokens are returned.',
        () async {
      final newTokenPairs = await withClock(
          Clock.fixed(DateTime.now()),
          () => Future.wait(
                List.generate(
                  3,
                  (final _) => AuthenticationTokens.rotateRefreshToken(
                    session,
                    refreshToken: authSuccess.refreshToken!,
                  ),
                ),
              ));

      final tokens = newTokenPairs.map((final t) => t.accessToken).toSet();
      expect(tokens, hasLength(3));
      expect(tokens.add(authSuccess.token), isTrue);

      final refreshTokens =
          newTokenPairs.map((final t) => t.refreshToken).toSet();
      expect(refreshTokens, hasLength(3));
      expect(refreshTokens.add(authSuccess.refreshToken!), isTrue);
    });

    test(
        'when rotating the tokens, then the new access token refers to the same refresh token ID.',
        () async {
      final newTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: authSuccess.refreshToken!,
      );

      expect(
        _extractRefreshTokenId(authSuccess.token),
        _extractRefreshTokenId(newTokenPair.accessToken),
      );
    });

    test(
        'when rotating the tokens, then the new access token has a different `jwtId`.',
        () async {
      final newTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: authSuccess.refreshToken!,
      );

      final decodedToken = JWT.decode(authSuccess.token);
      final newDecodedToken = JWT.decode(newTokenPair.accessToken);

      expect(newDecodedToken.jwtId, isNotNull);
      expect(decodedToken.jwtId, isNot(newDecodedToken.jwtId));
    });

    test(
        'when rotating the tokens, then the new access token contains the extra claims in the `payload` on the top-level.',
        () async {
      final newTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: authSuccess.refreshToken!,
      );

      final newDecodedToken = JWT.decode(newTokenPair.accessToken);

      expect((newDecodedToken.payload as Map)['string'], 'foo');
      expect((newDecodedToken.payload as Map)['int'], 1);
    });

    test(
        'when refreshing the tokens, then a new AuthSuccess is returned with new tokens, but same auth info.',
        () async {
      final newAuthSuccess = await AuthenticationTokens.refreshAccessToken(
        session,
        refreshToken: authSuccess.refreshToken!,
      );

      expect(newAuthSuccess.authStrategy, authSuccess.authStrategy);
      expect(newAuthSuccess.authUserId, authSuccess.authUserId);
      expect(newAuthSuccess.scopeNames, authSuccess.scopeNames);
      expect(newAuthSuccess.token, isNot(authSuccess.token));
      expect(newAuthSuccess.refreshToken, isNot(authSuccess.refreshToken));
    });

    test(
        'when calling `destroyRefreshToken` with a valid refresh token ID, then it returns true.',
        () async {
      final deleted = await AuthenticationTokens.destroyRefreshToken(
        session,
        refreshTokenId: _extractRefreshTokenId(authSuccess.token),
      );

      expect(deleted, isTrue);
    });

    test(
        'when calling `destroyRefreshToken` with an invalid refresh token ID, then it returns false.',
        () async {
      final deleted = await AuthenticationTokens.destroyRefreshToken(
        session,
        refreshTokenId: const Uuid().v4obj(),
      );

      expect(deleted, isFalse);
    });

    test(
        'when calling `destroyAllRefreshTokens`, then it returns the list of deleted token IDs.',
        () async {
      final newAuthSuccesses = await List.generate(
        3,
        (final _) async => AuthenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          method: 'test',
        ),
      ).wait;

      final deletedIds = await AuthenticationTokens.destroyAllRefreshTokens(
        session,
        authUserId: authUserId,
      );

      expect(deletedIds.toSet(), {
        _extractRefreshTokenId(authSuccess.token),
        for (final authSuccess in newAuthSuccesses)
          _extractRefreshTokenId(authSuccess.token),
      });
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
          refreshToken: authSuccess.refreshToken!,
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
          refreshToken: authSuccess.refreshToken!,
        ),
        throwsA(isA<RefreshTokenInvalidSecretException>()),
      );
    });

    test(
        'when trying to rotate the token with a wrong fixed secret, then it throws a "not found" error.',
        () async {
      final tokenParts = authSuccess.refreshToken!.split(':');
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
      final tokenParts = authSuccess.refreshToken!.split(':');
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
    late AuthSuccess initialAuthSuccess;
    late TokenPair refreshedTokenPair;

    setUp(() async {
      AuthenticationTokens.secretsTestOverride =
          AuthenticationTokenSecretsMock()
            ..setHs512Algorithm()
            ..refreshTokenHashPepper = 'pepper123';

      session = sessionBuilder.build();

      final authUser = await AuthUsers.create(session);

      initialAuthSuccess = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUser.id,
        scopes: {},
        method: 'test',
      );

      refreshedTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: initialAuthSuccess.refreshToken!,
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
          refreshToken: initialAuthSuccess.refreshToken!,
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

      await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
      );
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
        method: 'test',
      );

      final authUser2 = await AuthUsers.create(session);
      authUserId2 = authUser2.id;

      await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId2,
        scopes: {},
        method: 'test',
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

  withServerpod('Given a user with scopes,',
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
      // Assign scopes to the user using update
      await AuthUsers.update(
        session,
        authUserId: authUserId,
        scopes: {const Scope('user-scope')},
      );
    });

    tearDownAll(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test('when no scopes are provided, the users scopes should be used.',
        () async {
      final authSuccess = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        method: 'test',
      );
      final decodedToken = JwtUtil(secrets: secretsWithHmac).verifyJwt(
        authSuccess.token,
      );
      expect(decodedToken.scopes, hasLength(1));
      expect(decodedToken.scopes.single.name, 'user-scope');
    });

    test('when scopes are provided, the provided scopes are used.', () async {
      final authSuccess = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {
          const Scope('test-scope'),
        },
        method: 'test',
      );
      final decodedToken = JwtUtil(secrets: secretsWithHmac).verifyJwt(
        authSuccess.token,
      );
      expect(decodedToken.scopes, hasLength(1));
      expect(decodedToken.scopes.single.name, 'test-scope');
    });
  });

  withServerpod('Given a user that is blocked,',
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
      // Block the user using update
      await AuthUsers.update(session, authUserId: authUserId, blocked: true);
    });

    tearDownAll(() {
      AuthenticationTokens.secretsTestOverride = null;
    });

    test('when creating tokens, an AuthUserBlockedException should be thrown.',
        () async {
      await expectLater(
        () => AuthenticationTokens.createTokens(
          session,
          authUserId: authUserId,
          scopes: {},
          method: 'test',
        ),
        throwsA(isA<AuthUserBlockedException>()),
      );
    });

    test(
        'when creating token with skipUserBlockedChecked as true, then the token should be created successfully.',
        () async {
      final authSuccess = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
        method: 'test',
        skipUserBlockedChecked: true,
      );
      expect(authSuccess, isNotNull);
    });
  });
}

UuidValue _extractRefreshTokenId(final String accessToken) {
  final jwt = JWT.decode(accessToken);
  const claimName = 'dev.serverpod.refreshTokenId';
  final refreshTokenIdClaim = (jwt.payload as Map)[claimName] as String;
  return UuidValue.withValidation(refreshTokenIdClaim);
}

extension on DateTime {
  DateTime truncatedToSecond() =>
      DateTime.utc(year, month, day, hour, minute, second);
}
