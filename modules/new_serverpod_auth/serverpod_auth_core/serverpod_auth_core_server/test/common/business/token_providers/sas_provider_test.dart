import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

import '../../../serverpod_test_tools.dart';

void main() {
  group('SASTokenIssuer', () {
    withServerpod(
      'Given an existing AuthUser',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;
        late TokenIssuer tokenIssuer;

        setUp(() async {
          session = sessionBuilder.build();
          tokenIssuer = SasTokenIssuer();

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
            expect(authSuccess.authStrategy, equals(AuthStrategy.session));
          });

          test('then an AuthSession should be created in the database',
              () async {
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
            authSuccess = await tokenIssuer.issueToken(
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
      },
    );
  });

  group('SASTokenProvider', () {
    withServerpod(
      'Given multiple sessions for different users',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue user1Id;
        late UuidValue user2Id;
        late TokenProvider tokenProvider;

        setUp(() async {
          session = sessionBuilder.build();
          tokenProvider = SasTokenProvider();

          // Create two users
          final user1 = await AuthUsers.create(session);
          user1Id = user1.id;

          final user2 = await AuthUsers.create(session);
          user2Id = user2.id;

          // ignore: unused_result
          await AuthSessions.createSession(
            session,
            authUserId: user1Id,
            method: 'web',
            scopes: {const Scope('read')},
          );

          // ignore: unused_result
          await AuthSessions.createSession(
            session,
            authUserId: user1Id,
            method: 'mobile',
            scopes: {const Scope('write')},
          );

          // ignore: unused_result
          await AuthSessions.createSession(
            session,
            authUserId: user2Id,
            method: 'web',
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

          test('then all sessions should be returned', () {
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

        group('when listing tokens for user1', () {
          late List<TokenInfo> tokens;

          setUp(() async {
            tokens = await tokenProvider.listTokens(
              session: session,
              authUserId: user1Id,
              method: null,
              transaction: null,
            );
          });

          test('then only user1 sessions should be returned', () {
            expect(tokens, hasLength(2));
            expect(
              tokens.every((final t) => t.userId == user1Id.toString()),
              isTrue,
            );
          });

          test('then sessions should have correct methods', () {
            final methods = tokens.map((final t) => t.method).toSet();
            expect(methods, containsAll(['web', 'mobile']));
          });

          test('then sessions should have correct scopes', () {
            final webSession =
                tokens.firstWhere((final t) => t.method == 'web');
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
            tokens = await tokenProvider.listTokens(
              session: session,
              authUserId: null,
              method: 'web',
              transaction: null,
            );
          });

          test('then only web method sessions should be returned', () {
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
            tokens = await tokenProvider.listTokens(
              session: session,
              authUserId: user1Id,
              method: 'mobile',
              transaction: null,
            );
          });

          test('then only matching sessions should be returned', () {
            expect(tokens, hasLength(1));
            expect(tokens.first.userId, equals(user1Id.toString()));
            expect(tokens.first.method, equals('mobile'));
          });
        });

        group('when revoking a specific session', () {
          setUp(() async {
            final sessionToRevoke = await AuthSession.db
                .find(
                  session,
                  where: (final t) => t.authUserId.equals(user1Id),
                )
                .then((final sessions) => sessions.first);

            await tokenProvider.revokeToken(
              session: session,
              tokenId: sessionToRevoke.id.toString(),
              transaction: null,
            );
          });

          test('then the session should be removed from database', () async {
            final remainingSessions = await AuthSession.db.find(session);
            expect(remainingSessions, hasLength(2));
          });

          test('then other sessions should remain', () async {
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

        group('when revoking all sessions for a user', () {
          setUp(() async {
            await tokenProvider.revokeAllTokens(
              session: session,
              authUserId: user1Id,
              method: null,
              transaction: null,
            );
          });

          test('then all user sessions should be removed', () async {
            final user1Sessions = await AuthSession.db.find(
              session,
              where: (final t) => t.authUserId.equals(user1Id),
            );
            expect(user1Sessions, isEmpty);
          });

          test('then other user sessions should remain', () async {
            final user2Sessions = await AuthSession.db.find(
              session,
              where: (final t) => t.authUserId.equals(user2Id),
            );
            expect(user2Sessions, hasLength(1));
          });
        });

        group('when revoking all sessions with method filter', () {
          setUp(() async {
            await tokenProvider.revokeAllTokens(
              session: session,
              authUserId: null,
              method: 'web',
              transaction: null,
            );
          });

          test('then only web sessions should be removed', () async {
            final remainingSessions = await AuthSession.db.find(session);
            expect(remainingSessions, hasLength(1));
            expect(remainingSessions.first.method, equals('mobile'));
          });
        });

        group('when revoking all sessions without filters', () {
          setUp(() async {
            await tokenProvider.revokeAllTokens(
              session: session,
              authUserId: null,
              method: null,
              transaction: null,
            );
          });

          test('then all sessions should be removed', () async {
            final remainingSessions = await AuthSession.db.find(session);
            expect(remainingSessions, isEmpty);
          });
        });
      },
    );

    withServerpod(
      'Given an invalid session ID',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late TokenProvider tokenProvider;

        setUp(() async {
          session = sessionBuilder.build();
          tokenProvider = SasTokenProvider();
        });

        group('when revoking the invalid session', () {
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
