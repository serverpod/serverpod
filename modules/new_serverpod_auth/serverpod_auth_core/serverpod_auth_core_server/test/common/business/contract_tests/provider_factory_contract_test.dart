import 'package:serverpod_auth_core_server/profile.dart';
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
      late IdentityProviderFactory<T> idpFactory;
      late TokenManager tokenManager;
      late AuthUsers authUsers;
      late UserProfiles userProfiles;

      setUp(() {
        idpFactory = factoryBuilder();
        tokenManager = FakeTokenManager(FakeTokenStorage());
        authUsers = const AuthUsers();
        userProfiles = const UserProfiles();
      });

      test('when getting type, then the correct type should be returned', () {
        expect(idpFactory.type, equals(T));
      });

      test(
        'when constructing a provider the provider should be constructed',
        () {
          final provider = idpFactory.construct(
            tokenManager: tokenManager,
            authUsers: authUsers,
            userProfiles: userProfiles,
          );
          expect(provider, isNotNull);
          expect(provider, isA<T>());
        },
      );

      test(
        'when constructing multiple providers the providers should be unique',
        () {
          final provider1 = idpFactory.construct(
            tokenManager: tokenManager,
            authUsers: authUsers,
            userProfiles: userProfiles,
          );
          final provider2 = idpFactory.construct(
            tokenManager: tokenManager,
            authUsers: authUsers,
            userProfiles: userProfiles,
          );
          expect(provider1, isNot(same(provider2)));
        },
      );
    },
  );
}

void main() {
  testSuite(() => FakeIdentityProviderFactory());
}
