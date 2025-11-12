import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/profile.dart';
import 'package:serverpod_auth_core_server/src/common/business/multi_token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/token_manager_factory.dart';

import '../integrations/provider_factory.dart';

/// Global configuration for auth providers that are exposed through endpoints.
/// This object is also used to manage the lifecycle of authentication tokens
/// regardless of who issues the token.
class AuthServices {
  /// Returns the singleton instance of [AuthServices] used by the provider
  /// endpoints.
  static AuthServices get instance {
    final localInstance = _instance;
    if (localInstance == null) {
      throw StateError(
        'AuthServices is not set. Call AuthServices.set() to initialize it before accessing the instance.',
      );
    }

    return localInstance;
  }

  static AuthServices? _instance;

  /// Creates a new [AuthServices] instance and sets it as the global instance.
  ///
  /// [authUsersConfig] is the configuration for the auth users manager.
  /// [userProfileConfig] is the configuration for the user profiles manager.
  /// [primaryTokenManager] is the factory for the primary token manager.
  /// [identityProviders] is a list of factories for the identity providers.
  /// [additionalTokenManagers] is a list of factories for the additional token managers.
  ///
  /// These are passed to the [AuthServices] constructor to create the instance.
  /// {@macro auth_services_constructor}
  factory AuthServices.set({
    final AuthUsersConfig authUsersConfig = const AuthUsersConfig(),
    final UserProfileConfig userProfileConfig = const UserProfileConfig(),
    required final TokenManagerFactory primaryTokenManager,
    required final List<IdentityProviderFactory> identityProviders,
    final List<TokenManagerFactory> additionalTokenManagers = const [],
  }) {
    final instance = AuthServices(
      authUsers: AuthUsers(config: authUsersConfig),
      userProfiles: UserProfiles(config: userProfileConfig),
      primaryTokenManager: primaryTokenManager,
      identityProviders: identityProviders,
      additionalTokenManagers: additionalTokenManagers,
    );
    return _instance = instance;
  }

  /// Creates a new [AuthServices] instance.
  ///
  /// Use [AuthServices.set] to create a new instance and set it as the global instance.
  /// {@template auth_services_constructor}
  /// [authUsers] is the default manager for managing auth users.
  ///
  /// [userProfiles] is the default manager for managing user profiles.
  ///
  /// [primaryTokenManager] is the primary token manager used by identity providers
  /// for issuing new tokens. The factory is used to construct the token manager
  /// instance with the necessary dependencies.
  ///
  /// [identityProviders] is a list of [IdentityProviderFactory] instances that
  /// construct the identity providers used by authentication endpoints. Each factory
  /// creates a provider instance with the appropriate token manager dependency.
  ///
  /// [additionalTokenManagers] is a list of additional token managers factories
  /// that are used to construct additional token managers that handle token lifecycle
  /// operations alongside the [primaryTokenManager]. These additional token managers
  /// are used to validate tokens in the same order they are represented in the list.
  /// {@endtemplate}
  AuthServices({
    required this.authUsers,
    required this.userProfiles,
    required final TokenManagerFactory primaryTokenManager,
    required final List<IdentityProviderFactory> identityProviders,
    final List<TokenManagerFactory> additionalTokenManagers = const [],
  }) {
    tokenManager = MultiTokenManager(
      primaryTokenManager: primaryTokenManager.construct(authUsers: authUsers),
      additionalTokenManagers: additionalTokenManagers
          .map(
            (final factory) => factory.construct(authUsers: authUsers),
          )
          .toList(),
    );

    for (final provider in identityProviders) {
      _providers[provider.type] = provider.construct(
        tokenManager: tokenManager,
        authUsers: authUsers,
        userProfiles: userProfiles,
      );
    }
  }

  final Map<Type, Object> _providers = {};

  /// Retrieves the identity provider of type [T].
  static T getIdentityProvider<T>() {
    final provider = instance._providers[T];
    if (provider == null) {
      throw StateError(
        'Provider for $T is not registered. '
        'To register this provider, add its IdentityProviderFactory to the identityProviders list when calling AuthServices.set(). '
        'Example: AuthServices.set(defaultTokenManager: ..., identityProviders: [YourProviderFactory()])',
      );
    }
    return provider as T;
  }

  /// Manager for managing auth users.
  final AuthUsers authUsers;

  /// Manager for managing user profiles.
  final UserProfiles userProfiles;

  /// The token manager that handles token lifecycle operations.
  late final MultiTokenManager tokenManager;

  /// Validates an authentication token and returns the associated authentication info.
  ///
  /// This handler delegates to the [tokenManager] to validate the provided [key]
  /// against all registered token managers. Returns [AuthenticationInfo] if the
  /// token is valid, or `null` if validation fails.
  Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String key,
  ) async {
    return tokenManager.validateToken(session, key);
  }

  /// Retrieves the token manager of type [T].
  static T getTokenManager<T extends TokenManager>() {
    return instance.tokenManager.getTokenManager<T>();
  }
}
