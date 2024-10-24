part of '../headers.dart';

/// A class representing the HTTP ETag header.
///
/// This class manages strong and weak ETag values. It provides functionality to parse, compare,
/// and generate ETag header values.
class ETagHeader {
  /// The ETag value, excluding the `W/` prefix for weak ETags.
  final String value;

  /// Whether the ETag is weak.
  final bool isWeak;

  /// Constructs an [ETagHeader] instance with the specified value and whether it's weak.
  const ETagHeader({
    required this.value,
    this.isWeak = false,
  });

  /// Parses the ETag header value and returns an [ETagHeader] instance.
  ///
  /// This method checks if the ETag is weak (prefixed with `W/`) and processes the value accordingly.
  factory ETagHeader.fromHeaderValue(String value) {
    final isWeak = value.startsWith('W/');
    final tagValue = isWeak ? value.substring(2).trim() : value.trim();

    // Ensure ETag value is enclosed in double quotes.
    if (!tagValue.startsWith('"') || !tagValue.endsWith('"')) {
      throw FormatException('Invalid ETag format: missing quotes');
    }

    return ETagHeader(value: tagValue.replaceAll('"', ''), isWeak: isWeak);
  }

  /// Static method that attempts to parse the ETag header and returns `null` if the value is `null`.
  static ETagHeader? tryParse(String? value) {
    if (value == null) return null;
    return ETagHeader.fromHeaderValue(value);
  }

  /// Converts the [ETagHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method adds quotes around the ETag value and prefixes it with `W/` if it's weak.
  @override
  String toString() {
    final prefix = isWeak ? 'W/' : '';
    return '$prefix"$value"';
  }

  /// Compares this ETag with another ETag for equality.
  ///
  /// If either of the ETags is weak, the comparison fails unless both ETags are identical and weak.
  bool compare(ETagHeader other) {
    if (isWeak || other.isWeak) {
      // Both must be weak and identical for comparison
      return isWeak == other.isWeak && value == other.value;
    }
    return value == other.value;
  }
}
