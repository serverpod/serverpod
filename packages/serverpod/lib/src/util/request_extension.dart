import 'package:relic/relic.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Extends [Request] with useful methods.
extension RequestExtension on Request {
  /// Returns information about the remote client that made the request.
  ///
  /// The information is extracted from HTTP headers, preferring the `Forwarded`
  /// header, then the `X-Forwarded-For` header, and using
  /// [ConnectionInfo.remote.address] as fallback.
  String get remoteInfo {
    // Prefer first element of `Forwarded` Header
    //
    // Grammar:
    // for = "for" "=" ( node-id / quoted-string )
    // node-id = ( IPv4address / "[" IPv6address "]" / "unknown" / obfuscated )
    // obfuscated = "_" 1*( ALPHA / DIGIT / "." / "_" / "-" )
    //
    // Examaples: “192.0.2.43”, “[2001:db8::1]”, “unknown”, or “_08fusc4t3d"
    final forwardedFor =
        headers.forwarded?.elements.first.forwardedFor?.identifier;

    // Fallback to `X-Forwarded-For` then IPAddress of remote
    return forwardedFor ??
        headers.xForwardedFor?.addresses.first ?? // anything really ¯\_(ツ)_/¯
        connectionInfo.remote.address.toString();
  }

  /// Gets the Authorization header value from the request.
  ///
  /// If [validateHeaders] is true (default), uses Relic's typed API which
  /// validates that the Authorization header has a proper scheme (e.g.,
  /// "Bearer" or "Basic"). This will throw a [HeaderException] if the header
  /// is malformed.
  ///
  /// If [validateHeaders] is false, uses the non-typed API to get the raw
  /// header value, allowing unwrapped tokens for backward compatibility with
  /// Serverpod 2 clients. The non-typed API returns `Iterable<String>?`
  /// because HTTP allows multiple headers with the same name. However, the
  /// Authorization header should only appear once per RFC 7235, so we use
  /// `firstOrNull` to get the single value. If multiple Authorization headers
  /// are present (non-standard), only the first value is returned.
  String? getAuthorizationHeaderValue(bool validateHeaders) {
    if (validateHeaders) {
      // Use typed API - validates header format
      return headers.authorization?.headerValue;
    } else {
      // Use non-typed API - allows unwrapped tokens
      // Returns first value if multiple Authorization headers exist (rare)
      return headers['authorization']?.firstOrNull;
    }
  }

  /// Returns the value of the cookie named [cookieName] from the request's
  /// `Cookie` header, or null if it is absent, ambiguous, or the header has no
  /// valid cookie at all (all treated as absent rather than failing the
  /// request).
  ///
  /// relic's `Cookie` parser skips individual malformed cookies, so an
  /// unrelated bad cookie does not hide a well-formed one. It only throws when
  /// no cookie in the header is usable; that is caught here and treated as
  /// absent.
  ///
  /// If the `Cookie` header carries more than one cookie with [cookieName] this
  /// returns null (fail closed) instead of trusting whichever the browser
  /// ordered first: a sibling subdomain can plant a `Domain`-scoped duplicate
  /// that shadows a host-only cookie, so picking the first match would let an
  /// attacker fixate the session for a security-sensitive cookie.
  String? getCookieValue(String cookieName) {
    try {
      var matching = headers.cookie?.getCookies(cookieName).toList();
      if (matching == null || matching.length != 1) return null;
      return matching.first.value;
    } on Exception {
      return null;
    }
  }

  /// Returns the web auth token carried by the configured [authCookie], or null
  /// when cookie auth is not configured or the cookie is absent.
  String? getAuthCookieValue(WebAuthCookieConfig? authCookie) {
    if (authCookie == null) return null;
    return getCookieValue(authCookie.name);
  }
}
