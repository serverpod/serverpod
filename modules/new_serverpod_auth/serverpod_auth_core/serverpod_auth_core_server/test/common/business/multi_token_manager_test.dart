import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/auth_user.dart';
import 'package:serverpod_auth_core_server/src/common/business/multi_token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import 'fakes/fakes.dart';

void main() {
  withServerpod(
    'Given a MultiTokenManager with multiple fake managers',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late FakeTokenStorage defaultStorage;
      late FakeTokenStorage additionalStorage1;
      late FakeTokenStorage additionalStorage2;
      late FakeTokenManager defaultManager;
      late FakeTokenManager additionalManager1;
      late FakeTokenManager additionalManager2;
      late MultiTokenManager multiTokenManager;
      late UuidValue userId;

      setUp(() async {
        session = sessionBuilder.build();
        final authUser = await const AuthUsers().create(session);
        userId = authUser.id;

        defaultStorage = FakeTokenStorage();
        additionalStorage1 = FakeTokenStorage();
        additionalStorage2 = FakeTokenStorage();

        defaultManager = FakeTokenManager(defaultStorage);
        additionalManager1 = FakeTokenManager(additionalStorage1);
        additionalManager2 = FakeTokenManager(additionalStorage2);

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: defaultManager,
          additionalTokenManagers: [
            additionalManager1,
            additionalManager2,
          ],
        );
      });

      group('when issuing a token', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await multiTokenManager.issueToken(
            session,
            authUserId: userId,
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
          expect(authSuccess.authUserId, equals(userId));
        });

        test('then the scopeNames should match', () {
          expect(authSuccess.scopeNames, contains('test-scope'));
        });

        test('then only the default manager should have the token', () {
          expect(defaultStorage.tokenCount, equals(1));
          expect(additionalStorage1.tokenCount, equals(0));
          expect(additionalStorage2.tokenCount, equals(0));
        });

        test('then the token should be in the default manager', () {
          final tokens = defaultStorage.allTokens;
          expect(tokens, hasLength(1));
          expect(tokens.first.userId, equals(userId.toString()));
          expect(tokens.first.method, equals('test-method'));
        });
      });

      group('when issuing multiple tokens', () {
        late AuthSuccess firstToken;
        late AuthSuccess secondToken;

        setUp(() async {
          firstToken = await multiTokenManager.issueToken(
            session,
            authUserId: userId,
            method: 'test-method',
            scopes: {const Scope('test-scope')},
            transaction: null,
          );

          secondToken = await multiTokenManager.issueToken(
            session,
            authUserId: userId,
            method: 'test-method',
            scopes: {const Scope('test-scope')},
            transaction: null,
          );
        });

        test('then each token should be unique', () {
          expect(firstToken.token, isNot(equals(secondToken.token)));
          expect(
            firstToken.refreshToken,
            isNot(equals(secondToken.refreshToken)),
          );
        });

        test('then all tokens should be in the default manager', () {
          expect(defaultStorage.tokenCount, equals(2));
          expect(additionalStorage1.tokenCount, equals(0));
          expect(additionalStorage2.tokenCount, equals(0));
        });
      });
    },
  );

  withServerpod(
    'Given tokens in multiple managers',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late FakeTokenStorage defaultStorage;
      late FakeTokenStorage additionalStorage1;
      late FakeTokenStorage additionalStorage2;
      late FakeTokenManager defaultManager;
      late FakeTokenManager additionalManager1;
      late FakeTokenManager additionalManager2;
      late MultiTokenManager multiTokenManager;
      late UuidValue user1Id;
      late UuidValue user2Id;

      late String defaultManagerToken;
      late String additionalManager1Token;
      late String additionalManager1TokenId;
      late String additionalManager2Token1;

      setUp(() async {
        session = sessionBuilder.build();
        const authUsers = AuthUsers();
        user1Id = (await authUsers.create(session)).id;
        user2Id = (await authUsers.create(session)).id;

        defaultStorage = FakeTokenStorage();
        additionalStorage1 = FakeTokenStorage();
        additionalStorage2 = FakeTokenStorage();

        defaultManager = FakeTokenManager(
          defaultStorage,
          tokenIssuer: 'default',
        );
        additionalManager1 = FakeTokenManager(
          additionalStorage1,
          tokenIssuer: 'additional1',
        );
        additionalManager2 = FakeTokenManager(
          additionalStorage2,
          tokenIssuer: 'additional2',
        );

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: defaultManager,
          additionalTokenManagers: [
            additionalManager1,
            additionalManager2,
          ],
        );

        final defaultManagerAuthSuccess = await defaultManager.issueToken(
          session,
          authUserId: user1Id,
          method: 'email',
          scopes: {const Scope('read')},
        );
        defaultManagerToken = defaultManagerAuthSuccess.token;

        final additionalManager1AuthSuccess = await additionalManager1
            .issueToken(
              session,
              authUserId: user1Id,
              method: 'oauth',
              scopes: {const Scope('write')},
            );
        additionalManager1Token = additionalManager1AuthSuccess.token;
        additionalManager1TokenId = (await additionalManager1.listTokens(
          session,
          authUserId: user1Id,
        )).single.tokenId;

        final additionalManager2AuthSuccess1 = await additionalManager2
            .issueToken(
              session,
              authUserId: user2Id,
              method: 'email',
              scopes: {const Scope('admin')},
            );
        additionalManager2Token1 = additionalManager2AuthSuccess1.token;

        await additionalManager2.issueToken(
          session,
          authUserId: user1Id,
          method: 'email',
          scopes: {const Scope('write')},
        );
      });

      group('when listing all tokens', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await multiTokenManager.listTokens(
            session,
            authUserId: null,
            method: null,
          );
        });

        test('then all tokens from all managers should be returned', () {
          expect(tokens, hasLength(4));
        });

        test('then tokens should have correct providers', () {
          final providers = tokens.map((final t) => t.tokenIssuer).toSet();
          expect(
            providers,
            containsAllInOrder(['default', 'additional1', 'additional2']),
          );
        });
      });

      group('when listing tokens by user', () {
        late List<TokenInfo> user1Tokens;
        late List<TokenInfo> user2Tokens;

        setUp(() async {
          user1Tokens = await multiTokenManager.listTokens(
            session,
            authUserId: user1Id,
            method: null,
          );

          user2Tokens = await multiTokenManager.listTokens(
            session,
            authUserId: user2Id,
            method: null,
          );
        });

        test('then only tokens for the specified user should be returned', () {
          expect(user1Tokens, hasLength(3));
          expect(
            user1Tokens.every((final t) => t.userId == user1Id.toString()),
            isTrue,
          );

          expect(user2Tokens, hasLength(1));
          expect(user2Tokens.single.userId, equals(user2Id.toString()));
        });

        test('then user1 tokens should come from different managers', () {
          final providers = user1Tokens.map((final t) => t.tokenIssuer).toSet();
          expect(
            providers,
            containsAllInOrder(['default', 'additional1', 'additional2']),
          );
        });
      });

      group('when listing tokens by method', () {
        late List<TokenInfo> emailTokens;

        setUp(() async {
          emailTokens = await multiTokenManager.listTokens(
            session,
            authUserId: null,
            method: 'email',
          );
        });

        test('then only tokens with specified method should be returned', () {
          expect(emailTokens, hasLength(3));
          expect(
            emailTokens.every((final t) => t.method == 'email'),
            isTrue,
          );
        });

        test('then tokens should come from different managers', () {
          final providers = emailTokens.map((final t) => t.tokenIssuer).toSet();
          expect(providers, containsAllInOrder(['default', 'additional2']));
        });
      });

      group('when listing tokens with combined filters', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await multiTokenManager.listTokens(
            session,
            authUserId: user1Id,
            method: 'email',
          );
        });

        test('then only matching tokens should be returned', () {
          expect(tokens, hasLength(2));
          expect(
            tokens.every((final t) => t.userId == user1Id.toString()),
            isTrue,
          );
          expect(tokens.every((final t) => t.method == 'email'), isTrue);
        });
      });

      group('when revoking a specific token', () {
        setUp(() async {
          await multiTokenManager.revokeToken(
            session,
            tokenId: additionalManager1TokenId,
          );
        });

        test('then that token is removed from the list of tokens', () async {
          final tokens = await multiTokenManager.listTokens(
            session,
            authUserId: null,
            method: null,
          );

          expect(tokens, hasLength(3));
          expect(
            tokens.any((final t) => t.tokenId == additionalManager1TokenId),
            isFalse,
            reason: 'Token should not be found',
          );
        });
      });

      test(
        'when revoking a non-existent token then no error should be thrown',
        () async {
          expect(
            () => multiTokenManager.revokeToken(
              session,
              tokenId: 'non-existent',
            ),
            returnsNormally,
          );
        },
      );

      group('when revoking all tokens for a user', () {
        setUp(() async {
          await multiTokenManager.revokeAllTokens(
            session,
            authUserId: user1Id,
            method: null,
          );
        });

        test(
          'then all user tokens should be revoked across all managers',
          () async {
            final remainingTokens = await multiTokenManager.listTokens(
              session,
              authUserId: null,
              method: null,
            );

            expect(remainingTokens, hasLength(1));
            expect(remainingTokens.first.userId, equals(user2Id.toString()));
          },
        );

        test('then tokens should be removed from all managers', () {
          expect(defaultStorage.tokenCount, equals(0));
          expect(additionalStorage1.tokenCount, equals(0));
          expect(additionalStorage2.tokenCount, equals(1));
        });
      });

      group('when revoking all tokens by method', () {
        setUp(() async {
          await multiTokenManager.revokeAllTokens(
            session,
            authUserId: null,
            method: 'email',
          );
        });

        test(
          'then only tokens with specified method should be revoked',
          () async {
            final remainingTokens = await multiTokenManager.listTokens(
              session,
              authUserId: null,
              method: null,
            );

            expect(remainingTokens, hasLength(1));
            expect(remainingTokens.first.method, equals('oauth'));
            expect(remainingTokens.first.tokenIssuer, equals('additional1'));
          },
        );
      });

      group('when revoking all tokens with combined filters', () {
        setUp(() async {
          await multiTokenManager.revokeAllTokens(
            session,
            authUserId: user1Id,
            method: 'email',
            transaction: null,
          );
        });

        test('then only matching tokens should be revoked', () async {
          final remainingTokens = await multiTokenManager.listTokens(
            session,
            authUserId: null,
            method: null,
          );

          expect(remainingTokens, hasLength(2));
          expect(
            remainingTokens.any(
              (final t) =>
                  t.userId == user1Id.toString() && t.method == 'email',
            ),
            isFalse,
            reason: 'Tokens matching combined filters should be removed',
          );
        });
      });

      group('when revoking all tokens without filters', () {
        setUp(() async {
          await multiTokenManager.revokeAllTokens(
            session,
            authUserId: null,
            method: null,
          );
        });

        test('then all tokens should be removed', () async {
          final remainingTokens = await multiTokenManager.listTokens(
            session,
            authUserId: null,
            method: null,
          );
          expect(remainingTokens, isEmpty);
        });

        test('then all storages should be empty', () {
          expect(defaultStorage.tokenCount, equals(0));
          expect(additionalStorage1.tokenCount, equals(0));
          expect(additionalStorage2.tokenCount, equals(0));
        });
      });

      group('when validating a token from the default manager', () {
        late AuthenticationInfo? authInfo;

        setUp(() async {
          authInfo = await multiTokenManager.validateToken(
            session,
            defaultManagerToken,
          );
        });

        test('then authentication info should be returned', () {
          expect(authInfo, isNotNull);
        });

        test('then the user identifier should match', () {
          expect(authInfo!.userIdentifier, equals(user1Id.toString()));
        });

        test('then the scopes should match', () {
          expect(
            authInfo!.scopes.map((final s) => s.name),
            contains('read'),
          );
        });
      });

      test(
        'when validating a token from additional manager 1 then authentication info should be returned',
        () async {
          final authInfo = await multiTokenManager.validateToken(
            session,
            additionalManager1Token,
          );

          expect(authInfo, isNotNull);
          expect(authInfo!.userIdentifier, equals(user1Id.toString()));
          expect(
            authInfo.scopes.map((final s) => s.name),
            contains('write'),
          );
        },
      );

      test(
        'when validating a token from additional manager 2 then authentication info should be returned',
        () async {
          final authInfo = await multiTokenManager.validateToken(
            session,
            additionalManager2Token1,
          );

          expect(authInfo, isNotNull);
          expect(authInfo!.userIdentifier, equals(user2Id.toString()));
          expect(
            authInfo.scopes.map((final s) => s.name),
            contains('admin'),
          );
        },
      );

      test(
        'when validating an invalid token then null should be returned',
        () async {
          final authInfo = await multiTokenManager.validateToken(
            session,
            'invalid-token',
          );

          expect(authInfo, isNull);
        },
      );

      test(
        'when validating an empty token then null should be returned',
        () async {
          final authInfo = await multiTokenManager.validateToken(session, '');

          expect(authInfo, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given same token is valid in in primary and additional token manager',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late MultiTokenManager multiTokenManager;
      const String primaryTokenManagerUser = 'primary-token-manager-user';

      setUp(() {
        session = sessionBuilder.build();
        final primaryTokenManager = MockedTokenManager(
          onValidateToken: (final session, final token) async {
            return AuthenticationInfo(
              primaryTokenManagerUser,
              {const Scope('read')},
              authId: 'token1',
            );
          },
        );
        final additionalTokenManager = MockedTokenManager(
          onValidateToken: (final session, final token) async {
            return AuthenticationInfo(
              'additional-token-manager-user',
              {const Scope('write')},
              authId: 'token2',
            );
          },
        );
        multiTokenManager = MultiTokenManager(
          primaryTokenManager: primaryTokenManager,
          additionalTokenManagers: [
            additionalTokenManager,
          ],
        );
      });

      test(
        'when validating a token then validation result from primary token manager is returned',
        () async {
          final authInfo = await multiTokenManager.validateToken(
            session,
            'token',
          );

          expect(authInfo!.userIdentifier, equals(primaryTokenManagerUser));
        },
      );
    },
  );

  withServerpod(
    'Given same token is valid in multiple additional token managers',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late MultiTokenManager multiTokenManager;
      const String firstAdditionalTokenManagerUser =
          'first-additional-token-manager-user';

      setUp(() {
        session = sessionBuilder.build();
        final primaryTokenManager = MockedTokenManager(
          onValidateToken: (final session, final token) async {
            return null;
          },
        );
        final firstAdditionalTokenManager = MockedTokenManager(
          onValidateToken: (final session, final token) async {
            return AuthenticationInfo(
              firstAdditionalTokenManagerUser,
              {const Scope('write')},
              authId: 'token2',
            );
          },
        );
        final secondAdditionalTokenManager = MockedTokenManager(
          onValidateToken: (final session, final token) async {
            return AuthenticationInfo(
              'second-additional-token-manager-user',
              {const Scope('read')},
              authId: 'token3',
            );
          },
        );
        multiTokenManager = MultiTokenManager(
          primaryTokenManager: primaryTokenManager,
          additionalTokenManagers: [
            firstAdditionalTokenManager,
            secondAdditionalTokenManager,
          ],
        );
      });

      test(
        'when validating a token then validation result from first additional token manager is returned',
        () async {
          final authInfo = await multiTokenManager.validateToken(
            session,
            'token',
          );

          expect(
            authInfo!.userIdentifier,
            equals(firstAdditionalTokenManagerUser),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a MultiTokenManager with only a default manager',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late FakeTokenStorage storage;
      late MultiTokenManager multiTokenManager;
      late UuidValue userId;

      setUp(() async {
        session = sessionBuilder.build();
        const authUsers = AuthUsers();
        userId = (await authUsers.create(session)).id;
        storage = FakeTokenStorage();

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: FakeTokenManager(storage),
          additionalTokenManagers: const [],
        );
      });

      group('when issuing a token', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await multiTokenManager.issueToken(
            session,
            authUserId: userId,
            method: 'test',
            scopes: {const Scope('test')},
            transaction: null,
          );
        });

        test('then the token should be returned', () {
          expect(authSuccess.token, isNotEmpty);
        });

        test('then listing tokens should include the token', () async {
          await expectLater(
            multiTokenManager.listTokens(
              session,
              authUserId: null,
              method: null,
            ),
            completion(hasLength(1)),
          );
        });
      });

      test(
        'when listing tokens then all tokens from the default manager should be returned',
        () async {
          storage.storeToken(
            TokenInfo(
              userId: userId.uuid,
              tokenIssuer: 'default',
              tokenId: 'token-1',
              scopes: {const Scope('test')},
              method: 'test',
            ),
          );

          final tokens = await multiTokenManager.listTokens(
            session,
            authUserId: null,
            method: null,
          );

          expect(tokens, hasLength(1));
        },
      );
    },
  );

  withServerpod(
    'Given a MultiTokenManager with many additional managers',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late MultiTokenManager multiTokenManager;
      late List<FakeTokenStorage> storages;
      const String tokenIssuer1 = 'manager-1';
      const String tokenIssuer2 = 'manager-2';
      const String tokenIssuer3 = 'manager-3';
      const String tokenIssuer4 = 'manager-4';
      const String tokenIssuer5 = 'manager-5';
      const List<String> tokenIssuers = [
        tokenIssuer1,
        tokenIssuer2,
        tokenIssuer3,
        tokenIssuer4,
        tokenIssuer5,
      ];

      setUp(() async {
        session = sessionBuilder.build();
        const authUsers = AuthUsers();
        final userId = (await authUsers.create(session)).id;
        storages = List.generate(5, (final _) => FakeTokenStorage());
        final tokenManagers = List.generate(
          5,
          (final i) =>
              FakeTokenManager(storages[i], tokenIssuer: tokenIssuers[i]),
        );

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: tokenManagers[0],
          additionalTokenManagers: [
            tokenManagers[1],
            tokenManagers[2],
            tokenManagers[3],
            tokenManagers[4],
          ],
        );

        // Add one token to each manager
        for (var i = 0; i < 5; i++) {
          await tokenManagers[i].issueToken(
            session,
            authUserId: userId,
            method: 'email',
            scopes: {const Scope('read')},
          );
        }
      });

      test('then listTokens should return tokens from all managers', () async {
        final tokens = await multiTokenManager.listTokens(
          session,
          authUserId: null,
          method: null,
        );

        expect(tokens, hasLength(5));
        expect(
          tokens.map((final t) => t.tokenIssuer).toSet(),
          containsAll(tokenIssuers),
        );
      });

      test('then revokeAllTokens should remove from all managers', () async {
        await multiTokenManager.revokeAllTokens(
          session,
          authUserId: null,
          method: null,
        );

        await expectLater(
          multiTokenManager.listTokens(session, authUserId: null, method: null),
          completion(isEmpty),
        );
      });
    },
  );

  withServerpod(
    'Given a MultiTokenManager with kind-aware managers',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late FakeTokenStorage defaultStorage;
      late FakeTokenStorage storage1;
      late FakeTokenStorage storage2;
      late FakeTokenStorage storage3;
      late FakeTokenManager defaultManager;
      late FakeTokenManager manager1;
      late FakeTokenManager manager2;
      late FakeTokenManager manager3;
      late MultiTokenManager multiTokenManager;
      late UuidValue userId;
      late String firstManagerTokenId;

      setUp(() async {
        session = sessionBuilder.build();
        const authUsers = AuthUsers();
        userId = (await authUsers.create(session)).id;

        defaultStorage = FakeTokenStorage();
        storage1 = FakeTokenStorage();
        storage2 = FakeTokenStorage();
        storage3 = FakeTokenStorage();

        defaultManager = FakeTokenManager(
          defaultStorage,
          tokenIssuer: 'default',
        );
        manager1 = FakeTokenManager(storage1, tokenIssuer: 'jwt');
        manager2 = FakeTokenManager(storage2, tokenIssuer: 'session');
        manager3 = FakeTokenManager(storage3, tokenIssuer: 'refresh');

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: defaultManager,
          additionalTokenManagers: [
            manager1,
            manager2,
            manager3,
          ],
        );

        // Add tokens to each manager
        await manager1.issueToken(
          session,
          authUserId: userId,
          method: 'email',
          scopes: {const Scope('read')},
        );
        firstManagerTokenId = (await manager1.listTokens(
          session,
          authUserId: userId,
        )).single.tokenId;
        await manager2.issueToken(
          session,
          authUserId: userId,
          method: 'oauth',
          scopes: {const Scope('write')},
        );
        await manager3.issueToken(
          session,
          authUserId: userId,
          method: 'email',
          scopes: {const Scope('refresh')},
        );
      });

      group('when listing tokens with token issuer filter', () {
        test(
          'then only tokens from the specified manager should be returned',
          () async {
            final jwtTokens = await multiTokenManager.listTokens(
              session,
              authUserId: null,
              method: null,
              tokenIssuer: 'jwt',
            );

            expect(jwtTokens, hasLength(1));
            expect(jwtTokens.first.tokenIssuer, equals('jwt'));
          },
        );

        test(
          'then session tokens should be returned when kind is session',
          () async {
            final sessionTokens = await multiTokenManager.listTokens(
              session,
              authUserId: null,
              method: null,
              tokenIssuer: 'session',
            );

            expect(sessionTokens, hasLength(1));
            expect(sessionTokens.first.tokenIssuer, equals('session'));
          },
        );

        test(
          'then refresh tokens should be returned when kind is refresh',
          () async {
            final refreshTokens = await multiTokenManager.listTokens(
              session,
              authUserId: null,
              method: null,
              tokenIssuer: 'refresh',
            );

            expect(refreshTokens, hasLength(1));
            expect(refreshTokens.first.tokenIssuer, equals('refresh'));
          },
        );

        test('then all tokens should be returned when kind is null', () async {
          final allTokens = await multiTokenManager.listTokens(
            session,
            authUserId: null,
            method: null,
            tokenIssuer: null,
          );

          expect(allTokens, hasLength(3));
          expect(
            allTokens.map((final t) => t.tokenIssuer).toSet(),
            containsAll(['jwt', 'session', 'refresh']),
          );
        });
      });

      /// What are we testing here?
      /// That the filter in the fake is correctly implemented?
      group('when revoking a token with token issuer filter', () {
        setUp(() async {
          await multiTokenManager.revokeToken(
            session,
            tokenId: firstManagerTokenId,
            tokenIssuer: 'jwt',
          );
        });

        test(
          'then only the specified manager should process the revocation',
          () async {
            expect(storage1.tokenCount, equals(0));
            expect(storage2.tokenCount, equals(1));
            expect(storage3.tokenCount, equals(1));
          },
        );
      });

      group('when revoking all tokens with token issuer filter', () {
        test(
          'then only the specified manager should process the revocation',
          () async {
            await multiTokenManager.revokeAllTokens(
              session,
              authUserId: userId,
              method: null,
              tokenIssuer: 'jwt',
            );

            expect(storage1.tokenCount, equals(0));
            expect(storage2.tokenCount, equals(1));
            expect(storage3.tokenCount, equals(1));
          },
        );

        test('then multiple managers can be targeted separately', () async {
          await multiTokenManager.revokeAllTokens(
            session,
            authUserId: userId,
            method: null,
            transaction: null,
            tokenIssuer: 'session',
          );

          expect(storage1.tokenCount, equals(1));
          expect(storage2.tokenCount, equals(0));
          expect(storage3.tokenCount, equals(1));

          await multiTokenManager.revokeAllTokens(
            session,
            authUserId: userId,
            method: null,
            transaction: null,
            tokenIssuer: 'refresh',
          );

          expect(storage1.tokenCount, equals(1));
          expect(storage2.tokenCount, equals(0));
          expect(storage3.tokenCount, equals(0));
        });
      });
    },
  );
}

class MockedTokenManager implements TokenManager {
  final List<TokenInfo> Function(
    Session session, {
    required UuidValue? authUserId,
    String? method,
    String? tokenIssuer,
    Transaction? transaction,
  })?
  onListTokens;

  final Future<void> Function(
    Session session, {
    required String tokenId,
    Transaction? transaction,
    String? tokenIssuer,
  })?
  onRevokeToken;

  final Future<void> Function(
    Session session, {
    required UuidValue? authUserId,
    Transaction? transaction,
    String? method,
    String? tokenIssuer,
  })?
  onRevokeAllTokens;

  final Future<AuthenticationInfo?> Function(Session session, String token)?
  onValidateToken;

  final Future<AuthSuccess> Function(
    Session session, {
    required UuidValue authUserId,
    required String method,
    Set<Scope>? scopes,
    Transaction? transaction,
  })?
  onIssueToken;

  MockedTokenManager({
    this.onListTokens,
    this.onRevokeToken,
    this.onRevokeAllTokens,
    this.onValidateToken,
    this.onIssueToken,
  });

  @override
  Future<List<TokenInfo>> listTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final String? method,
    final String? tokenIssuer,
    final Transaction? transaction,
  }) async {
    return onListTokens!(
      session,
      authUserId: authUserId,
      method: method,
      tokenIssuer: tokenIssuer,
      transaction: transaction,
    );
  }

  @override
  Future<void> revokeAllTokens(
    final Session session, {
    required final UuidValue? authUserId,
    final Transaction? transaction,
    final String? method,
    final String? tokenIssuer,
  }) async {
    return onRevokeAllTokens!(
      session,
      authUserId: authUserId,
      transaction: transaction,
      method: method,
      tokenIssuer: tokenIssuer,
    );
  }

  @override
  Future<void> revokeToken(
    final Session session, {
    required final String tokenId,
    final Transaction? transaction,
    final String? tokenIssuer,
  }) async {
    return onRevokeToken!(
      session,
      tokenId: tokenId,
      transaction: transaction,
      tokenIssuer: tokenIssuer,
    );
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    return onValidateToken!(session, token);
  }

  @override
  Future<AuthSuccess> issueToken(
    final Session session, {
    required final UuidValue authUserId,
    required final String method,
    final Set<Scope>? scopes,
    final Transaction? transaction,
  }) async {
    return onIssueToken!(
      session,
      authUserId: authUserId,
      method: method,
      scopes: scopes,
      transaction: transaction,
    );
  }
}
