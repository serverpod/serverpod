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

  /// The button type: icon, continue with, or sign in.
  final FacebookButtonText type;

  /// The button style.
  ///
  /// For example, blue or white.
  final FacebookButtonStyle style;

  /// The button size.
  ///
  /// For example, small or large.
  final FacebookButtonSize size;

  /// The button shape.
  ///
  /// For example, rectangular or pill.
  final FacebookButtonShape shape;

  /// The Facebook logo alignment: left or center.
  final FacebookButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// Creates a Facebook Sign-In widget.
  const FacebookSignInWidget({
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
    this.permissions = FacebookAuthController.defaultPermissions,
    this.type = FacebookButtonText.continueWith,
    this.style = FacebookButtonStyle.blue,
    this.size = FacebookButtonSize.large,
    this.shape = FacebookButtonShape.pill,
    this.logoAlignment = FacebookButtonLogoAlignment.center,
    this.minimumWidth = 240,
    super.key,
  }) : assert(
         (controller == null) != (client == null),
         'Either controller or client must be provided, but not both. When '
         'passing a controller, the client parameter is ignored.',
       ),
       assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be between 0 and 400.',
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
