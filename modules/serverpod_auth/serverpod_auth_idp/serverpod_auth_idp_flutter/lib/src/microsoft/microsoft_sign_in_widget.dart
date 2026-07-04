import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import 'microsoft_auth_controller.dart';
import 'microsoft_sign_in_button.dart';
import 'microsoft_sign_in_style.dart';
import '../common/sign_in_button_style.dart';
import '../common/sign_in_flow_coordinator.dart';

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

  /// The brand color preset (light or dark).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final MicrosoftButtonStyle style;

  /// The button size.
  final SignInButtonSize size;

  /// The button label variant.
  final SignInButtonTextVariant text;

  /// The button shape.
  final SignInButtonShape shape;

  /// The Microsoft logo alignment: left or center.
  final SignInButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// The text style applied to the button label.
  ///
  /// Falls back to the shared [SignInButtonStyle] when null.
  final TextStyle? textStyle;

  /// Creates a Microsoft Sign-In widget.
  const MicrosoftSignInWidget({
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
    this.scopes = MicrosoftAuthController.defaultScopes,
    this.style = MicrosoftButtonStyle.light,
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
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be greater than 0 and at most 400.',
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
      onPressed: _signIn,
      isLoading: _controller.isLoading,
      isDisabled: _controller.isAuthenticated,
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
