import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Cross-Origin-Resource-Policy header.
///
/// This header specifies the policy for sharing resources across origins.
class CrossOriginResourcePolicyHeader implements TypedHeader {
  /// The policy value of the header.
  final String policy;

  /// Constructs a [CrossOriginResourcePolicyHeader] instance with the specified value.
  const CrossOriginResourcePolicyHeader._(this.policy);

  /// Predefined policy values.
  static const _sameOrigin = 'same-origin';
  static const _sameSite = 'same-site';
  static const _crossOrigin = 'cross-origin';

  static const sameOrigin = CrossOriginResourcePolicyHeader._(_sameOrigin);
  static const sameSite = CrossOriginResourcePolicyHeader._(_sameSite);
  static const crossOrigin = CrossOriginResourcePolicyHeader._(_crossOrigin);

  /// Parses a [value] and returns the corresponding [CrossOriginResourcePolicyHeader] instance.
  /// If the value does not match any predefined types, it returns a custom instance.
  factory CrossOriginResourcePolicyHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }
    switch (trimmed) {
      case _sameOrigin:
        return sameOrigin;
      case _sameSite:
        return sameSite;
      case _crossOrigin:
        return crossOrigin;
      default:
        throw FormatException('Invalid value');
    }
  }

  /// Converts the [CrossOriginResourcePolicyHeader] instance into a string
  /// representation suitable for HTTP headers.
  @override
  String toHeaderString() => policy;

  @override
  String toString() {
    return 'CrossOriginResourcePolicyHeader(value: $policy)';
  }
}
