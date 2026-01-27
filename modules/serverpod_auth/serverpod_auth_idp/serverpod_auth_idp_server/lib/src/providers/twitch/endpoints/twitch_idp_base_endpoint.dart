import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../business/twitch_idp.dart';

/// Base endpoint for Twitch Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Twitch authorization codes.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
abstract class TwitchIdpBaseEndpoint extends Endpoint {
  /// Accessor for the configured Twitch Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  TwitchIdp get twitchIdp => AuthServices.instance.twitchIdp;

  /// {@template twitch_idp_base_endpoint.login}
  /// Validates a Twitch authorization code and either logs in the associated
  /// user or creates a new user account if the Twitch account ID is not yet
  /// known.
  ///
  /// This method exchanges the `authorization code` for an `access token` using
  /// `PKCE`, then authenticates the user.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  /// {@endtemplate}
  Future<AuthSuccess> login(
    final Session session, {
    required final String code,
    required final String redirectUri,
  }) async {
    return twitchIdp.login(
      session,
      code: code,
      redirectUri: redirectUri,
    );
  }
}
