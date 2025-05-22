import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// Secrets used for authentication tokens.
abstract class AuthenticationTokenSecrets {
  /// The configuration key for the private key to sign access tokens with.
  static String privateKeyConfigurationKey = 'serverpod_auth_jwt.privateKey';

  /// The private key used for signing access tokens.
  static String get privateKey {
    final privateKey = privateKeyTestOverride ??
        Serverpod.instance.getPassword(privateKeyConfigurationKey);

    if (privateKey == null || privateKey.isEmpty) {
      throw Exception(
        'Password "$privateKeyConfigurationKey" is not set',
      );
    }

    return privateKey;
  }

  /// Private key override for testing, to be returned for [privateKey].
  @visibleForTesting
  static String? privateKeyTestOverride;
}
