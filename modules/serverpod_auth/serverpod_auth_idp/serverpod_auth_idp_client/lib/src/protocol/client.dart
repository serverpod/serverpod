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
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/src/protocol/providers/passkey/models/passkey_login_request.dart'
    as _ij3t58fp;
import 'package:serverpod_auth_idp_client/src/protocol/providers/passkey/models/passkey_registration_request.dart'
    as _i4bbcf8f;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Base endpoint for identity providers.
/// {@category Endpoint}
abstract class EndpointIdpBase extends _isc.EndpointRef {
  EndpointIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Returns the `method` value for each connected [Idp] subclass if the
  /// current session is authenticated and if the user has an account connected
  /// to the [Idp].
  _ida.Future<bool> hasAccount();
}

/// Base endpoint for anonymous accounts.
/// {@category Endpoint}
abstract class EndpointAnonymousIdpBase extends _isc.EndpointRef {
  EndpointAnonymousIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Creates a new anonymous account and returns its session.
  ///
  /// Invokes the [AnonymousIdp.beforeAnonymousAccount] callback if configured,
  /// which may prevent account creation if the endpoint is protected.
  _ida.Future<_iacc.AuthSuccess> login({String? token});
}

/// Endpoint for handling Sign in with Apple.
///
/// To expose these endpoint methods on your server, extend this class in a
/// concrete class.
/// For further details see https://docs.serverpod.dev/concepts/working-with-endpoints#inheriting-from-an-endpoint-class-marked-abstract
/// {@category Endpoint}
abstract class EndpointAppleIdpBase extends EndpointIdpBase {
  EndpointAppleIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Signs in a user with their Apple account.
  ///
  /// If no user exists yet linked to the Apple-provided identifier, a new one
  /// will be created (without any `Scope`s). Further their provided name and
  /// email (if any) will be used for the `UserProfile` which will be linked to
  /// their `AuthUser`.
  ///
  /// Returns a session for the user upon successful login.
  _ida.Future<_iacc.AuthSuccess> login({
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  });

  @override
  _ida.Future<bool> hasAccount();
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
/// logic by using [EmailIdp].
/// {@category Endpoint}
abstract class EndpointEmailIdpBase extends EndpointIdpBase {
  EndpointEmailIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  });

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
  _ida.Future<_isc.UuidValue> startRegistration({required String email});

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  });

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  });

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email});

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  });

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  });

  @override
  _ida.Future<bool> hasAccount();
}

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
/// {@category Endpoint}
abstract class EndpointEmailPasswordlessIdpBase extends EndpointIdpBase {
  EndpointEmailPasswordlessIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Starts a login with a verification code sent to [email].
  ///
  /// If the email address has an account, a sign-in code is sent to it. If it
  /// has none and sign-up is allowed, a sign-up code is sent, and the account
  /// is created when the code is verified.
  ///
  /// Always returns a login request ID, which together with the code is used
  /// to finish the login. If no code was sent, because sign-up is disabled for
  /// an unknown email address, or because a code was sent less than the resend
  /// cooldown ago, the returned ID may not be valid. Clients should wait for
  /// the resend cooldown before requesting another code, and keep using the
  /// ID of the previous request in the meantime.
  ///
  /// Throws an [EmailPasswordlessLoginException] in case of errors, with
  /// reason:
  /// - [EmailPasswordlessLoginExceptionReason.invalidEmail] if [email] is not
  ///   a valid email address.
  /// - [EmailPasswordlessLoginExceptionReason.rateLimited] if too many codes
  ///   have been requested for the email address.
  _ida.Future<_isc.UuidValue> startLogin({required String email});

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
  _ida.Future<_iacc.AuthSuccess> finishLogin({
    required _isc.UuidValue loginRequestId,
    required String verificationCode,
  });

  @override
  _ida.Future<bool> hasAccount();
}

/// Base endpoint for Facebook Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Facebook access tokens.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
/// {@category Endpoint}
abstract class EndpointFacebookIdpBase extends EndpointIdpBase {
  EndpointFacebookIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Validates a Facebook access token and either logs in the associated user or
  /// creates a new user account if the Facebook account ID is not yet known.
  ///
  /// If the access token is invalid or expired, the
  /// [FacebookAccessTokenVerificationException] will be thrown.
  _ida.Future<_iacc.AuthSuccess> login({required String accessToken});

  @override
  _ida.Future<bool> hasAccount();
}

/// Base endpoint for Firebase Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Firebase ID tokens.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
/// {@category Endpoint}
abstract class EndpointFirebaseIdpBase extends EndpointIdpBase {
  EndpointFirebaseIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Validates a Firebase ID token and either logs in the associated user or
  /// creates a new user account if the Firebase account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  _ida.Future<_iacc.AuthSuccess> login({required String idToken});

  @override
  _ida.Future<bool> hasAccount();
}

/// Base endpoint for GitHub Account-based authentication.
///
/// This endpoint exposes methods for logging in users using GitHub authorization codes.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
/// {@category Endpoint}
abstract class EndpointGitHubIdpBase extends EndpointIdpBase {
  EndpointGitHubIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Validates a GitHub authorization code and either logs in the associated
  /// user or creates a new user account if the GitHub account ID is not yet
  /// known.
  ///
  /// This method exchanges the `authorization code` for an `access token` using
  /// `PKCE`, then authenticates the user.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  _ida.Future<_iacc.AuthSuccess> login({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  });

  @override
  _ida.Future<bool> hasAccount();
}

/// Base endpoint for Google Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Google ID tokens.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
/// {@category Endpoint}
abstract class EndpointGoogleIdpBase extends EndpointIdpBase {
  EndpointGoogleIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  _ida.Future<_iacc.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  });

  /// Validates a Google authorization code from the web OAuth2 PKCE flow and
  /// either logs in the associated user or creates a new account.
  ///
  /// This is the web counterpart of [login], which accepts an ID token directly
  /// (used on native platforms via the `google_sign_in` package).
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  _ida.Future<_iacc.AuthSuccess> loginWithCode({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  });

  @override
  _ida.Future<bool> hasAccount();
}

/// Base endpoint for Microsoft Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Microsoft authorization codes.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
/// {@category Endpoint}
abstract class EndpointMicrosoftIdpBase extends EndpointIdpBase {
  EndpointMicrosoftIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Validates a Microsoft authorization code and either logs in the associated
  /// user or creates a new user account if the Microsoft account ID is not yet
  /// known.
  ///
  /// This method exchanges the `authorization code` for an `access token` using
  /// `PKCE`, then authenticates the user.
  ///
  /// The [isWebPlatform] flag indicates whether the client is a web application.
  /// Microsoft requires the client secret only for confidential clients (web
  /// apps). Public clients (mobile, desktop) using PKCE must not include it.
  /// Pass `true` for web clients and `false` for native platforms.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  _ida.Future<_iacc.AuthSuccess> login({
    required String code,
    required String codeVerifier,
    required String redirectUri,
    required bool isWebPlatform,
  });

  @override
  _ida.Future<bool> hasAccount();
}

/// Base endpoint for Passkey-based authentication.
/// {@category Endpoint}
abstract class EndpointPasskeyIdpBase extends EndpointIdpBase {
  EndpointPasskeyIdpBase(_isc.EndpointCaller caller) : super(caller);

  /// Returns a new challenge to be used for a login or registration request.
  _ida.Future<({_idt.ByteData challenge, _isc.UuidValue id})> createChallenge();

  /// Registers a Passkey for the [session]'s current user.
  ///
  /// Throws if the user is not authenticated.
  _ida.Future<void> register({
    required _i4bbcf8f.PasskeyRegistrationRequest registrationRequest,
  });

  /// Authenticates the user related to the given Passkey.
  _ida.Future<_iacc.AuthSuccess> login({
    required _ij3t58fp.PasskeyLoginRequest loginRequest,
  });

  @override
  _ida.Future<bool> hasAccount();
}

class Caller extends _isc.ModuleEndpointCaller {
  Caller(_isc.ServerpodClientShared client) : super(client) {}

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {};
}
