import '../../../jwt/jwt.dart';
import '../token_manager_factory.dart';

/// Token manager factory for [JwtTokenManager].
class JwtTokenManagerFactory extends TokenManagerFactory<JwtTokenManager> {
  /// The configuration used when creating the [JwtTokenManager].
  final JwtConfig config;

  /// Creates a new [JwtTokenManagerFactory].
  JwtTokenManagerFactory(
    this.config,
  );

  @override
  JwtTokenManager construct({
    required final AuthUsers authUsers,
  }) => JwtTokenManager(config: config, authUsers: authUsers);
}
