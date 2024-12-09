import 'package:relic/src/headers/typed/base/typed_header.dart';

/// A class representing the HTTP Cross-Origin-Opener-Policy header.
///
/// This header specifies the policy for opening cross-origin resources.
class CrossOriginOpenerPolicyHeader extends TypedHeader {
  /// The policy value of the header.
  final String policy;

  /// Constructs a [CrossOriginOpenerPolicyHeader] instance with the specified value.
  const CrossOriginOpenerPolicyHeader(this.policy);

  /// Predefined policy values.
  static const _sameOrigin = 'same-origin';
  static const _sameOriginAllowPopups = 'same-origin-allow-popups';
  static const _unsafeNone = 'unsafe-none';

  static const sameOrigin = CrossOriginOpenerPolicyHeader(_sameOrigin);
  static const sameOriginAllowPopups =
      CrossOriginOpenerPolicyHeader(_sameOriginAllowPopups);
  static const unsafeNone = CrossOriginOpenerPolicyHeader(_unsafeNone);

  /// Parses a [value] and returns the corresponding [CrossOriginOpenerPolicyHeader] instance.
  /// If the value does not match any predefined types, it returns a custom instance.
  factory CrossOriginOpenerPolicyHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    switch (trimmed.toLowerCase()) {
      case _sameOrigin:
        return sameOrigin;
      case _sameOriginAllowPopups:
        return sameOriginAllowPopups;
      case _unsafeNone:
        return unsafeNone;
      default:
        return CrossOriginOpenerPolicyHeader(trimmed);
    }
  }

  /// Converts the [CrossOriginOpenerPolicyHeader] instance into a string
  /// representation suitable for HTTP headers.
  @override
  String toHeaderString() => policy;

  @override
  String toString() {
    return 'CrossOriginOpenerPolicyHeader(value: $policy)';
  }
}
