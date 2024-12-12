import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Accept-Ranges header.
///
/// This class manages the range units that the server supports.
class AcceptRangesHeader implements TypedHeader {
  /// The range unit supported by the server, or `null` if no specific unit is supported.
  final String? rangeUnit;

  /// Constructs an [AcceptRangesHeader] instance with the specified range unit.
  const AcceptRangesHeader({this.rangeUnit});

  /// Constructs an [AcceptRangesHeader] instance with the range unit set to 'none'.
  factory AcceptRangesHeader.none() => AcceptRangesHeader(rangeUnit: 'none');

  /// Constructs an [AcceptRangesHeader] instance with the range unit set to 'bytes'.
  factory AcceptRangesHeader.bytes() => AcceptRangesHeader(rangeUnit: 'bytes');

  /// Parses the Accept-Ranges header value and returns an [AcceptRangesHeader] instance.
  ///
  /// This method processes the header value, extracting the range unit.
  factory AcceptRangesHeader.parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    return AcceptRangesHeader(rangeUnit: trimmed);
  }

  /// Returns `true` if the range unit is 'bytes', otherwise `false`.
  bool get isBytes => rangeUnit == 'bytes';

  /// Returns `true` if the range unit is 'none' or `null`, otherwise `false`.
  bool get isNone => rangeUnit == 'none' || rangeUnit == null;

  /// Converts the [AcceptRangesHeader] instance into a string representation suitable for HTTP headers.
  @override
  String toHeaderString() => rangeUnit ?? 'none';
  @override
  String toString() {
    return 'AcceptRangesHeader(rangeUnit: $rangeUnit)';
  }
}
