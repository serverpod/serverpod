import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../localization/sign_in_localization_provider.dart';
import 'anonymous_auth_controller.dart';
import 'anonymous_sign_in_style.dart';

/// A widget that provides anonymous-based authentication functionality.
///
/// This is a placeholder widget to trigger a workflow that you would
/// probably trigger in the background after a certain threshold of user
/// activity. It is not a real sign-in widget.
class AnonymousSignInWidget extends StatefulWidget {
  /// Controls the authentication state and behavior.
  ///
  /// If null, the widget creates and manages its own [AnonymousAuthController].
  /// In this case, [client] must be provided.
  ///
  /// If provided, the widget uses this controller instead of creating one,
  /// and [client], [onAuthenticated], and [onError] are ignored.
  final AnonymousAuthController? controller;

  /// {@macro create_anonymous_token}
  final Future<String?> Function()? createAnonymousToken;

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

  /// The button size.
  ///
  /// For example, small or large.
  final AnonymousButtonSize size;

  /// The button shape.
  ///
  /// For example, rectangular or pill.
  final AnonymousButtonShape shape;

  /// Creates an anonymous sign-in widget.
  const AnonymousSignInWidget({
    super.key,
    this.controller,
    this.client,
    this.onAuthenticated,
    this.createAnonymousToken,
    this.onError,
    this.size = AnonymousButtonSize.large,
    this.shape = AnonymousButtonShape.pill,
  }) : assert(
         (controller == null || client == null),
         'Either controller or client must be provided, but not both. When '
         'passing a controller, client, onAuthenticated, and onError '
         'parameters are ignored.',
       ),
       assert(
         (onAuthenticated == null && onError == null) || controller == null,
         'Do not provide onAuthenticated or onError when using a controller '
         'as they will be handled by the controller and will be ignored.',
       );

  @override
  State<AnonymousSignInWidget> createState() => _AnonymousSignInWidgetState();
}

class _AnonymousSignInWidgetState extends State<AnonymousSignInWidget> {
  late final AnonymousAuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        AnonymousAuthController(
          client: widget.client!,
          onAuthenticated: widget.onAuthenticated,
          createAnonymousToken: widget.createAnonymousToken,
          onError: widget.onError,
        );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.anonymousSignInTexts;
    final buttonStyle = AnonymousSignInStyle.fromConfiguration(
      shape: widget.shape,
      size: widget.size,
      width: 0,
    );

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 240,
            maxWidth: 400,
            minHeight: buttonStyle.size.height,
            maxHeight: buttonStyle.size.height,
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: buttonStyle.borderRadius,
              ),
            ),
            onPressed: _controller.login,
            child: Text(texts.continueWithoutAccount),
          ),
        );
      },
    );
  }
}
