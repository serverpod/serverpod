import 'dart:io';

/// Extends [HttpRequest] with useful methods.
extension RemoteIp on HttpRequest {
  /// Returns the ip address of the client, even if it has been routed through
  /// a proxy server.
  String get remoteIpAddress {
    // Check headers to see if there is a forwarded client IP
    List<String>? forwardHeaders = headers['x-forwarded-for'];
    if (forwardHeaders != null && forwardHeaders.isNotEmpty) {
      String forwarded = forwardHeaders[0];
      List<String> components = forwarded.split(',');
      if (components.isNotEmpty) {
        String clientIp = components[0].trim();
        return clientIp;
      }
    }

    // Fall back on IP number from connection
    return connectionInfo!.remoteAddress.address;
  }
}
