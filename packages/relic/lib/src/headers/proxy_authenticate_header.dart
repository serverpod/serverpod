part of '../headers.dart';

/// A class representing the HTTP Proxy-Authenticate header.
///
/// This class manages the authentication schemes used by a proxy to challenge the client.
/// It can parse multiple schemes like `Basic`, `Digest`, `Bearer`, etc.
class ProxyAuthenticateHeader {
  /// A list of authentication schemes (e.g., `Basic`, `Digest`, `Bearer`).
  final List<String> schemes;

  /// Constructs a [ProxyAuthenticateHeader] instance with the specified authentication schemes.
  const ProxyAuthenticateHeader({
    required this.schemes,
  });

  /// Parses the Proxy-Authenticate header value and returns a [ProxyAuthenticateHeader] instance.
  ///
  /// This method splits the value by commas and trims each authentication scheme.
  factory ProxyAuthenticateHeader.fromHeaderValue(String value) {
    final schemes = value.split(',').map((scheme) => scheme.trim()).toList();
    return ProxyAuthenticateHeader(schemes: schemes);
  }

  /// Static method that attempts to parse the Proxy-Authenticate header and returns `null` if the value is `null`.
  static ProxyAuthenticateHeader? tryParse(String? value) {
    if (value == null) return null;
    return ProxyAuthenticateHeader.fromHeaderValue(value);
  }

  /// Checks if a specific authentication scheme is present.
  bool containsScheme(String scheme) {
    return schemes.contains(scheme);
  }

  /// Converts the [ProxyAuthenticateHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method generates the header string by concatenating the authentication schemes with commas.
  @override
  String toString() => schemes.join(', ');
}
