import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';

class SignInWithGoogleButton extends StatefulWidget {
  Caller caller;

  SignInWithGoogleButton({required this.caller});

  @override
  _SignInWithGoogleButtonState createState() => _SignInWithGoogleButtonState();
}

class _SignInWithGoogleButtonState extends State<SignInWithGoogleButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        signInWithGoogle(widget.caller,);
      },
      child: Text('Sign In With Google'),
    );
  }
}
