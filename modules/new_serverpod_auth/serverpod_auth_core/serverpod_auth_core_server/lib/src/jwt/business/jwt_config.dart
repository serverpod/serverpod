import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as dart_jsonwebtoken;
import 'package:serverpod/serverpod.dart';

import '../../common/integrations/token_manager_builder.dart';
import '../jwt.dart';

/// Context provided to the [JwtConfig.extraClaimsProvider].
///
/// This class contains the contextual information available when a refresh
/// token is being created, allowing the provider to make informed decisions
/// about which claims to include.
class JwtContext {
  /// The authenticated user ID.
  final UuidValue authUserId;

  /// The authentication method used (e.g., "email", "google", "apple").
  final String method;

  /// The scopes granted to this authentication session.
  final Set<Scope> scopes;

  /// Extra claims provided programmatically via the `createTokens` method.
  ///
  /// The provider can use this to merge or override these claims as needed.
  final Map<String, dynamic>? extraClaims;

  /// Creates a new authentication context.
  const JwtContext({
    required this.authUserId,
    required this.method,
    required this.scopes,
    this.extraClaims,
  });
}

/// Configuration for an authentication token algorithm.
sealed class JwtAlgorithm {
  /// The key used to verify the JWT tokens.
  dart_jsonwebtoken.JWTKey get verificationKey;

  /// Create a new ECDSA SHA-512 authentication token algorithm configuration.
  static EcdsaSha512JwtAlgorithmConfiguration ecdsaSha512({
    required final dart_jsonwebtoken.ECPrivateKey privateKey,
    required final dart_jsonwebtoken.ECPublicKey publicKey,
  }) {
    return EcdsaSha512JwtAlgorithmConfiguration(
      privateKey: privateKey,
      publicKey: publicKey,
    );
  }

  /// Create a new HMAC SHA-512 authentication token algorithm configuration.
  static HmacSha512JwtAlgorithmConfiguration hmacSha512(
    final SecretKey key,
  ) {
    return HmacSha512JwtAlgorithmConfiguration(key: key);
  }
}

/// Configuration options for the JWT authentication module.
class JwtConfig implements TokenManagerBuilder<JwtTokenManager> {
  /// The algorithm used to sign and verify the JWT tokens.
  ///
  /// Supported options are `HmacSha512` and `EcdsaSha512`.
  final JwtAlgorithm algorithm;

  /// The algorithms used to verify the JWT tokens in case the primary
  /// algorithm fails. These are tried in order until one succeeds or all fail.
  final List<JwtAlgorithm> fallbackVerificationAlgorithms;

  /// Pepper used for hashing refresh tokens.
  ///
  /// This influences the stored refresh token hashes, so it must not be
  /// changed for a given deployment, as otherwise all refresh tokens become
  /// invalid.
  ///
  /// To rotate peppers without invalidating existing refresh tokens, use [fallbackRefreshTokenHashPeppers].
  final String refreshTokenHashPepper;

  /// Optional fallback peppers for validating refresh tokens created with previous peppers.
  ///
  /// When rotating peppers, add the old pepper to this list to allow existing refresh tokens
  /// to continue working. The system will try [refreshTokenHashPepper] first, then
  /// each fallback pepper in order until a match is found.
  ///
  /// This is optional and defaults to an empty list.
  final List<String> fallbackRefreshTokenHashPeppers;

  /// The lifetime of access tokens.
  ///
  /// This will be encoded in each access token, and for
  /// incoming requests only the token's value will be used.
  ///
  /// Defaults to 10 minutes.
  final Duration accessTokenLifetime;

  /// The lifetime of a refresh token.
  ///
  /// Once this is expired, no new refresh/access token pair can be created from
  /// the previous refresh token.
  ///
  /// This is checked whenever a rotation takes place and is not encoded in the
  /// refresh token.
  ///
  /// Defaults to 14 days.
  /// Meaning the refresh tokens needs to be used / rotated at least every 14 days
  /// to keep the client with working credentials.
  final Duration refreshTokenLifetime;

  /// The issuer set on the JWT access tokens.
  ///
  /// Set as `iss` claim.
  /// https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.1
  ///
  /// If set, incoming tokens will be validated to contain the same issuer.
  ///
  /// Defaults to `null`.
  final String? issuer;

  /// The amount of random bytes used for the fixed secret part of each individual refresh token.
  ///
  /// Default to 16.
  final int refreshTokenFixedSecretLength;

  /// The amount of random bytes used for the rotating secret of the refresh token.
  ///
  /// Defaults to 64.
  final int refreshTokenRotatingSecretLength;

  /// The amount of random bytes used to hash the rotation secret of the refresh token with.
  ///
  /// Defaults to 16.
  final int refreshTokenRotatingSecretSaltLength;

  /// Optional provider for extra claims to add to refresh tokens.
  ///
  /// This function is called during refresh token creation and allows developers
  /// to dynamically add custom claims to the token. The function receives the
  /// session and an [JwtContext] containing contextual information
  /// about the authentication, enabling it to fetch any additional information
  /// needed and decide how to merge with existing claims.
  ///
  /// The returned map contains extra claims to be included in the refresh
  /// token payload. These claims will be embedded in every access token
  /// (including across rotations) and sent along with any request.
  ///
  /// Claims must not conflict with [registered claims](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1)
  /// or Serverpod's internal claims (those starting with "dev.serverpod.").
  final Future<Map<String, dynamic>?> Function(
    Session session,
    JwtContext context,
  )?
  extraClaimsProvider;

  /// Create a new user profile configuration.
  JwtConfig({
    required this.algorithm,
    required this.refreshTokenHashPepper,
    this.fallbackRefreshTokenHashPeppers = const [],
    this.fallbackVerificationAlgorithms = const [],
    this.accessTokenLifetime = const Duration(minutes: 10),
    this.refreshTokenLifetime = const Duration(days: 14),
    this.issuer,
    this.refreshTokenFixedSecretLength = 16,
    this.refreshTokenRotatingSecretLength = 64,
    this.refreshTokenRotatingSecretSaltLength = 16,
    this.extraClaimsProvider,
  }) {
    _validateRefreshTokenHashPepper(refreshTokenHashPepper);
    for (final fallbackPepper in fallbackRefreshTokenHashPeppers) {
      _validateRefreshTokenHashPepper(fallbackPepper);
    }
  }

  @override
  JwtTokenManager build({
    required final AuthUsers authUsers,
  }) => JwtTokenManager(
    config: this,
    authUsers: authUsers,
  );
}

/// Creates a new [JwtConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
class JwtConfigFromPasswords extends JwtConfig {
  /// Creates a new [JwtConfigFromPasswords] instance.
  JwtConfigFromPasswords({
    super.fallbackRefreshTokenHashPeppers,
    super.accessTokenLifetime,
    super.refreshTokenLifetime,
    super.issuer,
    super.refreshTokenFixedSecretLength,
    super.refreshTokenRotatingSecretLength,
    super.refreshTokenRotatingSecretSaltLength,
    super.extraClaimsProvider,
    super.fallbackVerificationAlgorithms,
  }) : super(
         refreshTokenHashPepper: Serverpod.instance.getPassword(
           'jwtRefreshTokenHashPepper',
         )!,
         algorithm: JwtAlgorithm.hmacSha512(
           SecretKey(Serverpod.instance.getPassword('jwtPrivateKey')!),
         ),
       );
}

void _validateRefreshTokenHashPepper(final String refreshTokenHashPepper) {
  if (refreshTokenHashPepper.isEmpty) {
    throw ArgumentError.value(
      refreshTokenHashPepper,
      'refreshTokenHashPepper',
      'must not be empty',
    );
  }

  if (refreshTokenHashPepper.length < 10) {
    throw ArgumentError.value(
      refreshTokenHashPepper,
      'refreshTokenHashPepper',
      'must be at least 10 characters long',
    );
  }
}

/// ECDSA SHA-512 JWT algorithm configuration.
final class EcdsaSha512JwtAlgorithmConfiguration implements JwtAlgorithm {
  /// The private key to use for the ECDSA SHA-512 algorithm.
  final dart_jsonwebtoken.ECPrivateKey privateKey;

  /// The public key used for the ECDSA SHA512 algorithm.
  final dart_jsonwebtoken.ECPublicKey publicKey;

  /// Create a new ECDSA SHA-512 JWT algorithm configuration.
  EcdsaSha512JwtAlgorithmConfiguration({
    required this.privateKey,
    required this.publicKey,
  });

  @override
  dart_jsonwebtoken.JWTKey get verificationKey => publicKey;
}

/// HMAC SHA-512 JWT algorithm configuration.
///
final class HmacSha512JwtAlgorithmConfiguration implements JwtAlgorithm {
  /// The secret key to use for the HMAC SHA-512 algorithm.
  final SecretKey key;

  /// Create a new HMAC SHA-512 JWT algorithm configuration.
  const HmacSha512JwtAlgorithmConfiguration({
    required this.key,
  });

  @override
  dart_jsonwebtoken.JWTKey get verificationKey => key;
}
