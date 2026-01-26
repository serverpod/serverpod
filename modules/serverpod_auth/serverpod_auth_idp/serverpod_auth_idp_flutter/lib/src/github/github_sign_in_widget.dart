import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import 'github_auth_controller.dart';
import 'github_sign_in_button.dart';
import 'github_sign_in_style.dart';

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

  /// The button style (black or white).
  final GitHubButtonStyle style;

  /// The button size (large or medium).
  final GitHubButtonSize size;

  /// The button text.
  final GitHubButtonText text;

  /// The button shape (rectangular, pill, or rounded).
  final GitHubButtonShape shape;

  /// The GitHub logo alignment: left or center.
  final GitHubButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// Creates a GitHub Sign-In widget.
  const GitHubSignInWidget({
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
    this.scopes = GitHubAuthController.defaultScopes,
    this.type = GitHubButtonType.standard,
    this.style = GitHubButtonStyle.black,
    this.size = GitHubButtonSize.large,
    this.text = GitHubButtonText.continueWith,
    this.shape = GitHubButtonShape.pill,
    this.logoAlignment = GitHubButtonLogoAlignment.center,
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
      onPressed: _controller.signIn,
      isLoading: _controller.isLoading,
      isDisabled: _controller.isLoading,
      type: widget.type,
      style: widget.style,
      size: widget.size,
      text: widget.text,
      shape: widget.shape,
      minimumWidth: widget.minimumWidth,
      logoAlignment: widget.logoAlignment,
    );
  }
}
