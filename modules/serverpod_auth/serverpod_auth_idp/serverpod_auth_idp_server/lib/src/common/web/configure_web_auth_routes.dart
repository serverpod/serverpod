import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../providers/apple/business/apple_idp.dart';
import '../../providers/apple/routes/apple_web_routes.dart';
import '../../providers/email/business/email_idp.dart';
import '../../providers/email/routes/email_web_routes.dart';
import '../../providers/github/business/github_idp.dart';
import '../../providers/github/routes/github_web_routes.dart';
import '../../providers/google/business/google_idp.dart';
import '../../providers/google/routes/google_web_routes.dart';
import '../../providers/microsoft/business/microsoft_idp.dart';
import '../../providers/microsoft/routes/microsoft_web_routes.dart';
import 'csrf.dart';
import 'hmac_payload.dart';
import 'oauth_web_flow.dart';
import 'web_auth_helpers.dart';

/// HTML `/auth/*` login, logout, and OAuth BFF routes.
extension ConfigureWebAuthRoutes on Serverpod {
  /// Registers Relic routes for browser document login.
  ///
  /// Call after [AuthServicesInit.initializeAuthServices] and before
  /// [Serverpod.start]. SAS must be the primary token manager; [authCookie]
  /// must be configured; `sameSite: strict` is rejected because the OAuth
  /// return GET would drop the state cookie.
  ///
  /// Only providers present on [AuthServices] are mounted. Email missing
  /// means no email form and POST `/auth/login` is 404. Google/GitHub/
  /// Microsoft/Apple missing means no button and those paths 404.
  ///
  /// The HMAC key is `webAuthOAuthStatePepper` in `passwords.yaml` and must
  /// not reuse `sessionKeyHashPepper`.
  ///
  /// Do not mount HTML Google at `/auth/callback`;
  /// [FlutterWebAuth2CallbackRoute] lives there. HTML Apple is
  /// `POST /auth/apple/web/callback`, distinct from
  /// [AppleIdpConfigureRoutes.configureAppleIdpRoutes].
  void configureWebAuthRoutes({
    final String pathPrefix = '/auth',
    final String loginSuccessPath = '/',
    @visibleForTesting final OAuthLoginFn? googleLoginOverride,
    @visibleForTesting final OAuthLoginFn? githubLoginOverride,
    @visibleForTesting final MicrosoftWebLoginFn? microsoftLoginOverride,
    @visibleForTesting final AppleWebLoginFn? appleLoginOverride,
  }) {
    final AuthServices authServices;
    try {
      authServices = AuthServices.instance;
    } on StateError {
      throw StateError(
        'AuthServices is not initialized. Call initializeAuthServices '
        'before configureWebAuthRoutes.',
      );
    }

    final authCookie = config.authCookie;
    if (authCookie == null) {
      throw StateError(
        'configureWebAuthRoutes requires ServerpodConfig.authCookie.',
      );
    }

    final primary = authServices.tokenManager.primaryTokenManager;
    if (primary is! ServerSideSessionsTokenManager) {
      throw StateError(
        'configureWebAuthRoutes requires ServerSideSessionsTokenManager '
        'as the primary token manager (SAS first in tokenManagerBuilders).',
      );
    }

    final safeLoginSuccess = trySafeReturnTo(loginSuccessPath);
    if (safeLoginSuccess == null) {
      throw ArgumentError.value(
        loginSuccessPath,
        'loginSuccessPath',
        'Must be a safe same-origin relative path.',
      );
    }

    if (authCookie.sameSite == CookieSameSite.strict) {
      throw ArgumentError.value(
        authCookie.sameSite,
        'authCookie.sameSite',
        'strict drops the OAuth state cookie on the provider return GET. '
            'Use lax (default) or none.',
      );
    }

    final hmacPepper = getPassword(webAuthOAuthStatePepperPasswordKey);
    if (hmacPepper == null || hmacPepper.isEmpty) {
      throw PasswordNotFoundException(webAuthOAuthStatePepperPasswordKey);
    }

    if (csrfCookieName(authCookie) == authCookie.refreshName) {
      throw ArgumentError(
        'CSRF cookie name "${csrfCookieName(authCookie)}" must not equal '
        'authCookie.refreshName.',
      );
    }

    final prefix = _normalizePathPrefix(pathPrefix);
    final webServer = config.webServer;
    if (webServer == null) {
      throw StateError(
        'configureWebAuthRoutes requires ServerpodConfig.webServer.',
      );
    }

    final allowedOrigins = config.allowedOrigins;
    if (allowedOrigins == null || allowedOrigins.isEmpty) {
      throw StateError(
        'configureWebAuthRoutes requires a non-empty allowedOrigins list.',
      );
    }

    final emailIdp = authServices.providers.whereType<EmailIdp>().firstOrNull;
    final googleIdp = authServices.providers.whereType<GoogleIdp>().firstOrNull;
    final githubIdp = authServices.providers.whereType<GitHubIdp>().firstOrNull;
    final microsoftIdp = authServices.providers
        .whereType<MicrosoftIdp>()
        .firstOrNull;
    final appleIdp = authServices.providers.whereType<AppleIdp>().firstOrNull;

    if (googleIdp != null) {
      final expected = publicWebOrigin(
        webServer,
        '$prefix/google/callback',
      ).toString();
      final redirectUris = googleIdp.config.clientSecret.redirectUris;
      if (redirectUris.isNotEmpty && !redirectUris.contains(expected)) {
        throw ArgumentError(
          'GoogleClientSecret.redirectUris must include the HTML callback '
          'URI $expected (built from webServer public scheme/host/port).',
        );
      }
    }

    final flow = WebAuthFlowConfig(
      pathPrefix: prefix,
      loginSuccessPath: safeLoginSuccess,
      hmacPepper: hmacPepper,
      authCookie: authCookie,
      webServer: webServer,
      allowedOrigins: allowedOrigins,
    );

    this.webServer.addRoute(
      LoginRoute(
        config: flow,
        emailIdp: emailIdp,
        showGoogle: googleIdp != null,
        showGitHub: githubIdp != null,
        showMicrosoft: microsoftIdp != null,
        showApple: appleIdp != null,
      ),
      flow.loginPath,
    );
    this.webServer.addRoute(LogoutRoute(config: flow), flow.logoutPath);

    if (googleIdp != null) {
      addGoogleWebRoutes(
        webServer: this.webServer,
        config: flow,
        googleIdp: googleIdp,
        loginOverride: googleLoginOverride,
      );
    }
    if (githubIdp != null) {
      addGitHubWebRoutes(
        webServer: this.webServer,
        config: flow,
        githubIdp: githubIdp,
        loginOverride: githubLoginOverride,
      );
    }
    if (microsoftIdp != null) {
      addMicrosoftWebRoutes(
        webServer: this.webServer,
        config: flow,
        microsoftIdp: microsoftIdp,
        loginOverride: microsoftLoginOverride,
      );
    }
    if (appleIdp != null) {
      addAppleWebRoutes(
        webServer: this.webServer,
        config: flow,
        appleIdp: appleIdp,
        loginOverride: appleLoginOverride,
      );
    }
  }
}

String _normalizePathPrefix(final String pathPrefix) {
  var prefix = pathPrefix.trim();
  if (prefix.isEmpty) {
    throw ArgumentError.value(
      pathPrefix,
      'pathPrefix',
      'Must be a non-empty path starting with /.',
    );
  }
  if (!prefix.startsWith('/')) {
    throw ArgumentError.value(
      pathPrefix,
      'pathPrefix',
      'Must start with /.',
    );
  }
  while (prefix.length > 1 && prefix.endsWith('/')) {
    prefix = prefix.substring(0, prefix.length - 1);
  }
  return prefix;
}
