part of '../headers.dart';

/// A class representing the HTTP Connection header.
///
/// This class manages connection directives, such as `keep-alive`, `close`, or multiple
/// directives (e.g., `upgrade, keep-alive`). It provides functionality to parse and generate
/// connection header values.
class ConnectionHeader {
  /// A list of connection directives (e.g., `keep-alive`, `close`, `upgrade`).
  final List<String> directives;

  /// Constructs a [ConnectionHeader] instance with the specified connection directives.
  const ConnectionHeader({
    required this.directives,
  });

  /// Parses the Connection header value and returns a [ConnectionHeader] instance.
  ///
  /// This method splits the value by commas and trims each directive.
  factory ConnectionHeader.fromHeaderValue(String value) {
    final directives =
        value.split(',').map((directive) => directive.trim()).toList();
    return ConnectionHeader(directives: directives);
  }

  /// Static method that attempts to parse the Connection header and returns `null` if the value is `null`.
  static ConnectionHeader? tryParse(String? value) {
    if (value == null) return null;
    return ConnectionHeader.fromHeaderValue(value);
  }

  /// Checks if the connection is marked as `keep-alive`.
  bool get isKeepAlive => directives.contains('keep-alive');

  /// Checks if the connection is marked as `close`.
  bool get isClose => directives.contains('close');

  /// Converts the [ConnectionHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method generates the header string by concatenating the connection directives.
  @override
  String toString() => directives.join(', ');
}
