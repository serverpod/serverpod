import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../business/firebase_idp.dart';

/// Base endpoint for Firebase Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Firebase ID tokens.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
abstract class FirebaseIdpBaseEndpoint extends IdpBaseEndpoint {
  /// Accessor for the configured Firebase Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  FirebaseIdp get firebaseIdp => AuthServices.instance.firebaseIdp;

  /// {@template firebase_idp_base_endpoint.login}
  /// Validates a Firebase ID token and either logs in the associated user or
  /// creates a new user account if the Firebase account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  /// {@endtemplate}
  Future<AuthSuccess> login(
    final Session session, {
    required final String idToken,
  }) async {
    return firebaseIdp.login(
      session,
      idToken: idToken,
    );
  }

  @override
  Future<bool> hasAccount(final Session session) async =>
      await firebaseIdp.hasAccount(session);
}
