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
}
