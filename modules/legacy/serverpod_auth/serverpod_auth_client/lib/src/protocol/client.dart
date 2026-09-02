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
import 'package:serverpod_auth_client/src/protocol/apple_auth_info.dart'
    as _ixcvk3l9;
import 'package:serverpod_auth_client/src/protocol/authentication_response.dart'
    as _iasth1pm;
import 'package:serverpod_auth_client/src/protocol/user_info.dart' as _ih7rw17i;
import 'package:serverpod_auth_client/src/protocol/user_settings_config.dart'
    as _i02slxw5;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Endpoint for handling admin functions.
/// {@category Endpoint}
class EndpointAdmin extends _isc.EndpointRef {
  EndpointAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.admin';

  /// Finds a user by its id.
  _ida.Future<_ih7rw17i.UserInfo?> getUserInfo(int userId) =>
      caller.callServerEndpoint<_ih7rw17i.UserInfo?>(
        'serverpod_auth.admin',
        'getUserInfo',
        {'userId': userId},
      );

  /// Marks a user as blocked so that they can't log in, and invalidates their
  /// auth key so that they can't keep calling endpoints through their current
  /// session.
  _ida.Future<void> blockUser(int userId) => caller.callServerEndpoint<void>(
    'serverpod_auth.admin',
    'blockUser',
    {'userId': userId},
  );

  /// Unblocks a user so that they can log in again.
  _ida.Future<void> unblockUser(int userId) => caller.callServerEndpoint<void>(
    'serverpod_auth.admin',
    'unblockUser',
    {'userId': userId},
  );
}

/// Endpoint for handling Sign in with Apple.
/// {@category Endpoint}
class EndpointApple extends _isc.EndpointRef {
  EndpointApple(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.apple';

  /// Authenticates a user with Apple.
  _ida.Future<_iasth1pm.AuthenticationResponse> authenticate(
    _ixcvk3l9.AppleAuthInfo authInfo,
  ) => caller.callServerEndpoint<_iasth1pm.AuthenticationResponse>(
    'serverpod_auth.apple',
    'authenticate',
    {'authInfo': authInfo},
  );
}

/// Endpoint for handling Sign in with Email.
/// {@category Endpoint}
class EndpointEmail extends _isc.EndpointRef {
  EndpointEmail(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.email';

  /// Authenticates a user with email and password. Returns an
  /// [AuthenticationResponse] with the users information.
  _ida.Future<_iasth1pm.AuthenticationResponse> authenticate(
    String email,
    String password,
  ) => caller.callServerEndpoint<_iasth1pm.AuthenticationResponse>(
    'serverpod_auth.email',
    'authenticate',
    {
      'email': email,
      'password': password,
    },
  );

  /// Changes a users password.
  _ida.Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) => caller.callServerEndpoint<bool>(
    'serverpod_auth.email',
    'changePassword',
    {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    },
  );

  /// Initiates a password reset and sends an email with the reset code to the
  /// user.
  _ida.Future<bool> initiatePasswordReset(String email) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.email',
        'initiatePasswordReset',
        {'email': email},
      );

  /// Resets a users password using the reset code.
  _ida.Future<bool> resetPassword(
    String verificationCode,
    String password,
  ) => caller.callServerEndpoint<bool>(
    'serverpod_auth.email',
    'resetPassword',
    {
      'verificationCode': verificationCode,
      'password': password,
    },
  );

  /// Starts the procedure for creating an account by sending an email with
  /// a verification code.
  _ida.Future<bool> createAccountRequest(
    String userName,
    String email,
    String password,
  ) => caller.callServerEndpoint<bool>(
    'serverpod_auth.email',
    'createAccountRequest',
    {
      'userName': userName,
      'email': email,
      'password': password,
    },
  );

  /// Creates a new account using a verification code.
  _ida.Future<_ih7rw17i.UserInfo?> createAccount(
    String email,
    String verificationCode,
  ) => caller.callServerEndpoint<_ih7rw17i.UserInfo?>(
    'serverpod_auth.email',
    'createAccount',
    {
      'email': email,
      'verificationCode': verificationCode,
    },
  );
}

/// Endpoint for handling Sign in with Firebase.
/// {@category Endpoint}
class EndpointFirebase extends _isc.EndpointRef {
  EndpointFirebase(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.firebase';

  /// Authenticate a user with a Firebase id token.
  _ida.Future<_iasth1pm.AuthenticationResponse> authenticate(String idToken) =>
      caller.callServerEndpoint<_iasth1pm.AuthenticationResponse>(
        'serverpod_auth.firebase',
        'authenticate',
        {'idToken': idToken},
      );
}

/// Endpoint for handling Sign in with Google.
/// {@category Endpoint}
class EndpointGoogle extends _isc.EndpointRef {
  EndpointGoogle(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.google';

  /// Authenticates a user with Google using the serverAuthCode.
  _ida.Future<_iasth1pm.AuthenticationResponse> authenticateWithServerAuthCode(
    String authenticationCode,
    String? redirectUri,
  ) => caller.callServerEndpoint<_iasth1pm.AuthenticationResponse>(
    'serverpod_auth.google',
    'authenticateWithServerAuthCode',
    {
      'authenticationCode': authenticationCode,
      'redirectUri': redirectUri,
    },
  );

  /// Authenticates a user using an id token.
  _ida.Future<_iasth1pm.AuthenticationResponse> authenticateWithIdToken(
    String idToken,
  ) => caller.callServerEndpoint<_iasth1pm.AuthenticationResponse>(
    'serverpod_auth.google',
    'authenticateWithIdToken',
    {'idToken': idToken},
  );
}

/// Endpoint for getting status for a signed in user and module configuration.
/// {@category Endpoint}
class EndpointStatus extends _isc.EndpointRef {
  EndpointStatus(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.status';

  /// Returns true if the client user is signed in.
  _ida.Future<bool> isSignedIn() => caller.callServerEndpoint<bool>(
    'serverpod_auth.status',
    'isSignedIn',
    {},
  );

  /// Signs out a user from the current device.
  _ida.Future<void> signOutDevice() => caller.callServerEndpoint<void>(
    'serverpod_auth.status',
    'signOutDevice',
    {},
  );

  /// Signs out a user from all active devices.
  _ida.Future<void> signOutAllDevices() => caller.callServerEndpoint<void>(
    'serverpod_auth.status',
    'signOutAllDevices',
    {},
  );

  /// Gets the [UserInfo] for a signed in user, or null if the user is currently
  /// not signed in with the server.
  _ida.Future<_ih7rw17i.UserInfo?> getUserInfo() =>
      caller.callServerEndpoint<_ih7rw17i.UserInfo?>(
        'serverpod_auth.status',
        'getUserInfo',
        {},
      );

  /// Gets the server configuration.
  _ida.Future<_i02slxw5.UserSettingsConfig> getUserSettingsConfig() =>
      caller.callServerEndpoint<_i02slxw5.UserSettingsConfig>(
        'serverpod_auth.status',
        'getUserSettingsConfig',
        {},
      );
}

/// Endpoint with methods for managing the currently signed in user.
/// {@category Endpoint}
class EndpointUser extends _isc.EndpointRef {
  EndpointUser(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_auth.user';

  /// Removes the users uploaded image, replacing it with the default user
  /// image.
  _ida.Future<bool> removeUserImage() => caller.callServerEndpoint<bool>(
    'serverpod_auth.user',
    'removeUserImage',
    {},
  );

  /// Sets a new user image for the signed in user.
  _ida.Future<bool> setUserImage(_idt.ByteData image) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.user',
        'setUserImage',
        {'image': image},
      );

  /// Changes the name of a user.
  _ida.Future<bool> changeUserName(String userName) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.user',
        'changeUserName',
        {'userName': userName},
      );

  /// Changes the full name of a user.
  _ida.Future<bool> changeFullName(String fullName) =>
      caller.callServerEndpoint<bool>(
        'serverpod_auth.user',
        'changeFullName',
        {'fullName': fullName},
      );
}

class Caller extends _isc.ModuleEndpointCaller {
  Caller(_isc.ServerpodClientShared client) : super(client) {
    admin = EndpointAdmin(this);
    apple = EndpointApple(this);
    email = EndpointEmail(this);
    firebase = EndpointFirebase(this);
    google = EndpointGoogle(this);
    status = EndpointStatus(this);
    user = EndpointUser(this);
  }

  late final EndpointAdmin admin;

  late final EndpointApple apple;

  late final EndpointEmail email;

  late final EndpointFirebase firebase;

  late final EndpointGoogle google;

  late final EndpointStatus status;

  late final EndpointUser user;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'serverpod_auth.admin': admin,
    'serverpod_auth.apple': apple,
    'serverpod_auth.email': email,
    'serverpod_auth.firebase': firebase,
    'serverpod_auth.google': google,
    'serverpod_auth.status': status,
    'serverpod_auth.user': user,
  };
}
