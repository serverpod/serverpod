import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'apple_sign_in_service.dart';

/// Controller for managing Apple-based authentication flows.
///
/// This controller handles all the business logic for Apple authentication,
/// including initialization, sign-in, and authentication event handling.
/// It can be used with any UI implementation.
///
/// Example usage:
/// ```dart
/// final controller = AppleAuthController(
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
class AppleAuthController extends ChangeNotifier {
  /// The Serverpod client instance.
  final ServerpodClientShared client;

  /// Callback when authentication is successful.
  final VoidCallback? onAuthenticated;

  /// Callback when an error occurs during authentication.
  final Function(Object error)? onError;

  /// Scopes to request from Apple.
  ///
  /// The default scopes are `email` and `fullName`, which will give access to
  /// retrieving the user's email and full name.
  final List<AppleIDAuthorizationScopes> scopes;

  /// Creates an Apple authentication controller.
  AppleAuthController({
    required this.client,
    this.onAuthenticated,
    this.onError,
    this.scopes = defaultScopes,
  });

  /// Default scopes to request from Apple.
  static const defaultScopes = [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ];

  AppleAuthState _state = AppleAuthState.idle;

  bool _disposed = false;

  /// The current state of the authentication flow.
  AppleAuthState get state => _state;

  /// Whether the controller is currently processing a request.
  bool get isLoading => _state == AppleAuthState.loading;

  /// Whether the user is authenticated.
  bool get isAuthenticated => client.auth.isAuthenticated;

  /// The current error message, if any.
  String? get errorMessage => _error?.toString();

  /// The current error, if any.
  Object? get error => _state == AppleAuthState.error ? _error : null;
  Object? _error;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Initiates the Apple Sign-In flow.
  ///
  /// On success, the user will be signed in. On failure, transitions to error
  /// state with the error message.
  Future<void> signIn() async {
    if (!await SignInWithApple.isAvailable()) {
      throw StateError('Sign in with Apple is not available on this platform');
    }
    _setState(AppleAuthState.loading);

    try {
      final webAuthOptions = await AppleSignInService.instance
          .webAuthenticationOptions();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: scopes,
        webAuthenticationOptions: webAuthOptions,
      );

      await _handleServerSideSignIn(credential);
    } catch (error) {
      _error = error;
      _setState(AppleAuthState.error);
      onError?.call(error);
    }
  }

  /// Handles the server-side sign-in process with the Apple credentials.
  Future<void> _handleServerSideSignIn(
    AuthorizationCredentialAppleID credential,
  ) async {
    try {
      final identityToken = credential.identityToken;
      final authorizationCode = credential.authorizationCode;

      if (identityToken == null) {
        throw AppleIdTokenVerificationException();
      }

      final endpoint = client.getEndpointOfType<EndpointAppleIDPBase>();
      final authSuccess = await endpoint.login(
        identityToken: identityToken,
        authorizationCode: authorizationCode,
        isNativeApplePlatformSignIn:
            !kIsWeb && (Platform.isIOS || Platform.isMacOS),
        firstName: credential.givenName,
        lastName: credential.familyName,
      );

      await client.auth.updateSignedInUser(authSuccess);

      _setState(AppleAuthState.authenticated);
      onAuthenticated?.call();
    } catch (error) {
      _error = error;
      _setState(AppleAuthState.error);
      onError?.call(error);
    }
  }

  /// Sets the current state of the authentication flow and notifies listeners.
  void _setState(AppleAuthState newState) {
    if (_disposed) return;
    if (newState != AppleAuthState.error) _error = null;
    _state = newState;
    notifyListeners();
  }
}

/// Represents the state of the Apple authentication flow.
enum AppleAuthState {
  /// Initial idle state.
  idle,

  /// Loading state while processing any request.
  loading,

  /// A request ended with error. The error can be retrieved from the controller.
  error,

  /// Authentication was successful.
  authenticated,
}

/// Exception thrown when Apple ID token verification fails.
class AppleIdTokenVerificationException implements Exception {
  @override
  String toString() => 'Failed to verify Apple ID token';
}
