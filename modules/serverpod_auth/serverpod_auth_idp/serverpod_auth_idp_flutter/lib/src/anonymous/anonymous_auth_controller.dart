import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import 'anonymous_auth_exceptions.dart';

/// Controller for managing anonymous-based authentication flows.
class AnonymousAuthController extends ChangeNotifier {
  /// The Serverpod client instance.
  final ServerpodClientShared client;

  /// Function to generate the anonymous token supplied to the `login` endpoint.
  /// This token can fill many roles, including app attestation if the
  /// onBeforeAnonymousAccountCreated callback is used to prevent abuse. If
  /// onBeforeAnonymousAccountCreated is not configured on the server, then this
  /// function and any token it would generate are likely meaningless.
  final Future<String?> Function()? createAnonymousToken;

  /// Callback when authentication is successful.
  final VoidCallback? onAuthenticated;

  /// Callback when an error occurs during authentication.
  ///
  /// The [error] parameter is an exception that should be shown to the user.
  /// Exceptions that should not be shown to the user are shown in the debug
  /// log, but not passed to the callback.
  final Function(Object error)? onError;

  /// Creates a new [AnonymousAuthController] instance.
  AnonymousAuthController({
    required this.client,
    this.createAnonymousToken,
    this.onAuthenticated,
    this.onError,
  });

  AnonymousAuthState _state = AnonymousAuthState.idle;

  /// The current state of the authentication flow.
  AnonymousAuthState get state => _state;

  /// Whether the controller is currently processing a request.
  bool get isLoading => _state == AnonymousAuthState.loading;

  /// Gets the anonymous authentication endpoint from the client.
  EndpointAnonymousIdpBase get _anonymousEndpoint {
    try {
      return client.getEndpointOfType<EndpointAnonymousIdpBase>();
    } on ServerpodClientEndpointNotFound catch (_) {
      throw StateError(
        'No anonymous authentication endpoint found. Make sure you have '
        'extended and exposed "EndpointAnonymousIdpBase" in your server.',
      );
    }
  }

  /// Initiates the anonymous sign-in process.
  Future<void> login() async {
    await _guarded(() async {
      final token = await createAnonymousToken?.call();
      final authSuccess = await _anonymousEndpoint.login(token: token);
      await client.auth.updateSignedInUser(authSuccess);
    });
  }

  Future<void> _guarded(Future<void> Function() action) async {
    _state = AnonymousAuthState.loading;
    notifyListeners();
    try {
      await action();
      _state = AnonymousAuthState.authenticated;
      notifyListeners();
      onAuthenticated?.call();
    } catch (e) {
      _state = AnonymousAuthState.error;
      notifyListeners();

      final userFriendlyError = convertToUserFacingException(e);
      if (userFriendlyError != null) {
        onError?.call(userFriendlyError);
      }
    }
  }
}

/// Represents the state of the anonymous authentication flow.
enum AnonymousAuthState {
  /// Initial idle state.
  idle,

  /// Loading state while processing login.
  loading,

  /// A request ended with error.
  error,

  /// Authentication was successful.
  authenticated,
}
