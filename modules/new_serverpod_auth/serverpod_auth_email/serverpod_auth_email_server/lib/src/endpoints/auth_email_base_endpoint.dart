import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_email_server/serverpod_auth_email_server.dart';
import 'package:serverpod_auth_email_server/src/business/auth_email.dart';

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
abstract class AuthEmailBaseEndpoint<SessionType extends SerializableModel>
    extends Endpoint {
  ///
  AuthEmail<SessionType> get authEmail;

  /// {@template email_account_base_endpoint.login}
  /// Logs in the user and returns a new session.
  ///
  /// In case an expected error occurs, this throws a
  /// [EmailAccountLoginException].
  /// {@endtemplate}
  Future<SessionType> login(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    return authEmail.login(
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
    return authEmail.startRegistration(
      session,
      email: email,
      password: password,
    );
  }

  /// {@template email_account_base_endpoint.finish_registration}
  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestNotFoundException] in case the
  /// [accountRequestId] does not point to an existing request.
  /// Throws an [EmailAccountRequestExpiredException] in case the request's
  /// validation window has elapsed.
  /// Throws an [EmailAccountRequestTooManyAttemptsException] in case too many
  /// attempts have been made at finishing the same account request.
  /// Throws an [EmailAccountRequestUnauthorizedException] in case the
  /// [verificationCode] is not valid.
  ///
  /// Returns a session for the newly created user.
  /// {@endtemplate}
  Future<SessionType> finishRegistration(
    final Session session, {
    required final UuidValue accountRequestId,
    required final String verificationCode,
  }) async {
    return authEmail.finishRegistration(
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
  /// Throws an [EmailAccountPasswordResetRequestTooManyAttemptsException] in
  /// case the client or account has been involved in too many reset attempts.
  /// {@endtemplate}
  Future<void> startPasswordReset(
    final Session session, {
    required final String email,
  }) async {
    return authEmail.startPasswordReset(session, email: email);
  }

  /// {@template email_account_base_endpoint.finish_password_reset}
  /// Completes a password reset request by setting a new password.
  ///
  /// Throws an [EmailAccountPasswordResetRequestNotFoundException] in case no
  /// reset request could be found for [passwordResetRequestId].
  /// Throws an [EmailAccountPasswordResetRequestExpiredException] in case the
  /// reset request has expired.
  /// Throws an [EmailAccountPasswordPolicyViolationException] in case the
  /// password does not confirm to the configured policy.
  /// Throws an [EmailAccountPasswordResetRequestUnauthorizedException] in case
  /// the [verificationCode] is not valid.
  ///
  /// If the reset was successful, a new session is returned and
  /// all previous sessions of the user are destroyed.
  /// {@endtemplate}
  Future<SessionType> finishPasswordReset(
    final Session session, {
    required final UuidValue passwordResetRequestId,
    required final String verificationCode,
    required final String newPassword,
  }) async {
    return authEmail.finishPasswordReset(
      session,
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode,
      newPassword: newPassword,
    );
  }
}

///
abstract class AuthEmailDatabaseSessionBaseEndpoint
    extends AuthEmailBaseEndpoint<AuthSuccess> {
  ///
  @override
  AuthEmail<AuthSuccess> get authEmail => AuthEmailDatabaseSession();
}

// class ProjectEmailEndpoint extends AuthEmailDatabaseSessionBaseEndpoint {}
