import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Service to manage Firebase Sign-In and ensure it is only initialized once
/// throughout the app lifetime.
class FirebaseSignInService {
  /// Singleton instance of the [FirebaseSignInService].
  static final FirebaseSignInService instance =
      FirebaseSignInService._internal();

  /// Convenience getter for the [firebase_auth.FirebaseAuth.instance].
  static final firebaseAuth = firebase_auth.FirebaseAuth.instance;

  FirebaseSignInService._internal();

  final _initializedClients = <int>{};

  /// Ensures that Firebase Sign-In is initialized.
  ///
  /// This method is idempotent and can be called multiple times for the same
  /// client. Multiple clients can be registered by calling this method multiple
  /// times with different clients.
  ///
  /// The [auth] is used to register a sign-out hook to logout from Firebase
  /// when the user signs out from the app. This prevents the user from being
  /// signed in back automatically, which would undo the signing out.
  ///
  /// Returns the [firebase_auth.FirebaseAuth] instance that can be used to
  /// attach listeners to the events emitted by Firebase Auth.
  firebase_auth.FirebaseAuth ensureInitialized({
    required FlutterAuthSessionManager auth,
  }) {
    if (_initializedClients.contains(identityHashCode(auth))) {
      return firebaseAuth;
    }

    _initializeClient(auth);
    return firebaseAuth;
  }

  void _initializeClient(FlutterAuthSessionManager auth) {
    auth.authInfoListenable.addListener(() {
      if (!auth.isAuthenticated) {
        unawaited(
          firebaseAuth.signOut().onError(
            (e, _) =>
                debugPrint('Failed to sign out from Firebase: ${e.toString()}'),
          ),
        );
      }
    });

    _initializedClients.add(identityHashCode(auth));
  }
}

/// Expose convenient methods on [FlutterAuthSessionManager].
extension FirebaseSignInExtension on FlutterAuthSessionManager {
  /// Initializes Firebase Sign-In for the client.
  ///
  /// This method is idempotent and can be called multiple times and from
  /// multiple clients.
  ///
  /// Upon initialization, a sign-out hook is registered to sign out from
  /// Firebase when the user signs out from the app. This prevents the user
  /// from being signed in back automatically, which would undo the signing out.
  void initializeFirebaseSignIn() {
    FirebaseSignInService.instance.ensureInitialized(
      auth: this,
    );
  }

  /// Signs out the current user from Firebase Auth.
  ///
  /// Note: This only signs out from Firebase. To sign out from Serverpod,
  /// use the session manager's sign out method.
  Future<void> signOutFromFirebase() async {
    await FirebaseSignInService.firebaseAuth.signOut();
  }
}
