import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';

/// Sign in with Google button. When pressed, attempts to sign in with Google.
class SignInWithGoogleButton extends StatefulWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Called if sign in is successful.
  final VoidCallback onSignedIn;

  /// Called if sign in is unsuccessful.
  final VoidCallback onFailure;

  /// The style of the button.
  final ButtonStyle? style;

  /// Will output debug prints if set to true.
  final bool debug;

  final List<String> additionalScopes;

  final Alignment alignment;

  /// Creates a new Sign in with Google button.
  SignInWithGoogleButton({
    required this.caller,
    required this.onSignedIn,
    required this.onFailure,
    this.debug = false,
    this.style,
    this.additionalScopes = const [],
    this.alignment = Alignment.centerLeft,
  });

  @override
  _SignInWithGoogleButtonState createState() => _SignInWithGoogleButtonState();
}

class _SignInWithGoogleButtonState extends State<SignInWithGoogleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: widget.style ??
          ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.grey[700],
            alignment: widget.alignment,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
      onPressed: () {
        // Open a dialog with just the progress indicator that isn't
        // dismissable.
        showLoadingBarrier(context: context);

        // Attempt to sign in the user.
        signInWithGoogle(
          widget.caller,
          debug: widget.debug,
        ).then((UserInfo? userInfo) {
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
