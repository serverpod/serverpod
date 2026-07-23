import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'facebook_auth_controller.dart';
import 'facebook_sign_in_button.dart';
import 'facebook_sign_in_style.dart';

/// A widget that provides Facebook Sign-In functionality for all platforms.
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
/// ```dart
/// FacebookSignInWidget(
///   client: client,
///   onAuthenticated: () => Navigator.push(...),
///   onError: (error) => showSnackBar(...),
/// )
/// ```
///
/// Example with external controller:
/// ```dart
/// final controller = FacebookAuthController(
///   client: client,
///   onAuthenticated: ...,
/// );
///
/// FacebookSignInWidget(
///   controller: controller,
/// )
/// ```
class FacebookSignInWidget extends StatefulWidget {
  /// Controls the authentication state and behavior.
  ///
  /// If null, the widget creates and manages its own [FacebookAuthController].
  /// In this case, [client] must be provided.
  ///
  /// If provided, the widget uses this controller instead of creating one,
  /// and [client], [onAuthenticated], and [onError] are ignored.
  final FacebookAuthController? controller;

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

  /// Permissions to request from Facebook.
  ///
  /// The default permissions are `email` and `public_profile`, which will give
  /// access to retrieving the user's email, name, and profile picture.
  final List<String> permissions;

  /// The button label variant.
  final SignInButtonTextVariant text;

  /// The brand color preset (blue or white).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final FacebookButtonStyle style;

  /// The button size.
  final SignInButtonSize size;

  /// The button shape.
  final SignInButtonShape shape;

  /// The Facebook logo alignment: left or center.
  final SignInButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// The text style applied to the button label.
  ///
  /// Falls back to the shared [SignInButtonStyle] when null.
  final TextStyle? textStyle;

  /// Creates a Facebook Sign-In widget.
  const FacebookSignInWidget({
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
    this.permissions = FacebookAuthController.defaultPermissions,
    this.text = SignInButtonTextVariant.continueWith,
    this.style = FacebookButtonStyle.blue,
    this.size = SignInButtonSize.large,
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
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be greater than 0 and at most 400.',
       );

  @override
  State<FacebookSignInWidget> createState() => _FacebookSignInWidgetState();
}

class _FacebookSignInWidgetState extends State<FacebookSignInWidget> {
  late final FacebookAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        FacebookAuthController(
          client: widget.client!,
          onAuthenticated: widget.onAuthenticated,
          onError: widget.onError,
          permissions: widget.permissions,
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
    return FacebookSignInButton(
      onPressed: _signIn,
      isLoading: _controller.isLoading,
      isDisabled: _controller.isLoading,
      text: widget.text,
      style: widget.style,
      size: widget.size,
      shape: widget.shape,
      minimumWidth: widget.minimumWidth,
      logoAlignment: widget.logoAlignment,
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
