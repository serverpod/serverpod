import 'package:relic/relic.dart';
import 'package:serverpod/src/server/session.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart'
    show webAuthModeHeaderName, webAuthModeCookie;
import 'package:serverpod_shared/serverpod_shared.dart';

/// Web-auth-cookie helpers on [Session]: decides whether a request wants
/// cookie-based web auth and writes/clears the auth cookie accordingly.
extension WebAuthCookieSession on Session {
  /// Whether the request asked for cookie-based web auth (via the
  /// [webAuthModeHeaderName] header) and the server has a
  /// [ServerpodConfig.authCookie] configured.
  ///
  /// When true the auth token should be issued as an `HttpOnly` cookie (see
  /// [writeWebAuthCookie]) and omitted from the response body, so it never
  /// reaches client-side JavaScript.
  bool get isWebAuthCookieRequest {
    if (serverpod.config.authCookie == null) return false;
    return request?.headers[webAuthModeHeaderName]?.firstOrNull ==
        webAuthModeCookie;
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

  /// Clears the auth cookie for cookie-mode requests (a no-op otherwise).
  ///
  /// Gated on [isWebAuthCookieRequest] just like [writeWebAuthCookie], so the
  /// marker is the single source of truth for "this request participates in
  /// cookie auth": a header/native client signing out gets no stray
  /// `Set-Cookie`. Cookie clients send the marker on every call (including
  /// sign-out), so their cookie is still cleared.
  void clearWebAuthCookie() {
    if (!isWebAuthCookieRequest) return;
    setResponseCookie(serverpod.config.authCookie!.buildClearCookieHeader());
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
      _build(token, maxAge: maxAgeSeconds);

  /// A `Set-Cookie` that expires (removes) the auth cookie on the client. The
  /// attributes match those used to set it, which browsers require to remove a
  /// cookie.
  SetCookie buildClearCookieHeader() => _build('', maxAge: 0);

  SetCookie _build(String value, {int? maxAge}) {
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
        path: path,
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
