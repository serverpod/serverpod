import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Access-Control-Allow-Origin header.
///
/// This header specifies which origins are allowed to access the resource.
/// It can be a specific origin or a wildcard (`*`) to allow any origin.
class AccessControlAllowOriginHeader implements TypedHeader {
  /// The allowed origin URI, if specified.
  final Uri? origin;

  /// Whether any origin is allowed (`*`).
  final bool isWildcard;

  /// Constructs an instance allowing a specific origin.
  const AccessControlAllowOriginHeader.origin({required this.origin})
      : isWildcard = false;

  /// Constructs an instance allowing any origin (`*`).
  const AccessControlAllowOriginHeader.wildcard()
      : origin = null,
        isWildcard = true;

  /// Parses the Access-Control-Allow-Origin header value and
  /// returns an [AccessControlAllowOriginHeader] instance.
  ///
  /// This method checks if the value is a wildcard or a specific origin.
  factory AccessControlAllowOriginHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    if (trimmed == '*') {
      return AccessControlAllowOriginHeader.wildcard();
    }

    try {
      return AccessControlAllowOriginHeader.origin(
        origin: Uri.parse(trimmed),
      );
    } catch (_) {
      throw FormatException('Invalid URI format');
    }
  }

  /// Converts the [AccessControlAllowOriginHeader] instance into a string
  /// representation suitable for HTTP headers.
  @override
  String toHeaderString() => isWildcard ? '*' : origin.toString();

  @override
  String toString() =>
      'AccessControlAllowOriginHeader(origin: $origin, isWildcard: $isWildcard)';
}
