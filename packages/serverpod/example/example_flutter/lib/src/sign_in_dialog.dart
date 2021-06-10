import 'package:flutter/material.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';

import '../main.dart';

class SignInDialog extends StatelessWidget {
  VoidCallback onSignedIn;
  VoidCallback onFailure;

  SignInDialog({
    required this.onSignedIn,
    required this.onFailure,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SignInWithGoogleButton(
              caller: client.modules.auth,
              onSignedIn: onSignedIn,
              onFailure: onFailure,
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
}

void showSignInDialog({
  required BuildContext context,
  required VoidCallback onSignedIn,
  required VoidCallback onFailure,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SignInDialog(
        onSignedIn: onSignedIn,
        onFailure: onFailure,
      );
    },
  );
}
