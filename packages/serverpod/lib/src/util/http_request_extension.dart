import 'dart:io';

/// Extends [HttpRequest] with useful methods.
extension RemoteIp on HttpRequest {
  /// Returns the ip address of the client, even if it has been routed through
  /// a proxy server.
  String get remoteIpAddress {
    // Check headers to see if there is a forwarded client IP
    final forwardHeaders = headers['x-forwarded-for'];
    if (forwardHeaders != null && forwardHeaders.isNotEmpty) {
      final forwarded = forwardHeaders[0];
      final components = forwarded.split(',');
      if (components.isNotEmpty) {
        final clientIp = components[0].trim();
        return clientIp;
      }
    }

    // Fall back on IP number from connection
    return connectionInfo!.remoteAddress.address;
  }
}
