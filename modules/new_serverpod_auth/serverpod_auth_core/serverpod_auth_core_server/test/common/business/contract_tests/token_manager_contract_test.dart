import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../../serverpod_test_tools.dart';
import '../fakes/fakes.dart';

void testSuite({required final TokenManager Function() tokenManagerBuilder}) {
  withServerpod(
    'Given a TokenManager with valid user ID',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue userId;

      setUp(() {
        session = sessionBuilder.build();
        tokenManager = tokenManagerBuilder();
        userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
      });

      group('when issuing a token', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await tokenManager.issueToken(
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

        test('then the authStrategy should be set', () {
          expect(authSuccess.authStrategy, equals('jwt'));
        });
      });

      group('when issuing a token with multiple scopes', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await tokenManager.issueToken(
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
        });

        test('then all scopes should be included', () {
          expect(authSuccess.scopeNames, hasLength(3));
          expect(authSuccess.scopeNames, contains('scope1'));
          expect(authSuccess.scopeNames, contains('scope2'));
          expect(authSuccess.scopeNames, contains('scope3'));
        });
      });

      group('when issuing a token without scopes', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await tokenManager.issueToken(
            session: session,
            authUserId: userId,
            method: 'test-method',
            scopes: null,
            transaction: null,
          );
        });

        test('then scopeNames should be empty', () {
          expect(authSuccess.scopeNames, isEmpty);
        });
      });

      group('when issuing a token with empty scopes', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await tokenManager.issueToken(
            session: session,
            authUserId: userId,
            method: 'test-method',
            scopes: {},
            transaction: null,
          );
        });

        test('then scopeNames should be empty', () {
          expect(authSuccess.scopeNames, isEmpty);
        });
      });
    },
  );

  withServerpod(
    'Given multiple tokens issued for the same user',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue userId;
      late AuthSuccess firstToken;
      late AuthSuccess secondToken;
      late AuthSuccess thirdToken;

      setUp(() async {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
        userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');

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

      test('then each token should be unique', () {
        expect(firstToken.token, isNot(equals(secondToken.token)));
        expect(firstToken.token, isNot(equals(thirdToken.token)));
        expect(secondToken.token, isNot(equals(thirdToken.token)));
      });

      test('then each refresh token should be unique', () {
        expect(
            firstToken.refreshToken, isNot(equals(secondToken.refreshToken)));
        expect(firstToken.refreshToken, isNot(equals(thirdToken.refreshToken)));
        expect(
            secondToken.refreshToken, isNot(equals(thirdToken.refreshToken)));
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
    },
  );

  withServerpod(
    'Given a TokenManager with a transaction parameter',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue userId;

      setUp(() {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
        userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
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

      // Note: A group of tests for transaction rollbacks
      // are intentionally skipped. Since a `TokenManager`
      // could be completely in-memory or use some other storage mechanism,
      // where it can't use our database transactions, then there is no way to
      // test transaction rollbacks on those classes. Since we do not
      // want to force the use of our transactions for those reasons,
      // we skip the rollback tests here.
    },
  );

  withServerpod(
    'Given a TokenManager with multiple tokens existing',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;
      late UuidValue user1Id;
      late UuidValue user2Id;

      setUp(() async {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
        user1Id = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        user2Id = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440001');

        await tokenManager.issueToken(
          session: session,
          authUserId: user1Id,
          method: 'email',
          scopes: {const Scope('read')},
          transaction: null,
        );

        await tokenManager.issueToken(
          session: session,
          authUserId: user1Id,
          method: 'oauth',
          scopes: {const Scope('write')},
          transaction: null,
        );

        await tokenManager.issueToken(
          session: session,
          authUserId: user2Id,
          method: 'email',
          scopes: {const Scope('admin')},
          transaction: null,
        );
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
        });
      });

      group('when revoking a specific token', () {
        late String revokedTokenId;

        setUp(() async {
          final allTokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: null,
            transaction: null,
          );
          revokedTokenId = allTokens.first.tokenId;

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
          expect(remainingTokens, hasLength(2));
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
          expect(
            remainingTokens
                .every((final token) => token.tokenId != revokedTokenId),
            isTrue,
          );
        });
      });

      group('when revoking all tokens for a user', () {
        setUp(() async {
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
          final user2Tokens = await tokenManager.listTokens(
            session: session,
            authUserId: user2Id,
            method: null,
            transaction: null,
          );
          expect(user2Tokens, hasLength(1));
        });
      });

      group('when revoking all tokens with method filter', () {
        setUp(() async {
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

      setUp(() async {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
        userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');

        final authSuccess = await tokenManager.issueToken(
          session: session,
          authUserId: userId,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
          transaction: null,
        );
        validToken = authSuccess.token;
      });

      group('when validating the token', () {
        late AuthenticationInfo? authInfo;

        setUp(() async {
          authInfo = await tokenManager.validateToken(session, validToken);
        });

        test('then the authentication info should be returned', () {
          expect(authInfo, isNotNull);
        });

        test('then the user identifier should match', () {
          expect(authInfo!.userIdentifier, equals(userId.uuid));
        });

        test('then the scopes should match', () {
          expect(
            authInfo!.scopes.map((final s) => s.name),
            contains('test-scope'),
          );
        });
      });
    },
  );

  withServerpod(
    'Given a TokenManager with an invalid token',
    (final sessionBuilder, final endpoints) {
      late TokenManager tokenManager;
      late Session session;

      setUp(() async {
        tokenManager = tokenManagerBuilder();
        session = sessionBuilder.build();
      });

      group('when validating an invalid token', () {
        test('then null should be returned for malformed token', () async {
          final authInfo = await tokenManager.validateToken(
            session,
            'invalid-token',
          );
          expect(authInfo, isNull);
        });

        test('then null should be returned for empty token', () async {
          final authInfo = await tokenManager.validateToken(session, '');
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
        userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');

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
  testSuite(
    tokenManagerBuilder: () {
      final storage = FakeTokenStorage();
      return FakeTokenManager(storage);
    },
  );
}
