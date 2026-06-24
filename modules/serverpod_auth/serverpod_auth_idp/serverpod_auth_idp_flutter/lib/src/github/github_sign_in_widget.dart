import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import 'github_auth_controller.dart';
import 'github_sign_in_button.dart';
import 'github_sign_in_style.dart';
import '../common/sign_in_flow_coordinator.dart';

export 'github_sign_in_button.dart';
export 'github_sign_in_style.dart';

/// A widget that provides GitHub Sign-In functionality for all platforms.
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
/// GitHubSignInWidget(
///   client: client,
///   onAuthenticated: () => Navigator.push(...),
///   onError: (error) => showSnackBar(...),
/// )
/// ```
///
/// Example with external controller:
/// ```dart
/// GitHubSignInWidget(
///   controller: controller,
/// )
/// ```
class GitHubSignInWidget extends StatefulWidget {
  /// Controls the authentication state and behavior.
  ///
  /// If null, the widget creates and manages its own [GitHubAuthController].
  /// In this case, [client] must be provided.
  ///
  /// If provided, the widget uses this controller instead of creating one,
  /// and [client], [onAuthenticated], and [onError] are ignored.
  final GitHubAuthController? controller;

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

  /// Scopes to request from GitHub.
  ///
  /// The default scopes are `user`, `read:user` and `user:email`, which will give access to
  /// retrieving the user's profile data and user's emails automatically.
  final List<String> scopes;

  /// The button type: icon or standard button.
  final GitHubButtonType type;

  /// The brand color preset (black or white).
  ///
  /// When null, the button uses the shared [SignInButtonStyle] colors (or the
  /// uniform default). Set it to opt this button into GitHub's brand colors.
  final GitHubButtonStyle? style;

  /// The button size (large or medium).
  ///
  /// Falls back to the shared [SignInButtonStyle], then to
  /// [GitHubButtonSize.large], when null.
  final GitHubButtonSize? size;

  /// The button text.
  ///
  /// Falls back to the shared [SignInButtonStyle], then to
  /// [GitHubButtonText.continueWith], when null.
  final GitHubButtonText? text;

  /// The button shape (rectangular, pill, or rounded).
  ///
  /// Falls back to the shared [SignInButtonStyle], then to
  /// [GitHubButtonShape.pill], when null.
  final GitHubButtonShape? shape;

  /// The GitHub logo alignment: left or center.
  ///
  /// Falls back to the shared [SignInButtonStyle], then to
  /// [GitHubButtonLogoAlignment.center], when null.
  final GitHubButtonLogoAlignment? logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels. Falls back to the shared
  /// [SignInButtonStyle], then to 240, when null.
  final double? minimumWidth;

  /// The text style applied to the button label.
  ///
  /// Falls back to the shared [SignInButtonStyle] when null.
  final TextStyle? textStyle;

  /// Creates a GitHub Sign-In widget.
  const GitHubSignInWidget({
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
    this.scopes = GitHubAuthController.defaultScopes,
    this.type = GitHubButtonType.standard,
    this.style,
    this.size,
    this.text,
    this.shape,
    this.logoAlignment,
    this.minimumWidth,
    this.textStyle,
    super.key,
  }) : assert(
         (controller == null) != (client == null),
         'Either controller or client must be provided, but not both. When '
         'passing a controller, the client parameter is ignored.',
       ),
       assert(
         minimumWidth == null || (minimumWidth > 0 && minimumWidth <= 400),
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  @override
  State<GitHubSignInWidget> createState() => _GitHubSignInWidgetState();
}

class _GitHubSignInWidgetState extends State<GitHubSignInWidget> {
  late final GitHubAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        GitHubAuthController(
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
    return GitHubSignInButton(
      onPressed: _signIn,
      isLoading: _controller.isLoading,
      isDisabled: _controller.isLoading,
      type: widget.type,
      style: widget.style,
      size: widget.size,
      text: widget.text,
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
