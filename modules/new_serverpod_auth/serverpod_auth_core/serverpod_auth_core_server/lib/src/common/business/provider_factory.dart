import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';

/// Interface for factories that can create auth providers.
/// These factories are responsible for constructing instances of auth providers
/// with the necessary dependencies that can then be used by provider endpoints.
abstract class IdentityProviderFactory<T> {
  /// The type of the provider that this factory creates.
  /// Used to store the provider in the AuthConfig.
  Type get type => T;

  /// Optional [TokenIssuer] to override for this provider. If null, the default issuer will be used.
  TokenIssuer? get tokenIssuerOverride => null;

  /// Constructs a new instance of the provider.
  T construct({required final TokenIssuer tokenIssuer});
}
