import 'package:serverpod/serverpod.dart';

import '../../../common/auth_services.dart';
import '../google.dart';

/// Base endpoint for Google Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Google ID tokens.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
abstract class GoogleIDPBaseEndpoint extends Endpoint {
  /// Accessor for the configured Google IDP instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  GoogleIDP get googleIDP => AuthServices.instance.googleIDP;

  /// {@template google_idp_base_endpoint.login}
  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  /// {@endtemplate}
  Future<AuthSuccess> login(
    final Session session, {
    required final String idToken,
  }) async {
    return googleIDP.login(session, idToken: idToken);
  }
}
