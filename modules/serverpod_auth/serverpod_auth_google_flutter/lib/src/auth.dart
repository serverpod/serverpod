import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// Attempts to Sign in with Google. If successful, a [UserInfo] is returned.
/// If the attempt is not a success, null is returned.
Future<UserInfo?> signInWithGoogle(
  Caller caller, {
  bool debug = false,
  List<String> additionalScopes = const [],
}) async {
  var scopes = [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];
  scopes.addAll(additionalScopes);

  if (debug) print('serverpod_auth_google: GoogleSignIn');

  var _googleSignIn = GoogleSignIn(
    scopes: scopes,
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
    String? idToken;
    if (serverAuthCode == null) {
      if (debug)
        print(
            'serverpod_auth_google: serverAuthCode is null. Trying auth.idToken.');
      var auth = await result.authentication;
      idToken = auth.idToken;
    }

    if (serverAuthCode == null && idToken == null) {
      if (debug)
        print(
            'serverpod_auth_google: Failed to get valid serverAuthCode or idToken. Aborting.');
      return null;
    }

    // Authenticate with the Serverpod server.
    AuthenticationResponse serverResponse;
    if (serverAuthCode != null) {
      // Prefer to authenticate with serverAuthCode
      serverResponse =
          await caller.google.authenticateWithServerAuthCode(serverAuthCode);
    } else {
      // Fall back on idToken
      serverResponse = await caller.google.authenticateWithIdToken(idToken!);
    }

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
    if (debug) print('serverpod_auth_google: $e');
    if (debug) print('$stackTrace');
    return null;
  }
}
