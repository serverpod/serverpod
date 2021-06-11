import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<UserInfo?> signInWithApple(Caller caller) async {
  // Check that Sign in with Apple is available on this platform.
  try {
    var available = await SignInWithApple.isAvailable();
    if (!available)
      return null;

    // Attempt to sign in.
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print('credential: $credential');
  }
  catch(e, stackTrace) {
    print('$e');
    print('$stackTrace');
    return null;
  }
}