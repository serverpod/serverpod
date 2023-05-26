import 'dart:convert';
import 'dart:io';

/// Extends [HttpRequest] with useful methods.
extension HttpRequestExtensions on HttpRequest {
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

  /// Reads the body of an HTTP request and returns it as a String.
  /// If the request's content length exceeds the [maxRequestSize], an exception
  /// is thrown.
  Future<String?> readStringBody({required int maxRequestSize}) async {
    if (contentLength != -1) {
      if (contentLength > maxRequestSize) {
        throw Exception('The request size exceeds the maximum limit allowed.');
      }

      return utf8.decodeStream(this);
    }

    var data = <int>[];
    await for (var chunk in this) {
      if (data.length + chunk.length > maxRequestSize) {
        throw Exception('The request size exceeds the maximum limit allowed.');
      }

      data.addAll(chunk);
    }

    return utf8.decode(data);
  }
}

