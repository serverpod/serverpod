import '../../../session/session.dart';
import '../token_manager_factory.dart';

/// Token manager factory for [AuthSessionsTokenManager].
class AuthSessionsTokenManagerFactory
    extends TokenManagerFactory<AuthSessionsTokenManager> {
  /// The configuration used when creating the [AuthSessionsTokenManager].
  final AuthSessionsConfig config;

  /// Creates a new [AuthSessionsTokenManagerFactory].
  AuthSessionsTokenManagerFactory(
    this.config,
  );

  @override
  AuthSessionsTokenManager construct({required final AuthUsers authUsers}) =>
      AuthSessionsTokenManager(config: config, authUsers: authUsers);

  /// Creates a new [AuthSessionsTokenManagerFactory] from keys.
  factory AuthSessionsTokenManagerFactory.fromKeys(
    final String? Function(String key) getConfig,
  ) {
    final sessionKeyHashPepper = getConfig('authSessionsSessionKeyHashPepper');

    if (sessionKeyHashPepper == null) {
      throw StateError(
        'Missing required auth sessions config key: "authSessionsSessionKeyHashPepper".',
      );
    }

    return AuthSessionsTokenManagerFactory(
      AuthSessionsConfig(
        sessionKeyHashPepper: sessionKeyHashPepper,
      ),
    );
  }
}
