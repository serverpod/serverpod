import 'dart:io';

extension RemoteIp on HttpRequest {
  String get remoteIpAddress {
    // Check headers to see if there is a forwarded client IP
    List<String> forwardHeaders = headers['x-forwarded-for'];
    if (forwardHeaders != null && forwardHeaders.length > 0) {
      String forwarded = forwardHeaders[0];
      var components = forwarded.split(',');
      if (components.length > 0) {
        String clientIp = components[0].trim();
        return clientIp;
      }
    }

    // Fall back on IP number from connection
    return connectionInfo.remoteAddress.address;
  }
}