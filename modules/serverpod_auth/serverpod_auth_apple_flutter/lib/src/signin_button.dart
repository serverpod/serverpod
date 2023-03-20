import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

import 'auth.dart';

/// Sign in with Apple button. When pressed, attempts to sign in with Google.
class SignInWithAppleButton extends StatefulWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Called if sign in is successful.
  final VoidCallback? onSignedIn;

  /// Called if sign in is unsuccessful.
  final VoidCallback? onFailure;

  /// The style of the button.
  final ButtonStyle? style;

  /// Creates a new Sign in with Google button.
  const SignInWithAppleButton({
    required this.caller,
    this.onSignedIn,
    this.onFailure,
    this.style,
  });

  @override
  SignInWithAppleButtonState createState() => SignInWithAppleButtonState();
}

/// State for Sign in with Apple button.
class SignInWithAppleButtonState extends State<SignInWithAppleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: widget.style ??
          ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
      onPressed: () {
        // Open a dialog with just the progress indicator that isn't
        // dismissable.
        showLoadingBarrier(context: context);
        var navigator = Navigator.of(context, rootNavigator: true);

        // Attempt to sign in the user.
        signInWithApple(
          widget.caller,
        ).then((UserInfo? userInfo) {
          // Notify the parent.
          if (userInfo != null) {
            widget.onSignedIn?.call();
          } else {
            widget.onFailure?.call();
          }
        }).onError((error, stackTrace) {
          widget.onFailure?.call();
        }).whenComplete(() =>
            // Pop the loading barrier
            navigator.pop());
      },
      label: const Text('Sign in with Apple'),
      icon: const Icon(MdiIcons.apple),
    );
  }
}
