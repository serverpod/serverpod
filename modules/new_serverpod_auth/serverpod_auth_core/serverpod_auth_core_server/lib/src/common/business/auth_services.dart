import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/multi_token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';

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
  /// {@macro auth_services_constructor}
  factory AuthServices.set({
    required final TokenManager primaryTokenManager,
    required final List<IdentityProviderFactory<Object>> identityProviders,
    final List<TokenManager> additionalTokenManagers = const [],
  }) {
    final instance = AuthServices(
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
  /// [primaryTokenManager] is the primary token manager used by identity providers
  /// for issuing new tokens. Each identity provider can optionally override this
  /// with their own token manager via [IdentityProviderFactory.tokenManagerOverride].
  ///
  /// [identityProviders] is a list of [IdentityProviderFactory] instances that
  /// construct the identity providers used by authentication endpoints. Each factory
  /// creates a provider instance with the appropriate token manager dependency.
  ///
  /// [additionalTokenManagers] is a list of additional token managers that
  /// handle token lifecycle operations alongside the [primaryTokenManager].
  /// These additional token managers are also used to validate tokens in the
  /// same order they are represented in the list.
  /// {@endtemplate}
  AuthServices({
    required final TokenManager primaryTokenManager,
    required final List<IdentityProviderFactory<Object>> identityProviders,
    final List<TokenManager> additionalTokenManagers = const [],
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
