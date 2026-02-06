import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../business/passwordless_idp.dart';

/// Base endpoint for passwordless login.
///
/// Subclass this in your own application to expose an endpoint including all
/// methods.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
/// Alternatively you can build up your own endpoint on top of the same business
/// logic by using [PasswordlessIdp].
abstract class PasswordlessIdpBaseEndpoint extends Endpoint {
  /// Accessor for the configured Passwordless Idp instance.
  /// By default this uses the global instance configured in [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  PasswordlessIdp get passwordlessIdp => AuthServices.instance.passwordlessIdp;

  /// Starts the login process and delivers a verification code using the
  /// configured callback.
  ///
  /// Returns the login request ID.
  ///
  /// Throws a [PasswordlessLoginException] in case of errors, with reason:
  /// - [PasswordlessLoginExceptionReason.invalid] if the handle is invalid.
  /// - [PasswordlessLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many login attempts.
  Future<UuidValue> startLogin(
    final Session session, {
    required final String handle,
  }) async {
    return passwordlessIdp.startLogin(
      session,
      handle: handle,
    );
  }

  /// Verifies a login code and returns a token that can be used to complete the
  /// login.
  ///
  /// Throws a [PasswordlessLoginException] in case of errors, with reason:
  /// - [PasswordlessLoginExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [PasswordlessLoginExceptionReason.invalid] if no request exists
  ///   for the given [loginRequestId] or [verificationCode] is invalid.
  /// - [PasswordlessLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed verification attempts.
  Future<String> verifyLoginCode(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
  }) async {
    return passwordlessIdp.verifyLoginCode(
      session,
      loginRequestId: loginRequestId,
      verificationCode: verificationCode,
    );
  }

  /// Completes the login process and returns a new session.
  ///
  /// Throws a [PasswordlessLoginException] in case of errors, with reason:
  /// - [PasswordlessLoginExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [PasswordlessLoginExceptionReason.invalid] if the [loginToken] is invalid.
  /// - [PasswordlessLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed completion attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final String loginToken,
  }) async {
    return passwordlessIdp.finishLogin(
      session,
      loginToken: loginToken,
    );
  }
}
