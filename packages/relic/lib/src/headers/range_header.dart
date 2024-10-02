part of '../headers.dart';

/// A class representing the HTTP Range header.
///
/// This class manages byte ranges, such as `bytes=0-499`, allowing the client to request specific parts of a resource.
/// It provides functionality to parse and generate range header values.
class RangeHeader {
  /// The start of the byte range.
  final int? start;

  /// The end of the byte range.
  final int? end;

  /// Constructs a [RangeHeader] instance with the specified start and end of the byte range.
  const RangeHeader({
    this.start,
    this.end,
  });

  /// Parses the Range header value and returns a [RangeHeader] instance.
  ///
  /// This method processes the range header and extracts the byte range.
  factory RangeHeader.fromHeaderValue(String value) {
    final regex = RegExp(r'bytes=(\d*)-(\d*)');
    final match = regex.firstMatch(value);

    if (match == null) {
      throw FormatException('Invalid Range header format');
    }

    final start =
        match.group(1)?.isNotEmpty == true ? int.parse(match.group(1)!) : null;
    final end =
        match.group(2)?.isNotEmpty == true ? int.parse(match.group(2)!) : null;

    return RangeHeader(start: start, end: end);
  }

  /// Static method that attempts to parse the Range header and returns `null` if the value is `null`.
  static RangeHeader? tryParse(String? value) {
    if (value == null) return null;
    return RangeHeader.fromHeaderValue(value);
  }

  /// Converts the [RangeHeader] instance into a string representation suitable for HTTP headers.
  @override
  String toString() {
    final startStr = start?.toString() ?? '';
    final endStr = end?.toString() ?? '';
    return 'bytes=$startStr-$endStr';
  }
}
