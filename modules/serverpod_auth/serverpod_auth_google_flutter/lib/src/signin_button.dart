import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';

class SignInWithGoogleButton extends StatefulWidget {
  final Caller caller;
  final VoidCallback onSignedIn;
  final VoidCallback onFailure;
  final ButtonStyle? style;

  SignInWithGoogleButton({
    required this.caller,
    required this.onSignedIn,
    required this.onFailure,
    this.style,
  });

  @override
  _SignInWithGoogleButtonState createState() => _SignInWithGoogleButtonState();
}

class _SignInWithGoogleButtonState extends State<SignInWithGoogleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: widget.style ?? ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.grey[700],
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: () {
        // Open a dialog with just the progress indicator that isn't
        // dismissable.
        showLoadingBarrier(context: context);

        // Attempt to sign in the user.
        signInWithGoogle(widget.caller,).then((UserInfo? userInfo) {
          // Pop the loading barrier
          Navigator.of(context).pop();

          // Notify the parent.
          if (userInfo != null)
            widget.onSignedIn();
          else
            widget.onFailure();
        });
      },
      label: Text('Sign in with Google'),
      icon: Image.asset(
        'assets/google-icon.png',
        package: 'serverpod_auth_google_flutter',
        width: 24,
        height: 24,
      ),
    );
  }
}
