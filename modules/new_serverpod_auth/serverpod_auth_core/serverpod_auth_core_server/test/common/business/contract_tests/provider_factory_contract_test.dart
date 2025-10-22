import 'package:serverpod_auth_core_server/src/common/business/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:test/test.dart';

import '../fakes/fakes.dart';

void testSuite<T extends IdentityProvider>(
  final IdentityProviderFactory<T> Function() factoryBuilder,
) {
  group(
    'Given a identity provider factory',
    () {
      late IdentityProviderFactory<T> factory;
      late TokenManager tokenManager;

      setUp(() {
        factory = factoryBuilder();
        tokenManager = FakeTokenManager(FakeTokenStorage());
      });

      test('when getting type, then the correct type should be returned', () {
        expect(factory.type, equals(T));
      });

      group('when constructing a provider', () {
        late IdentityProvider provider;

        setUp(() {
          provider = factory.construct(tokenManager: tokenManager);
        });

        test('then the provider should have the supplied token manager', () {
          expect(provider.tokenIssuer, equals(tokenManager));
        });
      });

      group('when constructing multiple providers', () {
        late IdentityProvider provider1;
        late IdentityProvider provider2;

        setUp(() {
          provider1 = factory.construct(tokenManager: tokenManager);
          provider2 = factory.construct(tokenManager: tokenManager);
        });

        test('then each instance should be unique', () {
          expect(provider1, isNot(same(provider2)));
        });

        test('then each instance should have the same token issuer', () {
          expect(provider1.tokenIssuer, equals(tokenManager));
          expect(provider2.tokenIssuer, equals(tokenManager));
        });
      });

      group('when constructing providers with different token managers', () {
        late IdentityProvider provider1;
        late IdentityProvider provider2;
        late TokenManager tokenManager2;

        setUp(() {
          tokenManager2 = FakeTokenManager(FakeTokenStorage());
          provider1 = factory.construct(tokenManager: tokenManager);
          provider2 = factory.construct(tokenManager: tokenManager2);
        });

        test('then each provider should have its respective token manager', () {
          expect(provider1.tokenIssuer, equals(tokenManager));
          expect(provider2.tokenIssuer, equals(tokenManager2));
          expect(provider1.tokenIssuer, isNot(equals(tokenManager2)));
        });
      });
    },
  );
}

void main() {
  testSuite(() => FakeIdentityProviderFactory());
}
