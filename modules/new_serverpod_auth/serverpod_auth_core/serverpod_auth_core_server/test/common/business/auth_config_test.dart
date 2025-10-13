import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import 'fakes/fakes.dart';

void main() {
  group('AuthConfig', () {
    withServerpod(
      'Given AuthConfig',
      (final sessionBuilder, final endpoints) {
        late FakeTokenManager fakeTokenManager;
        late List<IdentityProviderFactory<IdentityProvider>>
            identityProviderFactories;
        late Map<String, TokenManager> tokenManagers;
        late FakeTokenStorage fakeTokenStorage;

        setUp(() {
          fakeTokenStorage = FakeTokenStorage();
          fakeTokenManager = FakeTokenManager(fakeTokenStorage);

          identityProviderFactories = [
            FakeIdentityProviderFactory(),
          ];

          tokenManagers = {
            'fake': FakeTokenManager(fakeTokenStorage),
          };
        });

        group('when AuthConfig.set is called with valid parameters', () {
          late AuthConfig authConfig;

          setUp(() {
            authConfig = AuthConfig.set(
              defaultTokenManager: fakeTokenManager,
              identityProviders: identityProviderFactories,
              tokenManagers: tokenManagers,
            );
          });

          test('then the singleton instance shall be created and accessible',
              () {
            expect(authConfig, isNotNull);
            expect(authConfig, isA<AuthConfig>());
            expect(authConfig.tokenManager, equals(fakeTokenManager));
          });

          test('then AuthConfig.instance shall return the created instance',
              () {
            expect(AuthConfig.instance, equals(authConfig));
            expect(AuthConfig.instance.tokenManager, equals(fakeTokenManager));
            expect(AuthConfig.instance.tokenManager, isNotNull);
          });

          test('then the configured token managers shall be accessible', () {
            expect(authConfig.tokenManager, equals(fakeTokenManager));
          });
        });

        group('when AuthConfig.set is called multiple times', () {
          late AuthConfig firstConfig;
          late AuthConfig secondConfig;
          late FakeTokenManager secondTokenManager;
          late FakeTokenStorage secondTokenStorage;

          setUp(() {
            firstConfig = AuthConfig.set(
              defaultTokenManager: fakeTokenManager,
              identityProviders: identityProviderFactories,
              tokenManagers: tokenManagers,
            );

            secondTokenStorage = FakeTokenStorage();
            secondTokenManager = FakeTokenManager(secondTokenStorage);
            secondConfig = AuthConfig.set(
              defaultTokenManager: secondTokenManager,
              identityProviders: identityProviderFactories,
              tokenManagers: tokenManagers,
            );
          });

          test('then the instance shall be replaced with the new configuration',
              () {
            expect(AuthConfig.instance, equals(secondConfig));
            expect(AuthConfig.instance, isNot(equals(firstConfig)));
          });

          test('then the new configuration shall take effect', () {
            expect(
                AuthConfig.instance.tokenManager, equals(secondTokenManager));
            expect(AuthConfig.instance.tokenManager,
                isNot(equals(fakeTokenManager)));
          });
        });

        group('when accessing providers', () {
          setUp(() {
            AuthConfig.set(
              defaultTokenManager: fakeTokenManager,
              identityProviders: identityProviderFactories,
              tokenManagers: tokenManagers,
            );
          });

          test('then registered provider should be returned', () {
            final provider =
                AuthConfig.getIdentityProvider<FakeIdentityProvider>();
            expect(provider, isA<FakeIdentityProvider>());
          });

          test('then unregistered provider should throw StateError', () {
            expect(
              () => AuthConfig.getIdentityProvider<String>(),
              throwsA(isA<StateError>()),
            );
          });
        });

        group('when using default token managers', () {
          setUp(() {
            AuthConfig.set(
              defaultTokenManager: fakeTokenManager,
              identityProviders: identityProviderFactories,
            );
          });

          test('then default token managers should be used', () {
            final tokenManager = AuthConfig.instance.tokenManager;
            expect(tokenManager, isNotNull);
          });

          test('then the default token manager shall be set', () {
            final tokenManager = AuthConfig.instance.tokenManager;
            expect(tokenManager, equals(fakeTokenManager));
          });
        });

        group('provider registration and retrieval', () {
          setUp(() {
            AuthConfig.set(
              defaultTokenManager: fakeTokenManager,
              identityProviders: identityProviderFactories,
              tokenManagers: tokenManagers,
            );
          });

          group('when provider is constructed during initialization', () {
            test('then constructed provider should have correct token manager',
                () {
              final provider =
                  AuthConfig.getIdentityProvider<FakeIdentityProvider>();
              expect(provider.tokenManager, equals(fakeTokenManager));
            });

            test('then constructed provider should be stored correctly', () {
              final provider =
                  AuthConfig.getIdentityProvider<FakeIdentityProvider>();
              expect(provider, isA<FakeIdentityProvider>());
              expect(provider, isNotNull);
            });
          });

          group('when retrieving provider by type', () {
            test(
                'then getProvider should return correct provider instance for registered types',
                () {
              final provider =
                  AuthConfig.getIdentityProvider<FakeIdentityProvider>();
              expect(provider, isA<FakeIdentityProvider>());
              expect(provider.tokenManager, equals(fakeTokenManager));
            });

            test(
                'then StateError should be thrown for unregistered provider types',
                () {
              expect(
                () => AuthConfig.getIdentityProvider<String>(),
                throwsA(isA<StateError>().having(
                  (final e) => e.message,
                  'message',
                  'Provider for String is not registered',
                )),
              );
            });
          });

          group('when multiple providers are registered', () {
            late List<IdentityProviderFactory<IdentityProvider>>
                multipleProviderFactories;
            late FakeIdentityProviderFactory firstFactory;
            late FakeIdentityProviderFactory secondFactory;

            setUp(() {
              firstFactory = FakeIdentityProviderFactory();
              secondFactory = FakeIdentityProviderFactory();
              multipleProviderFactories = [firstFactory, secondFactory];

              AuthConfig.set(
                defaultTokenManager: fakeTokenManager,
                identityProviders: multipleProviderFactories,
                tokenManagers: tokenManagers,
              );
            });

            test('then each provider should be accessible independently', () {
              final provider =
                  AuthConfig.getIdentityProvider<FakeIdentityProvider>();
              expect(provider, isA<FakeIdentityProvider>());
              expect(provider.tokenManager, equals(fakeTokenManager));
            });
          });
        });
      },
    );
  });
}
