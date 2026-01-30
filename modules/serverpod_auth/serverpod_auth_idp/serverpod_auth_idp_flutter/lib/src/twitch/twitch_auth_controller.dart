import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/exceptions.dart';
import 'twitch_sign_in_service.dart';

/// Controller for managing Twitch-based authentication flows.
///
/// This controller handles all the business logic for Twitch authentication,
/// including sign-in and authentication event handling. It can be used with
/// any UI implementation.
///
/// Example usage:
/// ```dart
/// final controller = TwitchAuthController(
///   client: client,
///   onAuthenticated: () {
///     // Do something when the user is authenticated.
///     //
///     // NOTE: You should not navigate to the home screen here, otherwise
///     // the user will have to sign in again every time they open the app.
///   },
/// );
///
/// // Initiate sign-in
/// await controller.signIn();
///
/// // Listen to state changes
/// controller.addListener(() {
///   // UI will rebuild automatically
///   // Can use `controller.state` to access the current state.
/// });
/// ```
class TwitchAuthController extends ChangeNotifier {
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

  /// Scopes to request from Twitch.
  ///
  /// The default scopes are [`user:read:email`], which will give access to
  /// retrieving the user's profile data and users's email address.
  ///
  /// Reference: https://dev.twitch.tv/docs/authentication/scopes/
  final List<String> scopes;

  /// Creates a Twitch authentication controller.
  TwitchAuthController({
    required this.client,
    this.onAuthenticated,
    this.onError,
    this.scopes = defaultScopes,
  });

  /// Default scopes to request from Twitch.
  /// Since this implementation uses an user token, no additional scopes are required to
  /// read basic profile information.
  ///
  /// To be able to read the user's email address, the following scope is required:
  /// - `user:read:email`: Grants read access to a user's email address.
  ///
  /// Reference: https://dev.twitch.tv/docs/authentication/scopes/
  static const List<String> defaultScopes = [
    'user:read:email',
  ];

  TwitchAuthState _state = TwitchAuthState.idle;

  bool _disposed = false;

  /// The current state of the authentication flow.
  TwitchAuthState get state => _state;

  /// Whether the controller is currently processing a request.
  bool get isLoading => _state == TwitchAuthState.loading;

  /// Whether the user is authenticated.
  bool get isAuthenticated => client.auth.isAuthenticated;

  /// The current error message, if any.
  String? get errorMessage => _error?.toString();

  /// The current error, if any.
  Object? get error => _state == TwitchAuthState.error ? _error : null;
  Object? _error;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Initiates the Twitch Sign-In flow.
  ///
  /// Opens the Twitch authorization page, waits for user authorization, and
  /// exchanges the `authorization code` for an `access token` on the server.
  ///
  /// On success, calls [onAuthenticated]. On failure, transitions to error
  /// state and calls [onError].
  Future<void> signIn() async {
    if (_state == TwitchAuthState.loading) return;
    _setState(TwitchAuthState.loading);

    try {
      // Get the authorization code and code verifier from Twitch OAuth flow
      final signInResult = await TwitchSignInService.instance.signIn(
        scopes: scopes,
      );

      // Exchange the code for an access token on the server
      await _handleServerSideSignIn(signInResult);
    } catch (error) {
      _handleAuthenticationError(error);
    }
  }

  /// Handles the server-side sign-in process.
  Future<void> _handleServerSideSignIn(
    TwitchSignInResult signInResult,
  ) async {
    try {
      final endpoint = client.getEndpointOfType<EndpointTwitchIdpBase>();
      log('[TwitchAuthController] Exchanging code for token on server');
      final authSuccess = await endpoint.login(
        code: signInResult.code,
        redirectUri: signInResult.redirectUri,
      );

      await client.auth.updateSignedInUser(authSuccess);

      _setState(TwitchAuthState.authenticated);
      onAuthenticated?.call();
    } catch (error) {
      _handleAuthenticationError(error);
    }
  }

  /// Handles authentication errors.
  void _handleAuthenticationError(Object error) {
    _error = error;
    _setState(TwitchAuthState.error);
    debugPrint('[TwitchAuthController] Authentication error: $error');

    final userFriendlyError = _convertToUserFacingException(error);
    if (userFriendlyError != null) {
      onError?.call(userFriendlyError);
    }
  }

  /// Sets the current state of the authentication flow and notifies listeners.
  void _setState(TwitchAuthState newState) {
    if (_disposed) return;
    if (newState != TwitchAuthState.error) _error = null;
    _state = newState;
    notifyListeners();
  }
}

/// Represents the state of the Twitch authentication flow.
enum TwitchAuthState {
  /// Initial idle state.
  idle,

  /// Loading state while processing any request.
  loading,

  /// A request ended with error. The error can be retrieved from the controller.
  error,

  /// Authentication was successful.
  authenticated,
}

/// Converts exceptions to user-friendly error messages.
///
/// Returns a user-friendly exception or message for exceptions that should be
/// shown to the user. Returns `null` for internal errors that shouldn't be
/// exposed to users (e.g., StateError, internal server errors, network errors).
Exception? _convertToUserFacingException(Object error) {
  if (error is UserFacingException) return error;
  if (error is StateError) {
    // StateError indicates programming or configuration issues that shouldn't
    // be shown to end users
    return null;
  }
  if (error is TwitchAccessTokenVerificationException) {
    return UserFacingException(
      'An error occurred while verifying the Twitch access token. Please '
      'check your Twitch account and try again. If the problem persists, '
      'please contact support.',
      originalException: error,
    );
  }
  if (error is ServerpodClientException) {
    return UserFacingException.fromServerpodClientException(error);
  }
  return null;
}
