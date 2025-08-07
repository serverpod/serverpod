import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// Secrets used for authentication tokens.
@internal
class AuthenticationTokenSecrets {
  AuthenticationTokenSecrets({
    @visibleForTesting final ConfigurationValueReader? getPassword,
  })  : algorithm = _algorithmFromConfig(
          getPassword ?? Serverpod.instance.getPassword,
        ),
        fallbackVerificationAlgorithm =
            _fallbackVerificationAlgorithmFromConfig(
          getPassword ?? Serverpod.instance.getPassword,
        ),
        refreshTokenHashPepper = _refreshTokenHashPepper(
          getPassword ?? Serverpod.instance.getPassword,
        );

  /// The primary algorithm to use.
  ///
  /// Supported options are `HS512` and `ES512`.
  static const String algorithmConfigurationKey =
      'serverpod_auth_jwt.algorithm';

  /// The configuration key for the secret key (for symmetric cryptography) to sign access and verify tokens with.
  static const String secretKeyConfigurationKey =
      'serverpod_auth_jwt.secretKey';

  /// The configuration key for the private key (for asymmetric cryptography) to sign access tokens with.
  static const String privateKeyConfigurationKey =
      'serverpod_auth_jwt.privateKey';

  /// The configuration key for the public key (for asymmetric cryptography) to verify access tokens with.
  static const String publicKeyConfigurationKey =
      'serverpod_auth_jwt.publicKey';

  /// Which algorithm to use for the fallback token verification (during key rotation).
  static const String fallbackAlgorithmConfigurationKey =
      'serverpod_auth_jwt.fallback.algorithm';

  /// The public key fallback to be used to verify access tokens with.
  static const String fallbackPublicKeyConfigurationKey =
      'serverpod_auth_jwt.fallback.publicKey';

  /// The configuration key for the fallback secret key to verify access tokens with.
  static const String fallbackSecretKeyConfigurationKey =
      'serverpod_auth_jwt.fallback.secretKey';

  /// The configuration key for the refresh token hash pepper.
  static const String refreshTokenHashPepperConfigurationKey =
      'serverpod_auth_jwt.refreshTokenHashPepper';

  final AuthenticationTokenAlgorithmConfiguration algorithm;

  final FallbackAuthenticationTokenAlgorithmConfiguration?
      fallbackVerificationAlgorithm;

  static AuthenticationTokenAlgorithmConfiguration _algorithmFromConfig(
    final ConfigurationValueReader getPassword,
  ) {
    final algorithmConfiguration = getPassword(algorithmConfigurationKey);
    if (algorithmConfiguration == null) {
      throw ArgumentError(
        'No primary authentication token algorithm was specified in passwords.',
        algorithmConfigurationKey,
      );
    }

    final algorithm =
        AuthenticationTokenAlgorithm.parseAlgorithm(algorithmConfiguration);

    switch (algorithm) {
      case AuthenticationTokenAlgorithm.hmacSha512:
        final secretKey = getPassword(secretKeyConfigurationKey);

        if (secretKey == null || secretKey.isEmpty) {
          throw ArgumentError(
            'No valid secret key was set in passwords',
            secretKeyConfigurationKey,
          );
        }

        return HmacSha512AuthenticationTokenAlgorithmConfiguration(
          key: SecretKey(secretKey),
        );

      case AuthenticationTokenAlgorithm.ecdsaSha512:
        final privateKey = getPassword(privateKeyConfigurationKey);

        if (privateKey == null || privateKey.isEmpty) {
          throw ArgumentError(
            'No valid private key was set in passwords',
            privateKeyConfigurationKey,
          );
        }

        final publicKey = getPassword(publicKeyConfigurationKey);

        if (publicKey == null || publicKey.isEmpty) {
          throw ArgumentError(
            'No valid public key was set in passwords',
            publicKeyConfigurationKey,
          );
        }

        return EcdsaSha512AuthenticationTokenAlgorithmConfiguration(
          privateKey: ECPrivateKey(privateKey),
          publicKey: ECPublicKey(publicKey),
        );
    }
  }

  /// The fallback algorithm to be used for verifications during key rotations.
  static FallbackAuthenticationTokenAlgorithmConfiguration?
      _fallbackVerificationAlgorithmFromConfig(
    final ConfigurationValueReader getPassword,
  ) {
    final algorithmConfiguration =
        getPassword(fallbackAlgorithmConfigurationKey);

    if (algorithmConfiguration == null || algorithmConfiguration.isEmpty) {
      return null;
    }

    final algorithm = AuthenticationTokenAlgorithm.parseAlgorithm(
      algorithmConfiguration,
    );

    switch (algorithm) {
      case AuthenticationTokenAlgorithm.hmacSha512:
        final secretKey = getPassword(fallbackSecretKeyConfigurationKey);

        if (secretKey == null || secretKey.isEmpty) {
          throw ArgumentError(
            'No valid fallback secret key was set in passwords',
            fallbackPublicKeyConfigurationKey,
          );
        }

        return HmacSha512FallbackAuthenticationTokenAlgorithmConfiguration(
          key: SecretKey(secretKey),
        );

      case AuthenticationTokenAlgorithm.ecdsaSha512:
        final publicKey = getPassword(fallbackPublicKeyConfigurationKey);

        if (publicKey == null || publicKey.isEmpty) {
          throw ArgumentError(
            'No valid fallback public key was set in passwords',
            fallbackPublicKeyConfigurationKey,
          );
        }

        return EcdsaSha512FallbackAuthenticationTokenAlgorithmConfiguration(
          publicKey: ECPublicKey(publicKey),
        );
    }
  }

  /// The pepper used for hashing refresh tokens.
  final String refreshTokenHashPepper;

  static String _refreshTokenHashPepper(
    final ConfigurationValueReader getPassword,
  ) {
    final pepper = getPassword(refreshTokenHashPepperConfigurationKey);

    if (pepper == null || pepper.isEmpty) {
      throw ArgumentError(
        'No pepper was set in the authentication token passwords.',
        refreshTokenHashPepperConfigurationKey,
      );
    }

    return pepper;
  }
}

/// Getter for a password configuration value.
typedef ConfigurationValueReader = String? Function(String key);

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
