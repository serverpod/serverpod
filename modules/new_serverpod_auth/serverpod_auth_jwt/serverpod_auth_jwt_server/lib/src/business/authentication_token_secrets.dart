import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// Secrets used for authentication tokens.
@internal
abstract class AuthenticationTokenSecrets {
  static const String algorithmConfigurationKey =
      'serverpod_auth_jwt.algorithm';

  /// The configuration key for the private key to sign access tokens with.
  static const String privateKeyConfigurationKey =
      'serverpod_auth_jwt.privateKey';

  /// The configuration key for the optional public key (for asymmetric cryptogrpahy) to verify access tokens with.
  static const String publicKeyConfigurationKey =
      'serverpod_auth_jwt.publicKey';

  /// Which algorithm to use for the fallback token verification (during key rotation).
  static const String fallbackAlgorithmConfigurationKey =
      'serverpod_auth_jwt.fallbackAlgorithm';

  /// The key to be used for the fallback key verification (during token rotation).
  ///
  /// For the `HS512` algorithm, this would be the single secret.
  /// For the `ES512` algorithm, this would be the public key.
  static const String fallbackKeyConfigurationKey =
      'serverpod_auth_jwt.fallbackKey';

  /// The configuration key for the refresh token hash pepper.
  static const String refreshTokenHashPepperConfigurationKey =
      'serverpod_auth_jwt.refreshTokenHashPepper';

  static AuthenticationTokenAlgorithm get algorithm {
    final algorithm = algorithmTestOverride ??
        Serverpod.instance.getPassword(algorithmConfigurationKey);

    final privateKey = privateKeyTestOverride ??
        Serverpod.instance.getPassword(privateKeyConfigurationKey);

    final publicKey = publicKeyTestOverride ??
        Serverpod.instance.getPassword(publicKeyConfigurationKey);

    if (privateKey == null || privateKey.isEmpty) {
      throw ArgumentError(
        'No valid private key was set',
        privateKeyConfigurationKey,
      );
    }

    switch (algorithm) {
      case null || algorithmHS512:
        return HmacSha512AuthenticationTokenAlgorithm(key: privateKey);

      case algorithmES512:
        if (publicKey == null || publicKey.isEmpty) {
          throw ArgumentError(
            'No valid public key was set',
            publicKeyConfigurationKey,
          );
        }

        return EcdsaSha512AuthenticationTokenAlgorithm(
          privateKey: privateKey,
          publicKey: publicKey,
        );

      default:
        throw ArgumentError(
          '"$algorithm" is not a valid configuration option',
          algorithmConfigurationKey,
        );
    }
  }

  /// The fallback algorithm to be used for verifications during key rotations.
  static FallbackAuthenticationTokenAlgorithm?
      get fallbackVerificationAlgorithm {
    final algorithm = fallbackAlgorithmTestOverride ??
        Serverpod.instance.getPassword(fallbackAlgorithmConfigurationKey);

    final key = fallbackKeyTestOverride ??
        Serverpod.instance.getPassword(fallbackKeyConfigurationKey);

    if (algorithm == null && key == null) {
      return null;
    }

    if (key == null || key.isEmpty) {
      throw ArgumentError(
        'No valid key was set',
        fallbackKeyConfigurationKey,
      );
    }

    switch (algorithm) {
      case null || algorithmHS512:
        return HmacSha512FallbackAuthenticationTokenAlgorithm(key: key);

      case algorithmES512:
        return EcdsaSha512FallbackAuthenticationTokenAlgorithm(
          publicKey: key,
        );

      default:
        throw ArgumentError(
          '"$algorithm" is not a valid configuration option',
          fallbackAlgorithmConfigurationKey,
        );
    }
  }

  /// The pepper used for hashing refresh tokens.
  static String get refreshTokenHashPepper {
    final pepper = refreshTokenHashPepperTestOverride ??
        Serverpod.instance.getPassword(refreshTokenHashPepperConfigurationKey);

    if (pepper == null || pepper.isEmpty) {
      throw ArgumentError(
        'No "pepper" was configured in the authentication token passwords.',
        refreshTokenHashPepperConfigurationKey,
      );
    }

    return pepper;
  }

  @visibleForTesting
  static String? algorithmTestOverride;

  /// Private key override for testing, to be returned for [privateKey].
  @visibleForTesting
  static String? privateKeyTestOverride;

  @visibleForTesting
  static String? publicKeyTestOverride;

  @visibleForTesting
  static String? refreshTokenHashPepperTestOverride;

  @visibleForTesting
  static String? fallbackAlgorithmTestOverride;

  @visibleForTesting
  static String? fallbackKeyTestOverride;

  /// HMAC using SHA-512 hash algorithm
  static const algorithmHS512 = 'HS512';

  /// ECDSA using P-512 curve and SHA-512 hash algorithm
  static const algorithmES512 = 'ES512';
}

@internal
sealed class AuthenticationTokenAlgorithm {}

@internal
class HmacSha512AuthenticationTokenAlgorithm
    implements AuthenticationTokenAlgorithm {
  final String key;

  const HmacSha512AuthenticationTokenAlgorithm({required this.key});
}

/// Elliptic Curve Digital Signature Algorithm
@internal
class EcdsaSha512AuthenticationTokenAlgorithm
    implements AuthenticationTokenAlgorithm {
  final String privateKey;

  final String publicKey;

  EcdsaSha512AuthenticationTokenAlgorithm({
    required this.privateKey,
    required this.publicKey,
  });
}

@internal
sealed class FallbackAuthenticationTokenAlgorithm {}

@internal
class HmacSha512FallbackAuthenticationTokenAlgorithm
    implements FallbackAuthenticationTokenAlgorithm {
  final String key;

  const HmacSha512FallbackAuthenticationTokenAlgorithm({required this.key});
}

@internal
class EcdsaSha512FallbackAuthenticationTokenAlgorithm
    implements FallbackAuthenticationTokenAlgorithm {
  final String publicKey;

  EcdsaSha512FallbackAuthenticationTokenAlgorithm({
    required this.publicKey,
  });
}
