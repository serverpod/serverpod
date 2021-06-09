import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';

Future<void> signInWithGoogle(Caller caller) async {
  var _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  try {
    print('User signed in: ${await caller.user.isSignedIn()}');

    var result = await _googleSignIn.signIn();
    if (result == null) {
      print('Failed to sign in');
    }
    else {
      print('Authenticated in as: ${result.email}');
      var auth = await result.authentication;
      var accessToken = auth.accessToken;
      var serverAuthCode = auth.serverAuthCode;

      print('accessToken: $accessToken');
      print('serverAuthCode: $serverAuthCode');

      if (serverAuthCode == null) {
        print('Failed to get auth code');
      }
      else {
        var serverResponse = await caller.google.authenticate(serverAuthCode);
        print('success: ${serverResponse.success}');

        if (serverResponse.success) {
          await FlutterAuthenticationKeyManager.instance.put('${serverResponse.keyId}:${serverResponse.key}');
        }
      }
    }

    print('key: ${await FlutterAuthenticationKeyManager.instance.get()}');
    print('User signed in: ${await caller.user.isSignedIn()}');
  }
  catch(e) {
    print('Error: $e');
  }
}