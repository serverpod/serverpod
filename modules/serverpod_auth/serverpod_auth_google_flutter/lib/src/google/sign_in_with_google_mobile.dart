import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_google_flutter/src/google/sign_in_with_google_platform.dart';

/// Attempts to signin with google on mobile platforms and returns the auth tokens.
SignInWithGooglePlatform signInWithGooglePlatform = ({
  clientId,
  serverClientId,
  required scopes,
  required redirectUri,
}) async {
  var googleSignIn = GoogleSignIn(
    scopes: scopes,
    clientId: clientId,
    serverClientId: serverClientId,
  );

  var result = await googleSignIn.signIn();
  if (result == null) {
    if (kDebugMode) {
      print(
        'serverpod_auth_google: GoogleSignIn.signIn() returned null. Aborting.',
      );
    }
    throw Exception('Signin was aborted.');
  }

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

  // Authentication with server is complete, we can sign out from Google locally
  if (kDebugMode) print('serverpod_auth_google: Signing out from google');

  if (serverAuthCode != null || idToken != null) {
    await googleSignIn.signOut();

    if (kDebugMode) {
      try {
        await googleSignIn.disconnect();
      } catch (e) {
        // Print without stacktrace (this seems to fail every time, #735)
        print('serverpod_auth_google: $e');
      }
    }
  }

  return ClientAuthTokens(idToken: idToken, serverAuthCode: serverAuthCode);
};
