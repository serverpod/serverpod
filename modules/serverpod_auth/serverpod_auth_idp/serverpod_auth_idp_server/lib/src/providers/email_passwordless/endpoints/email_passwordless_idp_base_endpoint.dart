import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../business/email_passwordless_idp.dart';

/// Base endpoint for passwordless email login.
///
/// Users log in with a verification code that is sent to their email address.
/// An email address without an account is signed up on the first successful
/// login, unless `allowSignUp` is disabled in the configuration. See
/// https://github.com/serverpod/serverpod/issues/2100.
///
/// Uses `serverpod_auth_session` for session creation upon successful login,
/// and `serverpod_auth_profile` to create profiles for new users.
///
/// Subclass this in your own application to expose an endpoint including all
/// methods.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
/// Alternatively you can build up your own endpoint on top of the same business
/// logic by using [EmailPasswordlessIdp].
///
/// This endpoint is separate from `EmailIdpBaseEndpoint`: exposing it makes
/// the passwordless login available, whatever the email and password endpoint
/// restricts.
abstract class EmailPasswordlessIdpBaseEndpoint extends IdpBaseEndpoint {
  /// Accessor for the configured passwordless email Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  EmailPasswordlessIdp get emailPasswordlessIdp =>
      AuthServices.instance.emailPasswordlessIdp;

  /// {@template email_passwordless_idp_base_endpoint.start_login}
  /// Starts a login with a verification code sent to [email].
  ///
  /// If the email address has an account, a sign-in code is sent to it. If it
  /// has none and sign-up is allowed, a sign-up code is sent, and the account
  /// is created when the code is verified.
  ///
  /// Returns the ID of the new login request, which together with the code is
  /// used to finish the login. The response and the errors do not show whether
  /// the email address has an account: if sign-up is disabled, an unknown email
  /// address gets a request that no code was sent for, and that can never be
  /// completed successfully.
  ///
  /// A code is only replaced once the resend cooldown has passed. Within it,
  /// the call fails with the `resendCooldown` reason, and the ID of the pending
  /// request is not returned again, so clients must keep the ID they received
  /// from the successful call and keep using it until it is replaced.
  ///
  /// Throws an [EmailPasswordlessLoginException] in case of errors, with
  /// reason:
  /// - [EmailPasswordlessLoginExceptionReason.invalidEmail] if [email] is not
  ///   a valid email address.
  /// - [EmailPasswordlessLoginExceptionReason.resendCooldown] if a code for the
  ///   email address was requested less than the resend cooldown ago, also by
  ///   a concurrent call.
  /// - [EmailPasswordlessLoginExceptionReason.rateLimited] if too many codes
  ///   have been requested for the email address.
  /// {@endtemplate}
  Future<UuidValue> startLogin(
    final Session session, {
    required final String email,
  }) async {
    return emailPasswordlessIdp.startLogin(session, email: email);
  }

  /// {@template email_passwordless_idp_base_endpoint.finish_login}
  /// Finishes a login by verifying the code of the login request, and returns
  /// a session for the user. A user is created if the email address is new.
  ///
  /// A code can be used once and is invalidated by too many wrong attempts.
  ///
  /// Throws an [EmailPasswordlessLoginException] in case of errors, with
  /// reason:
  /// - [EmailPasswordlessLoginExceptionReason.expired] if the login request
  ///   has already expired.
  /// - [EmailPasswordlessLoginExceptionReason.tooManyAttempts] if too many
  ///   attempts have been made to verify the code.
  /// - [EmailPasswordlessLoginExceptionReason.invalid] if no request exists
  ///   for the given [loginRequestId], it has already been used, or
  ///   [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  /// {@endtemplate}
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
  }) async {
    return emailPasswordlessIdp.finishLogin(
      session,
      loginRequestId: loginRequestId,
      verificationCode: verificationCode,
    );
  }

  @override
  Future<bool> hasAccount(final Session session) async =>
      await emailPasswordlessIdp.hasAccount(session);
}
