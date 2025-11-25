import 'package:serverpod/serverpod.dart';

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
  /// [pod] is the serverpod instance to use for the provider, if it needs to
  /// do something with the serverpod instance (e.g. add routes). It's covariant
  /// and can be declared as nullable for concrete implementations that do not
  /// need it in order to simplify provider testing.
  T construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
    required covariant final Serverpod pod,
  });
}
