import 'package:relic/relic.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

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
