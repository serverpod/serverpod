part of '../headers.dart';

/// A class representing the HTTP `If-Range` header.
///
/// The `If-Range` header typically contains an HTTP date.
class IfRangeHeader {
  /// The HTTP date if the `If-Range` header contains a date.
  final DateTime date;

  /// Private constructor to create an [IfRangeHeader] instance with the parsed date.
  const IfRangeHeader._(this.date);

  /// Parses the `If-Range` header value and returns an [IfRangeHeader] instance.
  ///
  /// This method assumes the value is a valid HTTP date and tries to parse it.
  factory IfRangeHeader.fromHeaderValue(String value) {
    final parsedDate = parseHttpDate(value);
    return IfRangeHeader._(parsedDate);
  }

  /// Static method that attempts to parse the `If-Range` header and returns `null` if the value is `null`.
  static IfRangeHeader? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    return IfRangeHeader.fromHeaderValue(value);
  }

  /// Converts the [IfRangeHeader] instance into a string representation suitable for HTTP headers.
  ///
  /// This method formats the HTTP date into a string.
  @override
  String toString() => formatHttpDate(date);
}
