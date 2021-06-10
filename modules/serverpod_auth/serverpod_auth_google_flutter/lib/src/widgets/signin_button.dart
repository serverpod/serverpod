import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
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
      ),
      onPressed: () {
        signInWithGoogle(widget.caller,);
      },
      label: Text('Sign in with Google'),
      icon: Image.asset(
        'assets/google-icon.png',
        package: 'serverpod_auth_google_flutter',
        width: 18,
        height: 18,
      ),
    );
  }
}
