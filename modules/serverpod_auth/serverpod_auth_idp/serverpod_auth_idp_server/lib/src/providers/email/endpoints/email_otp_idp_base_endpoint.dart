import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'email_idp_base_endpoint.dart';

/// Base endpoint for email-based accounts with passwordless login, where users
/// sign in or sign up with a one-time password (OTP) sent to their email.
///
/// Includes all methods of [EmailIdpBaseEndpoint], so users can still sign in
/// with their password. Exposing this endpoint instead of
/// [EmailIdpBaseEndpoint] makes the client show the passwordless sign-in
/// widget.
///
/// The codes are sent with `EmailIdpConfig.sendOtpLoginVerificationCode`,
/// which `ServerpodCloudEmailIdpConfig` sets. If it is not set, they are sent
/// with `EmailIdpConfig.sendRegistrationVerificationCode` instead, see
/// `EmailIdpConfig.sendOtpLoginVerificationCode` for when that is not
/// suitable.
///
/// Subclass this in your own application to expose an endpoint including all
/// methods.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
abstract class EmailOtpIdpBaseEndpoint extends EmailIdpBaseEndpoint {
  /// {@template email_account_base_endpoint.start_otp_login}
  /// Starts a passwordless login by sending a one-time password to [email].
  ///
  /// The code is sent whether or not an account is registered for the email.
  /// If none is, verifying the code lets the user create a new account.
  ///
  /// Always returns a login request ID, which must be passed to
  /// [verifyOtpLoginCode] together with the one-time password.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the email is
  ///   not valid.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if too many
  ///   one-time passwords have been requested for the email.
  /// {@endtemplate}
  Future<UuidValue> startOtpLogin(
    final Session session, {
    required final String email,
  }) async {
    return emailIdp.startOtpLogin(session, email: email);
  }

  /// {@template email_account_base_endpoint.verify_otp_login_code}
  /// Verifies a one-time password and returns a token to complete the login.
  ///
  /// If [EmailAccountOtpVerificationResult.accountExists] is `true`, pass the
  /// token to [finishOtpLogin] to sign in. Otherwise, have the user accept the
  /// terms (and optionally set a password if
  /// [EmailAccountOtpVerificationResult.allowPassword] is `true`) and pass it
  /// to [finishOtpRegistration] to create the account.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts to verify the code.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists for
  ///   the given [otpLoginRequestId] or [verificationCode] is invalid.
  /// {@endtemplate}
  Future<EmailAccountOtpVerificationResult> verifyOtpLoginCode(
    final Session session, {
    required final UuidValue otpLoginRequestId,
    required final String verificationCode,
  }) async {
    return emailIdp.verifyOtpLoginCode(
      session,
      otpLoginRequestId: otpLoginRequestId,
      verificationCode: verificationCode,
    );
  }

  /// {@template email_account_base_endpoint.finish_otp_login}
  /// Completes a passwordless login for an existing account and returns a new
  /// session.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or no account exists for the email.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  /// {@endtemplate}
  Future<AuthSuccess> finishOtpLogin(
    final Session session, {
    required final String otpLoginToken,
  }) async {
    return emailIdp.finishOtpLogin(session, otpLoginToken: otpLoginToken);
  }

  /// {@template email_account_base_endpoint.finish_otp_registration}
  /// Completes a passwordless login for an email without an account, by
  /// creating a new auth user with a profile and attaching the verified email
  /// to it.
  ///
  /// Must only be called after the user accepted the terms. The [password] is
  /// optional, and may only be set if
  /// [EmailAccountOtpVerificationResult.allowPassword] was `true`.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if a password is
  ///   given but not allowed, or it does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or an account already exists for the email.
  ///
  /// Returns a session for the newly created user.
  /// {@endtemplate}
  Future<AuthSuccess> finishOtpRegistration(
    final Session session, {
    required final String otpLoginToken,
    final String? password,
  }) async {
    return emailIdp.finishOtpRegistration(
      session,
      otpLoginToken: otpLoginToken,
      password: password,
    );
  }
}
