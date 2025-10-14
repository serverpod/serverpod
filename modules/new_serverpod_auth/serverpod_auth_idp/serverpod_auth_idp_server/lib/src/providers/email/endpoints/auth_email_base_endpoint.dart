import 'package:serverpod/serverpod.dart';

import '../email.dart';

/// Base endpoint for email-based accounts.
///
/// Uses `serverpod_auth_session` for session creation upon successful login,
/// and `serverpod_auth_profile` to create profiles for new users upon
/// registration.
///
/// Subclass this in your own application to expose an endpoint including all
/// methods.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
/// Alternatively you can build up your own endpoint on top of the same business
/// logic by using [AuthEmail].
abstract class AuthEmailBaseEndpoint extends Endpoint {
  /// {@template email_account_base_endpoint.login}
  /// Logs in the user and returns a new session.
  ///
  /// In case an expected error occurs, this throws a
  /// [EmailAccountLoginException].
  /// {@endtemplate}
  Future<AuthSuccess> login(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    return AuthEmail.login(
      session,
      email: email,
      password: password,
    );
  }

  /// {@template email_account_base_endpoint.start_registration}
  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  /// {@endtemplate}
  Future<UuidValue> startRegistration(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    return AuthEmail.startRegistration(
      session,
      email: email,
      password: password,
    );
  }

  /// {@template email_account_base_endpoint.finish_registration}
  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts to verify the account.
  /// - [EmailAccountRequestExceptionReason.unauthorized] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  ///
  /// Returns a session for the newly created user.
  /// {@endtemplate}
  Future<AuthSuccess> finishRegistration(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
  }) async {
    return AuthEmail.finishRegistration(
      session,
      accountRequestId: accountRequestId,
      verificationCode: verificationCode,
    );
  }

  /// {@template email_account_base_endpoint.start_password_reset}
  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case the client or
  /// account has been involved in too many reset attempts.
  /// {@endtemplate}
  Future<UuidValue> startPasswordReset(
    final Session session, {
    required final String email,
  }) async {
    return AuthEmail.startPasswordReset(session, email: email);
  }

  /// {@template email_account_base_endpoint.finish_password_reset}
  /// Completes a password reset request by setting a new password.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to complete the password reset.
  /// - [EmailAccountRequestExceptionReason.unauthorized] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If the reset was successful, a new session is returned and all previous
  /// active sessions of the user are destroyed.
  /// {@endtemplate}
  Future<AuthSuccess> finishPasswordReset(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
    required final String newPassword,
  }) async {
    return AuthEmail.finishPasswordReset(
      session,
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode,
      newPassword: newPassword,
    );
  }
}
