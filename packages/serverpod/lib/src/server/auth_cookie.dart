import 'package:relic/relic.dart';
import 'package:serverpod/src/server/session.dart';
import 'package:serverpod/src/util/request_extension.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart'
    show
        webAuthModeHeaderName,
        webAuthModeCookie,
        webAuthModeCookieTransport,
        webBasePathHeaderName;
import 'package:serverpod_shared/serverpod_shared.dart';

/// A declared base path: absolute, no `;` (cookie-attribute delimiter), no
/// whitespace or control characters, bounded length. Anything else is ignored.
final _basePathRegExp = RegExp(r'^/[^;\s\x00-\x1f\x7f]{0,255}$');

/// Web-auth-cookie helpers on [Session]: decides whether a request wants
/// cookie-based web auth and writes/clears the auth cookie accordingly.
extension WebAuthCookieSession on Session {
  /// Whether the auth token should be issued or cleared as an `HttpOnly`
  /// cookie (see [writeWebAuthCookie] / [clearWebAuthCookie]).
  ///
  /// True when [ServerpodConfig.authCookie] is configured and either:
  /// - the request carries [webAuthModeHeaderName] as [webAuthModeCookie] or
  ///   [webAuthModeCookieTransport] (RPC cookie-mode clients), or
  /// - this is a [WebCallSession] (Relic HTML; a second delivery path that
  ///   does not send the marker header).
  ///
  /// The marker is not the single source of truth for cookie delivery.
  /// Authenticating an incoming Relic request from the auth cookie is
  /// decided separately by `_SessionMiddleware`, never from the JWT refresh
  /// cookie. Whether the main auth cookie may authenticate an RPC call is
  /// decided by the server from the strict [webAuthModeCookie] value.
  bool get isWebAuthCookieRequest {
    if (serverpod.config.authCookie == null) return false;
    final authMode = request?.headers[webAuthModeHeaderName]?.firstOrNull;
    if (authMode == webAuthModeCookie ||
        authMode == webAuthModeCookieTransport) {
      return true;
    }
    return this is WebCallSession;
  }

  /// If [isWebAuthCookieRequest], writes [token] as the auth cookie and returns
  /// true. Otherwise returns false and the caller should return the token in
  /// the response body as usual. [maxAgeSeconds] sets the cookie lifetime;
  /// omit it for a session cookie.
  bool writeWebAuthCookie(String token, {int? maxAgeSeconds}) {
    if (!isWebAuthCookieRequest) return false;
    // isWebAuthCookieRequest already proved authCookie is non-null.
    setResponseCookie(
      serverpod.config.authCookie!.buildSetCookieHeader(
        token,
        maxAgeSeconds: maxAgeSeconds,
      ),
    );
    return true;
  }

  /// If [isWebAuthCookieRequest], writes [refreshToken] as the JWT refresh
  /// cookie and returns true. Otherwise returns false and the caller should
  /// return the refresh token in the response body as usual.
  ///
  /// [path] narrows the cookie `Path` (e.g. to the refresh endpoint's route so
  /// the browser only attaches the refresh token there); it defaults to the
  /// configured cookie path. Clearing must use the same path.
  bool writeWebAuthRefreshCookie(
    String refreshToken, {
    int? maxAgeSeconds,
    String? path,
  }) {
    if (!isWebAuthCookieRequest) return false;
    setResponseCookie(
      serverpod.config.authCookie!.buildSetRefreshCookieHeader(
        refreshToken,
        maxAgeSeconds: maxAgeSeconds,
        path: path,
      ),
    );
    return true;
  }

  /// Reads the JWT refresh token from the refresh cookie for cookie-mode
  /// requests, or null when cookie mode is not active or the cookie is absent.
  String? readWebAuthRefreshCookie() {
    if (!isWebAuthCookieRequest) return null;
    return request?.getCookieValue(serverpod.config.authCookie!.refreshName);
  }

  /// The browser-visible base path the cookie-mode client declared via the
  /// [webBasePathHeaderName] header, or null when absent or malformed.
  ///
  /// A prefix-stripping reverse proxy makes the browser-visible path differ
  /// from the path the server sees, and only the client knows the prefix (it
  /// is the path component of its `host`). Used to scope the refresh cookie's
  /// `Path`; a cookie `Path` is not a security boundary and only affects the
  /// sender's own cookie scope, so the client-supplied value is trusted after
  /// a format check. Normalized without a trailing slash (`/` at the root).
  String? get webAuthBasePath {
    if (!isWebAuthCookieRequest) return null;
    final declared = request?.headers[webBasePathHeaderName]?.firstOrNull;
    if (declared == null || !_basePathRegExp.hasMatch(declared)) return null;
    final normalized = declared.replaceFirst(RegExp(r'/+$'), '');
    return normalized.isEmpty ? '/' : normalized;
  }

  /// Clears the auth cookie for cookie-mode requests (a no-op otherwise).
  ///
  /// Gated on [isWebAuthCookieRequest] just like [writeWebAuthCookie], so a
  /// header/native client signing out gets no stray `Set-Cookie`. Cookie
  /// clients send the marker on every call (including sign-out); Relic HTML
  /// qualifies via [WebCallSession], so [clearWebAuthCookie] still runs.
  ///
  /// [refreshCookiePath] must match the path the refresh cookie was set with,
  /// or browsers will not remove it.
  void clearWebAuthCookie({String? refreshCookiePath}) {
    if (!isWebAuthCookieRequest) return;
    setResponseCookie(serverpod.config.authCookie!.buildClearCookieHeader());
    setResponseCookie(
      serverpod.config.authCookie!.buildClearRefreshCookieHeader(
        path: refreshCookiePath,
      ),
    );
  }
}

/// Builds the relic `Set-Cookie` headers for the web authentication cookie
/// described by a [WebAuthCookieConfig].
///
/// The auth cookie is always `HttpOnly` (the token must never be readable by
/// JavaScript); `secure`, `sameSite`, `domain` and `path` come from the config.
extension WebAuthCookieBuilder on WebAuthCookieConfig {
  /// A `Set-Cookie` that stores [token] as the auth cookie. When
  /// [maxAgeSeconds] is given it sets the cookie lifetime; omit it for a
  /// session cookie (cleared when the browser closes).
  SetCookie buildSetCookieHeader(String token, {int? maxAgeSeconds}) =>
      _build(name, token, maxAge: maxAgeSeconds);

  /// A `Set-Cookie` that expires (removes) the auth cookie on the client. The
  /// attributes match those used to set it, which browsers require to remove a
  /// cookie.
  SetCookie buildClearCookieHeader() => _build(name, '', maxAge: 0);

  /// A `Set-Cookie` that stores [refreshToken] as the JWT refresh cookie.
  /// [path] overrides the configured cookie path (see
  /// [WebAuthCookieSession.writeWebAuthRefreshCookie]).
  SetCookie buildSetRefreshCookieHeader(
    String refreshToken, {
    int? maxAgeSeconds,
    String? path,
  }) => _build(refreshName, refreshToken, maxAge: maxAgeSeconds, path: path);

  /// A `Set-Cookie` that expires (removes) the JWT refresh cookie. [path] must
  /// match the path the cookie was set with.
  SetCookie buildClearRefreshCookieHeader({String? path}) =>
      _build(refreshName, '', maxAge: 0, path: path);

  SetCookie _build(String name, String value, {int? maxAge, String? path}) {
    final domain = this.domain;
    // SetCookie validates name, value, domain and path, throwing
    // FormatException on bad input: it rejects a Domain with a port (RFC 6265
    // 5.2.3) and normalizes away a leading dot (`.example.com` -> `example.com`,
    // which browsers already treat as covering subdomains). Those values come
    // from operator config, so report a malformed one as a clear configuration
    // error rather than letting an opaque parse failure surface deep in the
    // sign-in path.
    try {
      return SetCookie(
        name: name,
        value: value,
        httpOnly: true,
        secure: secure,
        sameSite: _toRelicSameSite(sameSite),
        path: path ?? this.path,
        domain: domain == null ? null : Host.parse(domain),
        maxAge: maxAge,
      );
    } on FormatException catch (e) {
      throw ArgumentError(
        'Invalid authCookie configuration (check name, domain and path): '
        '${e.message}',
      );
    }
  }
}

SameSite _toRelicSameSite(CookieSameSite sameSite) => switch (sameSite) {
  CookieSameSite.lax => SameSite.lax,
  CookieSameSite.strict => SameSite.strict,
  CookieSameSite.none => SameSite.none,
};
