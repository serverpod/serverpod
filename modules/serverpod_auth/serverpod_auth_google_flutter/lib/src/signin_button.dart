import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_google_flutter/serverpod_auth_google_flutter.dart';

/// Sign in with Google button. When pressed, attempts to sign in with Google.
class SignInWithGoogleButton extends StatefulWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Google clientId, if not specified through a GoogleService-Info.plist file.
  final String? clientId;

  /// Your server's clientId, if not specified through a
  /// GoogleService-Info.plist file.
  final String? serverClientId;

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
  final Uri redirectUri;

  /// Creates a new Sign in with Google button.
  const SignInWithGoogleButton({
    required this.caller,
    this.clientId,
    this.serverClientId,
    this.onSignedIn,
    this.onFailure,
    this.debug = false,
    this.style,
    this.additionalScopes = const [],
    this.alignment = Alignment.centerLeft,
    required this.redirectUri,
  });

  @override
  SignInWithGoogleButtonState createState() => SignInWithGoogleButtonState();
}

/// State for Sign in with Google button.
class SignInWithGoogleButtonState extends State<SignInWithGoogleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: widget.style ??
          ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[700],
            alignment: widget.alignment,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
      onPressed: () {
        // Open a dialog with just the progress indicator that isn't
        // dismissable.
        showLoadingBarrier(context: context);
        var navigator = Navigator.of(context, rootNavigator: true);

        // Attempt to sign in the user.
        signInWithGoogle(
          widget.caller,
          debug: widget.debug,
          clientId: widget.clientId,
          serverClientId: widget.serverClientId,
          additionalScopes: widget.additionalScopes,
          redirectUri: widget.redirectUri,
        ).then((UserInfo? userInfo) {
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
        }).whenComplete(() =>
            // Pop the loading barrier
            navigator.pop());
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
