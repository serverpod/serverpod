import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../common/exceptions.dart';
import 'google_sign_in_service.dart';

/// Controller for managing Google-based authentication flows.
///
/// This controller handles all the business logic for Google authentication,
/// including initialization, sign-in, and authentication event handling.
/// It can be used with any UI implementation.
///
/// Example usage:
/// ```dart
/// final controller = GoogleAuthController(
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
class GoogleAuthController extends ChangeNotifier {
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

  /// Whether to attempt to authenticate the user automatically using the
  /// `attemptLightweightAuthentication` method after the controller is
  /// initialized.
  ///
  /// The amount of allowable UI is up to the platform to determine, but it
  /// should be minimal. Possible examples include FedCM on the web, and One Tap
  /// on Android. Platforms may even show no UI, and only sign in if a previous
  /// sign-in is being restored. This method is intended to be called as soon
  /// as the application needs to know if the user is signed in, often at
  /// initial launch.
  final bool attemptLightweightSignIn;

  /// Scopes to request from Google.
  ///
  /// The default scopes are `email` and `profile`, which will give access to
  /// retrieving the profile name and picture automatically.
  final List<String> scopes;

  /// Creates a Google authentication controller.
  GoogleAuthController({
    required this.client,
    this.onAuthenticated,
    this.onError,
    this.attemptLightweightSignIn = true,
    this.scopes = defaultScopes,
  }) {
    unawaited(_initialize());
  }

  /// Default scopes to request from Google.
  static const defaultScopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  GoogleAuthState _state = GoogleAuthState.initializing;

  bool _isInitialized = false;
  bool _disposed = false;

  StreamSubscription<GoogleSignInAuthenticationEvent?>? _authSubscription;

  /// The current state of the authentication flow.
  GoogleAuthState get state => _state;

  /// Whether the controller is currently processing a request.
  bool get isLoading => _state == GoogleAuthState.loading;

  /// Whether the user is authenticated.
  bool get isAuthenticated => client.auth.isAuthenticated;

  /// Whether the controller has been initialized.
  bool get isInitialized => _isInitialized;

  /// The current error message, if any.
  String? get errorMessage => _error?.toString();

  /// The current error, if any.
  Object? get error => _state == GoogleAuthState.error ? _error : null;
  Object? _error;

  /// Initializes the Google Sign-In service and sets up auth event listeners.
  Future<void> _initialize() async {
    try {
      final signIn = await GoogleSignInService.instance.ensureInitialized(
        auth: client.auth,
      );

      _authSubscription = signIn.authenticationEvents.listen(
        _handleAuthenticationEvent,
        onError: _handleAuthenticationError,
      );

      if (attemptLightweightSignIn) {
        unawaited(signIn.attemptLightweightAuthentication());
      }

      _isInitialized = true;
      _setState(GoogleAuthState.idle);
    } catch (e) {
      _error = e;
      _setState(GoogleAuthState.error);
      onError?.call(e);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_authSubscription?.cancel());
    super.dispose();
  }

  /// Initiates the Google Sign-In flow.
  ///
  /// On success, the authentication event will be handled automatically and the
  /// user will be signed in. On failure, transitions to error state with the
  /// error message.
  Future<void> signIn() async {
    if (!GoogleSignIn.instance.supportsAuthenticate()) {
      throw StateError('This sign-in method is not supported on this platform');
    }
    _setState(GoogleAuthState.loading);

    // Only need to initialize the sign-in. The scopes authorization and server
    // side authentication is handled by the authentication event listener.
    await GoogleSignIn.instance.authenticate(scopeHint: scopes);
  }

  /// Handles authentication events from the Google Sign-In service.
  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent googleAuthEvent,
  ) async {
    switch (googleAuthEvent) {
      case GoogleSignInAuthenticationEventSignIn(user: final user):
        await _handleServerSideSignIn(user);
      case GoogleSignInAuthenticationEventSignOut():
      // Since Google Sign-In is being used only for authentication, we have
      // nothing to process on sign-out events.
    }
  }

  /// Handles the server-side sign-in process with the Google ID token.
  Future<void> _handleServerSideSignIn(GoogleSignInAccount account) async {
    try {
      String? accessToken;
      if (scopes.isNotEmpty) {
        final authorization = await account.authorizationClient
            .ensureAuthorized(scopes);
        accessToken = authorization.accessToken;
      }

      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw GoogleIdTokenVerificationException();
      }

      final endpoint = client.getEndpointOfType<EndpointGoogleIDPBase>();
      final authSuccess = await endpoint.login(
        idToken: idToken,
        accessToken: accessToken,
      );

      await client.auth.updateSignedInUser(authSuccess);

      _setState(GoogleAuthState.authenticated);
      onAuthenticated?.call();
    } catch (error) {
      _handleAuthenticationError(error);
    }
  }

  /// Handles authentication errors from the Google Sign-In service.
  void _handleAuthenticationError(Object error) {
    if (error is GoogleSignInException &&
        error.code == GoogleSignInExceptionCode.canceled) {
      // The Google Sign-In package already prints these to the debug log.
      return;
    }
    _error = error;
    _setState(GoogleAuthState.error);
    debugPrint('[GoogleAuthController] Authentication error: $error');

    final userFriendlyError = convertToUserFacingException(error);
    if (userFriendlyError != null) {
      onError?.call(userFriendlyError);
    }
  }

  /// Sets the current state of the authentication flow and notifies listeners.
  void _setState(GoogleAuthState newState) {
    if (_disposed) return;
    if (newState != GoogleAuthState.error) _error = null;
    _state = newState;
    notifyListeners();
  }
}

/// Represents the state of the Google authentication flow.
enum GoogleAuthState {
  /// The controller is initializing.
  initializing,

  /// Initial idle state.
  idle,

  /// Loading state while processing any request.
  loading,

  /// A request ended with error. The error can be retrieved from the controller.
  error,

  /// Authentication was successful.
  authenticated,
}

extension on GoogleSignInAuthorizationClient {
  /// Ensure that the user is authorized for the given scopes. Users that have
  /// already authorized the scopes will be handled by [authorizationForScopes]
  /// and users that have not will be handled by [authorizeScopes].
  Future<GoogleSignInClientAuthorization> ensureAuthorized(
    List<String> scopes,
  ) async {
    final authorization = await authorizationForScopes(scopes);
    if (authorization != null) return authorization;
    return await authorizeScopes(scopes);
  }
}

/// Converts server exceptions to user-friendly error messages.
///
/// Returns a user-friendly exception or message for exceptions that should be
/// shown to the user. Returns `null` for internal errors that shouldn't be
/// exposed to users (e.g., StateError, internal server errors, network errors).
Exception? convertToUserFacingException(Object error) {
  if (error is UserFacingException) return error;
  if (error is GoogleIdTokenVerificationException) {
    return UserFacingException(
      'An error occurred while verifying the Google ID token. Please check '
      'your Google account and try again. If the problem persists, please '
      'contact support.',
      originalException: error,
    );
  }
  if (error is GoogleSignInException) {
    return UserFacingException(
      'An error occurred while signing in with Google. Please try again later. '
      'If the problem persists, please contact support.',
      originalException: error,
    );
  }
  if (error is ServerpodClientException) {
    return UserFacingException.fromServerpodClientException(error);
  }
  return null;
}
