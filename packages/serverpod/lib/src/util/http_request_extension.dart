import 'dart:io';

/// Extends [HttpRequest] with useful methods.
extension RemoteIp on HttpRequest {
  /// Returns the ip address of the client, even if it has been routed through
  /// a proxy server.
  String get remoteIpAddress {
    // Check headers to see if there is a forwarded client IP
    var forwardHeaders = headers['x-forwarded-for'];
    if (forwardHeaders != null && forwardHeaders.isNotEmpty) {
      var forwarded = forwardHeaders[0];
      var components = forwarded.split(',');
      if (components.isNotEmpty) {
        var clientIp = components[0].trim();
        return clientIp;
      }
    }

    // Fall back on IP number from connection
    return connectionInfo!.remoteAddress.address;
  }
}