import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../serverpod_test_tools.dart';
import 'utils/authentication_token_secrets_mock.dart';

void main() {
  setUpAll(() {
    final secrets = AuthenticationTokenSecretsMock()
      ..setHs512Algorithm()
      ..refreshTokenHashPepper = 'test-pepper';
    AuthenticationTokens.secretsTestOverride = secrets;
  });

  tearDownAll(() {
    AuthenticationTokens.secretsTestOverride = null;
  });

  withServerpod(
    'Given an existing AuthUser',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late TokenIssuer tokenIssuer;

      setUp(() async {
        session = sessionBuilder.build();
        tokenIssuer = JwtTokenIssuer();

        final authUser = await AuthUsers.create(session);
        authUserId = authUser.id;
      });

      group('when issuing a token', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await tokenIssuer.issueToken(
            session: session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: {const Scope('test-scope')},
            transaction: null,
          );
        });

        test('then the token should be returned', () {
          expect(authSuccess.token, isNotEmpty);
        });

        test('then the refresh token should be returned', () {
          expect(authSuccess.refreshToken, isNotNull);
          expect(authSuccess.refreshToken, isNotEmpty);
        });

        test('then the authUserId should match', () {
          expect(authSuccess.authUserId, equals(authUserId));
        });

        test('then the scopeNames should match', () {
          expect(authSuccess.scopeNames, contains('test-scope'));
        });

        test('then the authStrategy should be jwt', () {
          expect(authSuccess.authStrategy, equals(AuthStrategy.jwt.name));
        });

        test('then a RefreshToken should be created in the database', () async {
          final refreshTokens = await RefreshToken.db.find(
            session,
            where: (final t) => t.authUserId.equals(authUserId),
          );
          expect(refreshTokens, hasLength(1));
          expect(refreshTokens.first.method, equals('test-method'));
        });

        test('then access token is valid on the server', () async {
          final authInfo = await AuthenticationTokens.authenticationHandler(
            session,
            authSuccess.token,
          );
          expect(authInfo, isNotNull);
          expect(authInfo!.userIdentifier, equals(authUserId.uuid));
          expect(
            authInfo.scopes.map((final s) => s.name),
            contains('test-scope'),
          );
        });

        test('then refresh token is valid on the server', () async {
          // Refresh tokens are validated by being able to rotate them
          final rotatedAuth = await AuthenticationTokens.rotateRefreshToken(
            session,
            refreshToken: authSuccess.refreshToken!,
          );
          expect(rotatedAuth, isNotNull);
          expect(rotatedAuth.accessToken, isNotEmpty);
          expect(rotatedAuth.refreshToken, isNotEmpty);
        });
      });

      group('when issuing a token without scopes', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await tokenIssuer.issueToken(
            session: session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: null,
            transaction: null,
          );
        });

        test("then the user's scopes should be used", () async {
          // The default user created by AuthUsers.create has no scopes
          expect(authSuccess.scopeNames, isEmpty);
        });
      });

      group('when issuing tokens with custom scopes', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          await AuthUsers.update(
            session,
            authUserId: authUserId,
            scopes: {const Scope('user-scope-1'), const Scope('user-scope-2')},
          );

          authSuccess = await tokenIssuer.issueToken(
            session: session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: {const Scope('custom-scope')},
            transaction: null,
          );
        });

        test('then custom scopes override user scopes', () {
          expect(authSuccess.scopeNames, contains('custom-scope'));
          expect(authSuccess.scopeNames, isNot(contains('user-scope-1')));
          expect(authSuccess.scopeNames, isNot(contains('user-scope-2')));
        });
      });

      group('when issuing tokens with empty set of scopes', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          await AuthUsers.update(
            session,
            authUserId: authUserId,
            scopes: {const Scope('user-scope')},
          );

          authSuccess = await tokenIssuer.issueToken(
            session: session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: {},
            transaction: null,
          );
        });

        test('then empty scopes override user scopes', () {
          expect(authSuccess.scopeNames, isEmpty);
        });
      });

      group('when issuing tokens for a previously authenticated user', () {
        late AuthSuccess firstAuth;
        late AuthSuccess secondAuth;

        setUp(() async {
          firstAuth = await tokenIssuer.issueToken(
            session: session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: {const Scope('first-auth')},
            transaction: null,
          );

          secondAuth = await tokenIssuer.issueToken(
            session: session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: {const Scope('second-auth')},
            transaction: null,
          );
        });

        test('then a new token pair is returned', () {
          expect(secondAuth.token, isNotEmpty);
          expect(secondAuth.refreshToken, isNotEmpty);
          expect(secondAuth.token, isNot(equals(firstAuth.token)));
          expect(
              secondAuth.refreshToken, isNot(equals(firstAuth.refreshToken)));
        });

        test('then both refresh tokens exist in the database', () async {
          final refreshTokens = await RefreshToken.db.find(
            session,
            where: (final t) => t.authUserId.equals(authUserId),
          );
          expect(refreshTokens, hasLength(2));
        });
      });
    },
  );

  withServerpod(
    'Given a blocked AuthUser',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late TokenIssuer tokenIssuer;

      setUp(() async {
        session = sessionBuilder.build();
        tokenIssuer = JwtTokenIssuer();

        final authUser = await AuthUsers.create(session);
        authUserId = authUser.id;

        await AuthUsers.update(
          session,
          authUserId: authUserId,
          blocked: true,
        );
      });

      group('when issuing new tokens', () {
        test('then an AuthUserBlockedException is thrown', () async {
          expect(
            () => tokenIssuer.issueToken(
              session: session,
              authUserId: authUserId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            ),
            throwsA(isA<AuthUserBlockedException>()),
          );
        });
      });
    },
  );

  withServerpod(
    'Given a transaction that fails',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late TokenIssuer tokenIssuer;

      setUp(() async {
        session = sessionBuilder.build();
        tokenIssuer = JwtTokenIssuer();

        final authUser = await AuthUsers.create(session);
        authUserId = authUser.id;
      });

      group('when issuing new tokens', () {
        test('then tokens are not created in the database', () async {
          try {
            await session.db.transaction((final transaction) async {
              await tokenIssuer.issueToken(
                session: session,
                authUserId: authUserId,
                method: 'test-method',
                scopes: {const Scope('test-scope')},
                transaction: transaction,
              );
              throw Exception('Transaction failed');
            });
          } catch (_) {
            // Expected to fail
          }

          final refreshTokens = await RefreshToken.db.find(
            session,
            where: (final t) => t.authUserId.equals(authUserId),
          );
          expect(refreshTokens, isEmpty);
        });
      });
    },
  );
}
