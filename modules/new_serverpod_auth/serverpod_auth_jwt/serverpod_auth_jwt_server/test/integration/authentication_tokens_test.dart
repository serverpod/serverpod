import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';
import 'package:serverpod_auth_jwt_server/src/business/authentication_token_secrets.dart';
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given an empty session,',
      (final sessionBuilder, final endpoints) {
    late Session session;

    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride =
          'test-private-key-for-HS512';
    });

    setUp(() async {
      session = sessionBuilder.build();
    });

    tearDownAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = null;
    });

    test(
        'when calling the authentication handler with an non-JWT String, then it returns `null``.',
        () async {
      final authInfo = await AuthenticationTokens.authenticationHandler(
        session,
        'yolo',
      );

      expect(authInfo, isNull);
    });

    test(
        'when calling the authentication handler with an invalid JWT String, then it returns `null``.',
        () async {
      final authInfo = await AuthenticationTokens.authenticationHandler(
        session,
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
      );

      expect(authInfo, isNull);
    });
  });

  withServerpod('Given an existing `AuthUser`,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late UuidValue authUserId;

    setUpAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride =
          'test-private-key-for-HS512';
    });

    setUp(() async {
      session = sessionBuilder.build();

      final authUser = await AuthUser.db.insertRow(
        session,
        AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
      );

      authUserId = authUser.id!;
    });

    tearDownAll(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = null;
    });
    test('when requesting a new token pair, then one is returned.', () async {
      await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {},
      );
    });
  });

  withServerpod('Given a valid `TokenPair` for a refresh token with scopes,', (
    final sessionBuilder,
    final endpoints,
  ) {
    const String scopeName = 'test scope';
    late Session session;
    late UuidValue authUserId;
    late TokenPair tokenPair;

    setUp(() async {
      AuthenticationTokenSecrets.privateKeyTestOverride =
          'test-private-key-for-HS512';

      session = sessionBuilder.build();

      final authUser = await AuthUser.db.insertRow(
        session,
        AuthUser(created: DateTime.now(), scopeNames: {}, blocked: false),
      );

      authUserId = authUser.id!;

      tokenPair = await AuthenticationTokens.createTokens(
        session,
        authUserId: authUserId,
        scopes: {const Scope(scopeName)},
      );
    });

    tearDown(() {
      AuthenticationTokenSecrets.privateKeyTestOverride = null;
    });

    test(
        'when calling the authentication handler, then it returns the user and scopes.',
        () async {
      final authInfo = await AuthenticationTokens.authenticationHandler(
        session,
        tokenPair.accessToken,
      );

      expect(authInfo, isNotNull);
      expect(authInfo!.userUuid, authUserId);
      expect(authInfo.scopes, {const Scope(scopeName)});
    });

    test(
        'when calling the authentication handler after the secret key has been changed, then it returns `null`.',
        () async {
      AuthenticationTokenSecrets.privateKeyTestOverride = 'test 12345';

      final authInfo = await AuthenticationTokens.authenticationHandler(
        session,
        tokenPair.accessToken,
      );

      expect(authInfo, isNull);
    });

    test(
        'when rotating the tokens, then a new refresh and access token is returned.',
        () async {
      // Need to more forward the clock, as otherwise the new access token has the same expiry data and thus looks equal.
      await Future<void>.delayed(const Duration(seconds: 2));

      final newTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: tokenPair.refreshToken,
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
        'when rotating the tokens, then both the old (non-expired) and new access token are valid.',
        () async {
      final newTokenPair = await AuthenticationTokens.rotateRefreshToken(
        session,
        refreshToken: tokenPair.refreshToken,
      );

      expect(
        await AuthenticationTokens.authenticationHandler(
          session,
          tokenPair.accessToken,
        ),
        isNotNull,
      );

      expect(
        await AuthenticationTokens.authenticationHandler(
          session,
          newTokenPair.accessToken,
        ),
        isNotNull,
      );
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
        'when deleting all refresh tokens for the user, then the access token is still valid until it expires.',
        () async {
      await AuthenticationTokens.destroyAllRefreshTokens(
        session,
        authUserId: authUserId,
      );

      final authInfo = await AuthenticationTokens.authenticationHandler(
        session,
        tokenPair.accessToken,
      );

      expect(authInfo, isNotNull);
    });
  });
}
