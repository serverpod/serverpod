import 'package:serverpod/serverpod.dart';

/// Import function to use an older email based authentication system.
///
/// Returns an [AuthUser] id in case the email/password combination was valid in the old system.
/// Returns `null` if the email is not used in the old system.
/// Throws in case the email/password combination is not valid or the user is blocked.
///
/// Assumes that the email has been validated in the old system.
typedef ExistingEmailUserImportFunction = Future<UuidValue?> Function(
  Session session, {
  required String email,
  required String password,
});

// TODO: Should the endpoint module (which is the only one referenced in the end-user project) forward this?
class EmailAccountConfig {
  static EmailAccountConfig _config = EmailAccountConfig();

  /// Updates the configuration used by email account module.
  static void set(EmailAccountConfig config) {
    _config = config;
  }

  static void update({
    ExistingEmailUserImportFunction? existingUserImportFunction,
  }) {
    _config = _config.copyWith(
      existingUserImportFunction: existingUserImportFunction,
    );
  }

// TODO: If we follow this, we'd need a proper `copyWith` with null "write" support
  EmailAccountConfig copyWith({
    ExistingEmailUserImportFunction? existingUserImportFunction,
  }) {
    return EmailAccountConfig(
      registrationVerificationCodeLifetime:
          registrationVerificationCodeLifetime,
      passwordResetCodeLifetime: passwordResetCodeLifetime,
      sendRegistrationVerificationMail: sendRegistrationVerificationMail,
      sendPasswordResetMail: sendPasswordResetMail,
      existingUserImportFunction:
          existingUserImportFunction ?? this.existingUserImportFunction,
    );
  }

  /// Gets the current email account module configuration.
  static EmailAccountConfig get current => _config;

  final Duration registrationVerificationCodeLifetime;

  final Duration passwordResetCodeLifetime;

  final void Function({
    required String email,
    required String verificationToken,
  })? sendRegistrationVerificationMail;

  final void Function({
    required String email,
    required String resetToken,
  })? sendPasswordResetMail;

  final ExistingEmailUserImportFunction? existingUserImportFunction;

  EmailAccountConfig({
    this.registrationVerificationCodeLifetime = const Duration(hours: 1),
    this.passwordResetCodeLifetime = const Duration(minutes: 15),
    this.sendRegistrationVerificationMail,
    this.sendPasswordResetMail,
    this.existingUserImportFunction,
  });
}
