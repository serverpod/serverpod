import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing an HTTP Content-Range header for byte ranges.
///
/// This class is used to manage byte ranges in HTTP requests or responses,
/// including cases for unsatisfiable range requests.
class ContentRangeHeader implements TypedHeader {
  /// The unit of the range, e.g. "bytes".
  final String unit;

  /// The start of the byte range, or `null` if this is an unsatisfiable range.
  final int? start;

  /// The end of the byte range, or `null` if this is an unsatisfiable range.
  final int? end;

  /// The total size of the resource being ranged, or `null` if unknown.
  final int? size;

  /// Constructs a [ContentRangeHeader] with the specified range and optional total size.
  ContentRangeHeader({
    this.unit = 'bytes',
    this.start,
    this.end,
    this.size,
  }) {
    if (start != null && end != null && start! > end!) {
      throw FormatException('Invalid range');
    }
  }

  /// Factory constructor to create a [ContentRangeHeader] from the header string.
  factory ContentRangeHeader.parse(String value) {
    var trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    final regex = RegExp(r'(\w+) (?:(\d+)-(\d+)|\*)/(\*|\d+)');
    final match = regex.firstMatch(trimmed);

    if (match == null) {
      throw FormatException('Invalid format');
    }

    var unit = match.group(1)!;
    var start = match.group(2) != null ? int.tryParse(match.group(2)!) : null;
    var end = match.group(3) != null ? int.tryParse(match.group(3)!) : null;
    if (start != null && end != null && start > end) {
      throw FormatException('Invalid range');
    }
    var sizeGroup = match.group(4)!;

    // If totalSize is '*', it means the total size is unknown
    var size = sizeGroup == '*' ? null : int.parse(sizeGroup);

    return ContentRangeHeader(
      unit: unit,
      start: start,
      end: end,
      size: size,
    );
  }

  /// Returns the full content range string in the format "bytes start-end/totalSize".
  ///
  /// If the total size is unknown, it uses "*" in place of the total size.
  @override
  String toHeaderString() {
    final sizeStr = size?.toString() ?? '*';
    if (start == null && end == null) {
      return '$unit */$sizeStr';
    }
    return '$unit $start-$end/$sizeStr';
  }

  @override
  String toString() {
    return 'ContentRangeHeader(unit: $unit, start: $start, end: $end, size: $size)';
  }
}
