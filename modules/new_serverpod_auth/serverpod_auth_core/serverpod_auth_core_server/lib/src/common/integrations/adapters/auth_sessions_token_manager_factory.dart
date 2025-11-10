import '../../../session/session.dart';
import '../token_manager_factory.dart';

/// Token manager factory for [AuthSessionsTokenManager].
class AuthSessionsTokenManagerFactory
    extends TokenManagerFactory<AuthSessionsTokenManager> {
  /// The configuration used when creating the [AuthSessionsTokenManager].
  final AuthSessionsConfig config;

  /// Creates a new [AuthSessionsTokenManagerFactory].
  AuthSessionsTokenManagerFactory({
    required this.config,
    super.authUsersOverride,
  });

  @override
  AuthSessionsTokenManager construct({required final AuthUsers authUsers}) =>
      AuthSessionsTokenManager(config: config, authUsers: authUsers);
}
