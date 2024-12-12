import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Access-Control-Allow-Headers header.
///
/// This header specifies which HTTP headers can be used during the actual request
/// by listing them explicitly or using a wildcard (`*`) to allow all headers.
class AccessControlAllowHeadersHeader implements TypedHeader {
  /// The list of headers that are allowed.
  final List<String>? headers;

  /// Whether all headers are allowed (`*`).
  final bool isWildcard;

  /// Constructs an instance allowing specific headers to be allowed.
  const AccessControlAllowHeadersHeader.headers({required this.headers})
      : isWildcard = false;

  /// Constructs an instance allowing all headers to be allowed (`*`).
  const AccessControlAllowHeadersHeader.wildcard()
      : headers = null,
        isWildcard = true;

  /// Parses the Access-Control-Allow-Headers header value and returns an
  /// [AccessControlAllowHeadersHeader] instance.
  factory AccessControlAllowHeadersHeader.parse(List<String> values) {
    var splitValues = values.splitTrimAndFilterUnique();
    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    if (splitValues.length == 1 && splitValues.first == '*') {
      return AccessControlAllowHeadersHeader.wildcard();
    }

    if (splitValues.length > 1 && splitValues.contains('*')) {
      throw FormatException('Wildcard (*) cannot be used with other headers');
    }

    return AccessControlAllowHeadersHeader.headers(
      headers: splitValues,
    );
  }

  /// Converts the [AccessControlAllowHeadersHeader] instance into a string
  /// representation suitable for HTTP headers.
  @override
  String toHeaderString() => isWildcard ? '*' : headers!.join(', ');

  @override
  String toString() =>
      'AccessControlAllowHeadersHeader(headers: $headers, isWildcard: $isWildcard)';
}
