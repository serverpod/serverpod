import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/src/common/business/multi_token_manager.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';
import 'fakes/fakes.dart';

void main() {
  withServerpod(
    'Given AuthServices is being configured',
    (final sessionBuilder, final endpoints) {
      late FakeTokenManager fakeTokenManager;
      late List<IdentityProviderFactory<Object>> identityProviderFactories;
      late List<TokenManager> tokenManagers;
      late FakeTokenStorage fakeTokenStorage;

      setUp(() {
        fakeTokenStorage = FakeTokenStorage();
        fakeTokenManager = FakeTokenManager(fakeTokenStorage);

        identityProviderFactories = [
          FakeIdentityProviderFactory(),
        ];

        tokenManagers = [
          FakeTokenManager(fakeTokenStorage),
        ];
      });

      group('when AuthServices.set is called with valid parameters', () {
        late AuthServices authServices;

        setUp(() {
          authServices = AuthServices.set(
            primaryTokenManager: fakeTokenManager,
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
        late FakeTokenManager secondTokenManager;
        late FakeTokenStorage secondTokenStorage;

        setUp(() {
          firstAuthServices = AuthServices.set(
            primaryTokenManager: fakeTokenManager,
            identityProviders: identityProviderFactories,
            additionalTokenManagers: tokenManagers,
          );

          secondTokenStorage = FakeTokenStorage();
          secondTokenManager = FakeTokenManager(secondTokenStorage);
          secondAuthServices = AuthServices.set(
            primaryTokenManager: secondTokenManager,
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
      late FakeTokenManager fakeTokenManager;
      late List<IdentityProviderFactory<Object>> identityProviderFactories;
      late List<TokenManager> tokenManagers;
      late FakeTokenStorage fakeTokenStorage;

      setUp(() {
        fakeTokenStorage = FakeTokenStorage();
        fakeTokenManager = FakeTokenManager(fakeTokenStorage);

        identityProviderFactories = [
          FakeIdentityProviderFactory(),
        ];

        tokenManagers = [
          FakeTokenManager(fakeTokenStorage),
        ];

        AuthServices.set(
          primaryTokenManager: fakeTokenManager,
          identityProviders: identityProviderFactories,
          additionalTokenManagers: tokenManagers,
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
        });

        test('then StateError should be thrown for unregistered provider types',
            () {
          expect(
            () => AuthServices.getIdentityProvider<String>(),
            throwsA(isA<StateError>().having(
              (final e) => e.message,
              'message',
              contains('Provider for String is not registered'),
            )),
          );
        });
      });

      test(
          'when accessing a registered provider then the provider should be accessible',
          () {
        final provider =
            AuthServices.getIdentityProvider<FakeIdentityProvider>();
        expect(provider, isA<FakeIdentityProvider>());
      });

      test(
          'when accessing an unregistered provider then a StateError is thrown',
          () {
        expect(
          () => AuthServices.getIdentityProvider<String>(),
          throwsA(isA<StateError>()),
        );
      });
    },
  );

  withServerpod(
    'Given an AuthServices with multiple identity providers',
    (final sessionBuilder, final endpoints) {
      late FakeTokenManager fakeTokenManager;
      late List<IdentityProviderFactory<Object>> multipleProviderFactories;
      late List<TokenManager> tokenManagers;
      late FakeTokenStorage fakeTokenStorage;
      late FakeIdentityProviderFactory firstFactory;
      late FakeIdentityProviderFactory secondFactory;

      setUp(() {
        fakeTokenStorage = FakeTokenStorage();
        fakeTokenManager = FakeTokenManager(fakeTokenStorage);

        firstFactory = FakeIdentityProviderFactory();
        secondFactory = FakeIdentityProviderFactory();
        multipleProviderFactories = [firstFactory, secondFactory];

        tokenManagers = [
          FakeTokenManager(fakeTokenStorage),
        ];

        AuthServices.set(
          primaryTokenManager: fakeTokenManager,
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
      late FakeTokenManager fakeTokenManager;
      late List<IdentityProviderFactory<Object>> identityProviderFactories;
      late List<TokenManager> tokenManagers;
      late FakeTokenStorage fakeTokenStorage;
      late Session session;
      late AuthServices authServices;

      setUp(() {
        session = sessionBuilder.build();
        fakeTokenStorage = FakeTokenStorage();
        fakeTokenManager = FakeTokenManager(fakeTokenStorage);

        identityProviderFactories = [
          FakeIdentityProviderFactory(),
        ];

        tokenManagers = [
          FakeTokenManager(fakeTokenStorage),
        ];

        authServices = AuthServices.set(
          primaryTokenManager: fakeTokenManager,
          identityProviders: identityProviderFactories,
          additionalTokenManagers: tokenManagers,
        );
      });

      group('when validating a valid token with single scope', () {
        late AuthenticationInfo? result;
        late String validToken;

        setUp(() async {
          final authSuccess = await fakeTokenManager.issueToken(session,
              authUserId: UuidValue.fromString('user-123'),
              method: 'test-method',
              scopes: {const Scope('test-scope')});
          validToken = authSuccess.token;

          result =
              await authServices.authenticationHandler(session, validToken);
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

      group('when validating a token with multiple scopes', () {
        late String validToken;

        setUp(() async {
          final authSuccess = await fakeTokenManager.issueToken(session,
              authUserId: UuidValue.fromString('user-456'),
              method: 'oauth',
              scopes: {
                const Scope('read'),
                const Scope('write'),
                const Scope('admin')
              });
          validToken = authSuccess.token;
        });

        test('then all scopes should be included', () async {
          final result =
              await authServices.authenticationHandler(session, validToken);

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
