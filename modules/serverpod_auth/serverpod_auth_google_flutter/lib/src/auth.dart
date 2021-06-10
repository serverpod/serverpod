import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

Future<UserInfo?> signInWithGoogle(Caller caller) async {
  var _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  try {
    // Sign in with Google.
    var result = await _googleSignIn.signIn();
    if (result == null)
      return null;

    // Get the server auth code.
    var auth = await result.authentication;
    var serverAuthCode = auth.serverAuthCode;
    if (serverAuthCode == null)
      return null;

    // Authenticate with the Serverpod server.
    var serverResponse = await caller.google.authenticate(serverAuthCode);
    if (!serverResponse.success)
      return null;

    // Authentication was successful, store the key.
    var sessionManager = await SessionManager.instance;
    await sessionManager.keyManager.put('${serverResponse.keyId}:${serverResponse.key}');

    // Store the user info in the session manager.
    sessionManager.signedInUser = serverResponse.userInfo;

    // Return the user info.
    return serverResponse.userInfo;
  }
  catch(e) {
    return null;
  }
}