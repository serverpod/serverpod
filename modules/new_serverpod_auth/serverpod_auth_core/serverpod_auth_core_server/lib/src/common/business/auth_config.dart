import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/multi_token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/business/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/jwt_provider.dart';
import 'package:serverpod_auth_core_server/src/session/business/sas_provider.dart';

/// Global configuration for auth providers that are exposed through endpoints.
/// This object is also used to manage the lifecycle of authentication tokens
/// regardless of who issues the token.
class AuthConfig {
  /// Default token managers for JWT and session-based authentication.
  static Map<String, TokenManager> get defaultTokenManagers => {
        AuthStrategy.jwt.name: JwtTokenManager(),
        AuthStrategy.session.name: SasTokenManager(),
      };

  /// Returns the singleton instance of [AuthConfig] used by the provider
  /// endpoints.
  static AuthConfig get instance {
    final localInstance = _instance;
    if (localInstance == null) {
      throw StateError('AuthConfig is not initialized');
    }

    return localInstance;
  }

  static AuthConfig? _instance;

  /// Sets the [AuthConfig] instance.
  ///
  /// [defaultTokenManager] is the primary token manager used by identity providers
  /// for issuing new tokens. Each identity provider can optionally override this
  /// with their own token manager via [IdentityProviderFactory.tokenManagerOverride].
  ///
  /// [identityProviders] is a list of [IdentityProviderFactory] instances that
  /// construct the identity providers used by authentication endpoints. Each factory
  /// creates a provider instance with the appropriate token manager dependency.
  ///
  /// [tokenManagers] is a map of token managers keyed by strategy name (e.g., 'jwt', 'session')
  /// that handle token lifecycle operations. If not provided, defaults to built-in
  /// [JwtTokenManager] and [SasTokenManager] instances.
  factory AuthConfig.set({
    required final TokenManager defaultTokenManager,
    required final List<IdentityProviderFactory<IdentityProvider>>
        identityProviders,
    final Map<String, TokenManager>? tokenManagers,
  }) {
    final instance = AuthConfig._(
      defaultTokenManager: defaultTokenManager,
      identityProviders: identityProviders,
      tokenManagers: tokenManagers ?? defaultTokenManagers,
    );
    return _instance = instance;
  }

  AuthConfig._({
    required final TokenManager defaultTokenManager,
    required final List<IdentityProviderFactory<IdentityProvider>>
        identityProviders,
    required final Map<String, TokenManager> tokenManagers,
  }) {
    tokenManager = MultiTokenManager(
      defaultTokenManager: defaultTokenManager,
      additionalTokenManagers: tokenManagers.values.toList(),
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
      throw StateError('Provider for $T is not registered');
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
