part of '../headers.dart';

/// A class representing the HTTP Accept header.
///
/// This class manages MIME types and optional quality values (`q` values).
/// It supports parsing and generating the appropriate header string.
class AcceptHeader {
  /// The list of accepted MIME types.
  final List<MediaType> mediaTypes;

  /// Constructs an [AcceptHeader] instance with the specified media types.
  AcceptHeader(this.mediaTypes);

  /// Parses the Accept header value and returns an [AcceptHeader] instance.
  ///
  /// This method splits the header by commas, trims each media type, and processes
  /// the MIME types along with optional `q` values.
  factory AcceptHeader.fromHeaderValue(dynamic value) {
    if (value is String) {
      final mediaTypes = value.isEmpty
          ? <MediaType>[]
          : value
              .split(',')
              .map((part) => MediaType.parse(part.trim()))
              .toList();
      return AcceptHeader(mediaTypes);
    }
    if (value is List<String>) {
      final mediaTypes = value
          .where((e) => e.isNotEmpty)
          .map((part) => MediaType.parse(part.trim()))
          .toList();
      return AcceptHeader(mediaTypes);
    }

    throw FormatException('Invalid Accept header');
  }

  /// Static method that attempts to parse the Accept header and returns `null` if the value is `null`.
  ///
  /// This method safely parses the Accept header value or returns `null` if the input is invalid or `null`.
  static AcceptHeader? tryParse(dynamic value) {
    if (value == null) return null;
    return AcceptHeader.fromHeaderValue(value);
  }

  /// Converts the [AcceptHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method generates the header string by concatenating the MIME types and their optional `q` values.
  @override
  String toString() {
    return mediaTypes.map((mediaType) => mediaType.toString()).join(', ');
  }
}
