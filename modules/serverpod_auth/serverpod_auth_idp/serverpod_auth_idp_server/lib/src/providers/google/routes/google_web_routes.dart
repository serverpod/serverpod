import 'package:serverpod/serverpod.dart';

import '../../../common/web/oauth_web_flow.dart';
import '../../../common/web/web_auth_helpers.dart';
import '../business/google_idp.dart';

/// Google authorize endpoint for the HTML BFF.
final googleWebAuthorizeUrl = Uri.https(
  'accounts.google.com',
  '/o/oauth2/v2/auth',
);

/// Scopes requested by HTML Google sign-in (`openid` is required for `id_token`).
const googleWebScopes = ['openid', 'email', 'profile'];

/// Registers GET `/auth/google` and GET `/auth/google/callback`.
void addGoogleWebRoutes({
  required final WebServer webServer,
  required final WebAuthFlowConfig config,
  required final GoogleIdp googleIdp,
  final OAuthLoginFn? loginOverride,
}) {
  final callbackPath = '${config.pathPrefix}/google/callback';
  webServer.addRoute(
    OAuthStartRoute(
      config: config,
      provider: 'google',
      clientId: googleIdp.config.clientSecret.clientId,
      authorizeUrl: googleWebAuthorizeUrl,
      scopes: googleWebScopes,
      callbackPath: callbackPath,
    ),
    '${config.pathPrefix}/google',
  );
  webServer.addRoute(
    OAuthCallbackRoute(
      config: config,
      provider: 'google',
      callbackPath: callbackPath,
      login:
          loginOverride ??
          (
            final session, {
            required final code,
            required final codeVerifier,
            required final redirectUri,
          }) {
            return googleIdp.loginWithCode(
              session,
              code: code,
              codeVerifier: codeVerifier,
              redirectUri: redirectUri,
            );
          },
    ),
    callbackPath,
  );
}
