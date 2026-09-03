import 'package:serverpod/serverpod.dart';

import '../../../common/web/oauth_web_flow.dart';
import '../../../common/web/web_auth_helpers.dart';
import '../business/microsoft_idp.dart';

/// Completes a Microsoft HTML login. [isWebPlatform] is always `true` so the
/// token exchange includes the client secret.
typedef MicrosoftWebLoginFn =
    Future<void> Function(
      Session session, {
      required String code,
      required String codeVerifier,
      required String redirectUri,
      required bool isWebPlatform,
    });

/// Scopes requested by HTML Microsoft sign-in (same as Flutter).
const microsoftWebScopes = [
  'openid',
  'profile',
  'email',
  'offline_access',
  'https://graph.microsoft.com/User.Read',
];

/// Registers GET `/auth/microsoft` and GET `/auth/microsoft/callback`.
void addMicrosoftWebRoutes({
  required final WebServer webServer,
  required final WebAuthFlowConfig config,
  required final MicrosoftIdp microsoftIdp,
  final MicrosoftWebLoginFn? loginOverride,
}) {
  final callbackPath = '${config.pathPrefix}/microsoft/callback';
  final authorizeUrl = Uri.https(
    microsoftIdp.config.authorityHost,
    '/${microsoftIdp.config.tenant}/oauth2/v2.0/authorize',
  );
  webServer.addRoute(
    OAuthStartRoute(
      config: config,
      provider: 'microsoft',
      clientId: microsoftIdp.config.clientId,
      authorizeUrl: authorizeUrl,
      scopes: microsoftWebScopes,
      callbackPath: callbackPath,
    ),
    '${config.pathPrefix}/microsoft',
  );
  webServer.addRoute(
    OAuthCallbackRoute(
      config: config,
      provider: 'microsoft',
      callbackPath: callbackPath,
      login:
          (
            final session, {
            required final code,
            required final codeVerifier,
            required final redirectUri,
          }) {
            if (loginOverride != null) {
              return loginOverride(
                session,
                code: code,
                codeVerifier: codeVerifier,
                redirectUri: redirectUri,
                isWebPlatform: true,
              );
            }
            return microsoftIdp.login(
              session,
              code: code,
              codeVerifier: codeVerifier,
              redirectUri: redirectUri,
              isWebPlatform: true,
            );
          },
    ),
    callbackPath,
  );
}
