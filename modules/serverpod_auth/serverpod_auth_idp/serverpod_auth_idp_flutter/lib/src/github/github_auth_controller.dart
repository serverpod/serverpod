import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/exceptions.dart';
import 'github_sign_in_service.dart';

/// Controller for managing GitHub-based authentication flows.
///
/// This controller handles all the business logic for GitHub authentication,
/// including sign-in and authentication event handling. It can be used with
/// any UI implementation.
///
/// Example usage:
/// ```dart
/// final controller = GitHubAuthController(
///   client: client,
///   onAuthenticated: () {
///     // Navigate to home screen
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
class GitHubAuthController extends ChangeNotifier {
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

  /// Scopes to request from GitHub.
  ///
  /// The default scopes are `user`, `read:user` and `user:email`, which will give access to
  /// retrieving the user's profile data and user's emails automatically.
  ///
  /// Reference: https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps
  final List<String> scopes;

  /// Creates a GitHub authentication controller.
  GitHubAuthController({
    required this.client,
    this.onAuthenticated,
    this.onError,
    this.scopes = defaultScopes,
  });

  /// Default scopes to request from GitHub.
  ///
  /// - `user`: Grants read/write access to profile info only.
  /// - `read:user`: Grants access to read a user's profile data.
  /// - `user:email`: Grants read access to a user's email addresses.
  ///
  /// Requests access to user email and read-only profile information.
  static const List<String> defaultScopes = ['user', 'user:email', 'read:user'];

  GitHubAuthState _state = GitHubAuthState.idle;

  bool _disposed = false;

  /// The current state of the authentication flow.
  GitHubAuthState get state => _state;

  /// Whether the controller is currently processing a request.
  bool get isLoading => _state == GitHubAuthState.loading;

  /// Whether the user is authenticated.
  bool get isAuthenticated => client.auth.isAuthenticated;

  /// The current error message, if any.
  String? get errorMessage => _error?.toString();

  /// The current error, if any.
  Object? get error => _state == GitHubAuthState.error ? _error : null;
  Object? _error;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Initiates the GitHub Sign-In flow.
  ///
  /// Opens the GitHub authorization page, waits for user authorization, and
  /// exchanges the authorization code for an access token on the server.
  ///
  /// On success, calls [onAuthenticated]. On failure, transitions to error
  /// state and calls [onError].
  Future<void> signIn() async {
    _setState(GitHubAuthState.loading);

    try {
      // Get the authorization code from GitHub OAuth flow
      final code = await GitHubSignInService.instance.signIn(
        scopes: scopes,
      );

      // Exchange the code for an access token on the server
      await _handleServerSideSignIn(code);
    } catch (error) {
      _handleAuthenticationError(error);
    }
  }

  /// Handles the server-side sign-in process.
  Future<void> _handleServerSideSignIn(String code) async {
    try {
      // Get the code verifier for PKCE
      final codeVerifier = GitHubSignInService.instance.codeVerifier;
      if (codeVerifier == null) {
        throw StateError('Code verifier not found in sign-in session');
      }

      // Get the redirect URI from service (needed for token exchange)
      final redirectUri = GitHubSignInService.instance.redirectUri;
      if (redirectUri == null) {
        throw StateError('Redirect URI not configured');
      }

      final endpoint = client.getEndpointOfType<EndpointGitHubIdpBase>();
      final authSuccess = await endpoint.login(
        code: code,
        codeVerifier: codeVerifier,
        redirectUri: redirectUri,
      );

      await client.auth.updateSignedInUser(authSuccess);

      _setState(GitHubAuthState.authenticated);
      onAuthenticated?.call();
    } catch (error) {
      _handleAuthenticationError(error);
    }
  }

  /// Handles authentication errors.
  void _handleAuthenticationError(Object error) {
    _error = error;
    _setState(GitHubAuthState.error);
    debugPrint('[GitHubAuthController] Authentication error: $error');

    final userFriendlyError = _convertToUserFacingException(error);
    if (userFriendlyError != null) {
      onError?.call(userFriendlyError);
    }
  }

  /// Sets the current state of the authentication flow and notifies listeners.
  void _setState(GitHubAuthState newState) {
    if (_disposed) return;
    if (newState != GitHubAuthState.error) _error = null;
    _state = newState;
    notifyListeners();
  }
}

/// Represents the state of the GitHub authentication flow.
enum GitHubAuthState {
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
  if (error is GitHubAccessTokenVerificationException) {
    return UserFacingException(
      'An error occurred while verifying the GitHub access token. Please '
      'check your GitHub account and try again. If the problem persists, '
      'please contact support.',
      originalException: error,
    );
  }
  if (error is ServerpodClientException) {
    return UserFacingException.fromServerpodClientException(error);
  }
  return null;
}
