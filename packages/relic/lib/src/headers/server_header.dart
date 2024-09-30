part of '../headers.dart';

/// A class representing the HTTP Server header.
///
/// This class manages the server name and version, typically used to indicate the software
/// handling the request on the server side.
class ServerHeader {
  /// The name of the server software (e.g., `nginx`, `Apache`).
  final String name;

  /// The optional version of the server software.
  final String? version;

  /// Constructs a [ServerHeader] instance with the specified name and optional version.
  const ServerHeader({
    required this.name,
    this.version,
  });

  /// Parses the Server header value and returns a [ServerHeader] instance.
  ///
  /// This method splits the header value by the forward slash (`/`) to extract
  /// the server name and version if provided.
  factory ServerHeader.fromHeaderValue(String value) {
    final parts = value.split('/');
    final name = parts[0].trim();
    final version = parts.length > 1 ? parts[1].trim() : null;

    return ServerHeader(name: name, version: version);
  }

  /// Static method that attempts to parse the Server header and returns `null` if the value is `null`.
  static ServerHeader? tryParse(List<String>? value) {
    final first = value?.firstOrNull;
    if (first == null) return null;
    return ServerHeader.fromHeaderValue(first);
  }

  /// Converts the [ServerHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method joins the server name and version with a `/`, if the version is provided.
  @override
  String toString() {
    if (version != null) {
      return '$name/$version';
    }
    return name;
  }
}
