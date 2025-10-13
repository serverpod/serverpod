import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../../serverpod_test_tools.dart';
import '../fakes/fakes.dart';

class FakeTokenManagerForFactory implements TokenManager {
  @override
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> revokeAllTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final Transaction? transaction,
    required final String? method,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> revokeToken({
    required final Session session,
    required final String tokenId,
    required final Transaction? transaction,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<TokenInfo>> listTokens({
    required final Session session,
    required final UuidValue? authUserId,
    required final String? method,
    required final Transaction? transaction,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthenticationInfo?> validateToken(
    final Session session,
    final String token,
  ) async {
    throw UnimplementedError();
  }
}

void testSuite(
    final IdentityProviderFactory<FakeIdentityProvider> Function()
        factoryBuilder) {
  group('IdentityProviderFactory', () {
    withServerpod(
      'Given a factory',
      (final sessionBuilder, final endpoints) {
        late IdentityProviderFactory<FakeIdentityProvider> factory;
        late TokenManager tokenManager;

        setUp(() {
          factory = factoryBuilder();
          tokenManager = FakeTokenManagerForFactory();
        });

        group('when getting type', () {
          late Type providerType;

          setUp(() {
            providerType = factory.type;
          });

          test('then the correct type should be returned', () {
            expect(providerType, equals(FakeIdentityProvider));
          });
        });

        group('when constructing a provider', () {
          late FakeIdentityProvider provider;

          setUp(() {
            provider = factory.construct(tokenManager: tokenManager);
          });

          test('then a provider instance should be returned', () {
            expect(provider, isA<FakeIdentityProvider>());
          });

          test('then the provider should have the correct token manager', () {
            expect(provider.tokenManager, equals(tokenManager));
          });
        });

        group('when constructing multiple providers', () {
          late FakeIdentityProvider provider1;
          late FakeIdentityProvider provider2;

          setUp(() {
            provider1 = factory.construct(tokenManager: tokenManager);
            provider2 = factory.construct(tokenManager: tokenManager);
          });

          test('then each instance should be unique', () {
            expect(provider1, isNot(same(provider2)));
          });

          test('then each instance should have the same token manager', () {
            expect(provider1.tokenManager, equals(tokenManager));
            expect(provider2.tokenManager, equals(tokenManager));
          });
        });
      },
    );

    withServerpod(
      'Given multiple factories',
      (final sessionBuilder, final endpoints) {
        late IdentityProviderFactory<FakeIdentityProvider> factory1;
        late IdentityProviderFactory<FakeIdentityProvider> factory2;
        late TokenManager tokenManager1;
        late TokenManager tokenManager2;

        setUp(() {
          factory1 = factoryBuilder();
          factory2 = factoryBuilder();
          tokenManager1 = FakeTokenManagerForFactory();
          tokenManager2 = FakeTokenManagerForFactory();
        });

        group('when constructing providers with different token managers', () {
          late FakeIdentityProvider provider1;
          late FakeIdentityProvider provider2;

          setUp(() {
            provider1 = factory1.construct(tokenManager: tokenManager1);
            provider2 = factory2.construct(tokenManager: tokenManager2);
          });

          test('then each provider should have its respective token manager',
              () {
            expect(provider1.tokenManager, equals(tokenManager1));
            expect(provider2.tokenManager, equals(tokenManager2));
            expect(provider1.tokenManager, isNot(equals(tokenManager2)));
          });
        });
      },
    );
  });
}

void main() {
  testSuite(() => FakeIdentityProviderFactory());
}
