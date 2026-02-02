import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../business/facebook_idp.dart';

/// Base endpoint for Facebook Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Facebook access tokens.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
abstract class FacebookIdpBaseEndpoint extends Endpoint {
  /// Accessor for the configured Facebook Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  FacebookIdp get facebookIdp => AuthServices.instance.facebookIdp;

  /// {@template facebook_idp_base_endpoint.login}
  /// Validates a Facebook access token and either logs in the associated user or
  /// creates a new user account if the Facebook account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  ///
  /// The access token is verified using Facebook's Debug Token API to ensure
  /// it's valid and belongs to the correct app.
  /// If the token is invalid or expired, the [FacebookAccessTokenVerificationException] will be thrown.
  /// {@endtemplate}
  Future<AuthSuccess> login(
    final Session session, {
    required final String accessToken,
  }) async {
    return facebookIdp.login(
      session,
      accessToken: accessToken,
    );
  }
}
