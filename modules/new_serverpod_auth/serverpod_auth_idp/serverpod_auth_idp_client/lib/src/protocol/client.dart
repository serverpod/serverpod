/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i3;
import 'dart:typed_data' as _i4;
import 'package:serverpod_auth_idp_client/src/protocol/providers/passkey/models/passkey_registration_request.dart'
    as _i5;
import 'package:serverpod_auth_idp_client/src/protocol/providers/passkey/models/passkey_login_request.dart'
    as _i6;

/// Endpoint for handling Sign in with Apple.
///
/// To expose these endpoint methods on your server, extend this class in a
/// concrete class.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
/// {@category Endpoint}
abstract class EndpointAppleAccountBase extends _i1.EndpointRef {
  EndpointAppleAccountBase(_i1.EndpointCaller caller) : super(caller);

  /// Signs in a user with their Apple account.
  ///
  /// If no user exists yet linked to the Apple-provided identifier, a new one
  /// will be created (without any `Scope`s). Further their provided name and
  /// email (if any) will be used for the `UserProfile` which will be linked to
  /// their `AuthUser`.
  ///
  /// Returns a session for the user upon successful login.
  _i2.Future<_i3.AuthSuccess> signIn({
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  });
}

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
/// {@category Endpoint}
abstract class EndpointAuthEmailBase extends _i1.EndpointRef {
  EndpointAuthEmailBase(_i1.EndpointCaller caller) : super(caller);

  /// {@template email_account_base_endpoint.login}
  /// Logs in the user and returns a new session.
  ///
  /// In case an expected error occurs, this throws a
  /// [EmailAccountLoginException].
  /// {@endtemplate}
  _i2.Future<_i3.AuthSuccess> login({
    required String email,
    required String password,
  });

  /// {@template email_account_base_endpoint.start_registration}
  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  /// {@endtemplate}
  _i2.Future<void> startRegistration({
    required String email,
    required String password,
  });

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
  _i2.Future<_i3.AuthSuccess> finishRegistration({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  });

  /// {@template email_account_base_endpoint.start_password_reset}
  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Throws an [EmailAccountPasswordResetRequestTooManyAttemptsException] in
  /// case the client or account has been involved in too many reset attempts.
  /// {@endtemplate}
  _i2.Future<void> startPasswordReset({required String email});

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
  _i2.Future<_i3.AuthSuccess> finishPasswordReset({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
    required String newPassword,
  });
}

/// Base endpoint for Google Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Google ID tokens.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
/// {@category Endpoint}
abstract class EndpointGoogleIDPBase extends _i1.EndpointRef {
  EndpointGoogleIDPBase(_i1.EndpointCaller caller) : super(caller);

  /// {@template google_idp_base_endpoint.login}
  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  /// {@endtemplate}
  _i2.Future<_i3.AuthSuccess> login({required String idToken});
}

/// Base endpoint for Passkey-based authentication.
/// {@category Endpoint}
abstract class EndpointPasskeyAccountBase extends _i1.EndpointRef {
  EndpointPasskeyAccountBase(_i1.EndpointCaller caller) : super(caller);

  /// Returns a new challenge to be used for a login or registration request.
  _i2.Future<({_i4.ByteData challenge, _i1.UuidValue id})> createChallenge();

  /// Registers a Passkey for the [session]'s current user.
  _i2.Future<void> register(
      {required _i5.PasskeyRegistrationRequest registrationRequest});

  /// Authenticates the user related to the given Passkey.
  _i2.Future<_i3.AuthSuccess> authenticate(
      {required _i6.PasskeyLoginRequest loginRequest});
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {}

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {};
}
