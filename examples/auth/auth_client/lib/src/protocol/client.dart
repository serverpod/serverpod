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
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:auth_client/src/protocol/greeting.dart' as _i5;
import 'protocol.dart' as _i6;

/// {@category Endpoint}
class EndpointAppleIDP extends _i1.EndpointAppleIDPBase {
  EndpointAppleIDP(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'appleIDP';

  /// {@template apple_idp_base_endpoint.login}
  /// Signs in a user with their Apple account.
  ///
  /// If no user exists yet linked to the Apple-provided identifier, a new one
  /// will be created (without any `Scope`s). Further their provided name and
  /// email (if any) will be used for the `UserProfile` which will be linked to
  /// their `AuthUser`.
  ///
  /// Returns a session for the user upon successful login.
  /// {@endtemplate}
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  }) =>
      caller.callServerEndpoint<_i4.AuthSuccess>(
        'appleIDP',
        'login',
        {
          'identityToken': identityToken,
          'authorizationCode': authorizationCode,
          'isNativeApplePlatformSignIn': isNativeApplePlatformSignIn,
          'firstName': firstName,
          'lastName': lastName,
        },
      );
}

/// {@category Endpoint}
class EndpointEmailIDP extends _i1.EndpointEmailIDPBase {
  EndpointEmailIDP(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIDP';

  /// {@template email_account_base_endpoint.login}
  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  /// {@endtemplate}
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<_i4.AuthSuccess>(
        'emailIDP',
        'login',
        {
          'email': email,
          'password': password,
        },
      );

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
  @override
  _i3.Future<_i2.UuidValue> startRegistration({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIDP',
        'startRegistration',
        {
          'email': email,
          'password': password,
        },
      );

  /// {@template email_account_base_endpoint.finish_registration}
  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId], [verificationCode] is invalid, or
  ///   the request has not been verified yet.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  /// {@endtemplate}
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) =>
      caller.callServerEndpoint<_i4.AuthSuccess>(
        'emailIDP',
        'finishRegistration',
        {
          'accountRequestId': accountRequestId,
          'verificationCode': verificationCode,
        },
      );

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
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIDP',
        'startPasswordReset',
        {'email': email},
      );

  /// {@template email_account_base_endpoint.finish_password_reset}
  /// Completes a password reset request by setting a new password.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to complete the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// If the reset was successful, a new session is returned and all previous
  /// active sessions of the user are destroyed.
  /// {@endtemplate}
  @override
  _i3.Future<_i4.AuthSuccess> finishPasswordReset({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
    required String newPassword,
  }) =>
      caller.callServerEndpoint<_i4.AuthSuccess>(
        'emailIDP',
        'finishPasswordReset',
        {
          'passwordResetRequestId': passwordResetRequestId,
          'verificationCode': verificationCode,
          'newPassword': newPassword,
        },
      );
}

/// {@category Endpoint}
class EndpointGoogleIDP extends _i1.EndpointGoogleIDPBase {
  EndpointGoogleIDP(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleIDP';

  /// {@template google_idp_base_endpoint.login}
  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  /// {@endtemplate}
  @override
  _i3.Future<_i4.AuthSuccess> login({required String idToken}) =>
      caller.callServerEndpoint<_i4.AuthSuccess>(
        'googleIDP',
        'login',
        {'idToken': idToken},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i5.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i5.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i2.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i6.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    appleIDP = EndpointAppleIDP(this);
    emailIDP = EndpointEmailIDP(this);
    googleIDP = EndpointGoogleIDP(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointAppleIDP appleIDP;

  late final EndpointEmailIDP emailIDP;

  late final EndpointGoogleIDP googleIDP;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
        'appleIDP': appleIDP,
        'emailIDP': emailIDP,
        'googleIDP': googleIDP,
        'greeting': greeting,
      };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
        'serverpod_auth_idp': modules.serverpod_auth_idp,
        'serverpod_auth_core': modules.serverpod_auth_core,
      };
}
