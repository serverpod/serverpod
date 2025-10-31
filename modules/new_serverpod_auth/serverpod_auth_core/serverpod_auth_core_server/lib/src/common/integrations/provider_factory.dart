import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';

/// Base interface for all identity providers in the Serverpod auth system.
abstract interface class IdentityProvider {
  /// The token issuer used by this provider for creating authentication tokens.
  TokenIssuer get tokenIssuer;
}

/// Interface for factories that can create auth providers.
/// These factories are responsible for constructing instances of auth providers
/// with the necessary dependencies that can then be used by provider endpoints.
abstract class IdentityProviderFactory<T extends IdentityProvider> {
  /// The type of the provider that this factory creates.
  /// Used to store the provider in the AuthConfig.
  Type get type => T;

  /// Optional [TokenManager] to override for this provider. If null, the default manager will be used.
  TokenManager? get tokenManagerOverride => null;

  /// Constructs a new instance of the provider.
  T construct({required final TokenManager tokenManager});
}
