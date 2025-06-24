import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// Secrets used for sessions.
@internal
class AuthSessionSecrets {
  AuthSessionSecrets({
    @visibleForTesting final String? sessionKeyHashPepper,
  }) : sessionKeyHashPepper = sessionKeyHashPepper ?? _sessionKeyHashPepper;

  final String sessionKeyHashPepper;

  /// The configuration key for the session key pepper entry.
  static const String sessionKeyHashPepperConfigurationKey =
      'serverpod_auth_session_sessionKeyHashPepper';

  /// The pepper used for hashing authentication session keys.
  ///
  /// This influences the stored session hashes, so it must not be changed for a given deployment,
  /// as otherwise all sessions become invalid.
  static String get _sessionKeyHashPepper {
    final pepper = Serverpod.instance.getPassword(
      sessionKeyHashPepperConfigurationKey,
    );

    if (pepper == null || pepper.isEmpty) {
      throw ArgumentError(
        'No "pepper" was configured in the authentication session passwords.',
        sessionKeyHashPepperConfigurationKey,
      );
    }

    if (pepper.length < 10) {
      throw ArgumentError(
        'Given "pepper" in the authentication session passwords is too short. Use at least 10 random characters.',
        sessionKeyHashPepperConfigurationKey,
      );
    }

    return pepper;
  }
}
