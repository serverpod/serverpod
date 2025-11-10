import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/src/auth_user/business/auth_users_config.dart';
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
        fakeTokenManagerFactory =
            FakeTokenManagerFactory(tokenStorage: fakeTokenStorage);

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
            primaryTokenManager:
                FakeTokenManagerFactory(tokenStorage: fakeTokenStorage),
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
              scopes: {const Scope('test-scope')});
          validToken = authSuccess.token;

          result =
              await authServices.authenticationHandler(session, validToken);
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

  withServerpod(
    'Given an AuthServices with identity providers that have overrides',
    (final sessionBuilder, final endpoints) {
      late FakeTokenManagerFactory fakeTokenManagerFactory;
      late FakeTokenStorage fakeTokenStorage;
      late Session session;

      setUp(() async {
        session = sessionBuilder.build();
        fakeTokenStorage = FakeTokenStorage();
        fakeTokenManagerFactory = FakeTokenManagerFactory(
          tokenStorage: fakeTokenStorage,
        );

        // Create AuthUsers override that adds a scope when creating users
        final authUsersWithOverride = AuthUsers(
          config: AuthUsersConfig(
            onBeforeAuthUserCreated: (
              final session,
              final scopes,
              final blocked, {
              required final transaction,
            }) async {
              // Add an override scope to all created users
              return (
                scopes: {...scopes, const Scope('override-scope')},
                blocked: blocked,
              );
            },
          ),
        );

        // Create UserProfiles override that modifies the profile
        final userProfilesWithOverride = UserProfiles(
          config: UserProfileConfig(
            onBeforeUserProfileCreated: (
              final session,
              final authUserId,
              final userProfile, {
              required final transaction,
            }) async {
              // Add a prefix to userName if it exists
              return userProfile.copyWith(
                userName: userProfile.userName != null
                    ? 'override-${userProfile.userName}'
                    : null,
              );
            },
          ),
        );

        // Create identity providers - one with overrides, one without
        final identityProviderFactories = <IdentityProviderFactory<Object>>[
          FakeIdentityProviderFactory(),
          FakeIdentityProviderWithOverridesFactory(
            authUsersOverride: authUsersWithOverride,
            userProfilesOverride: userProfilesWithOverride,
          ),
        ];

        final tokenManagers = [
          FakeTokenManagerFactory(tokenStorage: fakeTokenStorage),
        ];

        AuthServices.set(
          primaryTokenManager: fakeTokenManagerFactory,
          identityProviders: identityProviderFactories,
          additionalTokenManagers: tokenManagers,
        );
      });

      group('when creating a user through provider without overrides', () {
        late AuthUserModel createdUser;
        late UserProfileModel createdProfile;

        setUp(() async {
          final provider =
              AuthServices.getIdentityProvider<FakeIdentityProvider>();
          createdUser = await provider.authUsers.create(
            session,
            scopes: {const Scope('test-scope')},
          );
          createdProfile = await provider.userProfiles.createUserProfile(
            session,
            createdUser.id,
            UserProfileData(userName: 'testuser'),
          );
        });

        test('then the user should have only the provided scopes', () {
          expect(createdUser.scopes.map((final s) => s.name), {
            'test-scope',
          });
        });

        test('then the profile should have the original userName', () {
          expect(createdProfile.userName, 'testuser');
        });
      });

      group('when creating a user through provider with overrides', () {
        late AuthUserModel createdUser;
        late UserProfileModel createdProfile;

        setUp(() async {
          final provider = AuthServices.getIdentityProvider<
              FakeIdentityProviderWithOverrides>();
          createdUser = await provider.authUsers.create(
            session,
            scopes: {const Scope('test-scope')},
          );
          createdProfile = await provider.userProfiles.createUserProfile(
            session,
            createdUser.id,
            UserProfileData(userName: 'testuser'),
          );
        });

        test('then the user should have the override scope added', () {
          expect(createdUser.scopes.map((final s) => s.name), {
            'test-scope',
            'override-scope',
          });
        });

        test('then the profile should have the userName modified with prefix',
            () {
          expect(createdProfile.userName, 'override-testuser');
        });
      });
    },
  );

  withServerpod(
    'Given an AuthServices with primary token manager and additional token manager without authUsersOverride',
    (final sessionBuilder, final endpoints) {
      late FakePrimaryTokenManagerFactory primaryTokenManagerFactory;
      late FakeAdditionalTokenManagerFactory additionalTokenManagerFactory;
      late FakeTokenStorage primaryTokenStorage;
      late FakeTokenStorage additionalTokenStorage;
      late AuthServices authServices;
      late AuthUsers defaultAuthUsers;

      setUp(() {
        primaryTokenStorage = FakeTokenStorage();
        additionalTokenStorage = FakeTokenStorage();
        defaultAuthUsers = const AuthUsers();

        primaryTokenManagerFactory = FakePrimaryTokenManagerFactory(
          tokenStorage: primaryTokenStorage,
          // No authUsersOverride
        );

        additionalTokenManagerFactory = FakeAdditionalTokenManagerFactory(
          tokenStorage: additionalTokenStorage,
          // No authUsersOverride
        );

        authServices = AuthServices.set(
          primaryTokenManager: primaryTokenManagerFactory,
          identityProviders: [FakeIdentityProviderFactory()],
          additionalTokenManagers: [additionalTokenManagerFactory],
        );
      });

      group('when retrieving authUsers from token managers', () {
        test('then primary token manager should use default authUsers', () {
          final primaryTokenManager = authServices
              .tokenManager.primaryTokenManager as FakePrimaryTokenManager;
          expect(primaryTokenManager.authUsers, same(defaultAuthUsers));
        });

        test('then additional token manager should use default authUsers', () {
          final additionalTokenManager = authServices.tokenManager
              .getTokenManager<FakeAdditionalTokenManager>();
          expect(additionalTokenManager.authUsers, same(defaultAuthUsers));
        });
      });
    },
  );

  withServerpod(
    'Given an AuthServices with primary token manager and additional token manager with authUsersOverride',
    (final sessionBuilder, final endpoints) {
      late FakePrimaryTokenManagerFactory primaryTokenManagerFactory;
      late FakeAdditionalTokenManagerFactory additionalTokenManagerFactory;
      late FakeTokenStorage primaryTokenStorage;
      late FakeTokenStorage additionalTokenStorage;
      late AuthServices authServices;
      late AuthUsers defaultAuthUsers;
      late AuthUsers overrideAuthUsers;

      setUp(() {
        primaryTokenStorage = FakeTokenStorage();
        additionalTokenStorage = FakeTokenStorage();
        defaultAuthUsers = const AuthUsers();

        // Create AuthUsers override that adds a scope when creating users
        overrideAuthUsers = AuthUsers(
          config: AuthUsersConfig(
            onBeforeAuthUserCreated: (
              final session,
              final scopes,
              final blocked, {
              required final transaction,
            }) async {
              // Add an override scope to all created users
              return (
                scopes: {...scopes, const Scope('override-scope')},
                blocked: blocked,
              );
            },
          ),
        );

        primaryTokenManagerFactory = FakePrimaryTokenManagerFactory(
          tokenStorage: primaryTokenStorage,
          // No authUsersOverride
        );

        additionalTokenManagerFactory = FakeAdditionalTokenManagerFactory(
          tokenStorage: additionalTokenStorage,
          authUsersOverride: overrideAuthUsers,
        );

        authServices = AuthServices.set(
          primaryTokenManager: primaryTokenManagerFactory,
          identityProviders: [FakeIdentityProviderFactory()],
          additionalTokenManagers: [additionalTokenManagerFactory],
        );
      });

      group('when retrieving authUsers from token managers', () {
        test('then primary token manager should use default authUsers', () {
          final primaryTokenManager =
              authServices.tokenManager.primaryTokenManager as FakeTokenManager;
          expect(primaryTokenManager.authUsers, same(defaultAuthUsers));
        });

        test('then additional token manager should use override authUsers', () {
          final additionalTokenManager = authServices.tokenManager
              .getTokenManager<FakeAdditionalTokenManager>();
          expect(additionalTokenManager.authUsers, same(overrideAuthUsers));
        });
      });
    },
  );
}

class FakeIdentityProviderWithOverrides {
  final TokenManager tokenManager;
  final AuthUsers authUsers;
  final UserProfiles userProfiles;

  FakeIdentityProviderWithOverrides({
    required this.tokenManager,
    required this.authUsers,
    required this.userProfiles,
  });
}

class FakeIdentityProviderWithOverridesFactory
    extends IdentityProviderFactory<FakeIdentityProviderWithOverrides> {
  FakeIdentityProviderWithOverridesFactory({
    super.tokenManagerOverride,
    super.authUsersOverride,
    super.userProfilesOverride,
  });

  @override
  FakeIdentityProviderWithOverrides construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return FakeIdentityProviderWithOverrides(
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

class FakePrimaryTokenManager extends FakeTokenManager {
  FakePrimaryTokenManager(
    super.tokenStorage, {
    super.authUsers = const AuthUsers(),
  });
}

class FakePrimaryTokenManagerFactory
    extends TokenManagerFactory<FakePrimaryTokenManager> {
  FakePrimaryTokenManagerFactory({
    required this.tokenStorage,
    super.authUsersOverride,
  });

  final FakeTokenStorage tokenStorage;

  @override
  FakePrimaryTokenManager construct({required final AuthUsers authUsers}) {
    return FakePrimaryTokenManager(tokenStorage, authUsers: authUsers);
  }
}

class FakeAdditionalTokenManager extends FakeTokenManager {
  FakeAdditionalTokenManager(
    super.tokenStorage, {
    super.authUsers = const AuthUsers(),
  });
}

class FakeAdditionalTokenManagerFactory
    extends TokenManagerFactory<FakeAdditionalTokenManager> {
  FakeAdditionalTokenManagerFactory({
    required this.tokenStorage,
    super.authUsersOverride,
  });

  final FakeTokenStorage tokenStorage;

  @override
  FakeAdditionalTokenManager construct({required final AuthUsers authUsers}) {
    return FakeAdditionalTokenManager(tokenStorage, authUsers: authUsers);
  }
}
