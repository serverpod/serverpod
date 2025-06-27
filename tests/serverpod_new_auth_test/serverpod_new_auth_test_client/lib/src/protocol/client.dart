/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_session_client/serverpod_auth_session_client.dart'
    as _i3;
import 'package:uuid/uuid_value.dart' as _i4;
import 'package:serverpod_auth_profile_client/serverpod_auth_profile_client.dart'
    as _i5;
import 'dart:typed_data' as _i6;
import 'package:serverpod_auth_email_client/serverpod_auth_email_client.dart'
    as _i7;
import 'package:serverpod_auth_email_account_client/serverpod_auth_email_account_client.dart'
    as _i8;
import 'package:serverpod_auth_user_client/serverpod_auth_user_client.dart'
    as _i9;
import 'protocol.dart' as _i10;

/// Endpoint for email-based authentication.
/// {@category Endpoint}
class EndpointEmailAccount extends _i1.EndpointRef {
  EndpointEmailAccount(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailAccount';

  /// Logs in the user and returns a new session.
  ///
  /// In case an expected error occurs, this throws a `EmailAccountLoginException`.
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

  /// Starts the registration for a new user account with an email-based login associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to complete the registration.
  _i2.Future<void> startRegistration({
    required String email,
    required String password,
  }) =>
      caller.callServerEndpoint<void>(
        'emailAccount',
        'startRegistration',
        {
          'email': email,
          'password': password,
        },
      );

  /// Completes a new account registration, creating a new auth user with a profile and attaching the given email account to it.
  _i2.Future<_i3.AuthSuccess> finishRegistration({
    required _i4.UuidValue accountRequestId,
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

  /// Requests a password reset for [email].
  _i2.Future<void> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<void>(
        'emailAccount',
        'startPasswordReset',
        {'email': email},
      );

  /// Completes a password reset request by setting a new password.
  ///
  /// If the reset was successful, a new session key is returned.
  ///
  /// Destroys all active sessions of the user.
  _i2.Future<_i3.AuthSuccess> finishPasswordReset({
    required _i4.UuidValue passwordResetRequestId,
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

/// {@category Endpoint}
class EndpointSessionTest extends _i1.EndpointRef {
  EndpointSessionTest(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sessionTest';

  _i2.Future<_i4.UuidValue> createTestUser() =>
      caller.callServerEndpoint<_i4.UuidValue>(
        'sessionTest',
        'createTestUser',
        {},
      );

  _i2.Future<_i3.AuthSuccess> createSession(_i4.UuidValue authUserId) =>
      caller.callServerEndpoint<_i3.AuthSuccess>(
        'sessionTest',
        'createSession',
        {'authUserId': authUserId},
      );

  _i2.Future<bool> checkSession(_i4.UuidValue authUserId) =>
      caller.callServerEndpoint<bool>(
        'sessionTest',
        'checkSession',
        {'authUserId': authUserId},
      );
}

/// Endpoint to view and edit one's profile.
/// {@category Endpoint}
class EndpointUserProfile extends _i1.EndpointRef {
  EndpointUserProfile(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userProfile';

  /// Returns the user profile of the current user.
  _i2.Future<_i5.UserProfileModel> get() =>
      caller.callServerEndpoint<_i5.UserProfileModel>(
        'userProfile',
        'get',
        {},
      );

  /// Removes the users uploaded image, replacing it with the default user
  /// image.
  _i2.Future<_i5.UserProfileModel> removeUserImage() =>
      caller.callServerEndpoint<_i5.UserProfileModel>(
        'userProfile',
        'removeUserImage',
        {},
      );

  /// Sets a new user image for the signed in user.
  _i2.Future<_i5.UserProfileModel> setUserImage(_i6.ByteData image) =>
      caller.callServerEndpoint<_i5.UserProfileModel>(
        'userProfile',
        'setUserImage',
        {'image': image},
      );

  /// Changes the name of a user.
  _i2.Future<_i5.UserProfileModel> changeUserName(String? userName) =>
      caller.callServerEndpoint<_i5.UserProfileModel>(
        'userProfile',
        'changeUserName',
        {'userName': userName},
      );

  /// Changes the full name of a user.
  _i2.Future<_i5.UserProfileModel> changeFullName(String? fullName) =>
      caller.callServerEndpoint<_i5.UserProfileModel>(
        'userProfile',
        'changeFullName',
        {'fullName': fullName},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_email = _i7.Caller(client);
    serverpod_auth_profile = _i5.Caller(client);
    serverpod_auth_email_account = _i8.Caller(client);
    serverpod_auth_session = _i3.Caller(client);
    serverpod_auth_user = _i9.Caller(client);
  }

  late final _i7.Caller serverpod_auth_email;

  late final _i5.Caller serverpod_auth_profile;

  late final _i8.Caller serverpod_auth_email_account;

  late final _i3.Caller serverpod_auth_session;

  late final _i9.Caller serverpod_auth_user;
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
          _i10.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    emailAccount = EndpointEmailAccount(this);
    sessionTest = EndpointSessionTest(this);
    userProfile = EndpointUserProfile(this);
    modules = Modules(this);
  }

  late final EndpointEmailAccount emailAccount;

  late final EndpointSessionTest sessionTest;

  late final EndpointUserProfile userProfile;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'emailAccount': emailAccount,
        'sessionTest': sessionTest,
        'userProfile': userProfile,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
        'serverpod_auth_email': modules.serverpod_auth_email,
        'serverpod_auth_profile': modules.serverpod_auth_profile,
        'serverpod_auth_email_account': modules.serverpod_auth_email_account,
        'serverpod_auth_session': modules.serverpod_auth_session,
        'serverpod_auth_user': modules.serverpod_auth_user,
      };
}
