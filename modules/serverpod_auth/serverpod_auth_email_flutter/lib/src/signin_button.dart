import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_email_flutter/src/signin_dialog.dart';

/// Sign in with Email button. When pressed, a pop-up window appears with fields for entering login, email and password.
class SignInWithEmailButton extends StatefulWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Called if sign in is successful.
  final VoidCallback? onSignedIn;

  /// The style of the button.
  final ButtonStyle? style;

  /// Minimum allowed password length.
  /// Defaults to 128.
  /// If this value is modified, the server must be updated to match.
  final int? maxPasswordLength;

  /// Minimum allowed password length.
  /// Defaults to 8.
  /// If this value is modified, the server must be updated to match.
  final int? minPasswordLength;

  /// Creates a new Sign in with Email button.
  const SignInWithEmailButton({
    required this.caller,
    this.onSignedIn,
    this.style,
    this.maxPasswordLength,
    this.minPasswordLength,
    Key? key,
  }) : super(key: key);

  @override
  SignInWithEmailButtonState createState() => SignInWithEmailButtonState();
}

/// State for Sign in with email button.
class SignInWithEmailButtonState extends State<SignInWithEmailButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: widget.style ??
          ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
      onPressed: () {
        showSignInWithEmailDialog(
          context: context,
          caller: widget.caller,
          maxPasswordLength: widget.maxPasswordLength,
          minPasswordLength: widget.minPasswordLength,
          onSignedIn: () {
            if (widget.onSignedIn != null) {
              widget.onSignedIn!();
            }
          },
        );
      },
      label: const Text('Sign in with Email'),
      icon: const Icon(Icons.email),
    );
  }
}
