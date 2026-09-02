import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Revokes the current device's token and clears the web auth cookie.
///
/// Same order as [StatusEndpoint.signOutDevice]: clear the cookie first, then
/// [TokenManager.revokeToken] for this `authId` only (not all devices).
Future<void> signOutCurrentDevice(final Session session) async {
  session.clearWebAuthCookie(
    refreshCookiePath: jwtRefreshCookiePath(session),
  );
  final authInfoIdStr = session.authenticated?.authId;
  if (authInfoIdStr == null) return;
  final authInfoId = UuidValue.withValidation(authInfoIdStr);
  await AuthServices.instance.tokenManager.revokeToken(
    session,
    tokenId: authInfoId.toString(),
  );
  // Drop the cached caller so a later issueToken in this same request
  // (HTML sign-out-before-login) is not treated as switching users.
  session.updateAuthenticated(null);
}

/// If the Relic session is already authenticated, signs out this device so
/// a subsequent [TokenIssuer.issueToken] does not throw
/// [SignInWhileAuthenticatedException].
///
/// Must run only after CSRF / OAuth HMAC checks succeed.
Future<void> signOutBeforeHtmlLogin(final Session session) async {
  if (session.authenticated == null) return;
  await signOutCurrentDevice(session);
}

/// Whether a same-origin form POST may proceed.
///
/// Origin is required when present. Referer is used only if Origin is absent
/// (anonymous login POST). Cookie-authenticated POSTs are already Origin-gated
/// by Relic when the cookie authenticates.
bool originAllowedForAuthForm(
  final Request request,
  final List<String> allowedOrigins,
) {
  final origin = requestOrigin(request);
  if (origin != null) {
    return allowedOrigins.contains(origin);
  }
  final referer = request.headers[Headers.refererHeader]?.firstOrNull;
  if (referer == null || referer.isEmpty) return false;
  final Uri refererUri;
  try {
    refererUri = Uri.parse(referer);
  } on FormatException {
    return false;
  }
  if (!refererUri.hasScheme || refererUri.host.isEmpty) return false;
  final refererOrigin = normalizeOriginValue(refererUri.origin);
  return refererOrigin != null && allowedOrigins.contains(refererOrigin);
}

/// Parses `application/x-www-form-urlencoded` body into a map.
Future<Map<String, String>> readFormFields(final Request request) async {
  final body = await request.readAsString();
  if (body.isEmpty) return const {};
  return Uri.splitQueryString(body);
}

/// Standard headers for `/auth/*` HTML and OAuth start responses.
Headers authPageHeaders() {
  return Headers.build((final mh) {
    mh.cacheControl = CacheControlHeader(noStore: true);
    mh['x-frame-options'] = ['DENY'];
  });
}

/// HTML 200 with [authPageHeaders].
Response authHtmlOk(final String html) {
  return Response.ok(
    body: Body.fromString(html, mimeType: MimeType.html),
    headers: authPageHeaders(),
  );
}

/// 303 See Other with [authPageHeaders].
Response authSeeOther(final String location) {
  return Response.seeOther(Uri.parse(location), headers: authPageHeaders());
}

/// 403 Forbidden with [authPageHeaders].
Response authForbidden() {
  return Response.forbidden(headers: authPageHeaders());
}

/// Relic [SameSite] for [CookieSameSite].
SameSite relicSameSite(final CookieSameSite sameSite) => switch (sameSite) {
  CookieSameSite.lax => SameSite.lax,
  CookieSameSite.strict => SameSite.strict,
  CookieSameSite.none => SameSite.none,
};

/// Shared configuration for HTML `/auth/*` routes.
final class WebAuthFlowConfig {
  /// Path prefix, without a trailing slash (e.g. `/auth`).
  final String pathPrefix;

  /// Safe same-origin path to send the browser after a successful login.
  final String loginSuccessPath;

  /// HMAC pepper from `passwords.yaml` (`webAuthOAuthStatePepper`).
  final String hmacPepper;

  /// Cookie settings copied onto CSRF / OAuth cookies.
  final WebAuthCookieConfig authCookie;

  /// Public web server used to build OAuth `redirect_uri` values.
  final ServerConfig webServer;

  /// Origin allow-list; required whenever [authCookie] is configured.
  final List<String> allowedOrigins;

  /// Creates a [WebAuthFlowConfig].
  WebAuthFlowConfig({
    required this.pathPrefix,
    required this.loginSuccessPath,
    required this.hmacPepper,
    required this.authCookie,
    required this.webServer,
    required this.allowedOrigins,
  });

  /// GET/POST login hub path.
  String get loginPath => '$pathPrefix/login';

  /// POST logout path.
  String get logoutPath => '$pathPrefix/logout';
}
