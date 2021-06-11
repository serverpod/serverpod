import 'package:flutter/material.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';
import 'package:serverpod_auth_apple_flutter/serverpod_auth_apple_flutter.dart';

import '../main.dart';

class _SignInDialog extends StatelessWidget {
  final VoidCallback onSignedIn;

  _SignInDialog({
    required this.onSignedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SignInWithGoogleButton(
              caller: client.modules.auth,
              onSignedIn: () { _signedIn(context); },
              onFailure: _failedToSignIn,
            ),
            SizedBox(height: 4,),
            SignInWithAppleButton(
              caller: client.modules.auth,
              onSignedIn: () { _signedIn(context); },
              onFailure: _failedToSignIn,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Sign in later'),
            ),
          ],
        ),
      ),
    );
  }

  void _signedIn(BuildContext context) {
    // Notify the caller that we successfully signed in and close the dialog.
    print('successfully signed in!!');
    onSignedIn();
    Navigator.of(context).pop();
  }

  void _failedToSignIn() {
    // The user cancelled the signing in, or something went wrong.
    print('failed to sign in');
  }
}

/// Opens the sign in dialog. If the user successfully signs in [onSignedIn] is
/// called.
void showSignInDialog({
  required BuildContext context,
  required VoidCallback onSignedIn,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _SignInDialog(
        onSignedIn: onSignedIn,
      );
    },
  );
}
