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
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_bridge_client/serverpod_auth_bridge_client.dart'
    as _iabc;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i312scxx;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_auth_migration_client/serverpod_auth_migration_client.dart'
    as _iamc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Endpoint for Apple-based authentication.
/// {@category Endpoint}
class EndpointAppleAccount extends _iaic.EndpointAppleIdpBase {
  EndpointAppleAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'appleAccount';

  /// Signs in a user with their Apple account.
  ///
  /// If no user exists yet linked to the Apple-provided identifier, a new one
  /// will be created (without any `Scope`s). Further their provided name and
  /// email (if any) will be used for the `UserProfile` which will be linked to
  /// their `AuthUser`.
  ///
  /// Returns a session for the user upon successful login.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'appleAccount',
    'login',
    {
      'identityToken': identityToken,
      'authorizationCode': authorizationCode,
      'isNativeApplePlatformSignIn': isNativeApplePlatformSignIn,
      'firstName': firstName,
      'lastName': lastName,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'appleAccount',
    'hasAccount',
    {},
  );
}

/// Endpoint for testing authentication.
/// {@category Endpoint}
class EndpointAuthTest extends _isc.EndpointRef {
  EndpointAuthTest(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authTest';

  /// Creates a new test user.
  _ida.Future<_isc.UuidValue> createTestUser() =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'authTest',
        'createTestUser',
        {},
      );

  /// Creates a new session authentication for the test user.
  _ida.Future<_iacc.AuthSuccess> createSasToken(_isc.UuidValue authUserId) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'authTest',
        'createSasToken',
        {'authUserId': authUserId},
      );

  _ida.Future<void> deleteSasTokens(_isc.UuidValue authUserId) =>
      caller.callServerEndpoint<void>(
        'authTest',
        'deleteSasTokens',
        {'authUserId': authUserId},
      );

  /// Creates a new JWT token for the test user.
  _ida.Future<_iacc.AuthSuccess> createJwtToken(_isc.UuidValue authUserId) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'authTest',
        'createJwtToken',
        {'authUserId': authUserId},
      );

  /// Deletes all refresh tokens for the test user.
  _ida.Future<void> deleteJwtRefreshTokens(_isc.UuidValue authUserId) =>
      caller.callServerEndpoint<void>(
        'authTest',
        'deleteJwtRefreshTokens',
        {'authUserId': authUserId},
      );

  /// Destroys a specific refresh token by ID.
  _ida.Future<bool> destroySpecificRefreshToken(String token) =>
      caller.callServerEndpoint<bool>(
        'authTest',
        'destroySpecificRefreshToken',
        {'token': token},
      );

  /// Checks if the session is authenticated for the test user.
  _ida.Future<bool> checkSession(_isc.UuidValue authUserId) =>
      caller.callServerEndpoint<bool>(
        'authTest',
        'checkSession',
        {'authUserId': authUserId},
      );

  _ida.Future<bool> checkSessionUnauthenticated() =>
      caller.callServerEndpoint<bool>(
        'authTest',
        'checkSessionUnauthenticated',
        {},
        authenticated: false,
      );

  _ida.Stream<bool> checkSessionUnauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'authTest',
        'checkSessionUnauthenticatedStream',
        {},
        {},
        authenticated: false,
      );

  _ida.Stream<String?> openPublicUserStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<String?>, String?>(
        'authTest',
        'openPublicUserStream',
        {},
        {},
      );

  _ida.Future<void> resetJwtRefreshConcurrency() =>
      caller.callServerEndpoint<void>(
        'authTest',
        'resetJwtRefreshConcurrency',
        {},
      );

  _ida.Future<int> getMaxConcurrentJwtRefreshes() =>
      caller.callServerEndpoint<int>(
        'authTest',
        'getMaxConcurrentJwtRefreshes',
        {},
      );

  _ida.Future<int> getJwtRefreshCallCount() => caller.callServerEndpoint<int>(
    'authTest',
    'getJwtRefreshCallCount',
    {},
  );

  /// Returns the auth-mode marker and whether an authorization header was
  /// received, as seen by the server on this authenticated call.
  _ida.Future<List<String?>> getReceivedAuthHeaders() =>
      caller.callServerEndpoint<List<String?>>(
        'authTest',
        'getReceivedAuthHeaders',
        {},
      );

  /// Like [getReceivedAuthHeaders], for an unauthenticated call.
  _ida.Future<List<String?>> getReceivedAuthHeadersUnauthenticated() =>
      caller.callServerEndpoint<List<String?>>(
        'authTest',
        'getReceivedAuthHeadersUnauthenticated',
        {},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointUnauthenticatedRequireLoginAuthTest extends _isc.EndpointRef {
  EndpointUnauthenticatedRequireLoginAuthTest(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'unauthenticatedRequireLoginAuthTest';

  _ida.Future<void> call() => caller.callServerEndpoint<void>(
    'unauthenticatedRequireLoginAuthTest',
    'call',
    {},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointAuthenticatedStreamingTest extends _isc.EndpointRef {
  EndpointAuthenticatedStreamingTest(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'authenticatedStreamingTest';

  _ida.Stream<int> openAuthenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'authenticatedStreamingTest',
        'openAuthenticatedStream',
        {},
        {},
      );

  _ida.Stream<String> watchAuthenticatedUserId() =>
      caller.callStreamingServerEndpoint<_ida.Stream<String>, String>(
        'authenticatedStreamingTest',
        'watchAuthenticatedUserId',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointEmailAccountBackwardsCompatibilityTest extends _isc.EndpointRef {
  EndpointEmailAccountBackwardsCompatibilityTest(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'emailAccountBackwardsCompatibilityTest';

  _ida.Future<int> createLegacyUser({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<int>(
    'emailAccountBackwardsCompatibilityTest',
    'createLegacyUser',
    {
      'email': email,
      'password': password,
    },
  );

  _ida.Future<_i312scxx.AuthKey> createLegacySession({
    required int userId,
    required Set<String> scopes,
  }) => caller.callServerEndpoint<_i312scxx.AuthKey>(
    'emailAccountBackwardsCompatibilityTest',
    'createLegacySession',
    {
      'userId': userId,
      'scopes': scopes,
    },
  );

  _ida.Future<void> migrateUser({
    required int legacyUserId,
    String? password,
  }) => caller.callServerEndpoint<void>(
    'emailAccountBackwardsCompatibilityTest',
    'migrateUser',
    {
      'legacyUserId': legacyUserId,
      'password': password,
    },
  );

  /// Returns the new auth user ID.
  _ida.Future<_isc.UuidValue?> getNewAuthUserId({required int userId}) =>
      caller.callServerEndpoint<_isc.UuidValue?>(
        'emailAccountBackwardsCompatibilityTest',
        'getNewAuthUserId',
        {'userId': userId},
      );

  /// Delete `UserInfo`, `AuthKey` and `EmailAuth` entities for the user
  _ida.Future<void> deleteLegacyAuthData({required int userId}) =>
      caller.callServerEndpoint<void>(
        'emailAccountBackwardsCompatibilityTest',
        'deleteLegacyAuthData',
        {'userId': userId},
      );

  /// Returns the user identifier associated with the session.
  ///
  /// Since the server runs with the backwards compatible auth handler, both
  /// old session keys will work post migration.
  _ida.Future<String?> sessionUserIdentifier() =>
      caller.callServerEndpoint<String?>(
        'emailAccountBackwardsCompatibilityTest',
        'sessionUserIdentifier',
        {},
      );

  /// Returns the user ID of associated with the session derived from the session key
  _ida.Future<bool> checkLegacyPassword({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<bool>(
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
class EndpointEmailAccount extends _iaic.EndpointEmailIdpBase {
  EndpointEmailAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailAccount';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailAccount',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

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
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailAccount',
        'startRegistration',
        {'email': email},
      );

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
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailAccount',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

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
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailAccount',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

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
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailAccount',
        'startPasswordReset',
        {'email': email},
      );

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
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailAccount',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

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
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailAccount',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailAccount',
    'hasAccount',
    {},
  );
}

/// Endpoint for Firebase-based authentication.
/// {@category Endpoint}
class EndpointFirebaseAccount extends _iaic.EndpointFirebaseIdpBase {
  EndpointFirebaseAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'firebaseAccount';

  /// Validates a Firebase ID token and either logs in the associated user or
  /// creates a new user account if the Firebase account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _ida.Future<_iacc.AuthSuccess> login({required String idToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'firebaseAccount',
        'login',
        {'idToken': idToken},
      );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'firebaseAccount',
    'hasAccount',
    {},
  );
}

/// Endpoint for GitHub-based authentication.
/// {@category Endpoint}
class EndpointGitHubAccount extends _iaic.EndpointGitHubIdpBase {
  EndpointGitHubAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'gitHubAccount';

  /// Validates a GitHub authorization code and either logs in the associated
  /// user or creates a new user account if the GitHub account ID is not yet
  /// known.
  ///
  /// This method exchanges the `authorization code` for an `access token` using
  /// `PKCE`, then authenticates the user.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'gitHubAccount',
    'login',
    {
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectUri': redirectUri,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'gitHubAccount',
    'hasAccount',
    {},
  );
}

/// Endpoint for Google-based authentication, which automatically imports legacy
/// accounts.
/// {@category Endpoint}
class EndpointGoogleAccountBackwardsCompatibilityTest
    extends _iaic.EndpointGoogleIdpBase {
  EndpointGoogleAccountBackwardsCompatibilityTest(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'googleAccountBackwardsCompatibilityTest';

  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleAccountBackwardsCompatibilityTest',
    'login',
    {
      'idToken': idToken,
      'accessToken': accessToken,
    },
  );

  /// Validates a Google authorization code from the web OAuth2 PKCE flow and
  /// either logs in the associated user or creates a new account.
  ///
  /// This is the web counterpart of [login], which accepts an ID token directly
  /// (used on native platforms via the `google_sign_in` package).
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _ida.Future<_iacc.AuthSuccess> loginWithCode({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleAccountBackwardsCompatibilityTest',
    'loginWithCode',
    {
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectUri': redirectUri,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'googleAccountBackwardsCompatibilityTest',
    'hasAccount',
    {},
  );
}

/// Endpoint for Google-based authentication.
/// {@category Endpoint}
class EndpointGoogleAccount extends _iaic.EndpointGoogleIdpBase {
  EndpointGoogleAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleAccount';

  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleAccount',
    'login',
    {
      'idToken': idToken,
      'accessToken': accessToken,
    },
  );

  /// Validates a Google authorization code from the web OAuth2 PKCE flow and
  /// either logs in the associated user or creates a new account.
  ///
  /// This is the web counterpart of [login], which accepts an ID token directly
  /// (used on native platforms via the `google_sign_in` package).
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _ida.Future<_iacc.AuthSuccess> loginWithCode({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleAccount',
    'loginWithCode',
    {
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectUri': redirectUri,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'googleAccount',
    'hasAccount',
    {},
  );
}

/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Endpoint for Passkey-based authentication.
/// {@category Endpoint}
class EndpointPasskeyAccount extends _iaic.EndpointPasskeyIdpBase {
  EndpointPasskeyAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'passkeyAccount';

  /// Returns a new challenge to be used for a login or registration request.
  @override
  _ida.Future<({_idt.ByteData challenge, _isc.UuidValue id})>
  createChallenge() =>
      caller.callServerEndpoint<({_idt.ByteData challenge, _isc.UuidValue id})>(
        'passkeyAccount',
        'createChallenge',
        {},
      );

  /// Registers a Passkey for the [session]'s current user.
  ///
  /// Throws if the user is not authenticated.
  @override
  _ida.Future<void> register({
    required _iaic.PasskeyRegistrationRequest registrationRequest,
  }) => caller.callServerEndpoint<void>(
    'passkeyAccount',
    'register',
    {'registrationRequest': registrationRequest},
  );

  /// Authenticates the user related to the given Passkey.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required _iaic.PasskeyLoginRequest loginRequest,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'passkeyAccount',
    'login',
    {'loginRequest': loginRequest},
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'passkeyAccount',
    'hasAccount',
    {},
  );
}

/// Endpoint for email-based authentication which imports the legacy passwords.
/// {@category Endpoint}
class EndpointPasswordImportingEmailAccount extends _iaic.EndpointEmailIdpBase {
  EndpointPasswordImportingEmailAccount(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'passwordImportingEmailAccount';

  /// Logs in the user and returns a new session.
  ///
  /// In case an expected error occurs, this throws a `EmailAccountLoginException`.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'passwordImportingEmailAccount',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

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
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'passwordImportingEmailAccount',
        'startRegistration',
        {'email': email},
      );

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
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'passwordImportingEmailAccount',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

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
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'passwordImportingEmailAccount',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

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
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'passwordImportingEmailAccount',
        'startPasswordReset',
        {'email': email},
      );

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
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'passwordImportingEmailAccount',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

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
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'passwordImportingEmailAccount',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'passwordImportingEmailAccount',
    'hasAccount',
    {},
  );
}

/// Endpoint to view and edit one's profile.
/// {@category Endpoint}
class EndpointUserProfile extends _iacc.EndpointUserProfileEditBase {
  EndpointUserProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userProfile';

  /// Removes the user's uploaded image, setting it to null.
  ///
  /// The client should handle displaying a placeholder for users without images.
  @override
  _ida.Future<_iacc.UserProfileModel> removeUserImage() =>
      caller.callServerEndpoint<_iacc.UserProfileModel>(
        'userProfile',
        'removeUserImage',
        {},
      );

  /// Sets a new user image for the signed in user.
  @override
  _ida.Future<_iacc.UserProfileModel> setUserImage(_idt.ByteData image) =>
      caller.callServerEndpoint<_iacc.UserProfileModel>(
        'userProfile',
        'setUserImage',
        {'image': image},
      );

  /// Changes the name of a user.
  @override
  _ida.Future<_iacc.UserProfileModel> changeUserName(String? userName) =>
      caller.callServerEndpoint<_iacc.UserProfileModel>(
        'userProfile',
        'changeUserName',
        {'userName': userName},
      );

  /// Changes the full name of a user.
  @override
  _ida.Future<_iacc.UserProfileModel> changeFullName(String? fullName) =>
      caller.callServerEndpoint<_iacc.UserProfileModel>(
        'userProfile',
        'changeFullName',
        {'fullName': fullName},
      );

  /// Returns the user profile of the current user.
  @override
  _ida.Future<_iacc.UserProfileModel> get() =>
      caller.callServerEndpoint<_iacc.UserProfileModel>(
        'userProfile',
        'get',
        {},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_bridge = _iabc.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_migration = _iamc.Caller(client);
    auth = _i312scxx.Caller(client);
  }

  late final _iabc.Caller serverpod_auth_bridge;

  late final _iacc.Caller serverpod_auth_core;

  late final _iaic.Caller serverpod_auth_idp;

  late final _iamc.Caller serverpod_auth_migration;

  late final _i312scxx.Caller auth;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    appleAccount = EndpointAppleAccount(this);
    authTest = EndpointAuthTest(this);
    unauthenticatedRequireLoginAuthTest =
        EndpointUnauthenticatedRequireLoginAuthTest(this);
    authenticatedStreamingTest = EndpointAuthenticatedStreamingTest(this);
    emailAccountBackwardsCompatibilityTest =
        EndpointEmailAccountBackwardsCompatibilityTest(this);
    emailAccount = EndpointEmailAccount(this);
    firebaseAccount = EndpointFirebaseAccount(this);
    gitHubAccount = EndpointGitHubAccount(this);
    googleAccountBackwardsCompatibilityTest =
        EndpointGoogleAccountBackwardsCompatibilityTest(this);
    googleAccount = EndpointGoogleAccount(this);
    jwtRefresh = EndpointJwtRefresh(this);
    passkeyAccount = EndpointPasskeyAccount(this);
    passwordImportingEmailAccount = EndpointPasswordImportingEmailAccount(this);
    userProfile = EndpointUserProfile(this);
    modules = Modules(this);
  }

  late final EndpointAppleAccount appleAccount;

  late final EndpointAuthTest authTest;

  late final EndpointUnauthenticatedRequireLoginAuthTest
  unauthenticatedRequireLoginAuthTest;

  late final EndpointAuthenticatedStreamingTest authenticatedStreamingTest;

  late final EndpointEmailAccountBackwardsCompatibilityTest
  emailAccountBackwardsCompatibilityTest;

  late final EndpointEmailAccount emailAccount;

  late final EndpointFirebaseAccount firebaseAccount;

  late final EndpointGitHubAccount gitHubAccount;

  late final EndpointGoogleAccountBackwardsCompatibilityTest
  googleAccountBackwardsCompatibilityTest;

  late final EndpointGoogleAccount googleAccount;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointPasskeyAccount passkeyAccount;

  late final EndpointPasswordImportingEmailAccount
  passwordImportingEmailAccount;

  late final EndpointUserProfile userProfile;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'appleAccount': appleAccount,
    'authTest': authTest,
    'unauthenticatedRequireLoginAuthTest': unauthenticatedRequireLoginAuthTest,
    'authenticatedStreamingTest': authenticatedStreamingTest,
    'emailAccountBackwardsCompatibilityTest':
        emailAccountBackwardsCompatibilityTest,
    'emailAccount': emailAccount,
    'firebaseAccount': firebaseAccount,
    'gitHubAccount': gitHubAccount,
    'googleAccountBackwardsCompatibilityTest':
        googleAccountBackwardsCompatibilityTest,
    'googleAccount': googleAccount,
    'jwtRefresh': jwtRefresh,
    'passkeyAccount': passkeyAccount,
    'passwordImportingEmailAccount': passwordImportingEmailAccount,
    'userProfile': userProfile,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_bridge': modules.serverpod_auth_bridge,
    'serverpod_auth_core': modules.serverpod_auth_core,
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_migration': modules.serverpod_auth_migration,
    'auth': modules.auth,
  };
}
