import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';

/// Configuration for an authentication token algorithm.
sealed class AuthenticationTokenAlgorithm {
  /// The key used to verify the JWT tokens.
  JWTKey get verificationKey;

  /// Create a new ECDSA SHA-512 authentication token algorithm configuration.
  static EcdsaSha512AuthenticationTokenAlgorithmConfiguration ecdsaSha512({
    required final ECPrivateKey privateKey,
    required final ECPublicKey publicKey,
  }) {
    return EcdsaSha512AuthenticationTokenAlgorithmConfiguration(
      privateKey: privateKey,
      publicKey: publicKey,
    );
  }

  /// Create a new HMAC SHA-512 authentication token algorithm configuration.
  static HmacSha512AuthenticationTokenAlgorithmConfiguration hmacSha512(
      final SecretKey key) {
    return HmacSha512AuthenticationTokenAlgorithmConfiguration(key: key);
  }
}

/// Configuration options for the JWT authentication module.
class AuthenticationTokenConfig {
  /// The algorithm used to sign and verify the JWT tokens.
  ///
  /// Supported options are `HmacSha512` and `EcdsaSha512`.
  final AuthenticationTokenAlgorithm algorithm;

  /// The algorithm used to verify the JWT tokens in case the primary
  /// algorithm fails.
  final AuthenticationTokenAlgorithm? fallbackVerificationAlgorithm;

  /// Pepper used for hashing refresh tokens.
  ///
  /// This influences the stored refresh token hashes, so it must not be
  /// changed for a given deployment, as otherwise all refresh tokens become
  /// invalid.
  final String refreshTokenHashPepper;

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
  /// session and the authenticated user ID as parameters, enabling it to fetch
  /// any additional information needed.
  ///
  /// The returned map contains extra claims to be included in the refresh
  /// token payload. These claims will be embedded in every access token
  /// (including across rotations) and sent along with any request.
  ///
  /// If both this provider and the `extraClaims` parameter in `createTokens` are
  /// provided, the claims will be merged, with the provider's claims taking
  /// precedence in case of conflicts.
  ///
  /// Example use case: Adding user roles, feature flags, or other
  /// session-related metadata to reduce database round-trips.
  ///
  /// Claims must not conflict with [registered claims](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1)
  /// or Serverpod's internal claims (those starting with "dev.serverpod.").
  final Future<Map<String, dynamic>?> Function(
    Session session,
    UuidValue authUserId,
  )? extraClaimsProvider;

  /// Create a new user profile configuration.
  AuthenticationTokenConfig({
    required this.algorithm,
    required this.refreshTokenHashPepper,
    this.fallbackVerificationAlgorithm,
    this.accessTokenLifetime = const Duration(minutes: 10),
    this.refreshTokenLifetime = const Duration(days: 14),
    this.issuer,
    this.refreshTokenFixedSecretLength = 16,
    this.refreshTokenRotatingSecretLength = 64,
    this.refreshTokenRotatingSecretSaltLength = 16,
    this.extraClaimsProvider,
  }) {
    _validateRefreshTokenHashPepper(refreshTokenHashPepper);
  }
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

/// ECDSA SHA-512 authentication token algorithm configuration.
final class EcdsaSha512AuthenticationTokenAlgorithmConfiguration
    implements AuthenticationTokenAlgorithm {
  /// The private key to use for the ECDSA SHA-512 algorithm.
  final ECPrivateKey privateKey;

  /// The public key used for the ECDSA SHA512 algorithm.
  final ECPublicKey publicKey;

  /// Create a new ECDSA SHA-512 authentication token algorithm configuration.
  EcdsaSha512AuthenticationTokenAlgorithmConfiguration({
    required this.privateKey,
    required this.publicKey,
  });

  @override
  JWTKey get verificationKey => publicKey;
}

/// HMAC SHA-512 authentication token algorithm configuration.
///
final class HmacSha512AuthenticationTokenAlgorithmConfiguration
    implements AuthenticationTokenAlgorithm {
  /// The secret key to use for the HMAC SHA-512 algorithm.
  final SecretKey key;

  /// Create a new HMAC SHA-512 authentication token algorithm configuration.
  const HmacSha512AuthenticationTokenAlgorithmConfiguration({
    required this.key,
  });

  @override
  JWTKey get verificationKey => key;
}
