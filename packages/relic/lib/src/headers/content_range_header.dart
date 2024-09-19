part of '../headers.dart';

/// A class representing an HTTP Content-Range header for byte ranges.
///
/// This class is used to manage byte ranges in HTTP requests or responses.
class ContentRangeHeader {
  /// The start of the byte range.
  final int start;

  /// The end of the byte range.
  final int end;

  /// The total size of the resource being ranged, or `null` if unknown.
  final int? totalSize;

  /// Constructs a [ContentRangeHeader] with the specified range and optional total size.
  ContentRangeHeader({
    required this.start,
    required this.end,
    this.totalSize,
  })  : assert(start >= 0, 'Start of the range must be non-negative'),
        assert(end >= start,
            'End of the range must be greater than or equal to start');

  /// Factory constructor to create a [ContentRangeHeader] from the header string.
  ///
  /// This method validates the format of the Content-Range string and parses
  /// the byte range and total size (if available).
  factory ContentRangeHeader.fromHeaderValue(String value) {
    final regex = RegExp(r'bytes (\d+)-(\d+)/(\d+|\*)');
    final match = regex.firstMatch(value);

    if (match != null) {
      final start = int.parse(match.group(1)!);
      final end = int.parse(match.group(2)!);
      final totalSizeGroup = match.group(3)!;

      // If totalSize is '*', it means the total size is unknown
      final totalSize =
          totalSizeGroup == '*' ? null : int.parse(totalSizeGroup);

      return ContentRangeHeader(start: start, end: end, totalSize: totalSize);
    }

    throw FormatException('Invalid Content-Range header format');
  }

  /// Static method that attempts to parse the Content-Range header value and returns `null` if the value is null.
  ///
  /// This method allows safe parsing by returning `null` only if the input value is `null`, otherwise it proceeds with parsing.
  static ContentRangeHeader? tryParse(String? value) {
    if (value == null) return null;
    return ContentRangeHeader.fromHeaderValue(value);
  }

  /// Returns the full content range string in the format "bytes start-end/totalSize".
  ///
  /// If the total size is unknown, it uses "*" in place of the total size.
  @override
  String toString() {
    final totalSizeStr = totalSize?.toString() ?? '*';
    return 'bytes $start-$end/$totalSizeStr';
  }
}
