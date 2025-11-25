import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

void main() {
  final tokenManagerFactory = AuthenticationTokensTokenManagerFactory(
    AuthenticationTokenConfig(
      refreshTokenHashPepper: 'refreshTokenHashPepper',
      algorithm: AuthenticationTokenAlgorithm.hmacSha512(
        SecretKey('refreshTokenHashPepper'),
      ),
    ),
  );

  final _ = tokenManagerFactory.construct(
    authUsers: const AuthUsers(),
  );

  final _ = AuthenticationTokensTokenManager(
    authUsers: const AuthUsers(),
    config: AuthenticationTokenConfig(
      refreshTokenHashPepper: 'refreshTokenHashPepper',
      algorithm: AuthenticationTokenAlgorithm.hmacSha512(
        SecretKey('refreshTokenHashPepper'),
      ),
    ),
  );
}
