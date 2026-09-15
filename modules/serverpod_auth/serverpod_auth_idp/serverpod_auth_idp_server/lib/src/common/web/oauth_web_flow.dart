import 'package:serverpod/serverpod.dart';

import 'hmac_payload.dart';
import 'web_auth_helpers.dart';

/// Completes an OAuth authorization-code + PKCE login on a Relic session.
typedef OAuthLoginFn =
    Future<void> Function(
      Session session, {
      required String code,
      required String codeVerifier,
      required String redirectUri,
    });

/// Cookie name for the HMAC'd OAuth BFF state, derived from [authCookie].
String oauthStateCookieName(final WebAuthCookieConfig authCookie) =>
    '${authCookie.name}_oauth';

SetCookie _oauthCookie(
  final WebAuthCookieConfig authCookie,
  final String value, {
  required final int maxAge,
}) {
  final domain = authCookie.domain;
  return SetCookie(
    name: oauthStateCookieName(authCookie),
    value: value,
    httpOnly: true,
    secure: authCookie.secure,
    sameSite: relicSameSite(authCookie.sameSite),
    path: authCookie.path,
    domain: domain == null ? null : Host.parse(domain),
    maxAge: maxAge,
  );
}

void _clearOAuthCookie(
  final Session session,
  final WebAuthCookieConfig authCookie,
) {
  session.setResponseCookie(_oauthCookie(authCookie, '', maxAge: 0));
}

/// GET start of a confidential-client OAuth + PKCE flow.
///
/// Stores HMAC'd `{state, code_verifier, return_to, provider, iat}` in an
/// HttpOnly cookie. The browser never sees [code_verifier].
final class OAuthStartRoute extends Route {
  /// Shared HTML auth config.
  final WebAuthFlowConfig config;

  /// Provider id stored in the HMAC payload (`google`, `github`, `microsoft`).
  final String provider;

  /// OAuth client id.
  final String clientId;

  /// Provider authorize endpoint, without query.
  final Uri authorizeUrl;

  /// Space-joinable scopes sent as `scope`.
  final List<String> scopes;

  /// Path passed to [publicWebOrigin] for `redirect_uri`.
  final String callbackPath;

  /// Extra authorize query parameters (e.g. Microsoft `prompt`).
  final Map<String, String> extraQuery;

  /// Creates an [OAuthStartRoute].
  OAuthStartRoute({
    required this.config,
    required this.provider,
    required this.clientId,
    required this.authorizeUrl,
    required this.scopes,
    required this.callbackPath,
    this.extraQuery = const {},
  }) : super(methods: {Method.get});

  @override
  Future<Result> handleCall(
    final Session session,
    final Request request,
  ) async {
    final returnTo = safeReturnTo(
      request.url.queryParameters['return_to'],
      fallback: config.loginSuccessPath,
    );
    final state = generateSecureRandomString(16);
    final codeVerifier = generateSecureRandomString(32);
    final token = encodeHmacPayload(
      {
        'state': state,
        'code_verifier': codeVerifier,
        'return_to': returnTo,
        'provider': provider,
      },
      config.hmacPepper,
    );
    session.setResponseCookie(
      _oauthCookie(
        config.authCookie,
        token,
        maxAge: oauthStateMaxAge.inSeconds,
      ),
    );

    final redirectUri = publicWebOrigin(config.webServer, callbackPath);
    final query = <String, String>{
      'client_id': clientId,
      'redirect_uri': redirectUri.toString(),
      'response_type': 'code',
      'state': state,
      'code_challenge': pkceS256Challenge(codeVerifier),
      'code_challenge_method': 'S256',
      'scope': scopes.join(' '),
      ...extraQuery,
    };

    return Response.found(
      authorizeUrl.replace(queryParameters: query),
      headers: authPageHeaders(),
    );
  }
}

/// GET callback that verifies HMAC + PKCE state, then runs [login].
final class OAuthCallbackRoute extends Route {
  /// Shared HTML auth config.
  final WebAuthFlowConfig config;

  /// Provider id that must match the HMAC payload.
  final String provider;

  /// Path passed to [publicWebOrigin]; must match the start `redirect_uri`.
  final String callbackPath;

  /// IDP login (or a test double).
  final OAuthLoginFn login;

  /// Creates an [OAuthCallbackRoute].
  OAuthCallbackRoute({
    required this.config,
    required this.provider,
    required this.callbackPath,
    required this.login,
  }) : super(methods: {Method.get});

  @override
  Future<Result> handleCall(
    final Session session,
    final Request request,
  ) async {
    final cookieValue = request.getCookieValue(
      oauthStateCookieName(config.authCookie),
    );
    _clearOAuthCookie(session, config.authCookie);

    final code = request.url.queryParameters['code'];
    final error = request.url.queryParameters['error'];
    if ((code == null || code.isEmpty) && error != null && error.isNotEmpty) {
      return authSeeOther(config.loginPath);
    }

    final payload = cookieValue == null
        ? null
        : decodeHmacPayload(cookieValue, config.hmacPepper);
    if (payload == null) {
      return authForbidden();
    }

    final storedState = payload['state'] as String?;
    final queryState = request.url.queryParameters['state'];
    if (storedState == null ||
        queryState == null ||
        !timingSafeEquals(storedState, queryState)) {
      return authForbidden();
    }

    if (payload['provider'] != provider) {
      return authForbidden();
    }

    final returnToRaw = payload['return_to'] as String?;
    final returnTo = trySafeReturnTo(returnToRaw);
    if (returnTo == null) {
      return authForbidden();
    }

    final codeVerifier = payload['code_verifier'] as String?;
    if (code == null || code.isEmpty || codeVerifier == null) {
      return authForbidden();
    }

    await signOutBeforeHtmlLogin(session);

    final redirectUri = publicWebOrigin(
      config.webServer,
      callbackPath,
    ).toString();

    try {
      await login(
        session,
        code: code,
        codeVerifier: codeVerifier,
        redirectUri: redirectUri,
      );
    } on Exception {
      return authSeeOther(config.loginPath);
    }

    return authSeeOther(returnTo);
  }
}
