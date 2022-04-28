import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import '../serverpod_auth_google_flutter.dart';

/// Sign in with Google button. When pressed, attempts to sign in with Google.
class SignInWithGoogleButton extends StatefulWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Called if sign in is successful.
  final VoidCallback? onSignedIn;

  /// Called if sign in is unsuccessful.
  final VoidCallback? onFailure;

  /// The style of the button.
  final ButtonStyle? style;

  /// Will output debug prints if set to true.
  final bool debug;

  /// Scopes to request when signing in. Default scopes are userinfo.profile
  /// and email, these should not be included in the [additionalScopes] list.
  final List<String> additionalScopes;

  /// Alignment of text and icon within the button.
  final Alignment alignment;

  /// Redirect Uri as setup in Google console.
  final Uri? redirectUri;

  /// Creates a new Sign in with Google button.
  const SignInWithGoogleButton({
    required this.caller,
    this.onSignedIn,
    this.onFailure,
    this.debug = false,
    this.style,
    this.additionalScopes = const <String>[],
    this.alignment = Alignment.centerLeft,
    this.redirectUri,
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
      onPressed: () {
        // Open a dialog with just the progress indicator that isn't
        // dismissable.
        showLoadingBarrier(context: context);

        // Attempt to sign in the user.
        signInWithGoogle(
          widget.caller,
          debug: widget.debug,
          additionalScopes: widget.additionalScopes,
          redirectUri: widget.redirectUri,
        ).then((UserInfo? userInfo) {
          // Pop the loading barrier
          Navigator.of(context).pop();

          // Notify the parent.
          if (userInfo != null) {
            if (widget.onSignedIn != null) {
              widget.onSignedIn!();
            }
          } else {
            if (widget.onFailure != null) {
              widget.onFailure!();
            }
          }
        });
      },
      label: const Text('Sign in with Google'),
      icon: Image.asset(
        'assets/google-icon.png',
        package: 'serverpod_auth_google_flutter',
        width: 24,
        height: 24,
      ),
    );
  }
}
