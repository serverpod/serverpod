import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// Attempts to Sign in with Google. If successful, a [UserInfo] is returned.
/// If the attempt is not a success, null is returned.
Future<UserInfo?> signInWithGoogle(
  Caller caller, {
  bool debug = false,
  String? clientId,
  String? serverClientId,
  List<String> additionalScopes = const [],
  required Uri redirectUri,
}) async {
  var scopes = [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];
  scopes.addAll(additionalScopes);

  if (kDebugMode) print('serverpod_auth_google: GoogleSignIn');

  var googleSignIn = GoogleSignIn(
    scopes: scopes,
    clientId: clientId,
    serverClientId: serverClientId,
    forceCodeForRefreshToken: true,
  );

  try {
    // Sign in with Google.
    var result = await googleSignIn.signIn();
    if (result == null) {
      if (kDebugMode) {
        print(
          'serverpod_auth_google: GoogleSignIn.signIn() returned null. Aborting.',
        );
      }
      return null;
    }

    // Get the server auth code.
    // var auth = await result.authentication;

    var serverAuthCode = result.serverAuthCode;
    String? idToken;
    if (serverAuthCode == null) {
      if (kDebugMode) {
        print(
          'serverpod_auth_google: serverAuthCode is null. Trying auth.idToken.',
        );
      }
      var auth = await result.authentication;
      idToken = auth.idToken;
    }

    if (serverAuthCode == null && idToken == null) {
      if (kDebugMode) {
        print(
          'serverpod_auth_google: Failed to get valid serverAuthCode or idToken. Aborting.',
        );
      }
      return null;
    }

    // Authenticate with the Serverpod server.
    AuthenticationResponse serverResponse;
    if (serverAuthCode != null) {
      // Prefer to authenticate with serverAuthCode
      serverResponse = await caller.google.authenticateWithServerAuthCode(
        serverAuthCode,
        redirectUri.toString(),
      );
    } else {
      // Fall back on idToken
      serverResponse = await caller.google.authenticateWithIdToken(idToken!);
    }

    if (!serverResponse.success) {
      if (kDebugMode) {
        print(
          'serverpod_auth_google: Failed to authenticate with Serverpod backend. Aborting.',
        );
      }
      return null;
    }

    // Store the user info in the session manager.
    var sessionManager = await SessionManager.instance;

    await sessionManager.registerSignedInUser(
      serverResponse.userInfo!,
      serverResponse.keyId!,
      serverResponse.key!,
    );

    // Authentication with server is complete, we can sign out from Google locally
    if (kDebugMode) print('serverpod_auth_google: Signing out from google');
    await googleSignIn.signOut();

    if (kDebugMode) {
      try {
        await googleSignIn.disconnect();
      } catch (e) {
        // Print without stacktrace (this seems to fail every time, #735)
        print('serverpod_auth_google: $e');
      }
    }

    if (kDebugMode) {
      print(
        'serverpod_auth_google: Authentication was successful. Saved credentials to SessionManager',
      );
    }

    // Return the user info.
    return serverResponse.userInfo;
  } catch (e, stackTrace) {
    if (kDebugMode) print('serverpod_auth_google: $e');
    if (kDebugMode) print('$stackTrace');
    return null;
  }
}
