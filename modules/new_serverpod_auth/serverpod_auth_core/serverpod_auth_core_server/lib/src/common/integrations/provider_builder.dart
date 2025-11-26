import '../../profile/profile.dart';
import 'token_manager.dart';

/// Interface for building identity providers.
///
/// Responsible for building instances of identity providers with dependencies
/// that can then be used by provider endpoints.
abstract interface class IdentityProviderBuilder<T extends Object> {
  /// Builds a new instance of the identity provider.
  ///
  /// [tokenManager] is the token manager to use for the provider.
  /// [authUsers] is the manager for managing auth users.
  /// [userProfiles] is the manager for managing user profiles.
  T build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  });
}

/// Extension methods for [IdentityProviderBuilder].
extension IdpBuilderExtension<T extends Object> on IdentityProviderBuilder<T> {
  /// The type of the provider that this builder creates.
  /// Used to store the provider in the AuthConfig.
  Type get type => T;
}

/// A builder that returns a pre-built identity provider.
///
/// Use this builder if you have a provider built from outside of the Serverpod
/// authentication framework.
class PreBuiltIdpBuilder<T extends Object>
    implements IdentityProviderBuilder<T> {
  /// The pre-built identity provider.
  final T idp;

  /// Creates a new [PreBuiltIdpBuilder] instance.
  const PreBuiltIdpBuilder(this.idp);

  @override
  T build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) => idp;
}
