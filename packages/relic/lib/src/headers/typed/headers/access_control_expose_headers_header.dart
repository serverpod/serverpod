import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Access-Control-Expose-Headers header.
///
/// This header specifies which headers can be exposed as part of the response
/// by listing them explicitly or using a wildcard (`*`) to expose all headers.
class AccessControlExposeHeadersHeader implements TypedHeader {
  /// The list of headers that can be exposed.
  final List<String>? headers;

  /// Whether all headers are allowed to be exposed (`*`).
  final bool isWildcard;

  /// Constructs an instance allowing specific headers to be exposed.
  const AccessControlExposeHeadersHeader.headers({required this.headers})
      : isWildcard = false;

  /// Constructs an instance allowing all headers to be exposed (`*`).
  const AccessControlExposeHeadersHeader.wildcard()
      : headers = null,
        isWildcard = true;

  /// Parses the Access-Control-Expose-Headers header value and returns an
  /// [AccessControlExposeHeadersHeader] instance.
  factory AccessControlExposeHeadersHeader.parse(List<String> values) {
    var splitValues = values.splitTrimAndFilterUnique();
    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    if (splitValues.length == 1 && splitValues.first == '*') {
      return AccessControlExposeHeadersHeader.wildcard();
    }

    if (splitValues.length > 1 && splitValues.contains('*')) {
      throw FormatException('Wildcard (*) cannot be used with other values');
    }

    return AccessControlExposeHeadersHeader.headers(
      headers: splitValues,
    );
  }

  /// Converts the [AccessControlExposeHeadersHeader] instance into a string
  /// representation suitable for HTTP headers.
  @override
  String toHeaderString() => isWildcard ? '*' : headers?.join(', ') ?? '';

  @override
  String toString() =>
      'AccessControlExposeHeadersHeader(headers: $headers, isWildcard: $isWildcard)';
}
