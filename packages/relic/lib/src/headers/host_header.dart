part of '../headers.dart';

/// A class representing the HTTP Host header.
///
/// This class manages both the host name and the optional port.
/// It provides functionality to parse, validate, and generate host header values.
class HostHeader {
  /// The host name (e.g., `example.com`).
  final String host;

  /// The optional port number (e.g., `8080`).
  final int? port;

  /// Constructs a [HostHeader] instance with the specified host and optional port.
  const HostHeader({
    required this.host,
    this.port,
  });

  /// Parses a host header value and returns a [HostHeader] instance.
  ///
  /// This method checks if a port is present after a colon (`:`) in the host header.
  factory HostHeader.fromHeaderValue(
    String value, {
    int? port,
  }) {
    final parts = value.split(':');
    final host = parts[0].trim();
    int? mPort = port;

    if (parts.length > 1 && mPort == null) {
      mPort = int.tryParse(parts[1].trim());
      if (mPort == null) {
        throw FormatException('Invalid port in Host header');
      }
    }

    return HostHeader(host: host, port: mPort);
  }

  /// Static method that attempts to parse the Host header and returns `null` if the value is `null`.
  static HostHeader? tryParse(
    String? value, {
    int? port,
  }) {
    if (value == null) return null;
    return HostHeader.fromHeaderValue(value, port: port);
  }

  /// Converts the [HostHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method joins the host name and port (if present) with a colon (`:`).
  @override
  String toString() => port != null ? '$host:$port' : host;
}
