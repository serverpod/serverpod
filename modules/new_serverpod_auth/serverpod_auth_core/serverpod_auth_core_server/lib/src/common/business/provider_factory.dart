import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';

/// Interface for factories that can create auth providers.
/// These factories are responsible for constructing instances of auth providers
/// with the necessary dependencies that can then be used by provider endpoints.
abstract interface class IdentityProviderFactory<T> {
  /// The type of the provider that this factory creates.
  /// Used to store the provider in the AuthConfig.
  Type get type;

  /// Constructs a new instance of the provider.
  T construct({required final TokenIssuer defaultTokenIssuer});
}
