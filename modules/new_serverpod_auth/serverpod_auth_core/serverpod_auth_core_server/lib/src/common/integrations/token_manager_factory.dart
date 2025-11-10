import '../../auth_user/business/auth_users.dart';
import 'token_manager.dart';

/// Interface for factories that can create token managers.
///
/// These factories are responsible for constructing instances of token managers
/// with the necessary dependencies that should be used in token manager implementations.
abstract class TokenManagerFactory<T extends TokenManager> {
  /// Default constructor that allows for overriding the auth users.
  TokenManagerFactory({
    this.authUsersOverride,
  });

  /// Optional [TokenManager] to override for this provider.
  /// If null, the default manager will be used.
  final AuthUsers? authUsersOverride;

  /// Constructs a new instance of the token manager.
  T construct({required final AuthUsers authUsers});
}
