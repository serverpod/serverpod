import 'package:serverpod/serverpod.dart';

/// Secrets used for sessions.
abstract class AuthSessionSecrets {
  /// The configuration key for the session key pepper entry.
  static String sessionKeyHashPepperConfigurationKey =
      'serverpod_auth_session.sessionKeyHashPepper';

  /// The pepper used for hashing authentication session keys.
  ///
  /// This influences the stored session hashes, so it must not be changed for a given deployment,
  /// as otherwise all sessions become invalid.
  static String get sessionKeyHashPepper {
    final pepper =
        Serverpod.instance.getPassword(sessionKeyHashPepperConfigurationKey);

    if (pepper == null || pepper.isEmpty) {
      throw Exception(
        'Password "${AuthSessionSecrets.sessionKeyHashPepperConfigurationKey}" is not set',
      );
    }

    return pepper;
  }
}
