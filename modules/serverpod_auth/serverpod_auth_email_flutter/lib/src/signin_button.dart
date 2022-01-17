import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_email_flutter/src/signin_dialog.dart';

/// Sign in with Apple button. When pressed, attempts to sign in with Google.
class SignInWithEmailButton extends StatefulWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Called if sign in is successful.
  final VoidCallback? onSignedIn;

  /// Called if sign in is unsuccessful.
  final VoidCallback? onFailure;

  /// The style of the button.
  final ButtonStyle? style;

  /// Creates a new Sign in with Google button.
  SignInWithEmailButton({
    required this.caller,
    this.onSignedIn,
    this.onFailure,
    this.style,
  });

  @override
  _SignInWithEmailButtonState createState() => _SignInWithEmailButtonState();
}

class _SignInWithEmailButtonState extends State<SignInWithEmailButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: widget.style ??
          ElevatedButton.styleFrom(
            primary: Colors.lightBlue,
            onPrimary: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
      onPressed: () {
        showSignInWithEmailDialog(
          context: context,
          caller: widget.caller,
          onSignedIn: () {
            if (widget.onSignedIn != null) {
              widget.onSignedIn!();
            }
          },
        );
      },
      label: Text('Sign in with Email'),
      icon: Icon(Icons.email),
    );
  }
}
