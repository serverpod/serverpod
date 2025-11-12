import '../../../../jwt.dart';
import '../token_manager_factory.dart';

/// Token manager factory for [AuthenticationTokensTokenManager].
class AuthenticationTokensTokenManagerFactory
    extends TokenManagerFactory<AuthenticationTokensTokenManager> {
  /// The configuration used when creating the [AuthenticationTokensTokenManager].
  final AuthenticationTokenConfig config;

  /// Creates a new [AuthenticationTokensTokenManagerFactory].
  AuthenticationTokensTokenManagerFactory(
    this.config,
  );

  @override
  AuthenticationTokensTokenManager construct({
    required final AuthUsers authUsers,
  }) => AuthenticationTokensTokenManager(config: config, authUsers: authUsers);
}
