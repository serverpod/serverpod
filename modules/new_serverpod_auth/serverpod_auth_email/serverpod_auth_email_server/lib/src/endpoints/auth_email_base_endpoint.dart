import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_server/serverpod_auth_email_server.dart';

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
  /// `EmailAccountLoginException`.
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
  /// {@endtemplate}
  Future<void> startRegistration(
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
  /// {@endtemplate}
  Future<void> startPasswordReset(
    final Session session, {
    required final String email,
  }) async {
    return AuthEmail.startPasswordReset(session, email: email);
  }

  /// {@template email_account_base_endpoint.finish_password_reset}
  /// Completes a password reset request by setting a new password.
  ///
  /// If the reset was successful, a new session key is returned.
  ///
  /// Destroys all active sessions of the user.
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
