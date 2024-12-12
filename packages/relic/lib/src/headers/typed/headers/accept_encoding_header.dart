import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Accept-Encoding header.
///
/// This header specifies the content encoding that the client can understand.
class AcceptEncodingHeader implements TypedHeader {
  /// The list of encodings that are accepted.
  final List<EncodingQuality>? encodings;

  /// A boolean value indicating whether the Accept-Encoding header is a wildcard.
  final bool isWildcard;

  /// Constructs an instance of [AcceptEncodingHeader] with the given encodings.
  AcceptEncodingHeader.encodings({required this.encodings})
      : isWildcard = false;

  /// Constructs an instance of [AcceptEncodingHeader] with a wildcard encoding.
  AcceptEncodingHeader.wildcard()
      : encodings = null,
        isWildcard = true;

  /// Parses the Accept-Encoding header value and returns an [AcceptEncodingHeader] instance.
  factory AcceptEncodingHeader.parse(List<String> values) {
    var splitValues = values.splitTrimAndFilterUnique();

    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    if (splitValues.length == 1 && splitValues.first == '*') {
      return AcceptEncodingHeader.wildcard();
    }

    if (splitValues.length > 1 && splitValues.contains('*')) {
      throw FormatException('Wildcard (*) cannot be used with other values');
    }

    var encodings = splitValues.map((value) {
      var encodingParts = value.split(';q=');
      var encoding = encodingParts[0].trim().toLowerCase();
      if (encoding.isEmpty) {
        throw FormatException('Invalid encoding');
      }
      double? quality;
      if (encodingParts.length > 1) {
        var value = double.tryParse(encodingParts[1].trim());
        if (value == null || value < 0 || value > 1) {
          throw FormatException('Invalid quality value');
        }
        quality = value;
      }
      return EncodingQuality(encoding, quality);
    }).toList();

    return AcceptEncodingHeader.encodings(encodings: encodings);
  }

  /// Converts the [AcceptEncodingHeader] instance into a string representation suitable for HTTP headers.
  @override
  String toHeaderString() => isWildcard
      ? '*'
      : encodings?.map((e) => e.toHeaderString()).join(', ') ?? '';

  @override
  String toString() => 'AcceptEncodingHeader(encodings: $encodings)';
}

/// A class representing an encoding with an optional quality value.
class EncodingQuality {
  /// The encoding value.
  final String encoding;

  /// The quality value (default is 1.0).
  final double? quality;

  /// Constructs an instance of [EncodingQuality].
  EncodingQuality(this.encoding, [double? quality]) : quality = quality ?? 1.0;

  /// Converts the [EncodingQuality] instance into a string representation suitable for HTTP headers.
  String toHeaderString() => quality == 1.0 ? encoding : '$encoding;q=$quality';

  @override
  String toString() =>
      'EncodingQuality(encoding: $encoding, quality: $quality)';
}
