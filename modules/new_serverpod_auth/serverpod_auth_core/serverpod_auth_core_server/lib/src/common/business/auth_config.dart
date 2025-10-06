import 'package:serverpod_auth_core_server/src/common/business/provider_factory.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_provider.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/src/jwt/business/jwt_provider.dart';
import 'package:serverpod_auth_core_server/src/session/business/sas_provider.dart';

/// Global configuration for auth providers that are exposed through endpoints.
/// This object is also used to manage the lifecycle of authentication tokens
/// regardless of who issues the token.
class AuthConfig {
  /// Default token providers for JWT and session-based authentication.
  static Map<String, TokenProvider> get defaultTokenProviders => {
        AuthStrategy.jwt.name: JwtTokenProvider(),
        AuthStrategy.session.name: SasTokenProvider(),
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
  /// [tokenIssuer] is the token issuer used by the identity providers.
  /// Serverpod provided token issuers are [JwtTokenIssuer] and [SasTokenIssuer].
  ///
  /// [identityProviders] is a list of factories that can create the identity
  /// providers used by the authentication endpoints.
  ///
  /// [tokenProviders] is a map of token providers that can be used to manage
  /// the lifecycle of authentication tokens. If not provided, the default
  /// token providers will be used.
  factory AuthConfig.set({
    required final TokenIssuer tokenIssuer,
    required final List<IdentityProviderFactory<dynamic>> identityProviders,
    final Map<String, TokenProvider>? tokenProviders,
  }) {
    final instance = AuthConfig._(
      defaultTokenIssuer: tokenIssuer,
      identityProviders: identityProviders,
      tokenProviders: tokenProviders ?? defaultTokenProviders,
    );
    _instance = instance;
    return instance;
  }

  AuthConfig._({
    required this.defaultTokenIssuer,
    required final List<IdentityProviderFactory<dynamic>> identityProviders,
    required final Map<String, TokenProvider> tokenProviders,
  }) {
    for (final provider in identityProviders) {
      _providers[provider.type] = provider.construct(
        tokenIssuer: provider.tokenIssuerOverride ?? defaultTokenIssuer,
      );
    }
    tokenManager = TokenManager(tokenProviders);
  }

  final Map<Type, dynamic> _providers = {};

  /// Retrieves the provider of type [T].
  static T getProvider<T>() {
    final provider = instance._providers[T];
    if (provider == null) {
      throw StateError('Provider for $T is not registered');
    }
    return provider as T;
  }

  /// The token issuer used by the identity providers.
  final TokenIssuer defaultTokenIssuer;

  /// The token manager that handles token lifecycle operations.
  late final TokenManager tokenManager;
}
