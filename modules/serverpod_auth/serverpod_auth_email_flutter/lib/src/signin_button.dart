import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_email_flutter/src/signin_dialog.dart';

/// Sign in with Email button. When pressed, a pop-up window appears with fields for entering login, email and password.
class SignInWithEmailButton extends StatefulWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Called if sign in is successful.
  final VoidCallback? onSignedIn;

  /// The style of the button.
  final ButtonStyle? style;

  /// The text of the button.
  final Text? label;

  /// The icon of the button.
  final Icon? icon;

  /// Maximum allowed password length.
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
    this.label,
    this.icon,
    this.maxPasswordLength,
    this.minPasswordLength,
    super.key,
  });

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
      label: widget.label ?? const Text('Sign in with Email'),
      icon: widget.icon ?? const Icon(Icons.email),
    );
  }
}
