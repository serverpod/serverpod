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
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i4;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i5;
import 'dart:typed_data' as _i6;
import 'package:serverpod_auth_bridge_client/serverpod_auth_bridge_client.dart'
    as _i7;
import 'package:serverpod_auth_migration_client/serverpod_auth_migration_client.dart'
    as _i8;
import 'protocol.dart' as _i9;

/// Endpoint for testing authentication.
/// {@category Endpoint}
class EndpointAuthTest extends _i1.EndpointRef {
  EndpointAuthTest(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authTest';

  /// Creates a new test user.
  _i2.Future<_i1.UuidValue> createTestUser() =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'authTest',
        'createTestUser',
        {},
      );

  /// Creates a new session authentication for the test user.
  _i2.Future<_i3.AuthSuccess> createSasToken(_i1.UuidValue authUserId) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'authTest',
        'createSasToken',
        {'authUserId': authUserId},
      );

  _i2.Future<void> deleteSasTokens(_i1.UuidValue authUserId) =>
      caller.callServerEndpoint<void>(
        'authTest',
        'deleteSasTokens',
        {'authUserId': authUserId},
      );

  /// Creates a new JWT token for the test user.
  _i2.Future<_i3.AuthSuccess> createJwtToken(_i1.UuidValue authUserId) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'authTest',
        'createJwtToken',
        {'authUserId': authUserId},
      );

  /// Deletes all refresh tokens for the test user.
  _i2.Future<void> deleteJwtRefreshTokens(_i1.UuidValue authUserId) =>
      caller.callServerEndpoint<void>(
        'authTest',
        'deleteJwtRefreshTokens',
        {'authUserId': authUserId},
      );

  /// Checks if the session is authenticated for the test user.
  _i2.Future<bool> checkSession(_i1.UuidValue authUserId) =>
      caller.callServerEndpoint<bool>(
        'authTest',
        'checkSession',
        {'authUserId': authUserId},
      );
}

/// {@category Endpoint}
class EndpointEmailAccountBackwardsCompatibilityTest extends _i1.EndpointRef {
  EndpointEmailAccountBackwardsCompatibilityTest(_i1.EndpointCaller caller)
      : super(caller);

  @override
  String get name => 'emailAccountBackwardsCompatibilityTest';

  _i2.Future<int> createLegacyUser({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<int>(
        'emailAccountBackwardsCompatibilityTest',
        'createLegacyUser',
        {
          'email': email,
          'password': password,
        },
      );

  _i2.Future<_i4.AuthKey> createLegacySession({
    required int userId,
    required Set<String> scopes,
  }) =>
      caller.callServerEndpoint<_i4.AuthKey>(
        'emailAccountBackwardsCompatibilityTest',
        'createLegacySession',
        {
          'userId': userId,
          'scopes': scopes,
        },
      );

  _i2.Future<void> migrateUser({
    required int legacyUserId,
    String? password,
  }) =>
      caller.callServerEndpoint<void>(
        'emailAccountBackwardsCompatibilityTest',
        'migrateUser',
        {
          'legacyUserId': legacyUserId,
          'password': password,
        },
      );

  /// Returns the new auth user ID.
  _i2.Future<_i1.UuidValue?> getNewAuthUserId({required int userId}) =>
      caller.callServerEndpoint<_i1.UuidValue?>(
        'emailAccountBackwardsCompatibilityTest',
        'getNewAuthUserId',
        {'userId': userId},
      );

  /// Delete `UserInfo`, `AuthKey` and `EmailAuth` entities for the user
  _i2.Future<void> deleteLegacyAuthData({required int userId}) =>
      caller.callServerEndpoint<void>(
        'emailAccountBackwardsCompatibilityTest',
        'deleteLegacyAuthData',
        {'userId': userId},
      );

  /// Returns the user identifier associated with the session.
  ///
  /// Since the server runs with the backwards compatible auth handler, both
  /// old session keys will work post migration.
  _i2.Future<String?> sessionUserIdentifier() =>
      caller.callServerEndpoint<String?>(
        'emailAccountBackwardsCompatibilityTest',
        'sessionUserIdentifier',
        {},
      );

  /// Returns the user ID of associated with the session derived from the session key
  _i2.Future<bool> checkLegacyPassword({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<bool>(
        'emailAccountBackwardsCompatibilityTest',
        'checkLegacyPassword',
        {
          'email': email,
          'password': password,
        },
      );
}

/// Endpoint for email-based authentication.
/// {@category Endpoint}
class EndpointEmailAccount extends _i5.EndpointAuthEmailBase {
  EndpointEmailAccount(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailAccount';

  /// {@template email_account_base_endpoint.login}
  /// Logs in the user and returns a new session.
  ///
  /// In case an expected error occurs, this throws a
  /// [EmailAccountLoginException].
  /// {@endtemplate}
  @override
  _i2.Future<_i3.AuthSuccess> login({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'emailAccount',
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
  _i2.Future<_i1.UuidValue> startRegistration({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailAccount',
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
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts to verify the account.
  /// - [EmailAccountRequestExceptionReason.unauthorized] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  ///
  /// Returns a session for the newly created user.
  /// {@endtemplate}
  @override
  _i2.Future<_i3.AuthSuccess> finishRegistration({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'emailAccount',
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
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailAccount',
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
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to complete the password reset.
  /// - [EmailAccountRequestExceptionReason.unauthorized] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If the reset was successful, a new session is returned and all previous
  /// active sessions of the user are destroyed.
  /// {@endtemplate}
  @override
  _i2.Future<_i3.AuthSuccess> finishPasswordReset({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
    required String newPassword,
  }) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'emailAccount',
        'finishPasswordReset',
        {
          'passwordResetRequestId': passwordResetRequestId,
          'verificationCode': verificationCode,
          'newPassword': newPassword,
        },
      );
}

/// Endpoint for Google-based authentication, which automatically imports legacy
/// accounts.
/// {@category Endpoint}
class EndpointGoogleAccountBackwardsCompatibilityTest
    extends _i5.EndpointGoogleAccountBase {
  EndpointGoogleAccountBackwardsCompatibilityTest(_i1.EndpointCaller caller)
      : super(caller);

  @override
  String get name => 'googleAccountBackwardsCompatibilityTest';

  @override
  _i2.Future<_i3.AuthSuccess> authenticate({required String idToken}) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'googleAccountBackwardsCompatibilityTest',
        'authenticate',
        {'idToken': idToken},
      );
}

/// Endpoint for Google-based authentication.
/// {@category Endpoint}
class EndpointGoogleAccount extends _i5.EndpointGoogleAccountBase {
  EndpointGoogleAccount(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleAccount';

  /// Logs in or registers an [AuthUser] for the given Google account ID.
  @override
  _i2.Future<_i3.AuthSuccess> authenticate({required String idToken}) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'googleAccount',
        'authenticate',
        {'idToken': idToken},
      );
}

/// Endpoint for email-based authentication which imports the legacy passwords.
/// {@category Endpoint}
class EndpointPasswordImportingEmailAccount extends _i5.EndpointAuthEmailBase {
  EndpointPasswordImportingEmailAccount(_i1.EndpointCaller caller)
      : super(caller);

  @override
  String get name => 'passwordImportingEmailAccount';

  /// Logs in the user and returns a new session.
  ///
  /// In case an expected error occurs, this throws a `EmailAccountLoginException`.
  @override
  _i2.Future<_i3.AuthSuccess> login({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'passwordImportingEmailAccount',
        'login',
        {
          'email': email,
          'password': password,
        },
      );

  /// Starts the registration for a new user account with an email-based login associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to complete the registration.
  @override
  _i2.Future<_i1.UuidValue> startRegistration({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'passwordImportingEmailAccount',
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
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts to verify the account.
  /// - [EmailAccountRequestExceptionReason.unauthorized] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  ///
  /// Returns a session for the newly created user.
  /// {@endtemplate}
  @override
  _i2.Future<_i3.AuthSuccess> finishRegistration({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'passwordImportingEmailAccount',
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
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'passwordImportingEmailAccount',
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
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to complete the password reset.
  /// - [EmailAccountRequestExceptionReason.unauthorized] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If the reset was successful, a new session is returned and all previous
  /// active sessions of the user are destroyed.
  /// {@endtemplate}
  @override
  _i2.Future<_i3.AuthSuccess> finishPasswordReset({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
    required String newPassword,
  }) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'passwordImportingEmailAccount',
        'finishPasswordReset',
        {
          'passwordResetRequestId': passwordResetRequestId,
          'verificationCode': verificationCode,
          'newPassword': newPassword,
        },
      );
}

/// Endpoint to view and edit one's profile.
/// {@category Endpoint}
class EndpointUserProfile extends _i3.EndpointUserProfileBase {
  EndpointUserProfile(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userProfile';

  /// Returns the user profile of the current user.
  @override
  _i2.Future<_i3.UserProfileModel> get() =>
      caller.callServerEndpoint<_i3.UserProfileModel>(
        'userProfile',
        'get',
        {},
      );

  /// Removes the users uploaded image, replacing it with the default user
  /// image.
  @override
  _i2.Future<_i3.UserProfileModel> removeUserImage() =>
      caller.callServerEndpoint<_i3.UserProfileModel>(
        'userProfile',
        'removeUserImage',
        {},
      );

  /// Sets a new user image for the signed in user.
  @override
  _i2.Future<_i3.UserProfileModel> setUserImage(_i6.ByteData image) =>
      caller.callServerEndpoint<_i3.UserProfileModel>(
        'userProfile',
        'setUserImage',
        {'image': image},
      );

  /// Changes the name of a user.
  @override
  _i2.Future<_i3.UserProfileModel> changeUserName(String? userName) =>
      caller.callServerEndpoint<_i3.UserProfileModel>(
        'userProfile',
        'changeUserName',
        {'userName': userName},
      );

  /// Changes the full name of a user.
  @override
  _i2.Future<_i3.UserProfileModel> changeFullName(String? fullName) =>
      caller.callServerEndpoint<_i3.UserProfileModel>(
        'userProfile',
        'changeFullName',
        {'fullName': fullName},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_bridge = _i7.Caller(client);
    serverpod_auth_core = _i3.Caller(client);
    serverpod_auth_idp = _i5.Caller(client);
    serverpod_auth_migration = _i8.Caller(client);
    auth = _i4.Caller(client);
  }

  late final _i7.Caller serverpod_auth_bridge;

  late final _i3.Caller serverpod_auth_core;

  late final _i5.Caller serverpod_auth_idp;

  late final _i8.Caller serverpod_auth_migration;

  late final _i4.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i9.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    authTest = EndpointAuthTest(this);
    emailAccountBackwardsCompatibilityTest =
        EndpointEmailAccountBackwardsCompatibilityTest(this);
    emailAccount = EndpointEmailAccount(this);
    googleAccountBackwardsCompatibilityTest =
        EndpointGoogleAccountBackwardsCompatibilityTest(this);
    googleAccount = EndpointGoogleAccount(this);
    passwordImportingEmailAccount = EndpointPasswordImportingEmailAccount(this);
    userProfile = EndpointUserProfile(this);
    modules = Modules(this);
  }

  late final EndpointAuthTest authTest;

  late final EndpointEmailAccountBackwardsCompatibilityTest
      emailAccountBackwardsCompatibilityTest;

  late final EndpointEmailAccount emailAccount;

  late final EndpointGoogleAccountBackwardsCompatibilityTest
      googleAccountBackwardsCompatibilityTest;

  late final EndpointGoogleAccount googleAccount;

  late final EndpointPasswordImportingEmailAccount
      passwordImportingEmailAccount;

  late final EndpointUserProfile userProfile;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'authTest': authTest,
        'emailAccountBackwardsCompatibilityTest':
            emailAccountBackwardsCompatibilityTest,
        'emailAccount': emailAccount,
        'googleAccountBackwardsCompatibilityTest':
            googleAccountBackwardsCompatibilityTest,
        'googleAccount': googleAccount,
        'passwordImportingEmailAccount': passwordImportingEmailAccount,
        'userProfile': userProfile,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
        'serverpod_auth_bridge': modules.serverpod_auth_bridge,
        'serverpod_auth_core': modules.serverpod_auth_core,
        'serverpod_auth_idp': modules.serverpod_auth_idp,
        'serverpod_auth_migration': modules.serverpod_auth_migration,
        'auth': modules.auth,
      };
}
