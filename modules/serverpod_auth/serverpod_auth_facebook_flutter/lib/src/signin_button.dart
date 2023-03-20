import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_facebook_flutter/serverpod_auth_facebook_flutter.dart';

/// Sign in with Facebook button. When pressed, attempts to sign in with Facebook.
class SignInWithFacebookButton extends StatefulWidget {
  /// The Auth module's caller.
  final Caller caller;

  /// Facebook appId, only needed for Web and desktop builds
  /// (Android and iOS will read this from their property file)
  final String? appIdForWebOrDesktop;

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

  /// Redirect Uri as setup in Facebook console.
  final Uri redirectUri;

  /// Creates a new Sign in with Facebook button.
  const SignInWithFacebookButton({
    required this.caller,
    this.onSignedIn,
    this.onFailure,
    this.debug = false,
    this.appIdForWebOrDesktop,
    this.style,
    this.additionalScopes = const [],
    this.alignment = Alignment.centerLeft,
    required this.redirectUri,
  });

  @override
  SignInWithFacebookButtonState createState() =>
      SignInWithFacebookButtonState();
}

/// State for Sign in with Facebook button.
class SignInWithFacebookButtonState extends State<SignInWithFacebookButton> {
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
        signInWithFacebook(
          widget.caller,
          appIdForWebOrDesktop: widget.appIdForWebOrDesktop,
          debug: widget.debug,
          additionalScopes: widget.additionalScopes,
          redirectUri: widget.redirectUri,
        ).then((UserInfo? userInfo) {
          // Notify the parent.
          if (userInfo != null) {
            widget.onSignedIn?.call();
          } else {
            widget.onFailure?.call();
          }
        }).onError((error, stackTrace) {
          print('Sign in error: $error');
          widget.onFailure?.call();
        }).whenComplete(() =>
            // Pop the loading barrier
            navigator.pop());
      },
      label: const Text('Sign in with Facebook'),
      icon: Image.asset(
        'assets/facebook-icon.png',
        package: 'serverpod_auth_facebook_flutter',
        width: 24,
        height: 24,
      ),
    );
  }
}
