import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP ETag header.
///
/// This class manages the ETag value, which can be either strong or weak.
/// It provides functionality to parse the header value and construct the
/// appropriate header string.
class ETagHeader implements TypedHeader {
  /// The ETag value without quotes.
  final String value;

  /// Indicates whether the ETag is weak.
  final bool isWeak;

  /// Constructs an [ETagHeader] instance with the specified value and whether it is weak.
  const ETagHeader({
    required this.value,
    this.isWeak = false,
  });

  /// Predefined ETag prefixes.
  static const _weakPrefix = 'W/';
  static const _quote = '"';

  /// Checks if a string is a valid ETag format (either strong or weak).
  ///
  /// Returns true if the string is either:
  /// - A strong ETag: quoted string (e.g., "123456")
  /// - A weak ETag: W/ followed by a quoted string (e.g., W/"123456")
  static bool isValidETag(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    // Check for weak ETag format
    if (trimmed.startsWith(_weakPrefix)) {
      final tag = trimmed.substring(2).trim();
      return tag.startsWith(_quote) && tag.endsWith(_quote);
    }

    // Check for strong ETag format
    return trimmed.startsWith(_quote) && trimmed.endsWith(_quote);
  }

  /// Parses the ETag header value and returns an [ETagHeader] instance.
  ///
  /// This method validates the format of the ETag string and parses
  /// the ETag value and whether it is weak.
  factory ETagHeader.parse(String value) {
    if (!isValidETag(value)) {
      throw FormatException('Invalid format');
    }

    var isWeak = value.startsWith(_weakPrefix);
    var tagValue = isWeak ? value.substring(2).trim() : value.trim();
    return ETagHeader(value: tagValue.replaceAll(_quote, ''), isWeak: isWeak);
  }

  /// Converts the [ETagHeader] instance into a string representation suitable
  /// for HTTP headers.
  @override
  String toHeaderString() {
    final prefix = isWeak ? _weakPrefix : '';
    return '$prefix$_quote$value$_quote';
  }

  @override
  String toString() {
    return 'ETagHeader(value: $value, isWeak: $isWeak)';
  }
}
