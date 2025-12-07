import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'anonymous_auth_controller.dart';

/// A widget that provides anonymous-based authentication functionality.
///
/// This is a placeholder widget to trigger a workflow that you would
/// probably trigger in the background after a certain threshold of user
/// activity. It is not a real sign-in widget.
class AnonymousSignInWidget extends StatefulWidget {
  /// Controls the authentication state and behavior.
  ///
  /// If null, the widget creates and manages its own [EmailAuthController].
  /// In this case, [client] must be provided.
  ///
  /// If provided, the widget uses this controller instead of creating one,
  /// and [client], [startScreen], [onAuthenticated], and [onError] are ignored.
  final AnonymousAuthController? controller;

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

  /// Creates an anonymous sign-in widget.
  const AnonymousSignInWidget({
    super.key,
    this.controller,
    this.client,
    this.onAuthenticated,
    this.onError,
  }) : assert(
         (controller == null || client == null),
         'Either controller or client must be provided, but not both. When '
         'passing a controller, client, onAuthenticated, and onError '
         'parameters are ignored.',
       ),
       assert(
         (onAuthenticated == null && onError == null) || controller == null,
         'Provided onAuthenticated or onError when using a controller '
         'as they are handled by the controller and will be ignored.',
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
          onError: widget.onError,
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
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          const Text(
            'The following is placeholder widget to invoke a workflow '
            'that you would probably trigger in the background after a certain '
            'threshold of user activity. It is not a real sign-in widget.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          // The styling of this button is unimportant, because you would not
          // show it to users in typical applications. It is only presented here
          // to force users into anonymous, authenticated states for testing
          // purposes.
          OutlinedButton(
            onPressed: _controller.login,
            child: const Text('Sign in anonymously'),
          ),
        ],
      ),
    );
  }
}
