import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:test/test.dart';

import '../../jwt/utils/authentication_token_secrets_mock.dart';
import '../../serverpod_test_tools.dart';

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

  group('TokenManager', () {
    withServerpod(
      'Given a TokenManager with JWT and SAS providers',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late TokenManager tokenManager;
        late UuidValue user1Id;
        late UuidValue user2Id;

        setUp(() async {
          session = sessionBuilder.build();

          tokenManager = TokenManager({
            'jwt': JwtTokenProvider(),
            'session': SasTokenProvider(),
          });

          final user1 = await AuthUsers.create(session);
          user1Id = user1.id;

          final user2 = await AuthUsers.create(session);
          user2Id = user2.id;

          await AuthenticationTokens.createTokens(
            session,
            authUserId: user1Id,
            method: 'email',
            scopes: {const Scope('read')},
          );

          // ignore: unused_result
          await AuthSessions.createSession(
            session,
            authUserId: user2Id,
            method: 'web',
            scopes: {const Scope('write')},
          );
        });

        group('when listing tokens without provider filter', () {
          late List<TokenInfo> tokens;

          setUp(() async {
            tokens = await tokenManager.listTokens(
              session: session,
              authUserId: null,
              method: null,
              transaction: null,
            );
          });

          test('then all tokens from all providers should be returned', () {
            expect(tokens, hasLength(2));
            expect(
              tokens.map((final t) => t.tokenProvider).toSet(),
              containsAll(['jwt', 'session']),
            );
          });

          test('then tokens should have correct user IDs', () {
            expect(
              tokens.map((final t) => t.userId).toSet(),
              containsAll([user1Id.toString(), user2Id.toString()]),
            );
          });
        });

        group('when listing tokens with provider filter', () {
          late List<TokenInfo> jwtTokens;
          late List<TokenInfo> sessionTokens;

          setUp(() async {
            jwtTokens = await tokenManager.listTokens(
              session: session,
              tokenProvider: 'jwt',
            );

            sessionTokens = await tokenManager.listTokens(
              session: session,
              tokenProvider: 'session',
            );
          });

          test('then only JWT tokens should be returned for JWT provider', () {
            expect(jwtTokens, hasLength(1));
            expect(jwtTokens.first.tokenProvider, equals('jwt'));
            expect(jwtTokens.first.userId, equals(user1Id.toString()));
          });

          test(
              'then only session tokens should be returned for session provider',
              () {
            expect(sessionTokens, hasLength(1));
            expect(sessionTokens.first.tokenProvider, equals('session'));
            expect(sessionTokens.first.userId, equals(user2Id.toString()));
          });
        });

        group('when revoking all tokens with provider filter', () {
          setUp(() async {
            await tokenManager.revokeAllTokens(
              session: session,
              tokenProvider: 'jwt',
              authUserId: user1Id,
            );
          });

          test('then only JWT tokens should be revoked', () async {
            final remainingTokens = await tokenManager.listTokens(
              session: session,
            );

            expect(remainingTokens, hasLength(1));
            expect(remainingTokens.first.tokenProvider, equals('session'));
          });
        });

        group('when revoking all tokens without provider filter', () {
          setUp(() async {
            await tokenManager.revokeAllTokens(
              session: session,
              authUserId: user1Id,
            );
          });

          test('then all user tokens should be revoked across providers',
              () async {
            final remainingTokens = await tokenManager.listTokens(
              session: session,
            );

            expect(remainingTokens, hasLength(1));
            expect(remainingTokens.first.userId, equals(user2Id.toString()));
          });
        });

        group('when using invalid provider', () {
          test('then ArgumentError should be thrown for listTokens', () {
            expect(
              () => tokenManager.listTokens(
                session: session,
                tokenProvider: 'invalid',
              ),
              throwsA(isA<ArgumentError>()),
            );
          });

          test('then ArgumentError should be thrown for revokeAllTokens', () {
            expect(
              () => tokenManager.revokeAllTokens(
                session: session,
                tokenProvider: 'invalid',
              ),
              throwsA(isA<ArgumentError>()),
            );
          });
        });
      },
    );
  });
}
