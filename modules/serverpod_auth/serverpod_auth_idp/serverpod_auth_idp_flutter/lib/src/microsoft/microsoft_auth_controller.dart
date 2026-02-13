import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/exceptions.dart';
import 'microsoft_sign_in_service.dart';

/// Controller for managing Microsoft-based authentication flows.
///
/// This controller handles all the business logic for Microsoft authentication,
/// including sign-in and authentication event handling. It can be used with
/// any UI implementation.
///
/// Example usage:
/// ```dart
/// final controller = MicrosoftAuthController(
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
class MicrosoftAuthController extends ChangeNotifier {
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

  /// Scopes to request from Microsoft.
  ///
  /// The default scopes are [`openid`, `profile`, `email`, `offline_access`, `https://graph.microsoft.com/User.Read`], which will give access to
  /// retrieving the user's profile data and user's emails automatically.
  ///
  /// Reference: https://learn.microsoft.com/en-us/entra/identity-platform/scopes-oidc
  final List<String> scopes;

  /// Creates a Microsoft authentication controller.
  MicrosoftAuthController({
    required this.client,
    this.onAuthenticated,
    this.onError,
    this.scopes = defaultScopes,
  });

  /// Default scopes to request from Microsoft.
  ///
  /// - `openid`: Allows OpenID Connect authentication
  /// - `profile`: Grants access to the user's basic profile information
  /// - `email`: Grants read access to the user's email address
  /// - `offline_access`: Allows the app to receive refresh tokens
  /// - `https://graph.microsoft.com/User.Read`: Grants access to read user profile from Microsoft Graph API
  ///
  /// Requests access to user email and profile information.
  static const List<String> defaultScopes = [
    'openid',
    'profile',
    'email',
    'offline_access',
    'https://graph.microsoft.com/User.Read',
  ];

  MicrosoftAuthState _state = MicrosoftAuthState.idle;

  bool _disposed = false;

  /// The current state of the authentication flow.
  MicrosoftAuthState get state => _state;

  /// Whether the controller is currently processing a request.
  bool get isLoading => _state == MicrosoftAuthState.loading;

  /// Whether the user is authenticated.
  bool get isAuthenticated => client.auth.isAuthenticated;

  /// The current error message, if any.
  String? get errorMessage => _error?.toString();

  /// The current error, if any.
  Object? get error => _state == MicrosoftAuthState.error ? _error : null;
  Object? _error;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Initiates the Microsoft Sign-In flow.
  ///
  /// Opens the Microsoft authorization page, waits for user authorization, and
  /// exchanges the `authorization code` for an `access token` on the server.
  ///
  /// On success, calls [onAuthenticated]. On failure, transitions to error
  /// state and calls [onError].
  Future<void> signIn() async {
    if (_state == MicrosoftAuthState.loading) return;
    _setState(MicrosoftAuthState.loading);

    try {
      final signInResult = await MicrosoftSignInService.instance.signIn(
        scopes: scopes,
      );

      await _handleServerSideSignIn(signInResult);
    } catch (error) {
      _handleAuthenticationError(error);
    }
  }

  /// Handles the server-side sign-in process.
  Future<void> _handleServerSideSignIn(
    MicrosoftSignInResult signInResult,
  ) async {
    try {
      final endpoint = client.getEndpointOfType<EndpointMicrosoftIdpBase>();
      final authSuccess = await endpoint.login(
        code: signInResult.code,
        codeVerifier: signInResult.codeVerifier,
        redirectUri: signInResult.redirectUri,
        isWebPlatform: kIsWeb,
      );

      await client.auth.updateSignedInUser(authSuccess);

      _setState(MicrosoftAuthState.authenticated);
      onAuthenticated?.call();
    } catch (error) {
      _handleAuthenticationError(error);
    }
  }

  /// Handles authentication errors.
  void _handleAuthenticationError(Object error) {
    _error = error;
    _setState(MicrosoftAuthState.error);
    debugPrint('[MicrosoftAuthController] Authentication error: $error');

    final userFriendlyError = _convertToUserFacingException(error);
    if (userFriendlyError != null) {
      onError?.call(userFriendlyError);
    }
  }

  /// Updates the state and notifies listeners.
  void _setState(MicrosoftAuthState newState) {
    if (_disposed) return;
    if (newState != MicrosoftAuthState.error) _error = null;
    _state = newState;
    notifyListeners();
  }
}

/// The state of the Microsoft authentication flow.
enum MicrosoftAuthState {
  /// The controller is idle, waiting for user interaction.
  idle,

  /// The controller is processing a sign-in request.
  loading,

  /// The user has been successfully authenticated.
  authenticated,

  /// An error occurred during authentication.
  error,
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
  if (error is MicrosoftAccessTokenVerificationException) {
    return UserFacingException(
      'An error occurred while verifying the Microsoft access token. Please '
      'check your Microsoft account and try again. If the problem persists, '
      'please contact support.',
      originalException: error,
    );
  }
  if (error is ServerpodClientException) {
    return UserFacingException.fromServerpodClientException(error);
  }
  return null;
}
