import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import 'firebase_sign_in_service.dart';

/// Controller for managing Firebase-based authentication flows.
///
/// This controller handles the business logic for Firebase authentication,
/// including sign-in and authentication event handling. It can be used with
/// any UI implementation, including `firebase_ui_auth`.
///
/// Example usage with firebase_ui_auth:
/// ```dart
/// final controller = FirebaseAuthController(
///   client: client,
///   onAuthenticated: () {
///     // Navigate to home screen
///   },
/// );
///
/// SignInScreen(
///   providers: [EmailAuthProvider()],
///   actions: [
///     AuthStateChangeAction<SignedIn>((context, state) async {
///       await controller.login(state.user);
///     }),
///   ],
/// );
/// ```
class FirebaseAuthController extends ChangeNotifier {
  /// The Serverpod client instance.
  final ServerpodClientShared client;

  /// Callback when authentication is successful.
  final VoidCallback? onAuthenticated;

  /// Callback when an error occurs during authentication.
  final Function(Object error)? onError;

  /// Creates a Firebase authentication controller.
  FirebaseAuthController({
    required this.client,
    this.onAuthenticated,
    this.onError,
  }) {
    FirebaseSignInService.instance.ensureInitialized(auth: client.auth);
  }

  FirebaseAuthState _state = FirebaseAuthState.idle;

  bool _disposed = false;

  /// The current state of the authentication flow.
  FirebaseAuthState get state => _state;

  /// Whether the controller is currently processing a request.
  bool get isLoading => _state == FirebaseAuthState.loading;

  /// Whether the user is authenticated.
  bool get isAuthenticated => client.auth.isAuthenticated;

  /// The current error message, if any.
  String? get errorMessage => _error?.toString();

  /// The current error, if any.
  Object? get error => _state == FirebaseAuthState.error ? _error : null;
  Object? _error;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  /// Signs in to Serverpod with the provided Firebase user.
  ///
  /// This method is designed to be used with `firebase_ui_auth`'s
  /// `AuthStateChangeAction<SignedIn>` to handle sign-in events.
  ///
  /// If [user] is null, the method returns without doing anything.
  ///
  /// Example:
  /// ```dart
  /// SignInScreen(
  ///   providers: [EmailAuthProvider()],
  ///   actions: [
  ///     AuthStateChangeAction<SignedIn>((context, state) async {
  ///       await controller.login(state.user);
  ///     }),
  ///   ],
  /// );
  /// ```
  Future<void> login(firebase_auth.User? user) async {
    if (user == null) {
      return;
    }

    _setState(FirebaseAuthState.loading);

    try {
      await _handleServerSideSignIn(user);
    } catch (error) {
      _error = error;
      _setState(FirebaseAuthState.error);
      onError?.call(error);
    }
  }

  /// Handles the server-side sign-in process with the Firebase user.
  Future<void> _handleServerSideSignIn(firebase_auth.User user) async {
    try {
      final idToken = await user.getIdToken();

      if (idToken == null) {
        throw FirebaseIdTokenVerificationException();
      }

      final endpoint = client.getEndpointOfType<EndpointFirebaseIdpBase>();
      final authSuccess = await endpoint.login(idToken: idToken);

      await client.auth.updateSignedInUser(authSuccess);

      _setState(FirebaseAuthState.authenticated);
      onAuthenticated?.call();
    } catch (error) {
      _error = error;
      _setState(FirebaseAuthState.error);
      onError?.call(error);
    }
  }

  /// Sets the current state of the authentication flow and notifies listeners.
  void _setState(FirebaseAuthState newState) {
    if (_disposed) return;
    if (newState != FirebaseAuthState.error) _error = null;
    _state = newState;
    notifyListeners();
  }
}

/// Represents the state of the Firebase authentication flow.
enum FirebaseAuthState {
  /// Initial idle state.
  idle,

  /// Loading state while processing any request.
  loading,

  /// A request ended with error. The error can be retrieved from the controller.
  error,

  /// Authentication was successful.
  authenticated,
}

/// Exception thrown when Firebase ID token verification fails.
class FirebaseIdTokenVerificationException implements Exception {
  @override
  String toString() => 'Failed to get Firebase ID token';
}
