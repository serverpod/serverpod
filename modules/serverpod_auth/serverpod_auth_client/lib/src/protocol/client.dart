/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

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
    return await caller
        .callServerEndpoint('serverpod_auth.admin', 'getUserInfo', 'UserInfo', {
      'userId': userId,
    });
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
    return await caller.callServerEndpoint(
        'serverpod_auth.apple', 'authenticate', 'AuthenticationResponse', {
      'authInfo': authInfo,
    });
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
    return await caller.callServerEndpoint(
        'serverpod_auth.email', 'authenticate', 'AuthenticationResponse', {
      'email': email,
      'password': password,
    });
  }

  /// Changes a users password.
  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    return await caller
        .callServerEndpoint('serverpod_auth.email', 'changePassword', 'bool', {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }

  /// Initiates a password reset and sends an email with the reset code to the
  /// user.
  Future<bool> initiatePasswordReset(
    String email,
  ) async {
    return await caller.callServerEndpoint(
        'serverpod_auth.email', 'initiatePasswordReset', 'bool', {
      'email': email,
    });
  }

  /// Verifies a password reset code, if successful returns an
  /// [EmailPasswordReset] object, otherwise returns null.
  Future<EmailPasswordReset?> verifyEmailPasswordReset(
    String verificationCode,
  ) async {
    return await caller.callServerEndpoint('serverpod_auth.email',
        'verifyEmailPasswordReset', 'EmailPasswordReset', {
      'verificationCode': verificationCode,
    });
  }

  /// Resets a users password using the reset code.
  Future<bool> resetPassword(
    String verificationCode,
    String password,
  ) async {
    return await caller
        .callServerEndpoint('serverpod_auth.email', 'resetPassword', 'bool', {
      'verificationCode': verificationCode,
      'password': password,
    });
  }

  /// Starts the procedure for creating an account by sending an email with
  /// a verification code.
  Future<bool> createAccountRequest(
    String userName,
    String email,
    String password,
  ) async {
    return await caller.callServerEndpoint(
        'serverpod_auth.email', 'createAccountRequest', 'bool', {
      'userName': userName,
      'email': email,
      'password': password,
    });
  }

  /// Creates a new account using a verification code.
  Future<UserInfo?> createAccount(
    String email,
    String verificationCode,
  ) async {
    return await caller.callServerEndpoint(
        'serverpod_auth.email', 'createAccount', 'UserInfo', {
      'email': email,
      'verificationCode': verificationCode,
    });
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
    return await caller.callServerEndpoint(
        'serverpod_auth.firebase', 'authenticate', 'AuthenticationResponse', {
      'idToken': idToken,
    });
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
    return await caller.callServerEndpoint('serverpod_auth.google',
        'authenticateWithServerAuthCode', 'AuthenticationResponse', {
      'authenticationCode': authenticationCode,
      'redirectUri': redirectUri,
    });
  }

  /// Authenticates a user using an id token.
  Future<AuthenticationResponse> authenticateWithIdToken(
    String idToken,
  ) async {
    return await caller.callServerEndpoint('serverpod_auth.google',
        'authenticateWithIdToken', 'AuthenticationResponse', {
      'idToken': idToken,
    });
  }
}

/// Endpoint for getting status for a signed in user and module configuration.
class _EndpointStatus extends EndpointRef {
  @override
  String get name => 'serverpod_auth.status';

  _EndpointStatus(EndpointCaller caller) : super(caller);

  /// Returns true if the client user is signed in.
  Future<bool> isSignedIn() async {
    return await caller
        .callServerEndpoint('serverpod_auth.status', 'isSignedIn', 'bool', {});
  }

  /// Signs out a user.
  Future<void> signOut() async {
    return await caller
        .callServerEndpoint('serverpod_auth.status', 'signOut', 'void', {});
  }

  /// Gets the [UserInfo] for a signed in user, or null if the user is currently
  /// not signed in with the server.
  Future<UserInfo?> getUserInfo() async {
    return await caller.callServerEndpoint(
        'serverpod_auth.status', 'getUserInfo', 'UserInfo', {});
  }

  /// Gets the server configuration.
  Future<UserSettingsConfig> getUserSettingsConfig() async {
    return await caller.callServerEndpoint('serverpod_auth.status',
        'getUserSettingsConfig', 'UserSettingsConfig', {});
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
    return await caller.callServerEndpoint(
        'serverpod_auth.user', 'removeUserImage', 'bool', {});
  }

  /// Sets a new user image for the signed in user.
  Future<bool> setUserImage(
    typed_data.ByteData image,
  ) async {
    return await caller
        .callServerEndpoint('serverpod_auth.user', 'setUserImage', 'bool', {
      'image': image,
    });
  }

  /// Changes the name of a user.
  Future<bool> changeUserName(
    String userName,
  ) async {
    return await caller
        .callServerEndpoint('serverpod_auth.user', 'changeUserName', 'bool', {
      'userName': userName,
    });
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
