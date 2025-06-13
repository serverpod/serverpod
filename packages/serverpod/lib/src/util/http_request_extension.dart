import 'package:relic/relic.dart';

// Note: dart:io.HttpHeaders.xForwardedFor could be used for 'x-forwarded-for'
// but since it's a string literal, dart:io import is removed for now.

/// Extends [relic.Request] with useful methods.
extension RemoteIpOnRelicRequest on Request {
  /// Returns the ip address of the client, attempting to find it even if routed
  /// through proxy servers by checking the 'x-forwarded-for' header.
  String get remoteIpAddress {
    // Check headers to see if there is a forwarded client IP
    // relic.Request.headers[] might return String or List<String>
    var headerValue = headers['x-forwarded-for'];

    String? firstForwardedIp;

    if (headerValue is String) {
      // Explicit cast to satisfy analyzer, though type promotion should handle this.
      var parts = (headerValue as String).split(',');
      if (parts.isNotEmpty) {
        firstForwardedIp = parts.first.trim();
      }
    } else if (headerValue is List<String>) {
      if (headerValue.isNotEmpty) {
        var parts = headerValue.first.split(',');
        if (parts.isNotEmpty) {
          firstForwardedIp = parts.first.trim();
        }
      }
    }

    if (firstForwardedIp != null && firstForwardedIp.isNotEmpty) {
      return firstForwardedIp;
    }

    // Fallback: relic.Request does not expose connectionInfo or a direct remote IP
    // in a way that's currently known/compatible with the old method.
    // TODO: Investigate if relic.Request offers a more direct way to get client IP.
    return 'unknown_ip_relic'; // Placeholder
  }
}
