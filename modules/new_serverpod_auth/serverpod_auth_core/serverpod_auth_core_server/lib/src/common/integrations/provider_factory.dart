import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';

/// Interface for factories that can create auth providers.
/// These factories are responsible for constructing instances of auth providers
/// with the necessary dependencies that can then be used by provider endpoints.
abstract class IdentityProviderFactory<T extends Object> {
  /// The type of the provider that this factory creates.
  /// Used to store the provider in the AuthConfig.
  Type get type => T;

  /// Default constructor that allows for overriding the token manager.
  IdentityProviderFactory({
    this.tokenManagerOverride,
  });

  /// Optional [TokenManager] to override for this provider.
  /// If null, the default manager will be used.
  final TokenManager? tokenManagerOverride;

  /// Constructs a new instance of the provider.
  T construct({required final TokenManager tokenManager});
}
