import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Attempts to Sign in with Apple. If successful, a [UserInfo] is returned.
/// If the attempt is not a success, null is returned.
Future<UserInfo?> signInWithApple(Caller caller) async {
  // Check that Sign in with Apple is available on this platform.
  try {
    var available = await SignInWithApple.isAvailable();
    if (!available) return null;

    // Attempt to sign in.
    var credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    var userIdentifier = credential.userIdentifier!;
    var nickname = credential.givenName ?? 'Unknown';
    var fullName = nickname;
    if (credential.familyName != null) fullName += ' ${credential.familyName}';
    var email = credential.email;
    var identityToken = credential.identityToken!;
    var authorizationCode = credential.authorizationCode;

    var authInfo = AppleAuthInfo(
      userIdentifier: userIdentifier,
      email: email,
      fullName: fullName,
      nickname: nickname,
      identityToken: identityToken,
      authorizationCode: authorizationCode,
    );

    // Authenticate with the Serverpod server.
    var serverResponse = await caller.apple.authenticate(authInfo);
    if (!serverResponse.success ||
        serverResponse.userInfo == null ||
        serverResponse.key == null ||
        serverResponse.keyId == null) {
      return null;
    }

    // Store the user info in the session manager.
    var sessionManager = await SessionManager.instance;
    await sessionManager.registerSignedInUser(
      serverResponse.userInfo!,
      serverResponse.keyId!,
      serverResponse.key!,
    );

    // Return the user info.
    return serverResponse.userInfo;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('$e');
      print('$stackTrace');
    }
    return null;
  }
}
