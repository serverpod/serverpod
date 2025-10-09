import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import 'fakes/fakes.dart';

void main() {
  group('AuthConfig', () {
    withServerpod(
      'Given AuthConfig',
      (final sessionBuilder, final endpoints) {
        late FakeTokenIssuer fakeTokenIssuer;
        late List<IdentityProviderFactory<dynamic>> identityProviderFactories;
        late Map<String, TokenProvider> tokenProviders;
        late FakeTokenStorage fakeTokenStorage;

        setUp(() {
          fakeTokenStorage = FakeTokenStorage();
          fakeTokenIssuer = FakeTokenIssuer(fakeTokenStorage);

          identityProviderFactories = [
            FakeIdentityProviderFactory(),
          ];

          tokenProviders = {
            'fake': FakeTokenProvider(fakeTokenStorage),
          };
        });

        group('when AuthConfig.set is called with valid parameters', () {
          late AuthConfig authConfig;

          setUp(() {
            authConfig = AuthConfig.set(
              tokenIssuer: fakeTokenIssuer,
              identityProviders: identityProviderFactories,
              tokenProviders: tokenProviders,
            );
          });

          test('then the singleton instance shall be created and accessible',
              () {
            expect(authConfig, isNotNull);
            expect(authConfig, isA<AuthConfig>());
            expect(authConfig.defaultTokenIssuer, equals(fakeTokenIssuer));
          });

          test('then AuthConfig.instance shall return the created instance',
              () {
            expect(AuthConfig.instance, equals(authConfig));
            expect(AuthConfig.instance.defaultTokenIssuer,
                equals(fakeTokenIssuer));
            expect(AuthConfig.instance.tokenManager, isNotNull);
          });

          test('then TokenManager shall receive the configured token providers',
              () {
            final tokenManager = AuthConfig.instance.tokenManager;
            expect(tokenManager.tokenProviders, equals(tokenProviders));
            expect(tokenManager.tokenProviders['fake'],
                equals(tokenProviders['fake']));
          });
        });

        group('when AuthConfig.set is called multiple times', () {
          late AuthConfig firstConfig;
          late AuthConfig secondConfig;
          late FakeTokenIssuer secondTokenIssuer;
          late FakeTokenStorage secondTokenStorage;

          setUp(() {
            firstConfig = AuthConfig.set(
              tokenIssuer: fakeTokenIssuer,
              identityProviders: identityProviderFactories,
              tokenProviders: tokenProviders,
            );

            secondTokenStorage = FakeTokenStorage();
            secondTokenIssuer = FakeTokenIssuer(secondTokenStorage);
            secondConfig = AuthConfig.set(
              tokenIssuer: secondTokenIssuer,
              identityProviders: identityProviderFactories,
              tokenProviders: tokenProviders,
            );
          });

          test('then the instance shall be replaced with the new configuration',
              () {
            expect(AuthConfig.instance, equals(secondConfig));
            expect(AuthConfig.instance, isNot(equals(firstConfig)));
          });

          test('then the new configuration shall take effect', () {
            expect(AuthConfig.instance.defaultTokenIssuer,
                equals(secondTokenIssuer));
            expect(AuthConfig.instance.defaultTokenIssuer,
                isNot(equals(fakeTokenIssuer)));
          });
        });

        group('when accessing providers', () {
          setUp(() {
            AuthConfig.set(
              tokenIssuer: fakeTokenIssuer,
              identityProviders: identityProviderFactories,
              tokenProviders: tokenProviders,
            );
          });

          test('then registered provider should be returned', () {
            final provider = AuthConfig.getProvider<FakeIdentityProvider>();
            expect(provider, isA<FakeIdentityProvider>());
          });

          test('then unregistered provider should throw StateError', () {
            expect(
              () => AuthConfig.getProvider<String>(),
              throwsA(isA<StateError>()),
            );
          });
        });

        group('when using default token providers', () {
          setUp(() {
            AuthConfig.set(
              tokenIssuer: fakeTokenIssuer,
              identityProviders: identityProviderFactories,
            );
          });

          test('then default token providers should be used', () {
            final tokenManager = AuthConfig.instance.tokenManager;
            expect(tokenManager, isNotNull);
          });

          test('then TokenManager shall receive the default token providers',
              () {
            final tokenManager = AuthConfig.instance.tokenManager;
            final defaultProviders = AuthConfig.defaultTokenProviders;
            expect(tokenManager.tokenProviders.keys,
                equals(defaultProviders.keys));
          });
        });

        group('provider registration and retrieval', () {
          setUp(() {
            AuthConfig.set(
              tokenIssuer: fakeTokenIssuer,
              identityProviders: identityProviderFactories,
              tokenProviders: tokenProviders,
            );
          });

          group('when provider is constructed during initialization', () {
            test('then constructed provider should have correct token issuer',
                () {
              final provider = AuthConfig.getProvider<FakeIdentityProvider>();
              expect(provider.tokenIssuer, equals(fakeTokenIssuer));
            });

            test('then constructed provider should be stored correctly', () {
              final provider = AuthConfig.getProvider<FakeIdentityProvider>();
              expect(provider, isA<FakeIdentityProvider>());
              expect(provider, isNotNull);
            });
          });

          group('when retrieving provider by type', () {
            test(
                'then getProvider should return correct provider instance for registered types',
                () {
              final provider = AuthConfig.getProvider<FakeIdentityProvider>();
              expect(provider, isA<FakeIdentityProvider>());
              expect(provider.tokenIssuer, equals(fakeTokenIssuer));
            });

            test(
                'then StateError should be thrown for unregistered provider types',
                () {
              expect(
                () => AuthConfig.getProvider<String>(),
                throwsA(isA<StateError>().having(
                  (final e) => e.message,
                  'message',
                  'Provider for String is not registered',
                )),
              );
            });
          });

          group('when multiple providers are registered', () {
            late List<IdentityProviderFactory<dynamic>>
                multipleProviderFactories;
            late FakeIdentityProviderFactory firstFactory;
            late FakeIdentityProviderFactory secondFactory;

            setUp(() {
              firstFactory = FakeIdentityProviderFactory();
              secondFactory = FakeIdentityProviderFactory();
              multipleProviderFactories = [firstFactory, secondFactory];

              AuthConfig.set(
                tokenIssuer: fakeTokenIssuer,
                identityProviders: multipleProviderFactories,
                tokenProviders: tokenProviders,
              );
            });

            test('then each provider should be accessible independently', () {
              final provider = AuthConfig.getProvider<FakeIdentityProvider>();
              expect(provider, isA<FakeIdentityProvider>());
              expect(provider.tokenIssuer, equals(fakeTokenIssuer));
            });
          });
        });
      },
    );
  });
}
