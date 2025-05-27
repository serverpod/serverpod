import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// Secrets used for authentication tokens.
@internal
abstract class AuthenticationTokenSecrets {
  static String algorithmConfigurationKey = 'serverpod_auth_jwt.algorithm';

  /// The configuration key for the private key to sign access tokens with.
  static String privateKeyConfigurationKey = 'serverpod_auth_jwt.privateKey';

  /// The configuration key for the optional public key (for asymmetric cryptogrpahy) to verify access tokens with.
  static String publicKeyConfigurationKey = 'serverpod_auth_jwt.publicKey';

  /// The configuration key for the token hash pepper.
  static String tokenHashPepperConfigurationKey =
      'serverpod_auth_jwt.tokenHashPepper';

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

  /// The pepper used for hashing tokens.
  ///
  /// This influences the stored password, so it must not be changed for a given deployment,
  /// as otherwise all passwords become invalid.
  static String get tokenHashPepper {
    final pepper = tokenHashPepperTestOverride ??
        Serverpod.instance.getPassword(tokenHashPepperConfigurationKey);

    if (pepper == null || pepper.isEmpty) {
      throw Exception(
        'Password "$tokenHashPepperConfigurationKey" is not set',
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
  static String? tokenHashPepperTestOverride;

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
