import 'package:clock/clock.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../../serverpod_test_tools.dart';
import '../fakes/fakes.dart';

void testSuite({
  required final TokenManager Function() tokenManagerBuilder,
  required final bool isDatabaseBackedManager,
  required final bool usesRefreshTokens,
}) {
  withServerpod(
    'Given a TokenManager and a valid user ID',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue userId;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = tokenManagerBuilder();
        final authUser = await AuthUsers.create(session);
        userId = authUser.id;
      });

      group('when issuing a token', () {
        late Future<AuthSuccess> issueTokenFuture;
        late AuthSuccess authSuccess;

        setUp(() async {
          issueTokenFuture = tokenManager.issueToken(
            session: session,
            authUserId: userId,
            method: 'test-method',
            scopes: {const Scope('test-scope')},
            transaction: null,
          );
          authSuccess = await issueTokenFuture;
        });

        test('then issuing the token should complete', () {
          expect(issueTokenFuture, completes);
        });

        test('then the authUserId should match', () {
          expect(authSuccess.authUserId, equals(userId));
        });

        test('then the scopeNames should match', () {
          expect(authSuccess.scopeNames, contains('test-scope'));
        });

        test('then the authStrategy should match the token manager kind', () {
          expect(authSuccess.authStrategy, equals(tokenManager.kind));
        });
      });

      test(
          'when issuing a token with multiple scopes then all scopes should be included',
          () async {
        final authSuccess = await tokenManager.issueToken(
          session: session,
          authUserId: userId,
          method: 'test-method',
          scopes: {
            const Scope('scope1'),
            const Scope('scope2'),
            const Scope('scope3'),
          },
          transaction: null,
        );

        expect(authSuccess.scopeNames, hasLength(3));
        expect(authSuccess.scopeNames, contains('scope1'));
        expect(authSuccess.scopeNames, contains('scope2'));
        expect(authSuccess.scopeNames, contains('scope3'));
      });

      test(
          'when issuing a token without scopes then scopeNames should be empty',
          () async {
        final authSuccess = await tokenManager.issueToken(
          session: session,
          authUserId: userId,
          method: 'test-method',
          scopes: null,
          transaction: null,
        );

        expect(authSuccess.scopeNames, isEmpty);
      });

      test(
          'when issuing a token with empty scopes then scopeNames should be empty',
          () async {
        final authSuccess = await tokenManager.issueToken(
          session: session,
          authUserId: userId,
          method: 'test-method',
          scopes: {},
          transaction: null,
        );

        expect(authSuccess.scopeNames, isEmpty);
      });

      group('when issuing multiple tokens at the same time', () {
        late AuthSuccess firstToken;
        late AuthSuccess secondToken;
        late AuthSuccess thirdToken;
        late DateTime fixedTime;

        setUp(() async {
          fixedTime = DateTime.now();

          await withClock(Clock.fixed(fixedTime), () async {
            firstToken = await tokenManager.issueToken(
              session: session,
              authUserId: userId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            secondToken = await tokenManager.issueToken(
              session: session,
              authUserId: userId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            thirdToken = await tokenManager.issueToken(
              session: session,
              authUserId: userId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );
          });
        });

        test('then each token should be unique', () {
          expect(firstToken.token, isNot(equals(secondToken.token)));
          expect(firstToken.token, isNot(equals(thirdToken.token)));
          expect(secondToken.token, isNot(equals(thirdToken.token)));
        });

        test('then each refresh token should be unique', () {
          if (usesRefreshTokens) {
            expect(firstToken.refreshToken,
                isNot(equals(secondToken.refreshToken)));
            expect(firstToken.refreshToken,
                isNot(equals(thirdToken.refreshToken)));
            expect(secondToken.refreshToken,
                isNot(equals(thirdToken.refreshToken)));
          } else {
            expect(firstToken.refreshToken, isNull);
            expect(secondToken.refreshToken, isNull);
            expect(thirdToken.refreshToken, isNull);
          }
        });

        test('then all tokens should have the same authUserId', () {
          expect(firstToken.authUserId, equals(userId));
          expect(secondToken.authUserId, equals(userId));
          expect(thirdToken.authUserId, equals(userId));
        });

        test('then all tokens should have the same scopes', () {
          expect(firstToken.scopeNames, contains('test-scope'));
          expect(secondToken.scopeNames, contains('test-scope'));
          expect(thirdToken.scopeNames, contains('test-scope'));
        });
      });
    },
  );

  withServerpod(
    'Given a TokenManager with a transaction parameter',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue userId;

      setUp(() async {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
        final authUser = await AuthUsers.create(session);
        userId = authUser.id;
      });

      group('when issuing tokens successfully with transaction', () {
        setUp(() async {
          await session.db.transaction((final transaction) async {
            await tokenManager.issueToken(
              session: session,
              authUserId: userId,
              method: 'transaction',
              scopes: {const Scope('scope1')},
              transaction: transaction,
            );

            await tokenManager.issueToken(
              session: session,
              authUserId: userId,
              method: 'transaction',
              scopes: {const Scope('scope2')},
              transaction: transaction,
            );
          });
        });

        test('then tokens should be persisted after transaction commits',
            () async {
          final tokensAfterCommit = await tokenManager.listTokens(
            session: session,
            authUserId: userId,
            method: null,
            transaction: null,
          );

          expect(
            tokensAfterCommit
                .where((final token) => token.method == 'transaction'),
            hasLength(2),
          );
        });
      });

      group(
        'when issuing tokens with transaction that rolls back',
        () {
          setUp(() async {
            try {
              await session.db.transaction((final transaction) async {
                await tokenManager.issueToken(
                  session: session,
                  authUserId: userId,
                  method: 'rollback-test',
                  scopes: {const Scope('rollback-scope')},
                  transaction: transaction,
                );

                // Force a rollback by throwing an exception
                throw Exception('Intentional rollback');
              });
            } catch (e) {
              // Expected exception, ignore
            }
          });

          test(
            'then tokens should not be persisted after transaction rollback',
            () async {
              final tokensAfterRollback = await tokenManager.listTokens(
                session: session,
                authUserId: userId,
                method: null,
                transaction: null,
              );

              expect(
                tokensAfterRollback
                    .where((final token) => token.method == 'rollback-test'),
                isEmpty,
              );
            },
            skip: !isDatabaseBackedManager
                ? 'Skipped for non-database-backed managers'
                : null,
          );
        },
        skip: !isDatabaseBackedManager
            ? 'Skipped for non-database-backed managers'
            : null,
      );

      group(
        'when revoking a token with transaction that rolls back',
        () {
          late String tokenIdToRevoke;

          setUp(() async {
            // First, issue a token
            final authSuccess = await tokenManager.issueToken(
              session: session,
              authUserId: userId,
              method: 'revoke-rollback-test',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );
            tokenIdToRevoke = authSuccess.token;

            // Try to revoke it in a transaction that rolls back
            try {
              await session.db.transaction((final transaction) async {
                await tokenManager.revokeToken(
                  session: session,
                  tokenId: tokenIdToRevoke,
                  transaction: transaction,
                );

                // Force a rollback by throwing an exception
                throw Exception('Intentional rollback');
              });
            } catch (e) {
              // Expected exception, ignore
            }
          });

          test(
            'then token should still exist after transaction rollback',
            () async {
              final tokensAfterRollback = await tokenManager.listTokens(
                session: session,
                authUserId: userId,
                method: null,
                transaction: null,
              );

              expect(
                tokensAfterRollback
                    .any((final token) => token.tokenId == tokenIdToRevoke),
                isTrue,
              );
            },
            skip: !isDatabaseBackedManager
                ? 'Skipped for non-database-backed managers'
                : null,
          );
        },
        skip: !isDatabaseBackedManager
            ? 'Skipped for non-database-backed managers'
            : null,
      );

      group(
        'when revoking all tokens with transaction that rolls back',
        () {
          setUp(() async {
            // First, issue some tokens
            await tokenManager.issueToken(
              session: session,
              authUserId: userId,
              method: 'revoke-all-rollback-test',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            await tokenManager.issueToken(
              session: session,
              authUserId: userId,
              method: 'revoke-all-rollback-test',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            // Try to revoke all in a transaction that rolls back
            try {
              await session.db.transaction((final transaction) async {
                await tokenManager.revokeAllTokens(
                  session: session,
                  authUserId: userId,
                  method: 'revoke-all-rollback-test',
                  transaction: transaction,
                );

                // Force a rollback by throwing an exception
                throw Exception('Intentional rollback');
              });
            } catch (e) {
              // Expected exception, ignore
            }
          });

          test(
            'then tokens should still exist after transaction rollback',
            () async {
              final tokensAfterRollback = await tokenManager.listTokens(
                session: session,
                authUserId: userId,
                method: 'revoke-all-rollback-test',
                transaction: null,
              );

              expect(tokensAfterRollback, hasLength(2));
            },
            skip: !isDatabaseBackedManager
                ? 'Skipped for non-database-backed managers'
                : null,
          );
        },
        skip: !isDatabaseBackedManager
            ? 'Skipped for non-database-backed managers'
            : null,
      );
    },
  );

  withServerpod(
    'Given a TokenManager with multiple tokens '
    'for multiple users using multiple methods '
    'and multiple scopes',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue user1Id;
      late UuidValue user2Id;
      late String token1Id;
      late String token2Id;
      late String token3Id;

      setUp(() async {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
        final authUser1 = await AuthUsers.create(session);
        final authUser2 = await AuthUsers.create(session);
        user1Id = authUser1.id;
        user2Id = authUser2.id;

        final token1 = await tokenManager.issueToken(
          session: session,
          authUserId: user1Id,
          method: 'email',
          scopes: {const Scope('read')},
          transaction: null,
        );
        token1Id = token1.token;

        final token2 = await tokenManager.issueToken(
          session: session,
          authUserId: user1Id,
          method: 'oauth',
          scopes: {const Scope('write')},
          transaction: null,
        );
        token2Id = token2.token;

        final token3 = await tokenManager.issueToken(
          session: session,
          authUserId: user2Id,
          method: 'email',
          scopes: {const Scope('admin')},
          transaction: null,
        );
        token3Id = token3.token;
      });

      group('when listing tokens without filters', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
        });

        test('then all tokens should be returned', () {
          expect(tokens, hasLength(3));
          final tokenIds = tokens.map((final t) => t.tokenId).toSet();
          expect(tokenIds, contains(token1Id));
          expect(tokenIds, contains(token2Id));
          expect(tokenIds, contains(token3Id));
        });

        test('then all tokens should have correct tokenProvider', () {
          expect(tokens, hasLength(3));
          expect(
            tokens.every(
                (final token) => token.tokenProvider == tokenManager.kind),
            isTrue,
          );
        });
      });

      group('when listing tokens with user filter', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await tokenManager.listTokens(
            session: session,
            authUserId: user1Id,
            method: null,
            transaction: null,
          );
        });

        test('then only tokens for the specified user should be returned', () {
          expect(tokens, hasLength(2));
          expect(
            tokens.every((final token) => token.userId == user1Id.toString()),
            isTrue,
          );
          final tokenIds = tokens.map((final t) => t.tokenId).toSet();
          expect(tokenIds, contains(token1Id));
          expect(tokenIds, contains(token2Id));
        });
      });

      group('when listing tokens with method filter', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: 'email',
            transaction: null,
          );
        });

        test('then only tokens with specified method should be returned', () {
          expect(tokens, hasLength(2));
          expect(
            tokens.every((final token) => token.method == 'email'),
            isTrue,
          );
          final tokenIds = tokens.map((final t) => t.tokenId).toSet();
          expect(tokenIds, contains(token1Id));
          expect(tokenIds, contains(token3Id));
        });
      });

      group('when listing tokens with combined filters', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await tokenManager.listTokens(
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
          expect(tokens.first.tokenId, equals(token2Id));
        });
      });

      group('when revoking a specific token', () {
        late String revokedTokenId;

        setUp(() async {
          await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
          // Revoke token2 (user1, oauth method, write scope)
          revokedTokenId = token2Id;

          await tokenManager.revokeToken(
            session: session,
            tokenId: revokedTokenId,
            transaction: null,
          );
        });

        test('then the token should be removed', () async {
          final remainingTokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
          expect(
            remainingTokens
                .any((final token) => token.tokenId == revokedTokenId),
            isFalse,
          );
        });

        test('then other tokens should remain', () async {
          final remainingTokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
          expect(remainingTokens, hasLength(2));

          final remainingTokenIds =
              remainingTokens.map((final t) => t.tokenId).toSet();
          expect(remainingTokenIds, contains(token1Id));
          expect(remainingTokenIds, contains(token3Id));
          expect(remainingTokenIds, isNot(contains(token2Id)));
        });

        test('then authenticationRevoked should be called with correct authId',
            () async {
          final channelName =
              MessageCentralServerpodChannels.revokedAuthentication(
            user1Id.uuid,
          );

          final revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          await tokenManager.revokeToken(
            session: session,
            tokenId: token1Id,
            transaction: null,
          );

          session.messages.removeListener(
            channelName,
            revocationMessages.add,
          );

          expect(revocationMessages, [
            isA<RevokedAuthenticationAuthId>().having(
              (final m) => m.authId,
              'authId',
              token1Id,
            ),
          ]);
        });
      });

      group('when revoking all tokens for a user', () {
        setUp(() async {
          await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );

          await tokenManager.revokeAllTokens(
            session: session,
            authUserId: user1Id,
            method: null,
            transaction: null,
          );
        });

        test('then all user tokens should be removed', () async {
          final user1Tokens = await tokenManager.listTokens(
            session: session,
            authUserId: user1Id,
            method: null,
            transaction: null,
          );
          expect(user1Tokens, isEmpty);
        });

        test('then other user tokens should remain', () async {
          final remainingTokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
          expect(remainingTokens, hasLength(1));

          final remainingTokenIds =
              remainingTokens.map((final t) => t.tokenId).toSet();
          expect(remainingTokenIds, contains(token3Id));
          expect(remainingTokenIds, isNot(contains(token1Id)));
          expect(remainingTokenIds, isNot(contains(token2Id)));
        });

        test('then authenticationRevoked should be called with user revocation',
            () async {
          final channelName =
              MessageCentralServerpodChannels.revokedAuthentication(
            user2Id.uuid,
          );

          final revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          await tokenManager.revokeAllTokens(
            session: session,
            authUserId: user2Id,
            method: null,
            transaction: null,
          );

          session.messages.removeListener(
            channelName,
            revocationMessages.add,
          );

          expect(revocationMessages, [isA<RevokedAuthenticationUser>()]);
        });
      });

      group('when revoking all tokens with method filter', () {
        setUp(() async {
          await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );

          await tokenManager.revokeAllTokens(
            session: session,
            authUserId: null,
            method: 'email',
            transaction: null,
          );
        });

        test('then only tokens with specified method should be removed',
            () async {
          final remainingTokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
          expect(remainingTokens, hasLength(1));

          final remainingTokenIds =
              remainingTokens.map((final t) => t.tokenId).toSet();
          expect(remainingTokenIds, contains(token2Id));
          expect(remainingTokenIds, isNot(contains(token1Id)));
          expect(remainingTokenIds, isNot(contains(token3Id)));
          expect(remainingTokens.first.method, equals('oauth'));
        });
      });

      group('when revoking all tokens without filters', () {
        setUp(() async {
          await tokenManager.revokeAllTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
        });

        test('then all tokens should be removed', () async {
          final remainingTokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
          expect(remainingTokens, isEmpty);
        });
      });
    },
  );

  withServerpod(
    'Given a TokenManager with no tokens',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;

      setUp(() {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
      });

      group('when listing tokens', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
        });

        test('then an empty list should be returned', () {
          expect(tokens, isEmpty);
        });
      });

      group('when revoking a non-existent token', () {
        test('then no error should be thrown', () async {
          expect(
            () => tokenManager.revokeToken(
              session: session,
              tokenId: 'non-existent',
              transaction: null,
            ),
            returnsNormally,
          );
        });
      });
    },
  );

  withServerpod(
    'Given a TokenManager with a valid token',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue userId;
      late String validToken;
      late AuthSuccess issuedToken;

      setUp(() async {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
        final authUser = await AuthUsers.create(session);
        userId = authUser.id;

        issuedToken = await tokenManager.issueToken(
          session: session,
          authUserId: userId,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
          transaction: null,
        );
        validToken = issuedToken.token;
      });

      group('when validating the token', () {
        late AuthenticationInfo? authInfo;

        setUp(() async {
          authInfo = await tokenManager.validateToken(session, validToken);
        });

        test('then the authentication info should be returned', () {
          expect(authInfo, isNotNull);
        });

        test('then the user identifier should match the issued token', () {
          expect(authInfo!.userIdentifier, equals(userId.uuid));
          expect(authInfo!.userIdentifier, equals(issuedToken.authUserId.uuid));
        });

        test('then the scopes should match the issued token', () {
          expect(authInfo!.scopes, hasLength(1));
          expect(
            authInfo!.scopes.map((final s) => s.name),
            containsAll(issuedToken.scopeNames),
          );
        });

        test('then the authId should match the token', () {
          expect(authInfo!.authId, equals(validToken));
        });
      });
    },
  );

  withServerpod(
    'Given a TokenManager with an invalid token',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue userId;
      late String validToken;

      setUp(() async {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
        final authUser = await AuthUsers.create(session);
        userId = authUser.id;

        // Issue a valid token to use as a base for creating invalid tokens
        final issuedToken = await tokenManager.issueToken(
          session: session,
          authUserId: userId,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
          transaction: null,
        );
        validToken = issuedToken.token;
      });

      group('when validating an invalid token', () {
        test('then null should be returned for malformed token', () async {
          final malformedToken = 'XXX${validToken.substring(3)}';

          final authInfo = await tokenManager.validateToken(
            session,
            malformedToken,
          );
          expect(authInfo, isNull);
        });
      });
    },
  );

  withServerpod(
    'Given a TokenManager with a revoked token',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue userId;
      late String token;

      setUp(() async {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
        final authUser = await AuthUsers.create(session);
        userId = authUser.id;

        final authSuccess = await tokenManager.issueToken(
          session: session,
          authUserId: userId,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
          transaction: null,
        );
        token = authSuccess.token;

        await tokenManager.revokeToken(
          session: session,
          tokenId: authSuccess.token,
          transaction: null,
        );
      });

      group('when validating the revoked token', () {
        late AuthenticationInfo? authInfo;

        setUp(() async {
          authInfo = await tokenManager.validateToken(session, token);
        });

        test('then null should be returned', () {
          expect(authInfo, isNull);
        });
      });
    },
  );
}

void main() {
  group('FakeTokenManager with refresh tokens', () {
    testSuite(
      tokenManagerBuilder: () {
        final storage = FakeTokenStorage();
        return FakeTokenManager(storage, usesRefreshTokens: true);
      },
      isDatabaseBackedManager: false,
      usesRefreshTokens: true,
    );
  });

  group('FakeTokenManager without refresh tokens', () {
    testSuite(
      tokenManagerBuilder: () {
        final storage = FakeTokenStorage();
        return FakeTokenManager(storage, usesRefreshTokens: false);
      },
      isDatabaseBackedManager: false,
      usesRefreshTokens: false,
    );
  });
}
