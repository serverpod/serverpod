import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../fakes/fakes.dart';

void testSuite<T extends IdentityProvider>(
  final IdentityProviderBuilder<T> Function() createIdpBuilder,
) {
  group(
    'Given an identity provider builder,',
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

      test(
        'when reading its provider type, '
        'then the type of the built identity provider is returned.',
        () {
          expect(idpBuilder.type, equals(T));
        },
      );

      test(
        'when building an identity provider, '
        'then an identity provider of the declared type is returned.',
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
        'when building two identity providers, '
        'then distinct provider instances are returned.',
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
