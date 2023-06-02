/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_client/src/protocol/user_info.dart' as _i3;
import 'package:serverpod_auth_client/src/protocol/authentication_response.dart'
    as _i4;
import 'package:serverpod_auth_client/src/protocol/apple_auth_info.dart' as _i5;
import 'package:serverpod_auth_client/src/protocol/email_password_reset.dart'
    as _i6;
import 'package:serverpod_auth_client/src/protocol/user_settings_config.dart'
    as _i7;
import 'dart:typed_data' as _i8;

/// Endpoint for handling admin functions.
class _EndpointAdmin extends _i1.EndpointRef {
  _EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.admin';

  /// Finds a user by its id.
  _i2.Future<_i3.UserInfo?> getUserInfo(int userId) =>
      caller.callServerEndpoint<_i3.UserInfo?>(
        'serverpod_auth.admin',
        'getUserInfo',
        {'userId': userId},
      );
}

/// Endpoint for handling Sign in with Apple.
class _EndpointApple extends _i1.EndpointRef {
  _EndpointApple(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.apple';

  /// Authenticates a user with Apple.
  _i2.Future<_i4.AuthenticationResponse> authenticate(
          _i5.AppleAuthInfo authInfo) =>
      caller.callServerEndpoint<_i4.AuthenticationResponse>(
        'serverpod_auth.apple',
        'authenticate',
        {'authInfo': authInfo},
      );
}

/// Endpoint for handling Sign in with Google.
class _EndpointEmail extends _i1.EndpointRef {
  _EndpointEmail(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.email';

  /// Authenticates a user with email and password. Returns an
  /// [AuthenticationResponse] with the users information.
  _i2.Future<_i4.AuthenticationResponse> authenticate(
    String email,
    String password,
  ) =>
      caller.callServerEndpoint<_i4.AuthenticationResponse>(
        'serverpod_auth.email',
        'authenticate',
        {
          'email': email,
          'password': password,
        },
      );

  /// Changes a users password.
  _i2.Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.email',
        'changePassword',
        {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

  /// Initiates a password reset and sends an email with the reset code to the
  /// user.
  _i2.Future<bool> initiatePasswordReset(String email) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.email',
        'initiatePasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code, if successful returns an
  /// [EmailPasswordReset] object, otherwise returns null.
  _i2.Future<_i6.EmailPasswordReset?> verifyEmailPasswordReset(
          String verificationCode) =>
      caller.callServerEndpoint<_i6.EmailPasswordReset?>(
        'serverpod_auth.email',
        'verifyEmailPasswordReset',
        {'verificationCode': verificationCode},
      );

  /// Resets a users password using the reset code.
  _i2.Future<bool> resetPassword(
    String verificationCode,
    String password,
  ) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.email',
        'resetPassword',
        {
          'verificationCode': verificationCode,
          'password': password,
        },
      );

  /// Starts the procedure for creating an account by sending an email with
  /// a verification code.
  _i2.Future<bool> createAccountRequest(
    String userName,
    String email,
    String password,
  ) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.email',
        'createAccountRequest',
        {
          'userName': userName,
          'email': email,
          'password': password,
        },
      );

  /// Creates a new account using a verification code.
  _i2.Future<_i3.UserInfo?> createAccount(
    String email,
    String verificationCode,
  ) =>
      caller.callServerEndpoint<_i3.UserInfo?>(
        'serverpod_auth.email',
        'createAccount',
        {
          'email': email,
          'verificationCode': verificationCode,
        },
      );
}

/// Endpoint for handling Sign in with Firebase.
class _EndpointFirebase extends _i1.EndpointRef {
  _EndpointFirebase(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.firebase';

  /// Authenticate a user with a Firebase id token.
  _i2.Future<_i4.AuthenticationResponse> authenticate(String idToken) =>
      caller.callServerEndpoint<_i4.AuthenticationResponse>(
        'serverpod_auth.firebase',
        'authenticate',
        {'idToken': idToken},
      );
}

/// Endpoint for handling Sign in with Google.
class _EndpointGoogle extends _i1.EndpointRef {
  _EndpointGoogle(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.google';

  /// Authenticates a user with Google using the serverAuthCode.
  _i2.Future<_i4.AuthenticationResponse> authenticateWithServerAuthCode(
    String authenticationCode,
    String? redirectUri,
  ) =>
      caller.callServerEndpoint<_i4.AuthenticationResponse>(
        'serverpod_auth.google',
        'authenticateWithServerAuthCode',
        {
          'authenticationCode': authenticationCode,
          'redirectUri': redirectUri,
        },
      );

  /// Authenticates a user using an id token.
  _i2.Future<_i4.AuthenticationResponse> authenticateWithIdToken(
          String idToken) =>
      caller.callServerEndpoint<_i4.AuthenticationResponse>(
        'serverpod_auth.google',
        'authenticateWithIdToken',
        {'idToken': idToken},
      );
}

/// Endpoint for getting status for a signed in user and module configuration.
class _EndpointStatus extends _i1.EndpointRef {
  _EndpointStatus(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.status';

  /// Returns true if the client user is signed in.
  _i2.Future<bool> isSignedIn() => caller.callServerEndpoint<bool>(
        'serverpod_auth.status',
        'isSignedIn',
        {},
      );

  /// Signs out a user.
  _i2.Future<void> signOut() => caller.callServerEndpoint<void>(
        'serverpod_auth.status',
        'signOut',
        {},
      );

  /// Gets the [UserInfo] for a signed in user, or null if the user is currently
  /// not signed in with the server.
  _i2.Future<_i3.UserInfo?> getUserInfo() =>
      caller.callServerEndpoint<_i3.UserInfo?>(
        'serverpod_auth.status',
        'getUserInfo',
        {},
      );

  /// Gets the server configuration.
  _i2.Future<_i7.UserSettingsConfig> getUserSettingsConfig() =>
      caller.callServerEndpoint<_i7.UserSettingsConfig>(
        'serverpod_auth.status',
        'getUserSettingsConfig',
        {},
      );
}

/// Endpoint with methods for managing the currently signed in user.
class _EndpointUser extends _i1.EndpointRef {
  _EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.user';

  /// Removes the users uploaded image, replacing it with the default user
  /// image.
  _i2.Future<bool> removeUserImage() => caller.callServerEndpoint<bool>(
        'serverpod_auth.user',
        'removeUserImage',
        {},
      );

  /// Sets a new user image for the signed in user.
  _i2.Future<bool> setUserImage(_i8.ByteData image) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.user',
        'setUserImage',
        {'image': image},
      );

  /// Changes the name of a user.
  _i2.Future<bool> changeUserName(String userName) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.user',
        'changeUserName',
        {'userName': userName},
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    admin = _EndpointAdmin(this);
    apple = _EndpointApple(this);
    email = _EndpointEmail(this);
    firebase = _EndpointFirebase(this);
    google = _EndpointGoogle(this);
    status = _EndpointStatus(this);
    user = _EndpointUser(this);
  }

  late final _EndpointAdmin admin;

  late final _EndpointApple apple;

  late final _EndpointEmail email;

  late final _EndpointFirebase firebase;

  late final _EndpointGoogle google;

  late final _EndpointStatus status;

  late final _EndpointUser user;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'serverpod_auth.admin': admin,
        'serverpod_auth.apple': apple,
        'serverpod_auth.email': email,
        'serverpod_auth.firebase': firebase,
        'serverpod_auth.google': google,
        'serverpod_auth.status': status,
        'serverpod_auth.user': user,
      };
}
