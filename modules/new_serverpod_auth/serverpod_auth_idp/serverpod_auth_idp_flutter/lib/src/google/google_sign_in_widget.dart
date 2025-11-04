import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import 'google_auth_controller.dart';
import 'native/button.dart';
import 'web/button.dart';

export 'native/button.dart';
export 'web/button.dart';

/// A widget that provides Google Sign-In functionality for all platforms.
///
/// The widget can manage its own authentication state, or you can provide an
/// external [controller] for advanced use cases like sharing state across
/// multiple widgets or integrating with state management solutions.
///
/// When [controller] is not provided, you must supply [client] and optionally
/// [onAuthenticated] and [onError] callbacks. When [controller] is provided,
/// those callbacks are handled by the controller itself.
///
/// Example with managed state:
/// ```
/// GoogleSignInWidget(
///   client: client,
///   onAuthenticated: () => Navigator.push(...),
///   onError: (error) => showSnackBar(...),
/// )
/// ```
///
/// Example with external controller:
/// ```
/// final controller = GoogleAuthController(
///   client: client,
///   onAuthenticated: ...,
/// );
///
/// GoogleSignInWidget(
///   controller: controller,
/// )
/// ```
class GoogleSignInWidget extends StatefulWidget {
  /// Controls the authentication state and behavior.
  ///
  /// If null, the widget creates and manages its own [GoogleAuthController].
  /// In this case, [client] must be provided.
  ///
  /// If provided, the widget uses this controller instead of creating one,
  /// and [client], [onAuthenticated], and [onError] are ignored.
  final GoogleAuthController? controller;

  /// The Serverpod client instance.
  ///
  /// Required when [controller] is null, ignored otherwise.
  final ServerpodClientShared? client;

  /// Callback when authentication is successful.
  ///
  /// Ignored when [controller] is provided.
  final VoidCallback? onAuthenticated;

  /// Callback when an error occurs during authentication.
  ///
  /// Ignored when [controller] is provided.
  final Function(Object error)? onError;

  /// A styled button to use for the web platform.
  final GoogleSignInWebButton? webButton;

  /// Whether to attempt to authenticate the user automatically using the
  /// `attemptLightweightAuthentication` method after the widget is initialized.
  ///
  /// The amount of allowable UI is up to the platform to determine, but it
  /// should be minimal. Possible examples include FedCM on the web, and One Tap
  /// on Android. Platforms may even show no UI, and only sign in if a previous
  /// sign-in is being restored. This method is intended to be called as soon
  /// as the application needs to know if the user is signed in, often at
  /// initial launch.
  final bool attemptLightweightSignIn;

  /// Creates a Google Sign-In widget.
  const GoogleSignInWidget({
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
    this.webButton,
    this.attemptLightweightSignIn = true,
    super.key,
  }) : assert(
          (controller == null || client == null),
          'Either controller or client must be provided, but not both. When '
          'passing a controller, only the `webButton` parameter is used. ',
        );

  @override
  State<GoogleSignInWidget> createState() => _GoogleSignInWidgetState();
}

class _GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  late final GoogleAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        GoogleAuthController(
          client: widget.client!,
          onAuthenticated: widget.onAuthenticated,
          onError: widget.onError,
          attemptLightweightSignIn: widget.attemptLightweightSignIn,
        );
    _controller.addListener(_onControllerStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerStateChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Rebuild when controller state changes
  void _onControllerStateChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (GoogleSignIn.instance.supportsAuthenticate())
          GoogleSignInNativeButton(
            onPressed: _controller.signIn,
            isLoading: _controller.isLoading,
            isDisabled: !_controller.isInitialized || _controller.isLoading,
          )
        else if (_controller.isInitialized)
          widget.webButton ?? GoogleSignInWebButton()
      ],
    );
  }
}
