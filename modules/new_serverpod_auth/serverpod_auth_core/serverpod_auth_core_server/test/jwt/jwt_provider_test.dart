import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'utils/authentication_token_secrets_mock.dart';
import '../serverpod_test_tools.dart';

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

  group('JwtTokenIssuer', () {
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

          test('then a RefreshToken should be created in the database',
              () async {
            final refreshTokens = await RefreshToken.db.find(
              session,
              where: (final t) => t.authUserId.equals(authUserId),
            );
            expect(refreshTokens, hasLength(1));
            expect(refreshTokens.first.method, equals('test-method'));
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
              scopes: {
                const Scope('user-scope-1'),
                const Scope('user-scope-2')
              },
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

        group('when issuing tokens', () {
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

        group('when issuing tokens for a blocked user', () {
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

        group('when issuing tokens with a transaction that fails', () {
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
  });

  group('JwtTokenProvider', () {
    withServerpod(
      'Given multiple refresh tokens for different users',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue user1Id;
        late UuidValue user2Id;
        late TokenProvider tokenProvider;

        setUp(() async {
          session = sessionBuilder.build();
          tokenProvider = JwtTokenProvider();

          // Create two users
          final user1 = await AuthUsers.create(session);
          user1Id = user1.id;

          final user2 = await AuthUsers.create(session);
          user2Id = user2.id;

          // Create tokens for user1
          await AuthenticationTokens.createTokens(
            session,
            authUserId: user1Id,
            method: 'email',
            scopes: {const Scope('read')},
          );

          await AuthenticationTokens.createTokens(
            session,
            authUserId: user1Id,
            method: 'oauth',
            scopes: {const Scope('write')},
          );

          // Create token for user2
          await AuthenticationTokens.createTokens(
            session,
            authUserId: user2Id,
            method: 'email',
            scopes: {const Scope('admin')},
          );
        });

        group('when listing tokens without filters', () {
          late List<TokenInfo> tokens;

          setUp(() async {
            tokens = await tokenProvider.listTokens(
              session: session,
              authUserId: null,
              method: null,
              transaction: null,
            );
          });

          test('then all tokens should be returned', () {
            expect(tokens, hasLength(3));
          });

          test('then tokens should have correct provider name', () {
            expect(
              tokens
                  .every((final t) => t.tokenProvider == AuthStrategy.jwt.name),
              isTrue,
            );
          });
        });

        group('when listing tokens for a specific user', () {
          late List<TokenInfo> tokens;

          setUp(() async {
            tokens = await tokenProvider.listTokens(
              session: session,
              authUserId: user1Id,
              method: null,
              transaction: null,
            );
          });

          test('then only tokens for the specified user should be returned',
              () {
            expect(tokens, hasLength(2));
            expect(
              tokens.every((final t) => t.userId == user1Id.toString()),
              isTrue,
            );
          });

          test('then tokens should have correct methods', () {
            final methods = tokens.map((final t) => t.method).toSet();
            expect(methods, containsAll(['email', 'oauth']));
          });

          test('then tokens should have correct scopes', () {
            final emailToken =
                tokens.firstWhere((final t) => t.method == 'email');
            expect(
                emailToken.scopes.map((final s) => s.name), contains('read'));

            final oauthToken =
                tokens.firstWhere((final t) => t.method == 'oauth');
            expect(
                oauthToken.scopes.map((final s) => s.name), contains('write'));
          });
        });

        group('when listing tokens with method filter', () {
          late List<TokenInfo> tokens;

          setUp(() async {
            tokens = await tokenProvider.listTokens(
              session: session,
              authUserId: null,
              method: 'email',
              transaction: null,
            );
          });

          test('then only tokens with specified method should be returned', () {
            expect(tokens, hasLength(2));
            expect(
              tokens.every((final t) => t.method == 'email'),
              isTrue,
            );
          });
        });

        group('when listing tokens with combined filters', () {
          late List<TokenInfo> tokens;

          setUp(() async {
            tokens = await tokenProvider.listTokens(
              session: session,
              authUserId: user1Id,
              method: 'oauth',
              transaction: null,
            );
          });

          test('then only matching tokens should be returned', () {
            expect(tokens, hasLength(1));
            expect(tokens.first.userId, equals(user1Id.toString()));
            expect(tokens.first.method, equals('oauth'));
          });
        });

        group('when revoking a specific token', () {
          setUp(() async {
            final tokenToRevoke = await RefreshToken.db
                .find(
                  session,
                  where: (final t) => t.authUserId.equals(user1Id),
                )
                .then((final tokens) => tokens.first);

            await tokenProvider.revokeToken(
              session: session,
              tokenId: tokenToRevoke.id.toString(),
              transaction: null,
            );
          });

          test('then the token should be removed from database', () async {
            final remainingTokens = await RefreshToken.db.find(session);
            expect(remainingTokens, hasLength(2));
          });

          test('then other tokens should remain', () async {
            final user1Tokens = await RefreshToken.db.find(
              session,
              where: (final t) => t.authUserId.equals(user1Id),
            );
            expect(user1Tokens, hasLength(1));

            final user2Tokens = await RefreshToken.db.find(
              session,
              where: (final t) => t.authUserId.equals(user2Id),
            );
            expect(user2Tokens, hasLength(1));
          });
        });

        group('when revoking all tokens for a user', () {
          setUp(() async {
            await tokenProvider.revokeAllTokens(
              session: session,
              authUserId: user1Id,
              method: null,
              transaction: null,
            );
          });

          test('then all user tokens should be removed', () async {
            final user1Tokens = await RefreshToken.db.find(
              session,
              where: (final t) => t.authUserId.equals(user1Id),
            );
            expect(user1Tokens, isEmpty);
          });

          test('then other user tokens should remain', () async {
            final user2Tokens = await RefreshToken.db.find(
              session,
              where: (final t) => t.authUserId.equals(user2Id),
            );
            expect(user2Tokens, hasLength(1));
          });
        });

        group('when revoking all tokens with method filter', () {
          setUp(() async {
            await tokenProvider.revokeAllTokens(
              session: session,
              authUserId: null,
              method: 'email',
              transaction: null,
            );
          });

          test('then only tokens with specified method should be removed',
              () async {
            final remainingTokens = await RefreshToken.db.find(session);
            expect(remainingTokens, hasLength(1));
            expect(remainingTokens.first.method, equals('oauth'));
          });
        });

        group('when revoking all tokens without filters', () {
          setUp(() async {
            await tokenProvider.revokeAllTokens(
              session: session,
              authUserId: null,
              method: null,
              transaction: null,
            );
          });

          test('then all tokens should be removed', () async {
            final remainingTokens = await RefreshToken.db.find(session);
            expect(remainingTokens, isEmpty);
          });
        });
      },
    );

    withServerpod(
      'Given an invalid token ID',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late TokenProvider tokenProvider;

        setUp(() async {
          session = sessionBuilder.build();
          tokenProvider = JwtTokenProvider();
        });

        group('when revoking the invalid token', () {
          test('then it should throw an exception', () async {
            expect(
              () => tokenProvider.revokeToken(
                session: session,
                tokenId: 'invalid-uuid',
                transaction: null,
              ),
              throwsA(isA<FormatException>()),
            );
          });
        });
      },
    );
  });
}
