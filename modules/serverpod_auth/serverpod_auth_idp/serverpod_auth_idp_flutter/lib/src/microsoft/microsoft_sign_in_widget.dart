import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import 'microsoft_auth_controller.dart';
import 'microsoft_sign_in_button.dart';
import 'microsoft_sign_in_style.dart';

export 'microsoft_sign_in_button.dart';
export 'microsoft_sign_in_style.dart';

/// A widget that provides Microsoft Sign-In functionality for all platforms.
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
/// MicrosoftSignInWidget(
///   client: client,
///   onAuthenticated: () => Navigator.push(...),
///   onError: (error) => showSnackBar(...),
/// )
/// ```
///
/// Example with external controller:
/// ```dart
/// MicrosoftSignInWidget(
///   controller: controller,
/// )
/// ```
class MicrosoftSignInWidget extends StatefulWidget {
  /// Controls the authentication state and behavior.
  ///
  /// If null, the widget creates and manages its own [MicrosoftAuthController].
  /// In this case, [client] must be provided.
  ///
  /// If provided, the widget uses this controller instead of creating one,
  /// and [client], [onAuthenticated], and [onError] are ignored.
  final MicrosoftAuthController? controller;

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

  /// Scopes to request from Microsoft.
  ///
  /// The default scopes are `openid`, `profile`, `email`, `offline_access`, and `https://graph.microsoft.com/User.Read`, which will give access to
  /// retrieving the user's profile data and user's emails automatically.
  final List<String> scopes;

  /// The button type: icon or standard button.
  final MicrosoftButtonType type;

  /// The button style (light or dark).
  final MicrosoftButtonStyle style;

  /// The button size (large or medium).
  final MicrosoftButtonSize size;

  /// The button text.
  final MicrosoftButtonText text;

  /// The button shape (rectangular, pill, or rounded).
  final MicrosoftButtonShape shape;

  /// The Microsoft logo alignment: left or center.
  final MicrosoftButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// Creates a Microsoft Sign-In widget.
  const MicrosoftSignInWidget({
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
    this.scopes = MicrosoftAuthController.defaultScopes,
    this.type = MicrosoftButtonType.standard,
    this.style = MicrosoftButtonStyle.light,
    this.size = MicrosoftButtonSize.large,
    this.text = MicrosoftButtonText.continueWith,
    this.shape = MicrosoftButtonShape.pill,
    this.logoAlignment = MicrosoftButtonLogoAlignment.center,
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
  State<MicrosoftSignInWidget> createState() => _MicrosoftSignInWidgetState();
}

class _MicrosoftSignInWidgetState extends State<MicrosoftSignInWidget> {
  late final MicrosoftAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        MicrosoftAuthController(
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

  void _onControllerStateChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MicrosoftSignInButton(
      onPressed: _controller.signIn,
      isLoading: _controller.isLoading,
      isDisabled: _controller.isAuthenticated,
      type: widget.type,
      style: widget.style,
      size: widget.size,
      text: widget.text,
      shape: widget.shape,
      logoAlignment: widget.logoAlignment,
      minimumWidth: widget.minimumWidth,
    );
  }
}
