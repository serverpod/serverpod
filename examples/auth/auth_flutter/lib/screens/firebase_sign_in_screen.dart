import 'package:auth_client/auth_client.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui;
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Example screen demonstrating how to integrate Firebase Authentication
/// with Serverpod using `firebase_ui_auth` and [FirebaseAuthController].
///
/// This screen uses `firebase_ui_auth`'s [firebase_ui.SignInScreen] to handle
/// the Firebase sign-in UI, then uses [FirebaseAuthController] to sync the
/// authenticated Firebase user with Serverpod's auth system.
///
/// The integration works by:
/// 1. Displaying Firebase's sign-in UI with configured providers
/// 2. Listening for [firebase_ui.SignedIn] and [firebase_ui.UserCreated] events
/// 3. Calling [FirebaseAuthController.login] with the Firebase user
/// 4. The controller extracts the ID token and authenticates with Serverpod
class FirebaseSignInScreen extends StatefulWidget {
  const FirebaseSignInScreen({
    super.key,
    required this.client,
  });

  final Client client;

  @override
  State<FirebaseSignInScreen> createState() => _FirebaseSignInScreenState();
}

class _FirebaseSignInScreenState extends State<FirebaseSignInScreen> {
  late final FirebaseAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FirebaseAuthController(
      client: widget.client,
      onAuthenticated: () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return firebase_ui.SignInScreen(
      providers: [
        // Configure the Firebase auth providers you want to support.
        // See https://github.com/firebase/FirebaseUI-Flutter for more providers.
        firebase_ui.EmailAuthProvider(),
      ],
      actions: [
        // Handle successful sign-in: sync the Firebase user with Serverpod.
        firebase_ui.AuthStateChangeAction<firebase_ui.SignedIn>((
          context,
          state,
        ) async {
          await _controller.login(state.user);
        }),
        // Handle new user registration: also sync with Serverpod.
        firebase_ui.AuthStateChangeAction<firebase_ui.UserCreated>((
          context,
          state,
        ) async {
          await _controller.login(state.credential.user);
        }),
        // Handle cancelled sign-in: pop back to previous screen.
        firebase_ui.AuthCancelledAction((context) {
          Navigator.of(context).pop();
        }),
      ],
    );
  }
}
