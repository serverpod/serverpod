import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/src/common/business/multi_token_manager.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import 'fakes/fakes.dart';

void main() {
  withServerpod(
    'Given AuthConfig dependencies',
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

        test('then the singleton instance shall be created and accessible', () {
          expect(authConfig, isNotNull);
          expect(authConfig, isA<AuthConfig>());
          expect(authConfig.tokenManager, isA<MultiTokenManager>());
        });

        test('then AuthConfig.instance shall return the created instance', () {
          expect(AuthConfig.instance, equals(authConfig));
          expect(AuthConfig.instance.tokenManager, isA<MultiTokenManager>());
          expect(AuthConfig.instance.tokenManager, isNotNull);
        });

        test('then the configured token managers shall be accessible', () {
          expect(authConfig.tokenManager, isA<MultiTokenManager>());
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
          expect(AuthConfig.instance.tokenManager, isA<MultiTokenManager>());
          expect(AuthConfig.instance, equals(secondConfig));
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

        test('then the registered provider should be returned', () {
          final provider =
              AuthConfig.getIdentityProvider<FakeIdentityProvider>();
          expect(provider, isA<FakeIdentityProvider>());
        });

        test('then the unregistered provider should throw StateError', () {
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
          expect(tokenManager, isA<MultiTokenManager>());
        });

        test('then the token manager shall be a MultiTokenManager', () {
          final tokenManager = AuthConfig.instance.tokenManager;
          expect(tokenManager, isA<MultiTokenManager>());
        });
      });

      group('when identity providers are registered and', () {
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
            expect(provider.tokenManager, isA<MultiTokenManager>());
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
            expect(provider.tokenManager, isA<MultiTokenManager>());
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
      });

      group('when multiple identity providers are registered', () {
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
          expect(provider.tokenManager, isA<MultiTokenManager>());
        });
      });

      group('when a token exists in storage and', () {
        late Session session;
        late AuthConfig authConfig;
        const validToken = 'valid-token-123';

        setUp(() {
          session = sessionBuilder.build();
          authConfig = AuthConfig.set(
            defaultTokenManager: fakeTokenManager,
            identityProviders: identityProviderFactories,
            tokenManagers: tokenManagers,
          );

          fakeTokenManager.addToken(TokenInfo(
            userId: 'user-123',
            tokenProvider: 'fake',
            tokenId: validToken,
            scopes: {const Scope('test-scope')},
            method: 'test-method',
          ));
        });

        group('when validating the token', () {
          late AuthenticationInfo? result;

          setUp(() async {
            result =
                await authConfig.authenticationHandler(session, validToken);
          });

          test('then authentication info should be returned', () {
            expect(result, isNotNull);
          });

          test('then the user identifier should match', () {
            expect(result!.userIdentifier, equals('user-123'));
          });

          test('then the scopes should match', () {
            expect(
              result!.scopes.map((final s) => s.name),
              contains('test-scope'),
            );
          });
        });
      });

      group('when a token with multiple scopes exists in storage and', () {
        late Session session;
        late AuthConfig authConfig;
        const validToken = 'multi-scope-token';

        setUp(() {
          session = sessionBuilder.build();
          authConfig = AuthConfig.set(
            defaultTokenManager: fakeTokenManager,
            identityProviders: identityProviderFactories,
            tokenManagers: tokenManagers,
          );

          fakeTokenManager.addToken(TokenInfo(
            userId: 'user-456',
            tokenProvider: 'fake',
            tokenId: validToken,
            scopes: {
              const Scope('read'),
              const Scope('write'),
              const Scope('admin')
            },
            method: 'oauth',
          ));
        });

        group('when validating the token', () {
          late AuthenticationInfo? result;

          setUp(() async {
            result =
                await authConfig.authenticationHandler(session, validToken);
          });

          test('then all scopes should be included', () {
            expect(result, isNotNull);
            final scopeNames = result!.scopes.map((final s) => s.name);
            expect(scopeNames, contains('read'));
            expect(scopeNames, contains('write'));
            expect(scopeNames, contains('admin'));
          });
        });
      });

      group('when no token exists in storage and', () {
        late Session session;
        late AuthConfig authConfig;

        setUp(() {
          session = sessionBuilder.build();
          authConfig = AuthConfig.set(
            defaultTokenManager: fakeTokenManager,
            identityProviders: identityProviderFactories,
            tokenManagers: tokenManagers,
          );
        });

        group('when validating an invalid token', () {
          late AuthenticationInfo? result;

          setUp(() async {
            result = await authConfig.authenticationHandler(
              session,
              'invalid-token',
            );
          });

          test('then null should be returned', () {
            expect(result, isNull);
          });
        });
      });

      group('when validating an empty token', () {
        late AuthenticationInfo? result;

        setUp(() async {
          final session = sessionBuilder.build();
          final authConfig = AuthConfig.set(
            defaultTokenManager: fakeTokenManager,
            identityProviders: identityProviderFactories,
            tokenManagers: tokenManagers,
          );
          result = await authConfig.authenticationHandler(session, '');
        });

        test('then null should be returned', () {
          expect(result, isNull);
        });
      });
    },
  );
}
