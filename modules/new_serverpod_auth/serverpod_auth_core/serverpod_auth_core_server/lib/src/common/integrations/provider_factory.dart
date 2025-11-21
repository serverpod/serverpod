import '../../profile/profile.dart';
import 'token_manager.dart';

/// Interface for factories that can create auth providers.
/// These factories are responsible for constructing instances of auth providers
/// with the necessary dependencies that can then be used by provider endpoints.
abstract class IdentityProviderFactory<T extends Object> {
  /// The type of the provider that this factory creates.
  /// Used to store the provider in the AuthConfig.
  Type get type => T;

  /// Constructs a new instance of the provider.
  ///
  /// [tokenManager] is the token manager to use for the provider.
  /// [authUsers] is the manager for managing auth users.
  /// [userProfiles] is the manager for managing user profiles.
  T construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  });
}
