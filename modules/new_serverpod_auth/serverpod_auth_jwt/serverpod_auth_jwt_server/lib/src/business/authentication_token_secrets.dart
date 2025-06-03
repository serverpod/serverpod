import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
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

  static AuthenticationTokenAlgorithmConfiguration get algorithm {
    final algorithmConfiguration = algorithmTestOverride ??
        Serverpod.instance.getPassword(algorithmConfigurationKey);
    final algorithm = algorithmConfiguration == null
        ? AuthenticationTokenAlgorithm.hmacSha512
        : AuthenticationTokenAlgorithm.parseAlgorithm(algorithmConfiguration);

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
      case AuthenticationTokenAlgorithm.hmacSha512:
        return HmacSha512AuthenticationTokenAlgorithmConfiguration(
          key: SecretKey(privateKey),
        );

      case AuthenticationTokenAlgorithm.ecdsaSha512:
        if (publicKey == null || publicKey.isEmpty) {
          throw ArgumentError(
            'No valid public key was set',
            publicKeyConfigurationKey,
          );
        }

        return EcdsaSha512AuthenticationTokenAlgorithmConfiguration(
          privateKey: ECPrivateKey(privateKey),
          publicKey: ECPublicKey(publicKey),
        );

      default:
        throw ArgumentError(
          '"$algorithm" is not a valid configuration option',
          algorithmConfigurationKey,
        );
    }
  }

  /// The fallback algorithm to be used for verifications during key rotations.
  static FallbackAuthenticationTokenAlgorithmConfiguration?
      get fallbackVerificationAlgorithm {
    final algorithmConfiguration = fallbackAlgorithmTestOverride ??
        Serverpod.instance.getPassword(fallbackAlgorithmConfigurationKey);

    final key = fallbackKeyTestOverride ??
        Serverpod.instance.getPassword(fallbackKeyConfigurationKey);

    if (algorithmConfiguration == null && key == null) {
      return null;
    }

    final algorithm = algorithmConfiguration == null
        ? AuthenticationTokenAlgorithm.hmacSha512
        : AuthenticationTokenAlgorithm.parseAlgorithm(algorithmConfiguration);

    if (key == null || key.isEmpty) {
      throw ArgumentError(
        'No valid key was set',
        fallbackKeyConfigurationKey,
      );
    }

    switch (algorithm) {
      case AuthenticationTokenAlgorithm.hmacSha512:
        return HmacSha512FallbackAuthenticationTokenAlgorithmConfiguration(
          key: SecretKey(key),
        );

      case AuthenticationTokenAlgorithm.ecdsaSha512:
        return EcdsaSha512FallbackAuthenticationTokenAlgorithmConfiguration(
          publicKey: ECPublicKey(key),
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
}

/// The algorithm used to sign an verify the JWT tokens.
@internal
enum AuthenticationTokenAlgorithm {
  /// HMAC using SHA-512 hash algorithm
  hmacSha512('HS512'),

  /// ECDSA using P-512 curve and SHA-512 hash algorithm
  ecdsaSha512('ES512');

  const AuthenticationTokenAlgorithm(this.configurationKey);

  final String configurationKey;

  static AuthenticationTokenAlgorithm parseAlgorithm(final String key) {
    return AuthenticationTokenAlgorithm.values.singleWhere(
      (final a) => a.configurationKey == key,
      orElse: () => throw ArgumentError.value(
        key,
        'key',
        'No authentication algorithm found for the given configuration key',
      ),
    );
  }
}

@internal
sealed class AuthenticationTokenAlgorithmConfiguration {}

@internal
class HmacSha512AuthenticationTokenAlgorithmConfiguration
    implements AuthenticationTokenAlgorithmConfiguration {
  final SecretKey key;

  const HmacSha512AuthenticationTokenAlgorithmConfiguration({
    required this.key,
  });
}

/// Elliptic Curve Digital Signature Algorithm
@internal
class EcdsaSha512AuthenticationTokenAlgorithmConfiguration
    implements AuthenticationTokenAlgorithmConfiguration {
  final ECPrivateKey privateKey;

  final ECPublicKey publicKey;

  EcdsaSha512AuthenticationTokenAlgorithmConfiguration({
    required this.privateKey,
    required this.publicKey,
  });
}

@internal
sealed class FallbackAuthenticationTokenAlgorithmConfiguration {}

@internal
class HmacSha512FallbackAuthenticationTokenAlgorithmConfiguration
    implements FallbackAuthenticationTokenAlgorithmConfiguration {
  final SecretKey key;

  const HmacSha512FallbackAuthenticationTokenAlgorithmConfiguration({
    required this.key,
  });
}

@internal
class EcdsaSha512FallbackAuthenticationTokenAlgorithmConfiguration
    implements FallbackAuthenticationTokenAlgorithmConfiguration {
  final ECPublicKey publicKey;

  EcdsaSha512FallbackAuthenticationTokenAlgorithmConfiguration({
    required this.publicKey,
  });
}
