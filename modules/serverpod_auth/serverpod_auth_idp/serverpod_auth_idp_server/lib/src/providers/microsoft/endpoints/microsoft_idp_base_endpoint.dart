import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../business/microsoft_idp.dart';

/// Base endpoint for Microsoft Account-based authentication.
///
/// This endpoint exposes methods for logging in users using Microsoft authorization codes.
/// If you would like modify the authentication flow, consider extending this
/// class and overriding the relevant methods.
abstract class MicrosoftIdpBaseEndpoint extends IdpBaseEndpoint {
  /// Accessor for the configured Microsoft Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  MicrosoftIdp get microsoftIdp => AuthServices.instance.microsoftIdp;

  /// {@template microsoft_idp_base_endpoint.login}
  /// Validates a Microsoft authorization code and either logs in the associated
  /// user or creates a new user account if the Microsoft account ID is not yet
  /// known.
  ///
  /// This method exchanges the `authorization code` for an `access token` using
  /// `PKCE`, then authenticates the user.
  ///
  /// The [isWebPlatform] flag indicates whether the client is a web application.
  /// Microsoft requires the client secret only for confidential clients (web
  /// apps). Public clients (mobile, desktop) using PKCE must not include it.
  /// Pass `true` for web clients and `false` for native platforms.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  /// {@endtemplate}
  Future<AuthSuccess> login(
    final Session session, {
    required final String code,
    required final String codeVerifier,
    required final String redirectUri,
    required final bool isWebPlatform,
  }) async {
    return microsoftIdp.login(
      session,
      code: code,
      codeVerifier: codeVerifier,
      redirectUri: redirectUri,
      isWebPlatform: isWebPlatform,
    );
  }

  @override
  Future<bool> hasAccount(final Session session) async =>
      await microsoftIdp.hasAccount(session);
}
