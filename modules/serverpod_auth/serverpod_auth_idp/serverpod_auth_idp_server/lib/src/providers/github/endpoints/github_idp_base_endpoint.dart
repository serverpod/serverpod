import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../business/github_idp.dart';

/// Base endpoint for GitHub Account-based authentication.
///
/// This endpoint exposes methods for logging in users using GitHub authorization codes.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
abstract class GitHubIdpBaseEndpoint extends Endpoint {
  /// Accessor for the configured GitHub Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  GitHubIdp get githubIdp => AuthServices.instance.githubIdp;

  /// {@template github_idp_base_endpoint.login}
  /// Validates a GitHub authorization code and either logs in the associated
  /// user or creates a new user account if the GitHub account ID is not yet
  /// known.
  ///
  /// This method exchanges the authorization code for an access token using
  /// PKCE, then authenticates the user.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  /// {@endtemplate}
  Future<AuthSuccess> login(
    final Session session, {
    required final String code,
    required final String codeVerifier,
    required final String redirectUri,
  }) async {
    return githubIdp.login(
      session,
      code: code,
      codeVerifier: codeVerifier,
      redirectUri: redirectUri,
    );
  }
}
