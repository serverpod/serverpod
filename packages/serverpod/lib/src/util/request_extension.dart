import 'package:relic/relic.dart';

/// Extends [Request] with useful methods.
extension RequestExtension on Request {
  /// Returns information about the remote client that made the request.
  ///
  /// The information is extracted from HTTP headers, preferring the
  /// `Forwarded` header, and using the `X-Forwarded-For` header as a fallback.
  /// If no information can be extracted, it returns 'unknown'.
  String get remoteInfo {
    return headers.forwarded?.elements.first.forwardedFor?.identifier ??
        headers.xForwardedFor?.addresses.first ??
        'unknown';
  }
}
