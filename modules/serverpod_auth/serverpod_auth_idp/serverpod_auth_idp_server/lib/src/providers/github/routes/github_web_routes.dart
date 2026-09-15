import 'package:serverpod/serverpod.dart';

import '../../../common/web/oauth_web_flow.dart';
import '../../../common/web/web_auth_helpers.dart';
import '../business/github_idp.dart';

/// GitHub authorize endpoint for the HTML BFF.
final githubWebAuthorizeUrl = Uri.https(
  'github.com',
  '/login/oauth/authorize',
);

/// Scopes requested by HTML GitHub sign-in.
const githubWebScopes = ['read:user', 'user:email'];

/// Registers GET `/auth/github` and GET `/auth/github/callback`.
void addGitHubWebRoutes({
  required final WebServer webServer,
  required final WebAuthFlowConfig config,
  required final GitHubIdp githubIdp,
  final OAuthLoginFn? loginOverride,
}) {
  final callbackPath = '${config.pathPrefix}/github/callback';
  webServer.addRoute(
    OAuthStartRoute(
      config: config,
      provider: 'github',
      clientId: githubIdp.config.clientId,
      authorizeUrl: githubWebAuthorizeUrl,
      scopes: githubWebScopes,
      callbackPath: callbackPath,
    ),
    '${config.pathPrefix}/github',
  );
  webServer.addRoute(
    OAuthCallbackRoute(
      config: config,
      provider: 'github',
      callbackPath: callbackPath,
      login:
          loginOverride ??
          (
            final session, {
            required final code,
            required final codeVerifier,
            required final redirectUri,
          }) {
            return githubIdp.login(
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
