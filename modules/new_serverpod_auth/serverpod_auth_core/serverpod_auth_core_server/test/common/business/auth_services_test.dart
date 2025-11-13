import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/src/common/business/multi_token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/token_manager_factory.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import 'fakes/fakes.dart';

void main() {
  withServerpod(
    'Given AuthServices is being configured',
    (final sessionBuilder, final endpoints) {
      late FakeTokenManagerFactory fakeTokenManagerFactory;
      late List<IdentityProviderFactory<Object>> identityProviderFactories;
      late List<TokenManagerFactory> tokenManagers;
      late FakeTokenStorage fakeTokenStorage;

      setUp(() {
        fakeTokenStorage = FakeTokenStorage();
        fakeTokenManagerFactory = FakeTokenManagerFactory(
          tokenStorage: fakeTokenStorage,
        );

        identityProviderFactories = [
          FakeIdentityProviderFactory(),
        ];

        tokenManagers = [
          FakeTokenManagerFactory(tokenStorage: fakeTokenStorage),
        ];
      });

      group('when AuthServices.set is called with valid parameters', () {
        late AuthServices authServices;

        setUp(() {
          authServices = AuthServices.set(
            primaryTokenManager: FakeTokenManagerFactory(
              tokenStorage: fakeTokenStorage,
            ),
            identityProviders: identityProviderFactories,
            additionalTokenManagers: tokenManagers,
          );
        });

        test('then a token manager is accessible', () {
          expect(authServices.tokenManager, isA<MultiTokenManager>());
        });
      });

      group('when AuthServices.set is called multiple times', () {
        late AuthServices firstAuthServices;
        late AuthServices secondAuthServices;
        late FakeTokenManagerFactory secondTokenManagerFactory;
        late FakeTokenStorage secondTokenStorage;

        setUp(() {
          firstAuthServices = AuthServices.set(
            primaryTokenManager: fakeTokenManagerFactory,
            identityProviders: identityProviderFactories,
            additionalTokenManagers: tokenManagers,
          );

          secondTokenStorage = FakeTokenStorage();
          secondTokenManagerFactory = FakeTokenManagerFactory(
            tokenStorage: secondTokenStorage,
          );
          secondAuthServices = AuthServices.set(
            primaryTokenManager: secondTokenManagerFactory,
            identityProviders: identityProviderFactories,
            additionalTokenManagers: tokenManagers,
          );
        });

        test('then the instance is replaced with the new configuration', () {
          expect(AuthServices.instance, equals(secondAuthServices));
          expect(AuthServices.instance, isNot(equals(firstAuthServices)));
        });
      });
    },
  );

  withServerpod(
    'Given an AuthServices with identity providers',
    (final sessionBuilder, final endpoints) {
      late FakeTokenManagerFactory fakeTokenManagerFactory;
      late List<IdentityProviderFactory<Object>> identityProviderFactories;
      late List<TokenManagerFactory> tokenManagerFactories;
      late FakeTokenStorage fakeTokenStorage;

      setUp(() {
        fakeTokenStorage = FakeTokenStorage();
        fakeTokenManagerFactory = FakeTokenManagerFactory(
          tokenStorage: fakeTokenStorage,
        );

        identityProviderFactories = [
          FakeIdentityProviderFactory(),
        ];

        tokenManagerFactories = [
          FakeTokenManagerFactory(tokenStorage: fakeTokenStorage),
        ];

        AuthServices.set(
          primaryTokenManager: fakeTokenManagerFactory,
          identityProviders: identityProviderFactories,
          additionalTokenManagers: tokenManagerFactories,
        );
      });

      group('when provider is constructed during initialization', () {
        test('then constructed provider should have correct token issuer', () {
          final provider =
              AuthServices.getIdentityProvider<FakeIdentityProvider>();
          expect(provider.tokenIssuer, isA<MultiTokenManager>());
        });

        test('then constructed provider should be stored correctly', () {
          final provider =
              AuthServices.getIdentityProvider<FakeIdentityProvider>();
          expect(provider, isA<FakeIdentityProvider>());
          expect(provider, isNotNull);
        });
      });

      group('when retrieving provider by type', () {
        test(
          'then getProvider should return correct provider instance for registered types',
          () {
            final provider =
                AuthServices.getIdentityProvider<FakeIdentityProvider>();
            expect(provider, isA<FakeIdentityProvider>());
            expect(provider.tokenIssuer, isA<MultiTokenManager>());
          },
        );

        test(
          'then StateError should be thrown for unregistered provider types',
          () {
            expect(
              () => AuthServices.getIdentityProvider<String>(),
              throwsA(
                isA<StateError>().having(
                  (final e) => e.message,
                  'message',
                  contains('Provider for String is not registered'),
                ),
              ),
            );
          },
        );
      });

      test(
        'when accessing a registered provider then the provider should be accessible',
        () {
          final provider =
              AuthServices.getIdentityProvider<FakeIdentityProvider>();
          expect(provider, isA<FakeIdentityProvider>());
        },
      );

      test(
        'when accessing an unregistered provider then a StateError is thrown',
        () {
          expect(
            () => AuthServices.getIdentityProvider<String>(),
            throwsA(isA<StateError>()),
          );
        },
      );
    },
  );

  withServerpod(
    'Given an AuthServices with multiple identity providers',
    (final sessionBuilder, final endpoints) {
      late FakeTokenManagerFactory fakeTokenManagerFactory;
      late List<IdentityProviderFactory<Object>> multipleProviderFactories;
      late List<TokenManagerFactory> tokenManagers;
      late FakeTokenStorage fakeTokenStorage;
      late FakeIdentityProviderFactory firstFactory;
      late FakeIdentityProviderFactory secondFactory;

      setUp(() {
        fakeTokenStorage = FakeTokenStorage();
        fakeTokenManagerFactory = FakeTokenManagerFactory(
          tokenStorage: fakeTokenStorage,
        );

        firstFactory = FakeIdentityProviderFactory();
        secondFactory = FakeIdentityProviderFactory();
        multipleProviderFactories = [firstFactory, secondFactory];

        tokenManagers = [
          FakeTokenManagerFactory(tokenStorage: fakeTokenStorage),
        ];

        AuthServices.set(
          primaryTokenManager: fakeTokenManagerFactory,
          identityProviders: multipleProviderFactories,
          additionalTokenManagers: tokenManagers,
        );
      });

      group('when accessing providers', () {
        test('then each provider should be accessible independently', () {
          final provider =
              AuthServices.getIdentityProvider<FakeIdentityProvider>();
          expect(provider, isA<FakeIdentityProvider>());
          expect(provider.tokenIssuer, isA<MultiTokenManager>());
        });
      });
    },
  );

  withServerpod(
    'Given an AuthServices with authentication handler',
    (final sessionBuilder, final endpoints) {
      late FakeTokenManagerFactory fakeTokenManagerFactory;
      late List<IdentityProviderFactory<Object>> identityProviderFactories;
      late List<TokenManagerFactory> tokenManagers;
      late FakeTokenStorage fakeTokenStorage;
      late Session session;
      late AuthServices authServices;
      late UuidValue authUserId;

      setUp(() async {
        session = sessionBuilder.build();
        fakeTokenStorage = FakeTokenStorage();
        fakeTokenManagerFactory = FakeTokenManagerFactory(
          tokenStorage: fakeTokenStorage,
        );

        identityProviderFactories = [
          FakeIdentityProviderFactory(),
        ];

        tokenManagers = [
          FakeTokenManagerFactory(tokenStorage: fakeTokenStorage),
        ];

        authServices = AuthServices.set(
          primaryTokenManager: fakeTokenManagerFactory,
          identityProviders: identityProviderFactories,
          additionalTokenManagers: tokenManagers,
        );
        authUserId = (await authServices.authUsers.create(session)).id;
      });

      group('when validating a valid token with single scope', () {
        late AuthenticationInfo? result;
        late String validToken;

        setUp(() async {
          final authSuccess = await authServices.tokenManager.issueToken(
            session,
            authUserId: authUserId,
            method: 'test-method',
            scopes: {const Scope('test-scope')},
          );
          validToken = authSuccess.token;

          result = await authServices.authenticationHandler(
            session,
            validToken,
          );
        });

        test('then authentication info should be returned', () {
          expect(result, isNotNull);
        });

        test('then the user identifier should match', () {
          expect(result!.userIdentifier, equals(authUserId.uuid));
        });

        test('then the scopes should match', () {
          expect(
            result!.scopes.map((final s) => s.name),
            contains('test-scope'),
          );
        });
      });

      group('when validating a token with multiple scopes', () {
        late String validToken;

        setUp(() async {
          final authSuccess = await authServices.tokenManager.issueToken(
            session,
            authUserId: authUserId,
            method: 'oauth',
            scopes: {
              const Scope('read'),
              const Scope('write'),
              const Scope('admin'),
            },
          );
          validToken = authSuccess.token;
        });

        test('then all scopes should be included', () async {
          final result = await authServices.authenticationHandler(
            session,
            validToken,
          );

          expect(result, isNotNull);
          final scopeNames = result!.scopes.map((final s) => s.name);
          expect(scopeNames, contains('read'));
          expect(scopeNames, contains('write'));
          expect(scopeNames, contains('admin'));
        });
      });

      group('when validating invalid tokens', () {
        test('then null should be returned for invalid token', () async {
          final result = await authServices.authenticationHandler(
            session,
            'invalid-token',
          );

          expect(result, isNull);
        });

        test('then null should be returned for empty token', () async {
          final result = await authServices.authenticationHandler(session, '');

          expect(result, isNull);
        });
      });
    },
  );
}
