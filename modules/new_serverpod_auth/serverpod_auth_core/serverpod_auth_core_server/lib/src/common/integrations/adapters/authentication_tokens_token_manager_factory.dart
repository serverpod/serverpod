import 'package:serverpod/serverpod.dart';

import '../../../jwt/jwt.dart';
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

  /// Creates a new [AuthenticationTokensTokenManagerFactory] from keys.
  factory AuthenticationTokensTokenManagerFactory.fromKeys(
    final String? Function(String key) getConfig, {
    final List<AuthenticationTokenAlgorithm> fallbackVerificationAlgorithms =
        const [],
    final Duration accessTokenLifetime = const Duration(minutes: 10),
    final Duration refreshTokenLifetime = const Duration(days: 14),
    final String? issuer,
    final int refreshTokenFixedSecretLength = 16,
    final int refreshTokenRotatingSecretLength = 64,
    final int refreshTokenRotatingSecretSaltLength = 16,
    final Future<Map<String, dynamic>?> Function(
      Session,
      AuthenticationContext,
    )?
    extraClaimsProvider,
  }) {
    final refreshTokenHashPepper = getConfig(
      'authenticationTokenRefreshTokenHashPepper',
    );
    final privateKey = getConfig(
      'authenticationTokenPrivateKey',
    );

    if (refreshTokenHashPepper == null || privateKey == null) {
      throw StateError(
        'Missing required authentication token config keys: '
        '"authenticationTokenRefreshTokenHashPepper" and "authenticationTokenPrivateKey".',
      );
    }

    return AuthenticationTokensTokenManagerFactory(
      AuthenticationTokenConfig(
        refreshTokenHashPepper: refreshTokenHashPepper,
        algorithm: AuthenticationTokenAlgorithm.hmacSha512(
          SecretKey(privateKey),
        ),
        fallbackVerificationAlgorithms: fallbackVerificationAlgorithms,
        accessTokenLifetime: accessTokenLifetime,
        refreshTokenLifetime: refreshTokenLifetime,
        issuer: issuer,
        refreshTokenFixedSecretLength: refreshTokenFixedSecretLength,
        refreshTokenRotatingSecretLength: refreshTokenRotatingSecretLength,
        refreshTokenRotatingSecretSaltLength:
            refreshTokenRotatingSecretSaltLength,
        extraClaimsProvider: extraClaimsProvider,
      ),
    );
  }
}
