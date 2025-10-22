import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/multi_token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/business/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';

/// Global configuration for auth providers that are exposed through endpoints.
/// This object is also used to manage the lifecycle of authentication tokens
/// regardless of who issues the token.
class AuthConfig {
  /// Returns the singleton instance of [AuthConfig] used by the provider
  /// endpoints.
  static AuthConfig get instance {
    final localInstance = _instance;
    if (localInstance == null) {
      throw StateError(
        'AuthConfig is not set. Call AuthConfig.set() to initialize it before accessing the instance.',
      );
    }

    return localInstance;
  }

  static AuthConfig? _instance;

  /// Sets the [AuthConfig] instance.
  ///
  /// [primaryTokenManager] is the primary token manager used by identity providers
  /// for issuing new tokens. Each identity provider can optionally override this
  /// with their own token manager via [IdentityProviderFactory.tokenManagerOverride].
  ///
  /// [identityProviders] is a list of [IdentityProviderFactory] instances that
  /// construct the identity providers used by authentication endpoints. Each factory
  /// creates a provider instance with the appropriate token manager dependency.
  ///
  /// [additionalTokenManagers] is a map of additional token managers keyed by strategy
  /// name (e.g., 'jwt', 'session') that handle token lifecycle operations alongside the
  /// [primaryTokenManager]. The default token manager is always included automatically.
  factory AuthConfig.set({
    required final TokenManager primaryTokenManager,
    required final List<IdentityProviderFactory<IdentityProvider>>
        identityProviders,
    final List<TokenManager> additionalTokenManagers = const [],
  }) {
    final instance = AuthConfig._(
      primaryTokenManager: primaryTokenManager,
      identityProviders: identityProviders,
      additionalTokenManagers: additionalTokenManagers,
    );
    return _instance = instance;
  }

  AuthConfig._({
    required final TokenManager primaryTokenManager,
    required final List<IdentityProviderFactory<IdentityProvider>>
        identityProviders,
    required final List<TokenManager> additionalTokenManagers,
  }) {
    tokenManager = MultiTokenManager(
      primaryTokenManager: primaryTokenManager,
      additionalTokenManagers: additionalTokenManagers,
    );

    for (final provider in identityProviders) {
      _providers[provider.type] = provider.construct(
        tokenManager: provider.tokenManagerOverride ?? tokenManager,
      );
    }
  }

  final Map<Type, IdentityProvider> _providers = {};

  /// Retrieves the identity provider of type [T].
  static T getIdentityProvider<T>() {
    final provider = instance._providers[T];
    if (provider == null) {
      throw StateError(
        'Provider for $T is not registered. '
        'To register this provider, add its IdentityProviderFactory to the identityProviders list when calling AuthConfig.set(). '
        'Example: AuthConfig.set(defaultTokenManager: ..., identityProviders: [YourProviderFactory()])',
      );
    }
    return provider as T;
  }

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
}
