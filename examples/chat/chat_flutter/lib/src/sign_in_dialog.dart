import 'package:flutter/material.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';

import '../main.dart';

class SignInDialog extends StatelessWidget {
  final VoidCallback? onSignedIn;
  final bool shownAsDialog;

  const SignInDialog({
    this.onSignedIn,
    this.shownAsDialog = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SignInWithEmailButton(
              caller: client.modules.auth,
              onSignedIn: () {
                _signedIn(context);
              },
              onFailure: _failedToSignIn,
            ),
            const SizedBox(
              height: 8,
            ),
            if (shownAsDialog)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Sign in later'),
              ),
          ],
        ),
      ),
    );
  }

  void _signedIn(BuildContext context) {
    // Notify the caller that we successfully signed in and close the dialog.
    if (onSignedIn != null) {
      onSignedIn!();
    }
    if (shownAsDialog) {
      Navigator.of(context).pop();
    }
  }

  void _failedToSignIn() {
    // The user cancelled the signing in, or something went wrong.
  }
}

/// Opens the sign in dialog. If the user successfully signs in [onSignedIn] is
/// called. After the user is signed in you can query [SessionManager] to find
/// information about the current user.
void showSignInDialog({
  required BuildContext context,
  required VoidCallback onSignedIn,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SignInDialog(
        onSignedIn: onSignedIn,
      );
    },
  );
}
