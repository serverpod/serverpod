import 'package:http_parser/http_parser.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';
import 'package:relic/src/headers/typed/typed_headers.dart';

/// A class representing the HTTP `If-Range` header.
///
/// The `If-Range` header can contain either an HTTP date or an ETag.
class IfRangeHeader implements TypedHeader {
  /// The HTTP date if the `If-Range` header contains a date.
  final DateTime? lastModified;

  /// The ETag if the `If-Range` header contains an ETag.
  final ETagHeader? etag;

  /// Constructs an [IfRangeHeader] instance with either a date or an ETag.
  ///
  /// Either [lastModified] or [etag] must be non-null.
  IfRangeHeader({
    this.lastModified,
    this.etag,
  }) {
    if (lastModified == null && etag == null) {
      throw FormatException('Either date or etag must be provided');
    }
  }

  /// Parses the `If-Range` header value and returns an [IfRangeHeader] instance.
  ///
  /// Determines if the value is an ETag or a date and creates the appropriate instance.
  factory IfRangeHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    // Check if the value is a valid ETag
    if (ETagHeader.isValidETag(trimmed)) {
      return IfRangeHeader(etag: ETagHeader.parse(trimmed));
    }

    try {
      final parsedDate = parseHttpDate(trimmed);
      return IfRangeHeader(lastModified: parsedDate);
    } catch (_) {
      throw FormatException('Invalid format');
    }
  }

  /// Converts the [IfRangeHeader] instance into a string representation
  /// suitable for HTTP headers.
  @override
  String toHeaderString() => lastModified != null
      ? formatHttpDate(lastModified!)
      : etag!.toHeaderString();

  @override
  String toString() {
    return 'IfRangeHeader(lastModified: $lastModified, etag: $etag)';
  }
}
