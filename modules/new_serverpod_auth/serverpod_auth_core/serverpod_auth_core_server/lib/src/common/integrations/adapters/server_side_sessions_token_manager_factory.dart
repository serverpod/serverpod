import '../../../session/session.dart';
import '../token_manager_factory.dart';

/// Token manager factory for [ServerSideSessionsTokenManager].
class ServerSideSessionsTokenManagerFactory
    extends TokenManagerFactory<ServerSideSessionsTokenManager> {
  /// The configuration used when creating the [ServerSideSessionsTokenManager].
  final ServerSideSessionsConfig config;

  /// Creates a new [ServerSideSessionsTokenManagerFactory].
  ServerSideSessionsTokenManagerFactory(
    this.config,
  );

  @override
  ServerSideSessionsTokenManager construct({
    required final AuthUsers authUsers,
  }) => ServerSideSessionsTokenManager(config: config, authUsers: authUsers);
}
