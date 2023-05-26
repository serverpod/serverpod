import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Exception thrown when an input stream exceeds the maximum allowed size.
class MaximumSizeExceeded implements Exception {
  /// The maximum allowed size of the input stream.
  final int maxSize;

  /// Creates a new [MaximumSizeExceeded] exception with the specified maximum
  /// size.
  const MaximumSizeExceeded(this.maxSize);

  /// Returns a string representation of the exception.
  @override
  String toString() => 'Input stream exceeded the maxSize: $maxSize';
}

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
  /// If the request's content length exceeds the [maxSize], an exception
  /// is thrown.
  Future<String> readString({required int maxSize}) async {
    if (contentLength != -1) {
      if (contentLength > maxSize) {
        throw MaximumSizeExceeded(maxSize);
      }

      return utf8.decodeStream(this);
    }

    var data = <int>[];
    await for (var chunk in this) {
      if (data.length + chunk.length > maxSize) {
        throw MaximumSizeExceeded(maxSize);
      }

      data.addAll(chunk);
    }

    return utf8.decode(data);
  }

  /// Reads the body of an HTTP request and returns it as a Uint8List.
  /// If the request's content length exceeds the [maxSize], an exception
  /// is thrown.
  Future<Uint8List> readBytes({required int maxSize}) async {
    if (contentLength != -1 && contentLength > maxSize) {
      throw MaximumSizeExceeded(maxSize);
    }

    var result = BytesBuilder();
    await for (var chunk in this) {
      if (result.length + chunk.length > maxSize) {
        throw MaximumSizeExceeded(maxSize);
      }

      result.add(chunk);
    }

    return result.takeBytes();
  }
}
