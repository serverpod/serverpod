import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

/// Controller for managing anonymous-based authentication flows.
class AnonymousAuthController extends ChangeNotifier {
  /// The Serverpod client instance.
  final ServerpodClientShared client;

  /// Callback when authentication is successful.
  final VoidCallback? onAuthenticated;

  /// Callback when an error occurs during authentication.
  ///
  /// The [error] parameter is an exception that should be shown to the user.
  /// Exceptions that should not be shown to the user are shown in the debug
  /// log, but not passed to the callback.
  final Function(Object error)? onError;

  ///
  AnonymousAuthController({
    required this.client,
    this.onAuthenticated,
    this.onError,
  });

  /// Gets the email authentication endpoint from the client.
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
    try {
      final authSuccess = await _anonymousEndpoint.login();
      await client.auth.updateSignedInUser(authSuccess);
    } catch (e) {
      onError?.call(e);
    }
  }
}
