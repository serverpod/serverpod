import 'dart:async';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

import '../../../serverpod_test_tools.dart';
import '../fakes/fake_token_manager.dart';
import '../fakes/fake_token_storage.dart';

@isTestGroup
void testSuite<T extends TokenManager>(
  final String description,
  final T Function(AuthUsers authUsers) tokenManagerBuilder, {
  required final AuthUsers authUsers,
  required final String tokenIssuer,
  required final bool isDatabaseBackedManager,
  required final bool usesRefreshTokens,
  final FutureOr<void> Function(T tokenManager)? teardownFunction,
}) {
  Future<UuidValue> createAuthId(final Session session) async {
    return await authUsers.create(session).then((final value) => value.id);
  }

  withServerpod(
    'Given a TokenManager and an authId',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authId;
      late T tokenManager;

      setUp(() async {
        session = sessionBuilder.build();
        authId = await authUsers
            .create(session)
            .then((final value) => value.id);
        tokenManager = tokenManagerBuilder(authUsers);
      });

      tearDown(() async {
        await teardownFunction?.call(tokenManager);
      });

      group('when issuing a token without scopes', () {
        late Future<AuthSuccess> authSuccessFuture;
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccessFuture = tokenManager.issueToken(
            session,
            authUserId: authId,
            method: 'test-method',
          );

          authSuccess = await authSuccessFuture;
        });

        test('then issueToken completes', () async {
          await expectLater(authSuccessFuture, completes);
        });

        test('then authStrategy matches tokenIssuer type', () {
          expect(authSuccess.authStrategy, equals(tokenIssuer));
        });

        test('then authUserId matches supplied value', () {
          expect(authSuccess.authUserId, equals(authId));
        });

        test('then scopes is empty', () {
          expect(authSuccess.scopeNames, isEmpty);
        });

        test(
          skip: !usesRefreshTokens
              ? 'Skipped for managers not using refresh tokens.'
              : false,
          'then refreshToken exists',
          () {
            expect(authSuccess.refreshToken, isNotEmpty);
          },
        );
      });

      test(
        'when issuing a token with scopes then scopes matches supplied value',
        () async {
          final authSuccess = await tokenManager.issueToken(
            session,
            authUserId: authId,
            method: 'test-method',
            scopes: {const Scope('test-scope')},
          );

          expect(authSuccess.scopeNames, hasLength(1));
          expect(authSuccess.scopeNames, contains('test-scope'));
        },
      );

      test(
        'when issuing a token with a transaction that succeeds '
        'then issuing the token completes',
        () async {
          final authSuccessFuture = session.db.transaction((
            final transaction,
          ) async {
            return await tokenManager.issueToken(
              session,
              authUserId: authId,
              method: 'test-method',
              transaction: transaction,
            );
          });

          await expectLater(authSuccessFuture, completes);
        },
      );

      test(
        skip: !isDatabaseBackedManager
            ? 'Skipped for non-database-backed managers.'
            : false,
        'when issuing a token with a transaction that rolls back '
        'then token does not exist',
        () async {
          await session.db.transaction((final transaction) async {
            final savepoint = await transaction.createSavepoint();
            await tokenManager.issueToken(
              session,
              authUserId: authId,
              method: 'intentional-rollback',
              transaction: transaction,
            );
            await savepoint.rollback();
          });

          final tokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
            method: 'intentional-rollback',
          );

          expect(tokens, isEmpty);
        },
      );
    },
  );

  withServerpod(
    'Given a TokenManager and an issued token for an authId',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authId;
      late T tokenManager;
      late String tokenId;
      late AuthSuccess authSuccess;
      late List<TokenInfo> initialTokens;

      setUp(() async {
        session = sessionBuilder.build();
        authId = await createAuthId(session);
        tokenManager = tokenManagerBuilder(authUsers);
        authSuccess = await tokenManager.issueToken(
          session,
          authUserId: authId,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
        );
        initialTokens = await tokenManager.listTokens(
          session,
          authUserId: authId,
        );

        tokenId = initialTokens.single.tokenId;
      });

      tearDown(() async {
        await teardownFunction?.call(tokenManager);
      });

      group('when validating the token', () {
        late AuthenticationInfo? authInfo;

        setUp(() async {
          authInfo = await tokenManager.validateToken(
            session,
            authSuccess.token,
          );
        });

        test('then AuthenticationInfo should be non-null', () {
          expect(authInfo, isNotNull);
        });

        test('then userIdentifier should match authUserId', () {
          expect(authInfo!.userIdentifier, equals(authId.uuid));
        });

        test('then scopes should match issued scopes', () {
          expect(authInfo!.scopes, hasLength(1));
          expect(authInfo!.scopes, contains(const Scope('test-scope')));
        });

        test('then authId should exist', () {
          expect(authInfo!.authId, isNotNull);
        });

        test('then authId should match tokenId', () async {
          expect(authInfo!.authId, tokenId);
        });
      });

      test(
        'when validating an invalid token, then AuthenticationInfo should be null',
        () async {
          final invalidToken = 'INVALID${authSuccess.token}';
          final authInfo = await tokenManager.validateToken(
            session,
            invalidToken,
          );

          expect(authInfo, isNull);
        },
      );

      test(
        'when revoking the token with a transaction that succeeds then token is removed',
        () async {
          await session.db.transaction((final transaction) async {
            await tokenManager.revokeToken(
              session,
              tokenId: tokenId,
              transaction: transaction,
            );
          });

          final tokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );

          expect(
            tokens.any((final t) => t.tokenId == tokenId),
            isFalse,
          );
        },
      );

      test(
        skip: !isDatabaseBackedManager
            ? 'Skipped for non-database-backed managers.'
            : false,
        'when revoking the token with a transaction that rolls back '
        'then token still exists',
        () async {
          await session.db.transaction((final transaction) async {
            final savepoint = await transaction.createSavepoint();
            await tokenManager.revokeToken(
              session,
              tokenId: tokenId,
              transaction: transaction,
            );
            await savepoint.rollback();
          });

          final tokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );

          expect(
            tokens.any((final t) => t.tokenId == tokenId),
            isTrue,
          );
        },
      );

      test(
        'when revoking the token with an invalid tokenIssuer filter '
        'then token is not removed',
        () async {
          await tokenManager.revokeToken(
            session,
            tokenId: tokenId,
            tokenIssuer: 'INVALID$tokenIssuer',
          );

          final tokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );

          expect(tokens, hasLength(initialTokens.length));
          expect(
            tokens.any((final t) => t.tokenId == tokenId),
            isTrue,
          );
        },
      );
    },
  );

  withServerpod(
    'Given a TokenManager and multiple issued tokens for the same authId',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authId;
      late T tokenManager;
      late List<TokenInfo> initialTokens;

      setUp(() async {
        session = sessionBuilder.build();
        authId = await createAuthId(session);
        tokenManager = tokenManagerBuilder(authUsers);

        await tokenManager.issueToken(
          session,
          authUserId: authId,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
        );

        initialTokens = await tokenManager.listTokens(
          session,
          authUserId: authId,
        );
      });

      tearDown(() async {
        await teardownFunction?.call(tokenManager);
      });

      group('when revoking a token with a non-existent tokenId', () {
        late Future<void> revokeTokenFuture;
        late List<TokenInfo> tokensAfterRevocation;

        setUp(() async {
          revokeTokenFuture = tokenManager.revokeToken(
            session,
            tokenId: 'non-existent-token-id',
          );

          tokensAfterRevocation = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );
        });

        test('then revokeToken completes', () async {
          await expectLater(revokeTokenFuture, completes);
        });

        test('then no tokens are revoked', () {
          expect(tokensAfterRevocation, hasLength(initialTokens.length));
        });
      });

      test(
        'when listing tokens with an invalid token issuer filter, then tokens should be empty',
        () async {
          final tokens = await tokenManager.listTokens(
            session,
            authUserId: null,
            tokenIssuer: 'INVALID$tokenIssuer',
          );

          expect(tokens, isEmpty);
        },
      );

      test(
        'when listing tokens '
        'then all tokens should be returned',
        () async {
          final tokens = await tokenManager.listTokens(
            session,
            authUserId: null,
          );

          expect(tokens, hasLength(initialTokens.length));
        },
      );

      group('when listing tokens with a valid token issuer filter', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await tokenManager.listTokens(
            session,
            authUserId: null,
            tokenIssuer: tokenIssuer,
          );
        });

        test('then tokens should not be empty', () {
          expect(tokens, isNotEmpty);
        });

        test('then tokens should have the specified token issuer', () {
          expect(
            tokens.every((final t) => t.tokenIssuer == tokenIssuer),
            isTrue,
          );
        });
      });

      group('when revoking a specific token by tokenId', () {
        late String channelName;
        late List<SerializableModel> revocationMessages;

        late List<TokenInfo> beforeRevocationTokens;
        late List<TokenInfo> afterRevocationTokens;
        late String tokenIdToRevoke;

        late Future<void> revokeTokenFuture;

        setUp(() async {
          channelName = MessageCentralServerpodChannels.revokedAuthentication(
            authId.uuid,
          );

          revocationMessages = <SerializableModel>[];
          session.messages.addListener(
            channelName,
            revocationMessages.add,
          );

          beforeRevocationTokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
            method: 'test-method',
          );

          tokenIdToRevoke = beforeRevocationTokens.first.tokenId;
          revokeTokenFuture = tokenManager.revokeToken(
            session,
            tokenId: tokenIdToRevoke,
          );

          afterRevocationTokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
            method: 'test-method',
          );
        });

        tearDown(() {
          session.messages.removeListener(
            channelName,
            revocationMessages.add,
          );
        });

        test('then revokeToken completes successfully', () async {
          await expectLater(revokeTokenFuture, completes);
        });

        test('then the token should be removed', () {
          expect(
            afterRevocationTokens,
            hasLength(beforeRevocationTokens.length - 1),
          );
          expect(
            afterRevocationTokens.any(
              (final t) => t.tokenId == tokenIdToRevoke,
            ),
            isFalse,
          );
        });

        test(
          'then authenticationRevoked message is sent with correct authId',
          () async {
            expect(revocationMessages, [
              isA<RevokedAuthenticationAuthId>().having(
                (final m) => m.authId,
                'authId',
                tokenIdToRevoke,
              ),
            ]);
          },
        );
      });

      group('when revoking a token with a valid tokenIssuer filter', () {
        late String tokenIdToRevoke;
        late List<TokenInfo> beforeRevocationTokens;
        late List<TokenInfo> afterRevocationTokens;

        setUp(() async {
          beforeRevocationTokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );

          tokenIdToRevoke = beforeRevocationTokens.first.tokenId;

          await tokenManager.revokeToken(
            session,
            tokenId: tokenIdToRevoke,
            tokenIssuer: tokenIssuer,
          );

          afterRevocationTokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );
        });

        test('then the token should be removed', () {
          expect(
            afterRevocationTokens.any(
              (final t) => t.tokenId == tokenIdToRevoke,
            ),
            isFalse,
          );
        });

        test('then other tokens should remain', () {
          expect(
            afterRevocationTokens,
            hasLength(beforeRevocationTokens.length - 1),
          );
        });
      });

      test(
        'when revoking a token with an invalid tokenIssuer filter '
        'then token is not removed',
        () async {
          final beforeRevocationTokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );

          final tokenIdToRevoke = beforeRevocationTokens.first.tokenId;

          await tokenManager.revokeToken(
            session,
            tokenId: tokenIdToRevoke,
            tokenIssuer: 'INVALID$tokenIssuer',
          );

          final afterRevocationTokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );

          expect(afterRevocationTokens, hasLength(initialTokens.length));
          expect(
            afterRevocationTokens.any(
              (final t) => t.tokenId == tokenIdToRevoke,
            ),
            isTrue,
          );
        },
      );

      test(
        'when revoking all tokens with a transaction that succeeds '
        'then tokens are removed',
        () async {
          await session.db.transaction((final transaction) async {
            await tokenManager.revokeAllTokens(
              session,
              authUserId: authId,
              transaction: transaction,
            );
          });

          final tokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );

          expect(tokens, isEmpty);
        },
      );

      test(
        skip: !isDatabaseBackedManager
            ? 'Skipped for non-database-backed managers.'
            : false,
        'when revoking all tokens with a transaction that rolls back '
        'then tokens still exist',
        () async {
          await session.db.transaction((final transaction) async {
            final savepoint = await transaction.createSavepoint();
            await tokenManager.revokeAllTokens(
              session,
              authUserId: authId,
              transaction: transaction,
            );
            final tokens = await tokenManager.listTokens(
              session,
              authUserId: authId,
              transaction: transaction,
            );

            /// New token can be listed
            expect(tokens, hasLength(0));
            await savepoint.rollback();
          });

          final tokens = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );

          expect(tokens, hasLength(initialTokens.length));
        },
      );
    },
  );

  withServerpod(
    'Given a TokenManager with tokens issued using different methods for the same authId',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authId;
      late T tokenManager;
      late List<TokenInfo> initialTokensMethod1;

      setUp(() async {
        session = sessionBuilder.build();
        authId = await createAuthId(session);
        tokenManager = tokenManagerBuilder(authUsers);

        await tokenManager.issueToken(
          session,
          authUserId: authId,
          method: 'method1',
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId,
          method: 'method1',
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId,
          method: 'method2',
        );

        initialTokensMethod1 = await tokenManager.listTokens(
          session,
          authUserId: null,
          method: 'method1',
        );
      });

      tearDown(() async {
        await teardownFunction?.call(tokenManager);
      });

      test(
        'when listing tokens with a method filter '
        'then only tokens with the specified method should be returned',
        () async {
          final tokens = await tokenManager.listTokens(
            session,
            authUserId: null,
            method: 'method1',
          );

          expect(tokens, hasLength(initialTokensMethod1.length));
          expect(
            tokens.every((final t) => t.method == 'method1'),
            isTrue,
          );
        },
      );

      group('when revoking all tokens globally with a method filter', () {
        late List<TokenInfo> tokensAfterRevocation;

        setUp(() async {
          await tokenManager.revokeAllTokens(
            session,
            authUserId: null,
            method: 'method1',
          );

          tokensAfterRevocation = await tokenManager.listTokens(
            session,
            authUserId: authId,
          );
        });

        test('then all tokens with the specified method should be removed', () {
          expect(
            tokensAfterRevocation.any((final t) => t.method == 'method1'),
            isFalse,
          );
        });

        test('then tokens with other methods should remain', () {
          expect(
            tokensAfterRevocation.any((final t) => t.method == 'method2'),
            isTrue,
          );
        });
      });
    },
  );

  withServerpod(
    'Given a TokenManager with tokens for multiple authIds',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late T tokenManager;
      late UuidValue authId1;
      late UuidValue authId2;
      late UuidValue authId3;
      late List<TokenInfo> initialTokensForAuthId1;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = tokenManagerBuilder(authUsers);

        authId1 = await createAuthId(session);
        authId2 = await createAuthId(session);
        authId3 = await createAuthId(session);

        await tokenManager.issueToken(
          session,
          authUserId: authId1,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId1,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId2,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId3,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
        );

        initialTokensForAuthId1 = await tokenManager.listTokens(
          session,
          authUserId: authId1,
        );
      });

      tearDown(() async {
        await teardownFunction?.call(tokenManager);
      });

      test(
        'when listing tokens for a specific authId '
        'then only tokens for the specified authId should be returned',
        () async {
          final tokens = await tokenManager.listTokens(
            session,
            authUserId: authId1,
          );

          expect(tokens, hasLength(initialTokensForAuthId1.length));
          expect(
            tokens.every((final t) => t.userId == authId1.toString()),
            isTrue,
          );
        },
      );

      group('when revoking all tokens for a specific authId', () {
        late List<TokenInfo> tokensAfterRevocation;
        late Future<void> revokeAllTokensFuture;

        setUp(() async {
          revokeAllTokensFuture = tokenManager.revokeAllTokens(
            session,
            authUserId: authId1,
          );

          tokensAfterRevocation = await tokenManager.listTokens(
            session,
            authUserId: null,
          );
        });

        test('then revokeAllTokens completes successfully', () async {
          await expectLater(revokeAllTokensFuture, completes);
        });

        test('then all tokens for the authId should be removed', () {
          expect(
            tokensAfterRevocation.any(
              (final t) => t.userId == authId1.toString(),
            ),
            isFalse,
          );
        });

        test('then tokens for other authIds should remain', () {
          expect(
            tokensAfterRevocation.any(
              (final t) => t.userId == authId2.toString(),
            ),
            isTrue,
          );
        });
      });

      group('when revoking all tokens for a non-existent authId', () {
        late List<TokenInfo> tokensBeforeRevocation;
        late List<TokenInfo> tokensAfterRevocation;
        late Future<void> revokeAllTokensFuture;

        setUp(() async {
          tokensBeforeRevocation = await tokenManager.listTokens(
            session,
            authUserId: null,
          );

          final nonExistentUserId = const Uuid().v4obj();

          revokeAllTokensFuture = tokenManager.revokeAllTokens(
            session,
            authUserId: nonExistentUserId,
          );

          tokensAfterRevocation = await tokenManager.listTokens(
            session,
            authUserId: null,
          );
        });

        test('then revokeAllTokens completes', () async {
          await expectLater(revokeAllTokensFuture, completes);
        });

        test('then no other tokens are revoked', () {
          expect(
            tokensAfterRevocation.length,
            equals(tokensBeforeRevocation.length),
          );
        });
      });
    },
  );

  withServerpod(
    'Given a TokenManager with tokens for multiple authIds and methods',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late T tokenManager;
      late UuidValue authId1;
      late UuidValue authId2;
      late List<TokenInfo> initialAllTokens;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = tokenManagerBuilder(authUsers);

        authId1 = await createAuthId(session);
        authId2 = await createAuthId(session);

        await tokenManager.issueToken(
          session,
          authUserId: authId1,
          method: 'method1',
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId1,
          method: 'method2',
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId2,
          method: 'method1',
        );

        await tokenManager.issueToken(
          session,
          authUserId: authId2,
          method: 'method2',
        );

        initialAllTokens = await tokenManager.listTokens(
          session,
          authUserId: null,
        );
      });

      tearDown(() async {
        await teardownFunction?.call(tokenManager);
      });

      group(
        'when revoking all tokens for a specific authId with combined filters',
        () {
          late List<TokenInfo> tokensAfterRevocation;

          setUp(() async {
            await tokenManager.revokeAllTokens(
              session,
              authUserId: authId1,
              method: 'method1',
              tokenIssuer: tokenIssuer,
            );

            tokensAfterRevocation = await tokenManager.listTokens(
              session,
              authUserId: null,
            );
          });

          test('then only token matching all filters should be removed', () {
            expect(
              tokensAfterRevocation.any(
                (final t) =>
                    t.userId == authId1.toString() && t.method == 'method1',
              ),
              isFalse,
            );
          });

          test('then all other tokens should remain', () {
            expect(
              tokensAfterRevocation,
              hasLength(initialAllTokens.length - 1),
            );
            expect(
              tokensAfterRevocation.any(
                (final t) =>
                    t.userId == authId1.toString() && t.method == 'method2',
              ),
              isTrue,
            );
            expect(
              tokensAfterRevocation.any(
                (final t) =>
                    t.userId == authId2.toString() && t.method == 'method1',
              ),
              isTrue,
            );
            expect(
              tokensAfterRevocation.any(
                (final t) =>
                    t.userId == authId2.toString() && t.method == 'method2',
              ),
              isTrue,
            );
          });
        },
      );

      test(
        'when revoking all tokens without any filters '
        'then all tokens are removed',
        () async {
          await tokenManager.revokeAllTokens(
            session,
            authUserId: null,
          );

          final tokens = await tokenManager.listTokens(
            session,
            authUserId: null,
          );

          expect(tokens, isEmpty);
        },
      );
    },
  );
}

void main() {
  final fakeTokenStorage = FakeTokenStorage();
  const authUsers = AuthUsers();
  testSuite(
    'FakeTokenManager',
    (final authUsers) {
      return FakeTokenManager(fakeTokenStorage, authUsers: authUsers);
    },
    teardownFunction: (final tokenManager) {
      fakeTokenStorage.clear();
    },
    tokenIssuer: 'fake',
    authUsers: authUsers,
    isDatabaseBackedManager: false,
    usesRefreshTokens: false,
  );

  testSuite(
    'AuthSessionsTokenManager',
    (final authUsers) {
      return AuthSessionsTokenManager(
        config: AuthSessionsConfig(
          sessionKeyHashPepper: 'test-pepper',
        ),
        authUsers: authUsers,
      );
    },
    tokenIssuer: AuthSessionsTokenManager.tokenIssuerName,
    authUsers: authUsers,
    isDatabaseBackedManager: true,
    usesRefreshTokens: false,
  );

  testSuite(
    'AuthenticationTokensTokenManager',
    (final authUsers) {
      return AuthenticationTokensTokenManager(
        config: AuthenticationTokenConfig(
          algorithm: HmacSha512AuthenticationTokenAlgorithmConfiguration(
            key: SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: 'test-pepper',
        ),
        authUsers: authUsers,
      );
    },
    tokenIssuer: AuthenticationTokensTokenManager.tokenIssuerName,
    authUsers: authUsers,
    isDatabaseBackedManager: true,
    usesRefreshTokens: true,
  );
}
