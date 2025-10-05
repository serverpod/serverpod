import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_provider.dart';
import 'package:test/test.dart';

import '../../../serverpod_test_tools.dart';
import '../fakes/fakes.dart';

void testSuite(
  final TokenProvider Function() providerBuilder, {
  required final Function(TokenInfo token) testAddToken,
}) {
  group('TokenProvider', () {
    withServerpod(
      'Given multiple tokens exist',
      (final sessionBuilder, final endpoints) {
        late TokenProvider tokenProvider;
        late Session session;
        late UuidValue user1Id;
        late UuidValue user2Id;

        setUp(() {
          tokenProvider = providerBuilder();
          session = sessionBuilder.build();
          user1Id =
              UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
          user2Id =
              UuidValue.fromString('550e8400-e29b-41d4-a716-446655440001');

          testAddToken(TokenInfo(
            userId: user1Id.toString(),
            tokenProvider: 'jwt',
            tokenId: 'token1',
            scopes: {const Scope('read')},
            method: 'email',
          ));

          testAddToken(TokenInfo(
            userId: user1Id.toString(),
            tokenProvider: 'jwt',
            tokenId: 'token2',
            scopes: {const Scope('write')},
            method: 'oauth',
          ));

          testAddToken(TokenInfo(
            userId: user2Id.toString(),
            tokenProvider: 'jwt',
            tokenId: 'token3',
            scopes: {const Scope('admin')},
            method: 'email',
          ));
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
        });

        group('when listing tokens with user filter', () {
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
              tokens.every((final token) => token.userId == user1Id.toString()),
              isTrue,
            );
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
              tokens.every((final token) => token.method == 'email'),
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
            await tokenProvider.revokeToken(
              session: session,
              tokenId: 'token1',
              transaction: null,
            );
          });

          test('then the token should be removed', () async {
            final remainingTokens = await tokenProvider.listTokens(
              session: session,
              authUserId: null,
              method: null,
              transaction: null,
            );
            expect(remainingTokens, hasLength(2));
            expect(
              remainingTokens.any((final token) => token.tokenId == 'token1'),
              isFalse,
            );
          });

          test('then other tokens should remain', () async {
            final remainingTokens = await tokenProvider.listTokens(
              session: session,
              authUserId: null,
              method: null,
              transaction: null,
            );
            expect(
              remainingTokens.any((final token) => token.tokenId == 'token2'),
              isTrue,
            );
            expect(
              remainingTokens.any((final token) => token.tokenId == 'token3'),
              isTrue,
            );
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
            final user1Tokens = await tokenProvider.listTokens(
              session: session,
              authUserId: user1Id,
              method: null,
              transaction: null,
            );
            expect(user1Tokens, isEmpty);
          });

          test('then other user tokens should remain', () async {
            final user2Tokens = await tokenProvider.listTokens(
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
            await tokenProvider.revokeAllTokens(
              session: session,
              authUserId: null,
              method: 'email',
              transaction: null,
            );
          });

          test('then only tokens with specified method should be removed',
              () async {
            final remainingTokens = await tokenProvider.listTokens(
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
            await tokenProvider.revokeAllTokens(
              session: session,
              authUserId: null,
              method: null,
              transaction: null,
            );
          });

          test('then all tokens should be removed', () async {
            final remainingTokens = await tokenProvider.listTokens(
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
      'Given no tokens exist',
      (final sessionBuilder, final endpoints) {
        late TokenProvider tokenProvider;
        late Session session;

        setUp(() {
          tokenProvider = providerBuilder();
          session = sessionBuilder.build();
        });

        group('when listing tokens', () {
          late List<TokenInfo> tokens;

          setUp(() async {
            tokens = await tokenProvider.listTokens(
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
              () => tokenProvider.revokeToken(
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
  });
}

void main() {
  final storage = FakeTokenStorage();
  final fakeTokenProvider = FakeTokenProvider(storage);
  testSuite(
    () => fakeTokenProvider,
    testAddToken: (final token) {
      return fakeTokenProvider.addToken(token);
    },
  );
}
