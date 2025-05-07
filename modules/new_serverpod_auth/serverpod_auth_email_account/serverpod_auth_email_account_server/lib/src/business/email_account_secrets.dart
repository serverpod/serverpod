import 'package:serverpod/serverpod.dart';

/// Secrets used for email authentication.
abstract class EmailAccountSecrets {
  /// The configuration key for the password hash pepper.
  static String passwordHashPepperConfigurationKey =
      'serverpod_auth_email_account.passwordHashPepper';

  /// The pepper used for hashing passwords.
  ///
  /// This influences the stored password, so it must not be changed for a given deployment,
  /// as otherwise all passwords become invalid.
  static String get passwordHashPepper {
    final pepper =
        Serverpod.instance.getPassword(passwordHashPepperConfigurationKey);

    if (pepper == null || pepper.isEmpty) {
      throw Exception(
        'Password "${EmailAccountSecrets.passwordHashPepperConfigurationKey}" is not set',
      );
    }

    return pepper;
  }
}
