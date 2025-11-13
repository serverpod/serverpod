import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'apple_auth_controller.dart';
import 'apple_sign_in_button.dart';
import 'apple_sign_in_style.dart';

/// A widget that provides Apple Sign-In functionality for all platforms.
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
/// AppleSignInWidget(
///   client: client,
///   onAuthenticated: () => Navigator.push(...),
///   onError: (error) => showSnackBar(...),
/// )
/// ```
///
/// Example with external controller:
/// ```
/// final controller = AppleAuthController(
///   client: client,
///   onAuthenticated: ...,
/// );
///
/// AppleSignInWidget(
///   controller: controller,
/// )
/// ```
class AppleSignInWidget extends StatefulWidget {
  /// Controls the authentication state and behavior.
  ///
  /// If null, the widget creates and manages its own [AppleAuthController].
  /// In this case, [client] must be provided.
  ///
  /// If provided, the widget uses this controller instead of creating one,
  /// and [client], [onAuthenticated], and [onError] are ignored.
  final AppleAuthController? controller;

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

  /// Scopes to request from Apple.
  ///
  /// The default scopes are `email` and `fullName`, which will give access to
  /// retrieving the user's email and full name.
  final List<AppleIDAuthorizationScopes> scopes;

  /// The button type: icon, or standard button.
  final AppleButtonText type;

  /// The button style.
  ///
  /// For example, black or white.
  final AppleButtonStyle style;

  /// The button size.
  ///
  /// For example, small or large.
  final AppleButtonSize size;

  /// The button shape.
  ///
  /// For example, rectangular or pill.
  final AppleButtonShape shape;

  /// The Apple logo alignment: left or center.
  final AppleButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// Creates an Apple Sign-In widget.
  const AppleSignInWidget({
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
    this.scopes = AppleAuthController.defaultScopes,
    this.type = AppleButtonText.continueWith,
    this.style = AppleButtonStyle.black,
    this.size = AppleButtonSize.large,
    this.shape = AppleButtonShape.pill,
    this.logoAlignment = AppleButtonLogoAlignment.center,
    this.minimumWidth = 240,
    super.key,
  }) : assert(
         (controller == null || client == null),
         'Either controller or client must be provided, but not both. When '
         'passing a controller, the client parameter is ignored.',
       ),
       assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  @override
  State<AppleSignInWidget> createState() => _AppleSignInWidgetState();
}

class _AppleSignInWidgetState extends State<AppleSignInWidget> {
  late final AppleAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        AppleAuthController(
          client: widget.client!,
          onAuthenticated: widget.onAuthenticated,
          onError: widget.onError,
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
    return AppleSignInButton(
      onPressed: _controller.signIn,
      isLoading: _controller.isLoading,
      isDisabled: _controller.isLoading,
      type: widget.type,
      style: widget.style,
      size: widget.size,
      shape: widget.shape,
      minimumWidth: widget.minimumWidth,
      logoAlignment: widget.logoAlignment,
    );
  }
}
