import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Attempts to Sign in with Apple. If successful, a [UserInfo] is returned.
/// If the attempt is not a success, null is returned.
Future<UserInfo?> signInWithApple(Caller caller) async {
  // Check that Sign in with Apple is available on this platform.
  try {
    bool available = await SignInWithApple.isAvailable();
    if (!available) return null;

    // Attempt to sign in.
    AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: <AppleIDAuthorizationScopes>[
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    String userIdentifier = credential.userIdentifier!;
    String nickname = credential.givenName ?? 'Unknown';
    String fullName = nickname;
    if (credential.familyName != null) fullName += ' ${credential.familyName}';
    String? email = credential.email;
    String identityToken = credential.identityToken!;
    String authorizationCode = credential.authorizationCode;

    AppleAuthInfo authInfo = AppleAuthInfo(
      userIdentifier: userIdentifier,
      email: email,
      fullName: fullName,
      nickname: nickname,
      identityToken: identityToken,
      authorizationCode: authorizationCode,
    );

    // Authenticate with the Serverpod server.
    AuthenticationResponse serverResponse =
        await caller.apple.authenticate(authInfo);
    if (!serverResponse.success) return null;

    // Authentication was successful, store the key.
    SessionManager sessionManager = await SessionManager.instance;
    await sessionManager.keyManager
        .put('${serverResponse.keyId}:${serverResponse.key}');

    // Store the user info in the session manager.
    sessionManager.signedInUser = serverResponse.userInfo;

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
