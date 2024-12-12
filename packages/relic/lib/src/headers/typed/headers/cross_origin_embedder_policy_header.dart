import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Cross-Origin-Embedder-Policy header.
///
/// This header specifies the policy for embedding cross-origin resources.
class CrossOriginEmbedderPolicyHeader implements TypedHeader {
  /// The policy value of the header.
  final String policy;

  /// Constructs a [CrossOriginEmbedderPolicyHeader] instance with the specified value.
  const CrossOriginEmbedderPolicyHeader._(this.policy);

  /// Predefined policy values.
  static const _unsafeNone = 'unsafe-none';
  static const _requireCorp = 'require-corp';
  static const _credentialless = 'credentialless';

  static const unsafeNone = CrossOriginEmbedderPolicyHeader._(_unsafeNone);
  static const requireCorp = CrossOriginEmbedderPolicyHeader._(_requireCorp);
  static const credentialless =
      CrossOriginEmbedderPolicyHeader._(_credentialless);

  /// Parses a [value] and returns the corresponding [CrossOriginEmbedderPolicyHeader] instance.
  /// If the value does not match any predefined types, it returns a custom instance.
  factory CrossOriginEmbedderPolicyHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    switch (trimmed) {
      case _unsafeNone:
        return unsafeNone;
      case _requireCorp:
        return requireCorp;
      case _credentialless:
        return credentialless;
      default:
        throw FormatException('Invalid value');
    }
  }

  /// Converts the [CrossOriginEmbedderPolicyHeader] instance into a string
  /// representation suitable for HTTP headers.
  @override
  String toHeaderString() => policy;

  @override
  String toString() {
    return 'CrossOriginEmbedderPolicyHeader(value: $policy)';
  }
}
