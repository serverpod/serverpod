import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../business/passwordless_idp.dart';

/// Base endpoint for passwordless login.
///
/// Subclass this in your own application to expose an endpoint including all
/// methods.
///
/// `THandle` is the typed handle used by [PasswordlessIdpConfig] callbacks.
/// The RPC boundary remains `String handle`; the framework parses that string
/// with `deserializeHandle`, passes the parsed handle to
/// `sendLoginVerificationCode`, stores the stable string returned by
/// `serializeHandle`, and deserializes that stored string again before calling
/// `resolveAuthUserId`.
///
/// [PasswordlessLoginExceptionReason.invalid] is used for invalid handle input
/// during `startLogin()`, and also for invalid verification state during
/// `finishLogin()`, such as missing requests or invalid verification codes.
///
/// Default string-based integrations should explicitly extend
/// `PasswordlessIdpBaseEndpoint<String>`.
///
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
/// Alternatively you can build up your own endpoint on top of the same business
/// logic by using [PasswordlessIdp].
abstract class PasswordlessIdpBaseEndpoint<THandle> extends Endpoint {
  /// Accessor for the configured Passwordless Idp instance.
  /// By default this uses the global instance configured in [AuthServices],
  /// keyed by the exact `PasswordlessIdp<THandle>` type.
  ///
  /// If you want to use a different instance, override this getter.
  late final PasswordlessIdp<THandle> passwordlessIdp =
      AuthServices.getIdentityProvider<PasswordlessIdp<THandle>>();

  /// Verifies the login code and completes the login in a single step.
  ///
  /// Returns an [AuthSuccess] with the authentication tokens.
  ///
  /// Throws a [PasswordlessLoginException] in case of errors, with reason:
  /// - [PasswordlessLoginExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [PasswordlessLoginExceptionReason.invalid] if no request exists
  ///   for the given [loginRequestId] or [verificationCode] is invalid.
  /// - [PasswordlessLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed verification attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  Future<AuthSuccess> finishLogin(
    final Session session, {
    required final UuidValue loginRequestId,
    required final String verificationCode,
  }) async {
    return passwordlessIdp.finishLogin(
      session,
      loginRequestId: loginRequestId,
      verificationCode: verificationCode,
    );
  }

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
}
