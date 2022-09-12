/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

/// Endpoint for handling admin functions.
class _EndpointAdmin extends EndpointRef {
  @override
  String get name => 'serverpod_auth.admin';

  _EndpointAdmin(EndpointCaller caller) : super(caller);

  /// Finds a user by its id.
  Future<UserInfo?> getUserInfo(
    int userId,
  ) async {
    var retval = await caller
        .callServerEndpoint('serverpod_auth.admin', 'getUserInfo', 'UserInfo', {
      'userId': userId,
    });
    return retval;
  }
}

/// Endpoint for handling Sign in with Apple.
class _EndpointApple extends EndpointRef {
  @override
  String get name => 'serverpod_auth.apple';

  _EndpointApple(EndpointCaller caller) : super(caller);

  /// Authenticates a user with Apple.
  Future<AuthenticationResponse> authenticate(
    AppleAuthInfo authInfo,
  ) async {
    var retval = await caller.callServerEndpoint(
        'serverpod_auth.apple', 'authenticate', 'AuthenticationResponse', {
      'authInfo': authInfo,
    });
    return retval;
  }
}

/// Endpoint for handling Sign in with Google.
class _EndpointEmail extends EndpointRef {
  @override
  String get name => 'serverpod_auth.email';

  _EndpointEmail(EndpointCaller caller) : super(caller);

  /// Authenticates a user with email and password. Returns an
  /// [AuthenticationResponse] with the users information.
  Future<AuthenticationResponse> authenticate(
    String email,
    String password,
  ) async {
    var retval = await caller.callServerEndpoint(
        'serverpod_auth.email', 'authenticate', 'AuthenticationResponse', {
      'email': email,
      'password': password,
    });
    return retval;
  }

  /// Changes a users password.
  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    var retval = await caller
        .callServerEndpoint('serverpod_auth.email', 'changePassword', 'bool', {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
    return retval;
  }

  /// Initiates a password reset and sends an email with the reset code to the
  /// user.
  Future<bool> initiatePasswordReset(
    String email,
  ) async {
    var retval = await caller.callServerEndpoint(
        'serverpod_auth.email', 'initiatePasswordReset', 'bool', {
      'email': email,
    });
    return retval;
  }

  /// Verifies a password reset code, if successful returns an
  /// [EmailPasswordReset] object, otherwise returns null.
  Future<EmailPasswordReset?> verifyEmailPasswordReset(
    String verificationCode,
  ) async {
    var retval = await caller.callServerEndpoint('serverpod_auth.email',
        'verifyEmailPasswordReset', 'EmailPasswordReset', {
      'verificationCode': verificationCode,
    });
    return retval;
  }

  /// Resets a users password using the reset code.
  Future<bool> resetPassword(
    String verificationCode,
    String password,
  ) async {
    var retval = await caller
        .callServerEndpoint('serverpod_auth.email', 'resetPassword', 'bool', {
      'verificationCode': verificationCode,
      'password': password,
    });
    return retval;
  }

  /// Starts the procedure for creating an account by sending an email with
  /// a verification code.
  Future<bool> createAccountRequest(
    String userName,
    String email,
    String password,
  ) async {
    var retval = await caller.callServerEndpoint(
        'serverpod_auth.email', 'createAccountRequest', 'bool', {
      'userName': userName,
      'email': email,
      'password': password,
    });
    return retval;
  }

  /// Creates a new account using a verification code.
  Future<UserInfo?> createAccount(
    String email,
    String verificationCode,
  ) async {
    var retval = await caller.callServerEndpoint(
        'serverpod_auth.email', 'createAccount', 'UserInfo', {
      'email': email,
      'verificationCode': verificationCode,
    });
    return retval;
  }
}

/// Endpoint for handling Sign in with Firebase.
class _EndpointFirebase extends EndpointRef {
  @override
  String get name => 'serverpod_auth.firebase';

  _EndpointFirebase(EndpointCaller caller) : super(caller);

  /// Authenticate a user with a Firebase id token.
  Future<AuthenticationResponse> authenticate(
    String idToken,
  ) async {
    var retval = await caller.callServerEndpoint(
        'serverpod_auth.firebase', 'authenticate', 'AuthenticationResponse', {
      'idToken': idToken,
    });
    return retval;
  }
}

/// Endpoint for handling Sign in with Google.
class _EndpointGoogle extends EndpointRef {
  @override
  String get name => 'serverpod_auth.google';

  _EndpointGoogle(EndpointCaller caller) : super(caller);

  /// Authenticates a user with Google using the serverAuthCode.
  Future<AuthenticationResponse> authenticateWithServerAuthCode(
    String authenticationCode,
    String? redirectUri,
  ) async {
    var retval = await caller.callServerEndpoint('serverpod_auth.google',
        'authenticateWithServerAuthCode', 'AuthenticationResponse', {
      'authenticationCode': authenticationCode,
      'redirectUri': redirectUri,
    });
    return retval;
  }

  /// Authenticates a user using an id token.
  Future<AuthenticationResponse> authenticateWithIdToken(
    String idToken,
  ) async {
    var retval = await caller.callServerEndpoint('serverpod_auth.google',
        'authenticateWithIdToken', 'AuthenticationResponse', {
      'idToken': idToken,
    });
    return retval;
  }
}

/// Endpoint for getting status for a signed in user and module configuration.
class _EndpointStatus extends EndpointRef {
  @override
  String get name => 'serverpod_auth.status';

  _EndpointStatus(EndpointCaller caller) : super(caller);

  /// Returns true if the client user is signed in.
  Future<bool> isSignedIn() async {
    var retval = await caller
        .callServerEndpoint('serverpod_auth.status', 'isSignedIn', 'bool', {});
    return retval;
  }

  /// Signs out a user.
  Future<void> signOut() async {
    var retval = await caller
        .callServerEndpoint('serverpod_auth.status', 'signOut', 'void', {});
    return retval;
  }

  /// Gets the [UserInfo] for a signed in user, or null if the user is currently
  /// not signed in with the server.
  Future<UserInfo?> getUserInfo() async {
    var retval = await caller.callServerEndpoint(
        'serverpod_auth.status', 'getUserInfo', 'UserInfo', {});
    return retval;
  }

  /// Gets the server configuration.
  Future<UserSettingsConfig> getUserSettingsConfig() async {
    var retval = await caller.callServerEndpoint('serverpod_auth.status',
        'getUserSettingsConfig', 'UserSettingsConfig', {});
    return retval;
  }
}

/// Endpoint with methods for managing the currently signed in user.
class _EndpointUser extends EndpointRef {
  @override
  String get name => 'serverpod_auth.user';

  _EndpointUser(EndpointCaller caller) : super(caller);

  /// Removes the users uploaded image, replacing it with the default user
  /// image.
  Future<bool> removeUserImage() async {
    var retval = await caller.callServerEndpoint(
        'serverpod_auth.user', 'removeUserImage', 'bool', {});
    return retval;
  }

  /// Sets a new user image for the signed in user.
  Future<bool> setUserImage(
    typed_data.ByteData image,
  ) async {
    var retval = await caller
        .callServerEndpoint('serverpod_auth.user', 'setUserImage', 'bool', {
      'image': image,
    });
    return retval;
  }

  /// Changes the name of a user.
  Future<bool> changeUserName(
    String userName,
  ) async {
    var retval = await caller
        .callServerEndpoint('serverpod_auth.user', 'changeUserName', 'bool', {
      'userName': userName,
    });
    return retval;
  }
}

class Caller extends ModuleEndpointCaller {
  late final _EndpointAdmin admin;
  late final _EndpointApple apple;
  late final _EndpointEmail email;
  late final _EndpointFirebase firebase;
  late final _EndpointGoogle google;
  late final _EndpointStatus status;
  late final _EndpointUser user;

  Caller(ServerpodClientShared client) : super(client) {
    admin = _EndpointAdmin(this);
    apple = _EndpointApple(this);
    email = _EndpointEmail(this);
    firebase = _EndpointFirebase(this);
    google = _EndpointGoogle(this);
    status = _EndpointStatus(this);
    user = _EndpointUser(this);
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
        'serverpod_auth.admin': admin,
        'serverpod_auth.apple': apple,
        'serverpod_auth.email': email,
        'serverpod_auth.firebase': firebase,
        'serverpod_auth.google': google,
        'serverpod_auth.status': status,
        'serverpod_auth.user': user,
      };
}
