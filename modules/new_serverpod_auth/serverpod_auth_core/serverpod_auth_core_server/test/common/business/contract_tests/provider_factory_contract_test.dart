import 'package:serverpod_auth_core_server/src/common/integrations/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';
import 'package:test/test.dart';

import '../fakes/fakes.dart';

void testSuite<T extends Object>(
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

      test('when constructing a provider the provider should be constructed',
          () {
        final provider = factory.construct(tokenManager: tokenManager);
        expect(provider, isNotNull);
        expect(provider, isA<T>());
      });

      test(
          'when constructing multiple providers the providers should be unique',
          () {
        final provider1 = factory.construct(tokenManager: tokenManager);
        final provider2 = factory.construct(tokenManager: tokenManager);
        expect(provider1, isNot(same(provider2)));
      });
    },
  );
}

void main() {
  testSuite(() => FakeIdentityProviderFactory());
}
