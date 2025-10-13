import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

import '../serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given an existing AuthUser',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late SasTokenManager tokenManager;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = SasTokenManager();

        final authUser = await AuthUsers.create(session);
        authUserId = authUser.id;
      });

      group('when issuing a token', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await tokenManager.issueToken(
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

        test('then no refresh token should be returned', () {
          expect(authSuccess.refreshToken, isNull);
        });

        test('then the authUserId should match', () {
          expect(authSuccess.authUserId, equals(authUserId));
        });

        test('then the scopeNames should match', () {
          expect(authSuccess.scopeNames, contains('test-scope'));
        });

        test('then the authStrategy should be session', () {
          expect(authSuccess.authStrategy, equals(AuthStrategy.session.name));
        });

        test('then an AuthSession should be created in the database', () async {
          final authSessions = await AuthSession.db.find(
            session,
            where: (final t) => t.authUserId.equals(authUserId),
          );
          expect(authSessions, hasLength(1));
          expect(authSessions.first.method, equals('test-method'));
        });
      });

      group('when issuing a token without scopes', () {
        late AuthSuccess authSuccess;

        setUp(() async {
          authSuccess = await tokenManager.issueToken(
            session: session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: null,
            transaction: null,
          );
        });

        test("then the user's scopes should be used", () async {
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

          authSuccess = await tokenManager.issueToken(
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

          authSuccess = await tokenManager.issueToken(
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
          firstAuth = await tokenManager.issueToken(
            session: session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: {const Scope('first-auth')},
            transaction: null,
          );

          secondAuth = await tokenManager.issueToken(
            session: session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: {const Scope('second-auth')},
            transaction: null,
          );
        });

        test('then a new session is returned', () {
          expect(secondAuth.token, isNotEmpty);
          expect(secondAuth.token, isNot(equals(firstAuth.token)));
        });

        test('then both sessions exist in the database', () async {
          final authSessions = await AuthSession.db.find(
            session,
            where: (final t) => t.authUserId.equals(authUserId),
          );
          expect(authSessions, hasLength(2));
        });
      });
    },
  );

  withServerpod(
    'Given a blocked AuthUser',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late SasTokenManager tokenManager;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = SasTokenManager();

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
            () => tokenManager.issueToken(
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
      late SasTokenManager tokenManager;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = SasTokenManager();

        final authUser = await AuthUsers.create(session);
        authUserId = authUser.id;
      });

      group('when issuing new tokens', () {
        test('then sessions are not created in the database', () async {
          try {
            await session.db.transaction((final transaction) async {
              await tokenManager.issueToken(
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

          final authSessions = await AuthSession.db.find(
            session,
            where: (final t) => t.authUserId.equals(authUserId),
          );
          expect(authSessions, isEmpty);
        });
      });
    },
  );

  withServerpod(
    'Given multiple auth sessions for different users',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue user1Id;
      late UuidValue user2Id;
      late SasTokenManager tokenManager;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = SasTokenManager();

        final user1 = await AuthUsers.create(session);
        user1Id = user1.id;

        final user2 = await AuthUsers.create(session);
        user2Id = user2.id;

        await tokenManager.issueToken(
          session: session,
          authUserId: user1Id,
          method: 'web',
          scopes: {const Scope('read')},
          transaction: null,
        );

        await tokenManager.issueToken(
          session: session,
          authUserId: user1Id,
          method: 'mobile',
          scopes: {const Scope('write')},
          transaction: null,
        );

        await tokenManager.issueToken(
          session: session,
          authUserId: user2Id,
          method: 'web',
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

        test('then tokens should have correct provider name', () {
          expect(
            tokens.every(
              (final t) => t.tokenProvider == AuthStrategy.session.name,
            ),
            isTrue,
          );
        });
      });

      group('when listing tokens for a specific user', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await tokenManager.listTokens(
            session: session,
            authUserId: user1Id,
            method: null,
            transaction: null,
          );
        });

        test(
          'then only tokens for the specified user should be returned',
          () {
            expect(tokens, hasLength(2));
            expect(
              tokens.every((final t) => t.userId == user1Id.toString()),
              isTrue,
            );
          },
        );

        test('then tokens should have correct methods', () {
          final methods = tokens.map((final t) => t.method).toSet();
          expect(methods, containsAll(['web', 'mobile']));
        });

        test('then tokens should have correct scopes', () {
          final webSession = tokens.firstWhere((final t) => t.method == 'web');
          expect(
            webSession.scopes.map((final s) => s.name),
            contains('read'),
          );

          final mobileSession =
              tokens.firstWhere((final t) => t.method == 'mobile');
          expect(
            mobileSession.scopes.map((final s) => s.name),
            contains('write'),
          );
        });
      });

      group('when listing tokens with method filter', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await tokenManager.listTokens(
            session: session,
            authUserId: null,
            method: 'web',
            transaction: null,
          );
        });

        test('then only tokens with specified method should be returned', () {
          expect(tokens, hasLength(2));
          expect(
            tokens.every((final t) => t.method == 'web'),
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
            method: 'mobile',
            transaction: null,
          );
        });

        test('then only matching tokens should be returned', () {
          expect(tokens, hasLength(1));
          expect(tokens.first.userId, equals(user1Id.toString()));
          expect(tokens.first.method, equals('mobile'));
        });
      });

      group('when revoking a specific token', () {
        setUp(() async {
          final sessionToRevoke = await AuthSession.db
              .find(
                session,
                where: (final t) => t.authUserId.equals(user1Id),
              )
              .then((final sessions) => sessions.first);

          await tokenManager.revokeToken(
            session: session,
            tokenId: sessionToRevoke.id.toString(),
            transaction: null,
          );
        });

        test('then the token should be removed from database', () async {
          final remainingSessions = await AuthSession.db.find(session);
          expect(remainingSessions, hasLength(2));
        });

        test('then other tokens should remain', () async {
          final user1Sessions = await AuthSession.db.find(
            session,
            where: (final t) => t.authUserId.equals(user1Id),
          );
          expect(user1Sessions, hasLength(1));

          final user2Sessions = await AuthSession.db.find(
            session,
            where: (final t) => t.authUserId.equals(user2Id),
          );
          expect(user2Sessions, hasLength(1));
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
          final user1Sessions = await AuthSession.db.find(
            session,
            where: (final t) => t.authUserId.equals(user1Id),
          );
          expect(user1Sessions, isEmpty);
        });

        test('then other user tokens should remain', () async {
          final user2Sessions = await AuthSession.db.find(
            session,
            where: (final t) => t.authUserId.equals(user2Id),
          );
          expect(user2Sessions, hasLength(1));
        });
      });

      group('when revoking all tokens with method filter', () {
        setUp(() async {
          await tokenManager.revokeAllTokens(
            session: session,
            authUserId: null,
            method: 'web',
            transaction: null,
          );
        });

        test('then only tokens with specified method should be removed',
            () async {
          final remainingSessions = await AuthSession.db.find(session);
          expect(remainingSessions, hasLength(1));
          expect(remainingSessions.first.method, equals('mobile'));
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
          final remainingSessions = await AuthSession.db.find(session);
          expect(remainingSessions, isEmpty);
        });
      });
    },
  );

  withServerpod(
    'Given an invalid token ID',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late SasTokenManager tokenManager;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = SasTokenManager();
      });

      group('when revoking the invalid token', () {
        test('then it should throw an exception', () async {
          expect(
            () => tokenManager.revokeToken(
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

  withServerpod(
    'Given a valid session token',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late SasTokenManager tokenManager;
      late String validToken;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = SasTokenManager();

        final authUser = await AuthUsers.create(session);
        authUserId = authUser.id;

        final authSuccess = await tokenManager.issueToken(
          session: session,
          authUserId: authUserId,
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
          expect(authInfo!.userIdentifier, equals(authUserId.uuid));
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
    'Given an invalid session token',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late SasTokenManager tokenManager;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = SasTokenManager();
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
    'Given a revoked session',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;
      late SasTokenManager tokenManager;
      late String sessionToken;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = SasTokenManager();

        final authUser = await AuthUsers.create(session);
        authUserId = authUser.id;

        final authSuccess = await tokenManager.issueToken(
          session: session,
          authUserId: authUserId,
          method: 'test-method',
          scopes: {const Scope('test-scope')},
          transaction: null,
        );
        sessionToken = authSuccess.token;
      });

      group('when validating token after revoking session', () {
        late AuthenticationInfo? authInfo;

        setUp(() async {
          final authSessionRecord = await AuthSession.db.findFirstRow(
            session,
            where: (final t) => t.authUserId.equals(authUserId),
          );

          await tokenManager.revokeToken(
            session: session,
            tokenId: authSessionRecord!.id.toString(),
            transaction: null,
          );

          authInfo = await tokenManager.validateToken(session, sessionToken);
        });

        test('then null should be returned', () {
          expect(authInfo, isNull);
        });
      });
    },
  );

  withServerpod(
    'Given multiple valid sessions',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue user1Id;
      late UuidValue user2Id;
      late SasTokenManager tokenManager;
      late String user1Token;
      late String user2Token;

      setUp(() async {
        session = sessionBuilder.build();
        tokenManager = SasTokenManager();

        final user1 = await AuthUsers.create(session);
        user1Id = user1.id;

        final user2 = await AuthUsers.create(session);
        user2Id = user2.id;

        final auth1 = await tokenManager.issueToken(
          session: session,
          authUserId: user1Id,
          method: 'test-method',
          scopes: {const Scope('scope-1')},
          transaction: null,
        );
        user1Token = auth1.token;

        final auth2 = await tokenManager.issueToken(
          session: session,
          authUserId: user2Id,
          method: 'test-method',
          scopes: {const Scope('scope-2')},
          transaction: null,
        );
        user2Token = auth2.token;
      });

      group('when validating tokens for different users', () {
        test('then each token should return correct user info', () async {
          final authInfo1 =
              await tokenManager.validateToken(session, user1Token);
          final authInfo2 =
              await tokenManager.validateToken(session, user2Token);

          expect(authInfo1, isNotNull);
          expect(authInfo2, isNotNull);
          expect(authInfo1!.userIdentifier, equals(user1Id.uuid));
          expect(authInfo2!.userIdentifier, equals(user2Id.uuid));
        });

        test('then each token should return correct scopes', () async {
          final authInfo1 =
              await tokenManager.validateToken(session, user1Token);
          final authInfo2 =
              await tokenManager.validateToken(session, user2Token);

          expect(
            authInfo1!.scopes.map((final s) => s.name),
            contains('scope-1'),
          );
          expect(
            authInfo2!.scopes.map((final s) => s.name),
            contains('scope-2'),
          );
        });
      });
    },
  );
}
