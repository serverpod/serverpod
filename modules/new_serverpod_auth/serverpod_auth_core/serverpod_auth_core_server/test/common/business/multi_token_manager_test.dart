import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/multi_token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
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

      setUp(() {
        session = sessionBuilder.build();
        userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');

        defaultStorage = FakeTokenStorage();
        additionalStorage1 = FakeTokenStorage();
        additionalStorage2 = FakeTokenStorage();

        defaultManager = FakeTokenManager(defaultStorage);
        additionalManager1 = FakeTokenManager(additionalStorage1);
        additionalManager2 = FakeTokenManager(additionalStorage2);

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: defaultManager,
          additionalTokenManagers: {
            'manager1': additionalManager1,
            'manager2': additionalManager2,
          },
        );
      });

      group('when issuing a token', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await multiTokenManager.issueToken(
            session: session,
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
            session: session,
            authUserId: userId,
            method: 'test-method',
            scopes: {const Scope('test-scope')},
            transaction: null,
          );

          secondToken = await multiTokenManager.issueToken(
            session: session,
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

      setUp(() {
        session = sessionBuilder.build();
        user1Id = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        user2Id = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440001');

        defaultStorage = FakeTokenStorage();
        additionalStorage1 = FakeTokenStorage();
        additionalStorage2 = FakeTokenStorage();

        defaultManager = FakeTokenManager(defaultStorage);
        additionalManager1 = FakeTokenManager(additionalStorage1);
        additionalManager2 = FakeTokenManager(additionalStorage2);

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: defaultManager,
          additionalTokenManagers: {
            'manager1': additionalManager1,
            'manager2': additionalManager2,
          },
        );

        defaultManager.addToken(TokenInfo(
          userId: user1Id.toString(),
          tokenProvider: 'default',
          tokenId: 'default-token-1',
          scopes: {const Scope('read')},
          method: 'email',
        ));

        additionalManager1.addToken(TokenInfo(
          userId: user1Id.toString(),
          tokenProvider: 'additional1',
          tokenId: 'additional1-token-1',
          scopes: {const Scope('write')},
          method: 'oauth',
        ));

        additionalManager2.addToken(TokenInfo(
          userId: user2Id.toString(),
          tokenProvider: 'additional2',
          tokenId: 'additional2-token-1',
          scopes: {const Scope('admin')},
          method: 'email',
        ));

        additionalManager2.addToken(TokenInfo(
          userId: user1Id.toString(),
          tokenProvider: 'additional2',
          tokenId: 'additional2-token-2',
          scopes: {const Scope('write')},
          method: 'email',
        ));
      });

      group('when listing all tokens', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
        });

        test('then all tokens from all managers should be returned', () {
          expect(tokens, hasLength(4));
        });

        test('then tokens should have correct providers', () {
          final providers = tokens.map((final t) => t.tokenProvider).toSet();
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
            session: session,
            authUserId: user1Id,
            method: null,
            transaction: null,
          );

          user2Tokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: user2Id,
            method: null,
            transaction: null,
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
          final providers =
              user1Tokens.map((final t) => t.tokenProvider).toSet();
          expect(providers,
              containsAllInOrder(['default', 'additional1', 'additional2']));
        });
      });

      group('when listing tokens by method', () {
        late List<TokenInfo> emailTokens;

        setUp(() async {
          emailTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: 'email',
            transaction: null,
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
          final providers =
              emailTokens.map((final t) => t.tokenProvider).toSet();
          expect(providers, containsAllInOrder(['default', 'additional2']));
        });
      });

      group('when listing tokens with combined filters', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: user1Id,
            method: 'email',
            transaction: null,
          );
        });

        test('then only matching tokens should be returned', () {
          expect(tokens, hasLength(2));
          expect(tokens.every((final t) => t.userId == user1Id.toString()),
              isTrue);
          expect(tokens.every((final t) => t.method == 'email'), isTrue);
        });
      });

      group('when revoking a specific token', () {
        setUp(() async {
          await multiTokenManager.revokeToken(
            session: session,
            tokenId: 'additional1-token-1',
            transaction: null,
          );
        });

        test('then the token should be removed from all managers', () {
          expect(defaultStorage.getToken('additional1-token-1'), isNull);
          expect(additionalStorage1.getToken('additional1-token-1'), isNull);
          expect(additionalStorage2.getToken('additional1-token-1'), isNull);
        });

        test('then other tokens should remain', () async {
          final remainingTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
          expect(remainingTokens, hasLength(3));
          expect(
            remainingTokens.any((final t) => t.tokenId == 'default-token-1'),
            isTrue,
          );
          expect(
            remainingTokens
                .any((final t) => t.tokenId == 'additional2-token-1'),
            isTrue,
          );
        });
      });

      test('when revoking a non-existent token then no error should be thrown',
          () async {
        expect(
          () => multiTokenManager.revokeToken(
            session: session,
            tokenId: 'non-existent',
            transaction: null,
          ),
          returnsNormally,
        );
      });

      group('when revoking all tokens for a user', () {
        setUp(() async {
          await multiTokenManager.revokeAllTokens(
            session: session,
            authUserId: user1Id,
            method: null,
            transaction: null,
          );
        });

        test('then all user tokens should be revoked across all managers',
            () async {
          final remainingTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );

          expect(remainingTokens, hasLength(1));
          expect(remainingTokens.first.userId, equals(user2Id.toString()));
        });

        test('then tokens should be removed from all managers', () {
          expect(defaultStorage.tokenCount, equals(0));
          expect(additionalStorage1.tokenCount, equals(0));
          expect(additionalStorage2.tokenCount, equals(1));
        });
      });

      group('when revoking all tokens by method', () {
        setUp(() async {
          await multiTokenManager.revokeAllTokens(
            session: session,
            authUserId: null,
            method: 'email',
            transaction: null,
          );
        });

        test('then only tokens with specified method should be revoked',
            () async {
          final remainingTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );

          expect(remainingTokens, hasLength(1));
          expect(remainingTokens.first.method, equals('oauth'));
          expect(remainingTokens.first.tokenProvider, equals('additional1'));
        });
      });

      group('when revoking all tokens with combined filters', () {
        setUp(() async {
          await multiTokenManager.revokeAllTokens(
            session: session,
            authUserId: user1Id,
            method: 'email',
            transaction: null,
          );
        });

        test('then only matching tokens should be revoked', () async {
          final remainingTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );

          expect(remainingTokens, hasLength(2));
          expect(
            remainingTokens
                .any((final t) => t.tokenId == 'additional1-token-1'),
            isTrue,
          );
          expect(
            remainingTokens
                .any((final t) => t.tokenId == 'additional2-token-1'),
            isTrue,
          );
        });
      });

      group('when revoking all tokens without filters', () {
        setUp(() async {
          await multiTokenManager.revokeAllTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
        });

        test('then all tokens should be removed', () async {
          final remainingTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
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
            'default-token-1',
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
          'additional1-token-1',
        );

        expect(authInfo, isNotNull);
        expect(authInfo!.userIdentifier, equals(user1Id.toString()));
        expect(
          authInfo.scopes.map((final s) => s.name),
          contains('write'),
        );
      });

      test(
          'when validating a token from additional manager 2 then authentication info should be returned',
          () async {
        final authInfo = await multiTokenManager.validateToken(
          session,
          'additional2-token-1',
        );

        expect(authInfo, isNotNull);
        expect(authInfo!.userIdentifier, equals(user2Id.toString()));
        expect(
          authInfo.scopes.map((final s) => s.name),
          contains('admin'),
        );
      });

      test('when validating an invalid token then null should be returned',
          () async {
        final authInfo = await multiTokenManager.validateToken(
          session,
          'invalid-token',
        );

        expect(authInfo, isNull);
      });

      test('when validating an empty token then null should be returned',
          () async {
        final authInfo = await multiTokenManager.validateToken(session, '');

        expect(authInfo, isNull);
      });

      group('when a token exists in multiple managers', () {
        setUp(() {
          additionalManager1.addToken(TokenInfo(
            userId: user2Id.toString(),
            tokenProvider: 'additional1',
            tokenId: 'duplicate-token',
            scopes: {const Scope('first-scope')},
            method: 'method1',
          ));

          additionalManager2.addToken(TokenInfo(
            userId: user1Id.toString(),
            tokenProvider: 'additional2',
            tokenId: 'duplicate-token',
            scopes: {const Scope('second-scope')},
            method: 'method2',
          ));
        });

        test(
            'then the first manager with the token should return authentication info',
            () async {
          final authInfo = await multiTokenManager.validateToken(
            session,
            'duplicate-token',
          );

          expect(authInfo, isNotNull);
          expect(authInfo!.userIdentifier, equals(user2Id.toString()));
          expect(
            authInfo.scopes.map((final s) => s.name),
            contains('first-scope'),
          );
        });
      });
    },
  );

  withServerpod(
    'Given no tokens exist',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late MultiTokenManager multiTokenManager;

      setUp(() {
        session = sessionBuilder.build();

        final defaultStorage = FakeTokenStorage();
        final additionalStorage = FakeTokenStorage();

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: FakeTokenManager(defaultStorage),
          additionalTokenManagers: {
            'additional': FakeTokenManager(additionalStorage),
          },
        );
      });

      test('when listing tokens then an empty list should be returned',
          () async {
        final tokens = await multiTokenManager.listTokens(
          session: session,
          authUserId: null,
          method: null,
          transaction: null,
        );

        expect(tokens, isEmpty);
      });
    },
  );

  withServerpod(
    'Given a MultiTokenManager with only a default manager',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late FakeTokenStorage storage;
      late MultiTokenManager multiTokenManager;

      setUp(() {
        session = sessionBuilder.build();
        storage = FakeTokenStorage();

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: FakeTokenManager(storage),
          additionalTokenManagers: {},
        );
      });

      group('when issuing a token', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await multiTokenManager.issueToken(
            session: session,
            authUserId:
                UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
            method: 'test',
            scopes: {const Scope('test')},
            transaction: null,
          );
        });

        test('then the token should be returned', () {
          expect(authSuccess.token, isNotEmpty);
        });

        test('then the token should be stored in the default manager', () {
          expect(storage.tokenCount, equals(1));
        });
      });

      test(
          'when listing tokens then all tokens from the default manager should be returned',
          () async {
        storage.storeToken(TokenInfo(
          userId: '550e8400-e29b-41d4-a716-446655440000',
          tokenProvider: 'default',
          tokenId: 'token-1',
          scopes: {const Scope('test')},
          method: 'test',
        ));

        final tokens = await multiTokenManager.listTokens(
          session: session,
          authUserId: null,
          method: null,
          transaction: null,
        );

        expect(tokens, hasLength(1));
      });
    },
  );

  withServerpod(
    'Given a MultiTokenManager with many additional managers',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late MultiTokenManager multiTokenManager;
      late List<FakeTokenStorage> storages;

      setUp(() {
        session = sessionBuilder.build();
        storages = List.generate(5, (final _) => FakeTokenStorage());

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: FakeTokenManager(storages[0]),
          additionalTokenManagers: {
            'manager1': FakeTokenManager(storages[1]),
            'manager2': FakeTokenManager(storages[2]),
            'manager3': FakeTokenManager(storages[3]),
            'manager4': FakeTokenManager(storages[4]),
          },
        );

        // Add one token to each manager
        for (var i = 0; i < 5; i++) {
          storages[i].storeToken(TokenInfo(
            userId: '550e8400-e29b-41d4-a716-446655440000',
            tokenProvider: 'manager-$i',
            tokenId: 'token-$i',
            scopes: {Scope('scope-$i')},
            method: 'method-$i',
          ));
        }
      });

      test('then listTokens should return tokens from all managers', () async {
        final tokens = await multiTokenManager.listTokens(
          session: session,
          authUserId: null,
          method: null,
          transaction: null,
        );

        expect(tokens, hasLength(5));
        expect(
          tokens.map((final t) => t.tokenProvider).toSet(),
          containsAll([
            'manager-0',
            'manager-1',
            'manager-2',
            'manager-3',
            'manager-4'
          ]),
        );
      });

      test('then revokeAllTokens should remove from all managers', () async {
        await multiTokenManager.revokeAllTokens(
          session: session,
          authUserId: null,
          method: null,
          transaction: null,
        );

        for (final storage in storages) {
          expect(storage.tokenCount, equals(0));
        }
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

      setUp(() {
        session = sessionBuilder.build();
        userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');

        defaultStorage = FakeTokenStorage();
        storage1 = FakeTokenStorage();
        storage2 = FakeTokenStorage();
        storage3 = FakeTokenStorage();

        defaultManager = FakeTokenManager(defaultStorage, kind: 'default');
        manager1 = FakeTokenManager(storage1, kind: 'jwt');
        manager2 = FakeTokenManager(storage2, kind: 'session');
        manager3 = FakeTokenManager(storage3, kind: 'refresh');

        multiTokenManager = MultiTokenManager(
          primaryTokenManager: defaultManager,
          additionalTokenManagers: {
            'jwt': manager1,
            'session': manager2,
            'refresh': manager3,
          },
        );

        // Add tokens to each manager
        manager1.addToken(TokenInfo(
          userId: userId.toString(),
          tokenProvider: 'jwt',
          tokenId: 'jwt-token-1',
          scopes: {const Scope('read')},
          method: 'email',
        ));

        manager2.addToken(TokenInfo(
          userId: userId.toString(),
          tokenProvider: 'session',
          tokenId: 'session-token-1',
          scopes: {const Scope('write')},
          method: 'oauth',
        ));

        manager3.addToken(TokenInfo(
          userId: userId.toString(),
          tokenProvider: 'refresh',
          tokenId: 'refresh-token-1',
          scopes: {const Scope('refresh')},
          method: 'email',
        ));
      });

      group('when listing tokens with kind filter', () {
        test('then only tokens from the specified manager should be returned',
            () async {
          final jwtTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
            kind: 'jwt',
          );

          expect(jwtTokens, hasLength(1));
          expect(jwtTokens.first.tokenProvider, equals('jwt'));
          expect(jwtTokens.first.tokenId, equals('jwt-token-1'));
        });

        test('then session tokens should be returned when kind is session',
            () async {
          final sessionTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
            kind: 'session',
          );

          expect(sessionTokens, hasLength(1));
          expect(sessionTokens.first.tokenProvider, equals('session'));
          expect(sessionTokens.first.tokenId, equals('session-token-1'));
        });

        test('then refresh tokens should be returned when kind is refresh',
            () async {
          final refreshTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
            kind: 'refresh',
          );

          expect(refreshTokens, hasLength(1));
          expect(refreshTokens.first.tokenProvider, equals('refresh'));
          expect(refreshTokens.first.tokenId, equals('refresh-token-1'));
        });

        test('then all tokens should be returned when kind is null', () async {
          final allTokens = await multiTokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
            kind: null,
          );

          expect(allTokens, hasLength(3));
          expect(
            allTokens.map((final t) => t.tokenProvider).toSet(),
            containsAll(['jwt', 'session', 'refresh']),
          );
        });
      });

      group('when revoking a token with kind filter', () {
        test('then only the specified manager should process the revocation',
            () async {
          await multiTokenManager.revokeToken(
            session: session,
            tokenId: 'jwt-token-1',
            transaction: null,
            kind: 'jwt',
          );

          expect(storage1.tokenCount, equals(0));
          expect(storage2.tokenCount, equals(1));
          expect(storage3.tokenCount, equals(1));
        });

        test('then other managers should not be affected', () async {
          await multiTokenManager.revokeToken(
            session: session,
            tokenId: 'session-token-1',
            transaction: null,
            kind: 'session',
          );

          expect(storage1.tokenCount, equals(1));
          expect(storage2.tokenCount, equals(0));
          expect(storage3.tokenCount, equals(1));
        });
      });

      group('when revoking all tokens with kind filter', () {
        test('then only the specified manager should process the revocation',
            () async {
          await multiTokenManager.revokeAllTokens(
            session: session,
            authUserId: userId,
            method: null,
            transaction: null,
            kind: 'jwt',
          );

          expect(storage1.tokenCount, equals(0));
          expect(storage2.tokenCount, equals(1));
          expect(storage3.tokenCount, equals(1));
        });

        test('then multiple managers can be targeted separately', () async {
          await multiTokenManager.revokeAllTokens(
            session: session,
            authUserId: userId,
            method: null,
            transaction: null,
            kind: 'session',
          );

          expect(storage1.tokenCount, equals(1));
          expect(storage2.tokenCount, equals(0));
          expect(storage3.tokenCount, equals(1));

          await multiTokenManager.revokeAllTokens(
            session: session,
            authUserId: userId,
            method: null,
            transaction: null,
            kind: 'refresh',
          );

          expect(storage1.tokenCount, equals(1));
          expect(storage2.tokenCount, equals(0));
          expect(storage3.tokenCount, equals(0));
        });
      });

      group('when validating a token with kind filter', () {
        test('then only the specified manager should be used', () async {
          final authInfo = await multiTokenManager.validateToken(
            session,
            'jwt-token-1',
            kind: 'jwt',
          );

          expect(authInfo, isNotNull);
          expect(authInfo!.userIdentifier, equals(userId.toString()));
        });

        test('then wrong kind should return null even if token exists',
            () async {
          final authInfo = await multiTokenManager.validateToken(
            session,
            'jwt-token-1',
            kind: 'session',
          );

          expect(authInfo, isNull);
        });

        test('then null kind should check all managers', () async {
          final jwtAuth = await multiTokenManager.validateToken(
            session,
            'jwt-token-1',
            kind: null,
          );

          expect(jwtAuth, isNotNull);

          final sessionAuth = await multiTokenManager.validateToken(
            session,
            'session-token-1',
            kind: null,
          );

          expect(sessionAuth, isNotNull);

          final refreshAuth = await multiTokenManager.validateToken(
            session,
            'refresh-token-1',
            kind: null,
          );

          expect(refreshAuth, isNotNull);
        });
      });
    },
  );
}
