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
            tokens.every((final t) => t.tokenProvider == AuthStrategy.jwt.name),
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

        test('then only tokens for the specified user should be returned', () {
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
          expect(emailToken.scopes.map((final s) => s.name), contains('read'));

          final oauthToken =
              tokens.firstWhere((final t) => t.method == 'oauth');
          expect(oauthToken.scopes.map((final s) => s.name), contains('write'));
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
}
