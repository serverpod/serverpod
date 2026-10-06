import 'package:serverpod/serverpod.dart';

import '../../email/business/util/serverpod_cloud_code_sender.dart';
import '../../email/business/util/serverpod_cloud_email_client.dart';
import 'email_passwordless_idp_config.dart';

export '../../email/business/util/serverpod_cloud_email_client.dart';

/// {@template serverpod_cloud_email_passwordless_idp_config}
/// An [EmailPasswordlessIdpConfig] that works with Serverpod Cloud without
/// configuration.
///
/// In development and test run mode, verification codes are logged to the
/// console via [Session.alert], as "Sign-up code for ..." for email addresses
/// without an account and as "Sign-in code for ..." for the ones with an
/// account. In staging and production run mode, emails are sent through the
/// hosted Serverpod Cloud transactional email service (see
/// [ServerpodCloudEmailClient]).
///
/// The staging/production setup reads the `scloudAuthEmailKey` password, which
/// is provided automatically by Serverpod Cloud. The key is read lazily when an
/// email is sent (not at startup), so a self-hosted server still boots when it
/// is unset. Sending is best-effort: a failure (outage, missing key, non-200,
/// or timeout) is logged and never propagated, so it does not reveal whether an
/// account exists.
///
/// The Serverpod Cloud email service does not have an email type for signing in
/// yet, so both kinds of codes are sent as [ServerpodCloudEmailType.signup]
/// emails by default. Use [signUpEmailType] and [signInEmailType] to change
/// that once it has.
///
/// The codes must consist of 1-16 alphanumeric characters (`A-Z`, `a-z`,
/// `0-9`) to be accepted by the email service, which the default 6 digit code
/// does.
///
/// If you want to send emails through a custom provider instead, use
/// [EmailPasswordlessIdpConfigFromPasswords].
///
/// This requires that a [Serverpod] instance has already been initialized, as
/// it reads the `emailSecretHashPepper` password from the `passwords.yaml` file.
/// {@endtemplate}
class ServerpodCloudEmailPasswordlessIdpConfig
    extends EmailPasswordlessIdpConfigFromPasswords {
  /// {@macro serverpod_cloud_email_passwordless_idp_config}
  ///
  /// [appDisplayName] is the name shown to recipients in the emails (at most 64
  /// characters) and is prefilled with the project name in the default
  /// template.
  factory ServerpodCloudEmailPasswordlessIdpConfig({
    required final String appDisplayName,

    /// The Serverpod Cloud email type for codes sent to email addresses
    /// without an account.
    final ServerpodCloudEmailType signUpEmailType =
        ServerpodCloudEmailType.signup,

    /// The Serverpod Cloud email type for codes sent to email addresses with an
    /// account.
    final ServerpodCloudEmailType signInEmailType =
        ServerpodCloudEmailType.signup,

    /// The client used to send emails in staging/production. Defaults to a
    /// [ServerpodCloudEmailClient] targeting the hosted service; override it to
    /// target a different endpoint or for testing.
    final ServerpodCloudEmailClient? emailClient,

    /// The run mode determining whether codes are logged (development/test) or
    /// emailed (staging/production). Defaults to `Serverpod.instance.runMode`;
    /// primarily an override for testing.
    final String? runMode,

    /// Whether an unknown email address is signed up on the first successful
    /// verification of a code. Defaults to `true`.
    final bool allowSignUp = true,

    /// Callback to be invoked before a new account is created.
    ///
    /// This can be used to enforce a sign-up policy.
    final BeforePasswordlessAccountCreatedFunction? onBeforeAccountCreated,

    /// Callback to be invoked after a new email account has been created.
    ///
    /// This can be used to perform additional setup tasks, such as sending a
    /// welcome email.
    final AfterAccountCreatedFunction? onAfterAccountCreated,

    /// Callback to be invoked after each successful login, before the token is
    /// issued.
    final AfterPasswordlessLoginFunction? onAfterLogin,
  }) {
    final resolvedRunMode = runMode ?? Serverpod.instance.runMode;
    final isDevelopment =
        resolvedRunMode == ServerpodRunMode.development ||
        resolvedRunMode == ServerpodRunMode.test;

    // In development/test the codes are logged, so no HTTP client is needed.
    // Otherwise a single client is shared between both senders.
    final client = isDevelopment
        ? null
        : (emailClient ?? ServerpodCloudEmailClient());

    return ServerpodCloudEmailPasswordlessIdpConfig._(
      sendSignUpVerificationCode: _loginSender(
        serverpodCloudCodeSender(
          appDisplayName: appDisplayName,
          client: client,
          emailType: signUpEmailType,
          logLabel: 'Sign-up',
        ),
      ),
      sendSignInVerificationCode: _loginSender(
        serverpodCloudCodeSender(
          appDisplayName: appDisplayName,
          client: client,
          emailType: signInEmailType,
          logLabel: 'Sign-in',
        ),
      ),
      allowSignUp: allowSignUp,
      onBeforeAccountCreated: onBeforeAccountCreated,
      onAfterAccountCreated: onAfterAccountCreated,
      onAfterLogin: onAfterLogin,
    );
  }

  // Reads `emailSecretHashPepper` via `EmailPasswordlessIdpConfigFromPasswords`.
  ServerpodCloudEmailPasswordlessIdpConfig._({
    required super.sendSignUpVerificationCode,
    required super.sendSignInVerificationCode,
    super.allowSignUp,
    super.onBeforeAccountCreated,
    super.onAfterAccountCreated,
    super.onAfterLogin,
  });

  /// Adapts a shared [send] callback to the login code callback signature.
  static SendPasswordlessLoginVerificationCodeFunction _loginSender(
    final SendCodeFunction send,
  ) {
    return (
      final Session session, {
      required final String email,
      required final UuidValue loginRequestId,
      required final String verificationCode,
      required final Transaction? transaction,
    }) => send(session, email: email, code: verificationCode);
  }
}
