import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/src/integrations/google_identity_provider_factory.dart';

import '../google.dart';

/// Base endpoint for Google Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Google ID tokens.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
abstract class GoogleIdpBaseEndpoint extends Endpoint {
  /// Accessor for the configured Google Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  GoogleIdp get googleIdp => AuthServices.instance.googleIdp;

  /// {@template google_idp_base_endpoint.login}
  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  /// {@endtemplate}
  Future<AuthSuccess> login(
    final Session session, {
    required final String idToken,
    required final String? accessToken,
  }) async {
    return googleIdp.login(
      session,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
