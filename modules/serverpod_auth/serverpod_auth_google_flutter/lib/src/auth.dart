import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// Attempts to Sign in with Google. If successful, a [UserInfo] is returned.
/// If the attempt is not a success, null is returned.
Future<UserInfo?> signInWithGoogle(
  Caller caller, {
  bool debug = false,
}) async {
  var _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  try {
    // Sign in with Google.
    var result = await _googleSignIn.signIn();
    if (result == null) {
      if (debug)
        print(
            'serverpod_auth_google: GoogleSignIn.signIn() returned null. Aborting.');
      return null;
    }

    // Get the server auth code.
    // var auth = await result.authentication;

    var serverAuthCode = result.serverAuthCode;
    if (serverAuthCode == null) {
      if (debug)
        print('serverpod_auth_google: serverAuthCode is null. Aborting.');
      return null;
    }

    // Authenticate with the Serverpod server.
    var serverResponse = await caller.google.authenticate(serverAuthCode);
    if (!serverResponse.success) {
      if (debug)
        print(
            'serverpod_auth_google: Failed to authenticate with Serverpod backend. Aborting.');
      return null;
    }

    // Authentication was successful, store the key.
    var sessionManager = await SessionManager.instance;
    await sessionManager.keyManager
        .put('${serverResponse.keyId}:${serverResponse.key}');

    // Store the user info in the session manager.
    sessionManager.signedInUser = serverResponse.userInfo;

    if (debug)
      print(
          'serverpod_auth_google: Authentication was successful. Saved credentials to SessionManager');

    // Return the user info.
    return serverResponse.userInfo;
  } catch (e, stackTrace) {
    print('$e');
    print('$stackTrace');
    return null;
  }
}
