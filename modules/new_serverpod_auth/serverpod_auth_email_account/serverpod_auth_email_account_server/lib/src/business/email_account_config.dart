import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_account_server/src/util/verification_code_generator.dart';

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
  required Transaction transaction,
});

/// Configuration options for the email account module.
class EmailAccountConfig {
  /// The currently active configuration.
  static EmailAccountConfig current = EmailAccountConfig();

  /// The time for initial registration email verication link to be valid.
  ///
  ///  Default is 15 minutes.
  final Duration registrationVerificationCodeLifetime;

  /// Function returning the registration verification code.
  ///
  /// By default this is a 8 digits alpha-numeric lower-case code.
  final String Function() registrationVerificationCodeGenerator;

  /// The time for password resets to be valid.
  ///
  ///  Default is 15 minutes.
  final Duration passwordResetCodeLifetime;

  /// Function returning the password rest verification code.
  ///
  /// By default this is a 8 digits alpha-numeric lower-case code.
  final String Function() passwordResetCodeGenerator;

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
  final void Function(
    Session session, {
    required String email,
    required String verificationToken,
    required Transaction transaction,
  })? sendRegistrationVerificationMail;

  /// Callback to be invoked for sending outgoing password reset emails.
  final void Function(
    Session session, {
    required String email,
    required String resetToken,
    required Transaction transaction,
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
    this.registrationVerificationCodeGenerator =
        defaultVerificationCodeGenerator,
    this.passwordResetCodeLifetime = const Duration(minutes: 15),
    this.passwordResetCodeGenerator = defaultVerificationCodeGenerator,
    this.sendRegistrationVerificationMail,
    this.sendPasswordResetMail,
    this.existingUserImportFunction,
    this.emailSignInFailureResetTime = const Duration(minutes: 5),
    this.maxAllowedEmailSignInAttempts = 5,
  });
}
