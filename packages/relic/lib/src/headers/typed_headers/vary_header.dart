part of '../headers.dart';

/// A class representing the HTTP Vary header.
///
/// This class manages the list of headers that the response may vary on,
/// and can also handle the wildcard value "*", which indicates that the
/// response varies on all request headers.
class VaryHeader {
  /// A list of headers that the response varies on.
  /// If the list contains only "*", it means all headers are varied on.
  final List<String>? fields;

  /// Whether all headers are allowed to vary (`*`).
  final bool isWildcard;

  /// Constructs an instance allowing specific headers to vary.
  VaryHeader.headers({required this.fields}) : isWildcard = false;

  /// Constructs an instance allowing all headers to vary (`*`).
  VaryHeader.wildcard()
      : fields = null,
        isWildcard = true;

  /// Parses the Vary header value and returns a [VaryHeader] instance.
  ///
  /// This method handles the wildcard value "*" or splits the value by commas and trims each field.
  factory VaryHeader.parse(List<String> values) {
    var splitValues = values.splitTrimAndFilterUnique();

    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    if (splitValues.length == 1 && splitValues.first == '*') {
      return VaryHeader.wildcard();
    }

    if (splitValues.length > 1 && splitValues.contains('*')) {
      throw FormatException('Wildcard (*) cannot be used with other values');
    }

    return VaryHeader.headers(fields: splitValues);
  }

  /// Converts the [VaryHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method generates the header string by concatenating the fields with commas or using "*" if all headers vary.
  String toHeaderString() => isWildcard ? '*' : fields!.join(', ');

  @override
  String toString() {
    return 'VaryHeader(fields: $fields, isWildcard: $isWildcard)';
  }
}
