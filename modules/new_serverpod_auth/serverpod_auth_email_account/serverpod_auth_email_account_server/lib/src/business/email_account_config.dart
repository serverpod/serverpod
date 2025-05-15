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

/// Configuration options for the email account module.
class EmailAccountConfig {
  /// The currently active configuration.
  static EmailAccountConfig current = EmailAccountConfig();

  /// The time for initial registration email verication link to be valid.
  ///
  ///  Default is 15 minutes.
  final Duration registrationVerificationCodeLifetime;

  /// The time for password resets to be valid.
  ///
  ///  Default is 15 minutes.
  final Duration passwordResetCodeLifetime;

  /// The reset period for email sign in attempts.
  ///
  /// Defaults to 5 minutes.
  final Duration emailSignInFailureResetTime;

  /// Max allowed failed email sign in attempts within the [emailSignInFailureResetTime] period.
  ///
  /// Defaults to 5, meaning a user can make 5 sign in attempts within a
  /// 5 minute window.
  final int maxAllowedEmailSignInAttempts;

  /// Callback to be invoked for sending outgoing registration emails for the email address verification.
  final void Function({
    required String email,
    required String verificationToken,
  })? sendRegistrationVerificationMail;

  /// Callback to be invoked for sending outgoing password reset emails.
  final void Function({
    required String email,
    required String resetToken,
  })? sendPasswordResetMail;

  /// Existing email account import function.
  ///
  /// If a username / password can be not found in the current system,
  /// an import using this function is attempted.
  final ExistingEmailUserImportFunction? existingUserImportFunction;

  /// Create a new email account configuration.
  ///
  /// Set [current] to apply this configuration.
  EmailAccountConfig({
    this.registrationVerificationCodeLifetime = const Duration(minutes: 15),
    this.passwordResetCodeLifetime = const Duration(minutes: 15),
    this.sendRegistrationVerificationMail,
    this.sendPasswordResetMail,
    this.existingUserImportFunction,
    this.emailSignInFailureResetTime = const Duration(minutes: 5),
    this.maxAllowedEmailSignInAttempts = 5,
  });
}
