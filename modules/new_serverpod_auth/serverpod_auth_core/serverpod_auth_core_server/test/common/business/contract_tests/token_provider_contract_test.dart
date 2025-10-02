import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/auth_config.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_provider.dart';
import 'package:test/test.dart';

import '../../../serverpod_test_tools.dart';
import '../token_issuer_contract_test.dart';
import '../token_provider_contract_test.dart';

void main() {
  withServerpod(
    'Given a single token provider is injected into AuthConfig',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late TestableTokenProvider fakeProvider;
      late UuidValue user1Id;
      late UuidValue user2Id;

      setUp(() {
        fakeProvider = FakeTokenProvider();

        user1Id = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        user2Id = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440001');

        fakeProvider.testAddToken(TokenInfo(
          userId: user1Id.toString(),
          tokenProvider: 'fake-provider',
          tokenId: 'token1',
          scopes: {const Scope('read')},
          method: 'email',
        ));

        fakeProvider.testAddToken(TokenInfo(
          userId: user1Id.toString(),
          tokenProvider: 'fake-provider',
          tokenId: 'token2',
          scopes: {const Scope('write')},
          method: 'oauth',
        ));

        fakeProvider.testAddToken(TokenInfo(
          userId: user2Id.toString(),
          tokenProvider: 'fake-provider',
          tokenId: 'token3',
          scopes: {const Scope('admin')},
          method: 'email',
        ));

        AuthConfig.set(
          tokenIssuer: FakeTokenIssuer(),
          identityProviders: [],
          tokenProviders: {'fake-provider': fakeProvider},
        );

        session = sessionBuilder.build();
      });

      group('when listing tokens using the token manager without filters', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
          );
        });

        test('then all tokens are returned', () {
          expect(tokens, hasLength(3));
        });

        test('then all tokens have the correct provider', () {
          expect(
            tokens.every((final t) => t.tokenProvider == 'fake-provider'),
            isTrue,
          );
        });
      });

      group(
        'when listing tokens using the token manager with a user filter',
        () {
          late List<TokenInfo> tokens;

          setUp(() async {
            tokens = await AuthConfig.instance.tokenManager.listTokens(
              session: session,
              authUserId: user1Id,
            );
          });

          test('then all tokens for the user are returned', () {
            expect(tokens, hasLength(2));
            expect(
              tokens.every((final t) => t.userId == user1Id.toString()),
              isTrue,
            );
          });
        },
      );

      group('when listing tokens using the token manager with a method filter',
          () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            method: 'email',
          );
        });

        test('then all tokens for the method are returned', () {
          expect(tokens, hasLength(2));
          expect(
            tokens.every((final t) => t.method == 'email'),
            isTrue,
          );
        });
      });

      group(
        'when listing tokens using the token manager with a combined filter',
        () {
          late List<TokenInfo> tokens;

          setUp(() async {
            tokens = await AuthConfig.instance.tokenManager.listTokens(
              session: session,
              authUserId: user1Id,
              method: 'oauth',
            );
          });

          test('then all tokens for the combined filter are returned', () {
            expect(tokens, hasLength(1));
            expect(tokens.first.userId, equals(user1Id.toString()));
            expect(tokens.first.method, equals('oauth'));
          });
        },
      );

      group('when listing tokens from empty provider', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          fakeProvider.testClear();

          tokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
          );
        });

        test('then empty list is returned', () {
          expect(tokens, isEmpty);
        });
      });

      group('when revoking a specific token', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeToken(
            session: session,
            tokenId: 'token1',
          );
        });

        test('then only that token is removed', () async {
          final remaining = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
          );

          expect(remaining, hasLength(2));
          expect(
            remaining.any((final t) => t.tokenId == 'token1'),
            isFalse,
          );
          expect(
            remaining.any((final t) => t.tokenId == 'token2'),
            isTrue,
          );
          expect(
            remaining.any((final t) => t.tokenId == 'token3'),
            isTrue,
          );
        });
      });

      group('when revoking a non-existent token', () {
        test('then no error is thrown', () async {
          expect(
            () => AuthConfig.instance.tokenManager.revokeToken(
              session: session,
              tokenId: 'non-existent',
            ),
            returnsNormally,
          );
        });
      });

      group('when revoking all tokens for a user', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeAllTokens(
            session: session,
            authUserId: user1Id,
          );
        });

        test('then all user tokens are removed', () async {
          final remaining = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            authUserId: user1Id,
          );

          expect(remaining, isEmpty);
        });

        test('then other user tokens remain', () async {
          final remaining = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            authUserId: user2Id,
          );

          expect(remaining, hasLength(1));
        });
      });

      group('when revoking all tokens by method', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeAllTokens(
            session: session,
            method: 'email',
          );
        });

        test('then all method tokens are removed', () async {
          final remaining = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
          );

          expect(remaining, hasLength(1));
          expect(remaining.first.method, equals('oauth'));
        });
      });

      group('when revoking all tokens without filters', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeAllTokens(
            session: session,
          );
        });

        test('then all tokens are removed', () async {
          final remaining = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
          );

          expect(remaining, isEmpty);
        });
      });

      group('when revoking all tokens with combined filters', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeAllTokens(
            session: session,
            authUserId: user1Id,
            method: 'email',
          );
        });

        test('then only matching tokens are removed', () async {
          final remaining = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
          );

          expect(remaining, hasLength(2));
          expect(
            remaining.any((final t) =>
                t.userId == user1Id.toString() && t.method == 'email'),
            isFalse,
          );
        });
      });
    },
  );

  withServerpod(
    'Given multiple token providers are injected into AuthConfig',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late TestableTokenProvider jwtProvider;
      late TestableTokenProvider sasProvider;
      late UuidValue user1Id;
      late UuidValue user2Id;

      setUp(() {
        jwtProvider = FakeTokenProvider();
        sasProvider = FakeTokenProvider();

        user1Id = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        user2Id = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440001');

        // Add JWT tokens
        jwtProvider.testAddToken(TokenInfo(
          userId: user1Id.toString(),
          tokenProvider: 'jwt',
          tokenId: 'jwt-token1',
          scopes: {const Scope('read')},
          method: 'email',
        ));

        jwtProvider.testAddToken(TokenInfo(
          userId: user2Id.toString(),
          tokenProvider: 'jwt',
          tokenId: 'jwt-token2',
          scopes: {const Scope('write')},
          method: 'oauth',
        ));

        // Add SAS tokens
        sasProvider.testAddToken(TokenInfo(
          userId: user1Id.toString(),
          tokenProvider: 'session',
          tokenId: 'sas-token1',
          scopes: {const Scope('admin')},
          method: 'web',
        ));

        sasProvider.testAddToken(TokenInfo(
          userId: user2Id.toString(),
          tokenProvider: 'session',
          tokenId: 'sas-token2',
          scopes: {const Scope('read')},
          method: 'web',
        ));

        // Configure AuthConfig with multiple providers
        AuthConfig.set(
          tokenIssuer: FakeTokenIssuer(),
          identityProviders: [],
          tokenProviders: {
            'jwt': jwtProvider,
            'session': sasProvider,
          },
        );

        session = sessionBuilder.build();
      });

      group('when listing tokens without provider filter', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
          );
        });

        test('then tokens from all providers are returned', () {
          expect(tokens, hasLength(4));
        });

        test('then tokens from both providers are present', () {
          final providers = tokens.map((final t) => t.tokenProvider).toSet();
          expect(providers, containsAll(['jwt', 'session']));
        });
      });

      group('when listing tokens with provider filter', () {
        late List<TokenInfo> jwtTokens;
        late List<TokenInfo> sasTokens;

        setUp(() async {
          jwtTokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'jwt',
          );

          sasTokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'session',
          );
        });

        test('then only tokens from specified provider are returned', () {
          expect(jwtTokens, hasLength(2));
          expect(
            jwtTokens.every((final t) => t.tokenProvider == 'jwt'),
            isTrue,
          );

          expect(sasTokens, hasLength(2));
          expect(
            sasTokens.every((final t) => t.tokenProvider == 'session'),
            isTrue,
          );
        });
      });

      group('when listing tokens with user filter across providers', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            authUserId: user1Id,
          );
        });

        test('then matching tokens from all providers are returned', () {
          expect(tokens, hasLength(2));
          expect(
            tokens.every((final t) => t.userId == user1Id.toString()),
            isTrue,
          );

          final providers = tokens.map((final t) => t.tokenProvider).toSet();
          expect(providers, containsAll(['jwt', 'session']));
        });
      });

      group('when listing tokens with provider and user filter', () {
        late List<TokenInfo> tokens;

        setUp(() async {
          tokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'jwt',
            authUserId: user1Id,
          );
        });

        test('then matching tokens from specified provider only are returned',
            () {
          expect(tokens, hasLength(1));
          expect(tokens.first.tokenProvider, equals('jwt'));
          expect(tokens.first.userId, equals(user1Id.toString()));
        });
      });

      group('when revoking specific token without provider hint', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeToken(
            session: session,
            tokenId: 'jwt-token1',
          );
        });

        test('then token is removed from correct provider', () async {
          final jwtTokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'jwt',
          );

          expect(jwtTokens, hasLength(1));
          expect(
            jwtTokens.any((final t) => t.tokenId == 'jwt-token1'),
            isFalse,
          );
        });

        test('then tokens in other providers remain', () async {
          final sasTokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'session',
          );

          expect(sasTokens, hasLength(2));
        });
      });

      group('when revoking all tokens without provider filter', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeAllTokens(
            session: session,
          );
        });

        test('then tokens are removed from all providers', () async {
          final allTokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
          );

          expect(allTokens, isEmpty);
        });
      });

      group('when revoking all tokens with provider filter', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeAllTokens(
            session: session,
            tokenProvider: 'jwt',
          );
        });

        test('then tokens are removed from specified provider only', () async {
          final jwtTokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'jwt',
          );

          expect(jwtTokens, isEmpty);
        });

        test('then tokens in other providers remain', () async {
          final sasTokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'session',
          );

          expect(sasTokens, hasLength(2));
        });
      });

      group('when revoking all tokens with user filter', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeAllTokens(
            session: session,
            authUserId: user1Id,
          );
        });

        test('then user tokens are removed from all providers', () async {
          final user1Tokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            authUserId: user1Id,
          );

          expect(user1Tokens, isEmpty);
        });

        test('then other user tokens remain in all providers', () async {
          final user2Tokens = await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            authUserId: user2Id,
          );

          expect(user2Tokens, hasLength(2));

          final providers =
              user2Tokens.map((final t) => t.tokenProvider).toSet();
          expect(providers, containsAll(['jwt', 'session']));
        });
      });

      group('when revoking with provider and user filter', () {
        setUp(() async {
          await AuthConfig.instance.tokenManager.revokeAllTokens(
            session: session,
            tokenProvider: 'jwt',
            authUserId: user1Id,
          );
        });

        test('then user tokens are removed from specified provider only',
            () async {
          final jwtUser1Tokens =
              await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'jwt',
            authUserId: user1Id,
          );

          expect(jwtUser1Tokens, isEmpty);
        });

        test('then user tokens in other providers remain', () async {
          final sasUser1Tokens =
              await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'session',
            authUserId: user1Id,
          );

          expect(sasUser1Tokens, hasLength(1));
        });

        test('then other user tokens in same provider remain', () async {
          final jwtUser2Tokens =
              await AuthConfig.instance.tokenManager.listTokens(
            session: session,
            tokenProvider: 'jwt',
            authUserId: user2Id,
          );

          expect(jwtUser2Tokens, hasLength(1));
        });
      });
    },
  );

  withServerpod(
    'Given an unregistered provider name',
    (final sessionBuilder, final endpoints) {
      late Session session;

      setUp(() {
        // Configure AuthConfig with only jwt provider
        AuthConfig.set(
          tokenIssuer: FakeTokenIssuer(),
          identityProviders: [],
          tokenProviders: {'jwt': FakeTokenProvider()},
        );

        session = sessionBuilder.build();
      });

      group('when listing tokens with invalid provider', () {
        test('then ArgumentError is thrown', () async {
          expect(
            () => AuthConfig.instance.tokenManager.listTokens(
              session: session,
              tokenProvider: 'invalid-provider',
            ),
            throwsA(isA<ArgumentError>()),
          );
        });
      });

      group('when revoking all tokens with invalid provider', () {
        test('then ArgumentError is thrown', () async {
          expect(
            () => AuthConfig.instance.tokenManager.revokeAllTokens(
              session: session,
              tokenProvider: 'invalid-provider',
            ),
            throwsA(isA<ArgumentError>()),
          );
        });
      });
    },
  );
}
