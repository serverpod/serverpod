import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../fakes/fakes.dart';

void testSuite<T extends Object>(
  final IdentityProviderBuilder<T> Function() createIdpBuilder,
) {
  group(
    'Given a identity provider builder',
    () {
      late IdentityProviderBuilder<T> idpBuilder;
      late TokenManager tokenManager;
      late AuthUsers authUsers;
      late UserProfiles userProfiles;

      setUp(() {
        idpBuilder = createIdpBuilder();
        tokenManager = FakeTokenManager(FakeTokenStorage());
        authUsers = const AuthUsers();
        userProfiles = const UserProfiles();
      });

      test('when getting type, then the correct type should be returned', () {
        expect(idpBuilder.type, equals(T));
      });

      test(
        'when constructing a provider the provider should be constructed',
        () {
          final provider = idpBuilder.build(
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
          final provider1 = idpBuilder.build(
            tokenManager: tokenManager,
            authUsers: authUsers,
            userProfiles: userProfiles,
          );
          final provider2 = idpBuilder.build(
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
  testSuite(() => const FakeConfig());
}
