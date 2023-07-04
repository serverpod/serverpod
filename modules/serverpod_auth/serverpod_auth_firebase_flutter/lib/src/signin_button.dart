import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:serverpod_auth_client/module.dart';

import 'auth.dart';

/// Sign in with Firebase button. When pressed, attempts to sign in with
/// Firebase.
class SignInWithFirebaseButton extends StatelessWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Called if sign in is successful.
  final VoidCallback? onSignedIn;

  /// Called if sign in is unsuccessful.
  final VoidCallback? onFailure;

  /// The style of the button.
  final ButtonStyle? style;

  /// List of Firebase auth provider.
  final List<AuthProvider> authProviders;

  /// Creates a new Sign in with Firebase button.
  const SignInWithFirebaseButton({
    Key? key,
    required this.caller,
    required this.authProviders,
    this.onSignedIn,
    this.onFailure,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[900],
            foregroundColor: Colors.white,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
      onPressed: () {
        signInWithFirebase(
          caller: caller,
          authProviders: authProviders,
          context: context,
        ).then((UserInfo? userInfo) {
          // Notify the parent.
          if (userInfo != null) {
            if (onSignedIn != null) {
              onSignedIn!();
            }
          } else {
            if (onFailure != null) {
              onFailure!();
            }
          }
        });
      },
      label: const Text('Sign in with Firebase'),
      icon: const Icon(MdiIcons.firebase),
    );
  }
}
