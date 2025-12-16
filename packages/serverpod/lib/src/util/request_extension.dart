import 'package:postgres/postgres.dart';
import 'package:relic/relic.dart';

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
  /// Serverpod 2 clients.
  String? getAuthorizationHeaderValue(bool validateHeaders) {
    if (validateHeaders) {
      // Use typed API - validates header format
      return headers.authorization?.headerValue;
    } else {
      // Use non-typed API - allows unwrapped tokens
      // The non-typed API returns Iterable<String>? for header values.
      // Authorization header should only appear once per HTTP spec, so we
      // take the first value.
      return headers['authorization']?.firstOrNull;
    }
  }
}
