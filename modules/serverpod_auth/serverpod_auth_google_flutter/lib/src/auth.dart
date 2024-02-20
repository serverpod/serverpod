import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'google/sign_in_with_google.dart';

/// Attempts to Sign in with Google. If successful, a [UserInfo] is returned.
/// If the attempt is not a success, null is returned.
///
/// If [clientId] and [serverClientId] are not provided, the values are expected to
/// be supplied via the json credentials file in your android and ios projects.
///
/// On the web, the [serverClientId] is mandatory and must be provided.
///
/// The ID's can be created at https://console.developers.google.com/apis/credentials
///
/// The redirect uri to web page that will handle the authentication. This page
/// should send an event to the parent window with the server auth code.
/// The event is expected to be a string with the server auth code.
/// After the event is sent, the window can be closed safely.
///
/// Example web implementation:
/// ```javascript
///  function returnToWebClient() {
///    const serverAuthCode = findParam('code');
///    window.opener.postMessage(serverAuthCode, '*');
///    window.close();
///  }
/// ```
///
/// Consider using the GoogleSignInRedirectPageWidget inside [serverpod_auth_server]
/// to handle the the logic for you.
/// ```dart
/// // main.dart
/// pod.webServer.addRoute(auth.RouteGoogleSignIn(), '/googlesignin');
/// ```
/// Assuming the above route is added, the redirect uri would be:
/// https://example.com/googlesignin
Future<UserInfo?> signInWithGoogle(
  Caller caller, {
  bool debug = false, //TODO: Remove this parameter on next breaking change.
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

  try {
    var tokens = await signInWithGooglePlatform(
      scopes: scopes,
      clientId: clientId,
      serverClientId: serverClientId,
      redirectUri: redirectUri,
    );

    // Authenticate with the Serverpod server.
    AuthenticationResponse serverResponse;
    if (tokens.serverAuthCode != null) {
      // Prefer to authenticate with serverAuthCode
      serverResponse = await caller.google.authenticateWithServerAuthCode(
        tokens.serverAuthCode!,
        redirectUri.toString(),
      );
    } else {
      // Fall back on idToken
      serverResponse =
          await caller.google.authenticateWithIdToken(tokens.idToken!);
    }

    if (!serverResponse.success) {
      if (kDebugMode) {
        print(
          'serverpod_auth_google: Failed to authenticate with Serverpod backend: '
          '${serverResponse.failReason ?? 'reason unknown'}. Aborting.',
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

    if (kDebugMode) {
      print(
        'serverpod_auth_google: Authentication was successful. Saved credentials to SessionManager',
      );
    }

    return serverResponse.userInfo;
  } catch (e, stackTrace) {
    if (kDebugMode) print('serverpod_auth_google: $e');
    if (kDebugMode) print('$stackTrace');
    return null;
  }
}
