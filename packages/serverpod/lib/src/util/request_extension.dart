import 'package:relic/relic.dart';

/// Extends [Request] with useful methods.
extension RemoteIpOnRelicRequest on Request {
  /// Returns the ip address of the client, attempting to find it even if routed
  /// through proxy servers by checking the 'x-forwarded-for' header.
  String get remoteIpAddress => remoteIdentifier;

  String get clientIpAddress => remoteIdentifier;

  /// Returns the ip address of the client, attempting to find it even if routed
  /// through proxy servers by checking the 'x-forwarded-for' header.
  String get remoteIdentifier {
    String? remoteAddress;
    try {
      // Extract remote address from headers, preferring Forwarded,
      // and using X-Forwarded-For as fallback
      remoteAddress =
          headers.forwarded?.elements.first.forwardedFor?.identifier ??
              headers.xForwardedFor?.addresses.first;
      if (remoteAddress != null) return remoteAddress;
    } catch (e) {
      //logDebug('Error parsing client IP from headers: $e\\n$s');
    }
    return 'unknown';
  }
}
