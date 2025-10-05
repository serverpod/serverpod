import 'package:serverpod_auth_core_server/src/common/business/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../../serverpod_test_tools.dart';
import '../fakes/fakes.dart';

class FakeTokenIssuerForFactory implements TokenIssuer {
  @override
  Future<AuthSuccess> issueToken({
    required final session,
    required final authUserId,
    required final method,
    required final scopes,
    required final transaction,
  }) async {
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
        late TokenIssuer tokenIssuer;

        setUp(() {
          factory = factoryBuilder();
          tokenIssuer = FakeTokenIssuerForFactory();
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
            provider = factory.construct(defaultTokenIssuer: tokenIssuer);
          });

          test('then a provider instance should be returned', () {
            expect(provider, isA<FakeIdentityProvider>());
          });

          test('then the provider should have the correct token issuer', () {
            expect(provider.tokenIssuer, equals(tokenIssuer));
          });
        });

        group('when constructing multiple providers', () {
          late FakeIdentityProvider provider1;
          late FakeIdentityProvider provider2;

          setUp(() {
            provider1 = factory.construct(defaultTokenIssuer: tokenIssuer);
            provider2 = factory.construct(defaultTokenIssuer: tokenIssuer);
          });

          test('then each instance should be unique', () {
            expect(provider1, isNot(same(provider2)));
          });

          test('then each instance should have the same token issuer', () {
            expect(provider1.tokenIssuer, equals(tokenIssuer));
            expect(provider2.tokenIssuer, equals(tokenIssuer));
          });
        });
      },
    );

    withServerpod(
      'Given multiple factories',
      (final sessionBuilder, final endpoints) {
        late IdentityProviderFactory<FakeIdentityProvider> factory1;
        late IdentityProviderFactory<FakeIdentityProvider> factory2;
        late TokenIssuer tokenIssuer1;
        late TokenIssuer tokenIssuer2;

        setUp(() {
          factory1 = factoryBuilder();
          factory2 = factoryBuilder();
          tokenIssuer1 = FakeTokenIssuerForFactory();
          tokenIssuer2 = FakeTokenIssuerForFactory();
        });

        group('when constructing providers with different token issuers', () {
          late FakeIdentityProvider provider1;
          late FakeIdentityProvider provider2;

          setUp(() {
            provider1 = factory1.construct(defaultTokenIssuer: tokenIssuer1);
            provider2 = factory2.construct(defaultTokenIssuer: tokenIssuer2);
          });

          test('then each provider should have its respective token issuer',
              () {
            expect(provider1.tokenIssuer, equals(tokenIssuer1));
            expect(provider2.tokenIssuer, equals(tokenIssuer2));
            expect(provider1.tokenIssuer, isNot(equals(tokenIssuer2)));
          });
        });
      },
    );
  });
}

void main() {
  testSuite(() => FakeIdentityProviderFactory());
}
