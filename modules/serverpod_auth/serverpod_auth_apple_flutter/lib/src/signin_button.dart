import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:serverpod_auth_client/module.dart';

class SignInWithAppleButton extends StatefulWidget {
  final Caller caller;
  final VoidCallback onSignedIn;
  final VoidCallback onFailure;
  final ButtonStyle? style;

  SignInWithAppleButton({
    required this.caller,
    required this.onSignedIn,
    required this.onFailure,
    this.style,
  });

  @override
  _SignInWithAppleButtonState createState() => _SignInWithAppleButtonState();
}

class _SignInWithAppleButtonState extends State<SignInWithAppleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: widget.style ?? ElevatedButton.styleFrom(
        primary: Colors.black,
        onPrimary: Colors.white,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: () {
        throw UnimplementedError();
      },
      label: Text('Sign in with Apple'),
      icon: Icon(Mdi.apple),
    );
  }
}
