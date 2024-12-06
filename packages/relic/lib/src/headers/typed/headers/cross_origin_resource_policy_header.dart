import 'package:relic/src/headers/typed/base/typed_header.dart';

/// A class representing the HTTP Cross-Origin-Resource-Policy header.
///
/// This header specifies the policy for sharing resources across origins.
class CrossOriginResourcePolicyHeader extends TypedHeader {
  /// The policy value of the header.
  final String policy;

  /// Constructs a [CrossOriginResourcePolicyHeader] instance with the specified value.
  const CrossOriginResourcePolicyHeader(this.policy);

  /// Predefined policy values.
  static const _sameOrigin = 'same-origin';
  static const _sameSite = 'same-site';
  static const _crossOrigin = 'cross-origin';

  static const sameOrigin = CrossOriginResourcePolicyHeader(_sameOrigin);
  static const sameSite = CrossOriginResourcePolicyHeader(_sameSite);
  static const crossOrigin = CrossOriginResourcePolicyHeader(_crossOrigin);

  /// Parses a [value] and returns the corresponding [CrossOriginResourcePolicyHeader] instance.
  /// If the value does not match any predefined types, it returns a custom instance.
  factory CrossOriginResourcePolicyHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }
    switch (trimmed.toLowerCase()) {
      case _sameOrigin:
        return sameOrigin;
      case _sameSite:
        return sameSite;
      case _crossOrigin:
        return crossOrigin;
      default:
        return CrossOriginResourcePolicyHeader(trimmed);
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
