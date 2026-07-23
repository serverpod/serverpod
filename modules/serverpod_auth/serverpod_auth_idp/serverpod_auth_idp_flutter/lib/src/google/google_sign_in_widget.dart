import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import 'common/style.dart';
import 'google_auth_controller.dart';
import 'google_web_sign_in_service.dart';
import 'native/button.dart';
import '../common/sign_in_button_style.dart';
import '../common/sign_in_flow_coordinator.dart';

export 'common/style.dart';
export 'native/button.dart';

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
/// On the web the OAuth2 flow must be initialized (see [GoogleWebSignInService]);
/// without it there is no Google sign-in path and the widget renders nothing.
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

  /// Scopes to request from Google.
  ///
  /// The default scopes are `email` and `profile`, which will give access to
  /// retrieving the profile name and picture automatically.
  final List<String> scopes;

  /// The brand color preset (outline, filledBlue, or filledBlack).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final GoogleButtonStyle style;

  /// The button size.
  final SignInButtonSize size;

  /// The button label variant.
  final SignInButtonTextVariant text;

  /// The button shape.
  final SignInButtonShape shape;

  /// The Google logo alignment: left or center.
  final SignInButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// The text style applied to the button label.
  ///
  /// Falls back to the shared [SignInButtonStyle] when null.
  final TextStyle? textStyle;

  /// Creates a Google Sign-In widget.
  const GoogleSignInWidget({
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
    this.attemptLightweightSignIn = false,
    this.scopes = GoogleAuthController.defaultScopes,
    this.style = GoogleButtonStyle.outline,
    this.size = SignInButtonSize.large,
    this.text = SignInButtonTextVariant.continueWith,
    this.shape = SignInButtonShape.pill,
    this.logoAlignment = SignInButtonLogoAlignment.center,
    this.minimumWidth = 240,
    this.textStyle,
    super.key,
  }) : assert(
         (controller == null) != (client == null),
         'Either controller or client must be provided, but not both. When '
         'passing a controller, the client parameter is ignored.',
       ),
       assert(
         (onAuthenticated == null && onError == null) || controller == null,
         'Do not provide onAuthenticated or onError when using a controller '
         'as they will be handled by the controller and will be ignored.',
       ),
       assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be greater than 0 and at most 400.',
       );

  @override
  State<GoogleSignInWidget> createState() => _GoogleSignInWidgetState();
}

class _GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  late final GoogleAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        GoogleAuthController(
          client: widget.client!,
          onAuthenticated: widget.onAuthenticated,
          onError: widget.onError,
          attemptLightweightSignIn: widget.attemptLightweightSignIn,
          scopes: widget.scopes,
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
    // Native platforms (iOS, Android, macOS, etc.) and web with the OAuth2 flow
    // initialized. Without a supported path (e.g. web without OAuth2), there is
    // no Google button to show.
    final hasSignInPath =
        (kIsWeb && GoogleWebSignInService.instance.isInitialized) ||
        GoogleSignIn.instance.supportsAuthenticate();
    if (!hasSignInPath) return const SizedBox.shrink();

    return GoogleSignInNativeButton(
      onPressed: _signIn,
      isLoading: _controller.isLoading,
      isDisabled: !_controller.isInitialized || _controller.isLoading,
      style: widget.style,
      size: widget.size,
      text: widget.text,
      shape: widget.shape,
      logoAlignment: widget.logoAlignment,
      minimumWidth: widget.minimumWidth,
      textStyle: widget.textStyle,
    );
  }

  Future<void> _signIn() async {
    final coordinator = SignInFlowCoordinatorWidget.of(context);
    if (coordinator?.isAuthenticating == true) return;

    coordinator?.lockUI();
    try {
      await _controller.signIn();
    } finally {
      if (mounted) {
        coordinator?.unlockUI();
      }
    }
  }
}
