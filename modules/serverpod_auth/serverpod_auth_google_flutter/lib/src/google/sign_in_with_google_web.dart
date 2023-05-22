import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_google_flutter/src/google/google_sign_in_web_service.dart';
import 'package:serverpod_auth_google_flutter/src/google/sign_in_with_google_platform.dart';

/// Atempts to signin with google on the web and returns the auth tokens.
SignInWithGooglePlatform signInWithGooglePlatform = ({
  clientId,
  serverClientId,
  required scopes,
  required redirectUri,
}) async {
  assert(serverClientId != null);

  var googleSignIn = GoogleSignInWebService(
    scopes: scopes,
    // The clientId is the serverClientId on the web.
    clientId: serverClientId!,
    redirectUri: redirectUri.toString(),
  );

  var serverAuthCode = await googleSignIn.signIn();
  if (serverAuthCode == null) {
    if (kDebugMode) {
      print(
        'serverpod_auth_google: GoogleSignIn.signIn() returned null. Aborting.',
      );
    }
    throw Exception('signin was aborted.');
  }

  return ClientAuthTokens(serverAuthCode: serverAuthCode);
};
