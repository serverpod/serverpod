import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP TE header.
///
/// The TE header indicates the transfer encodings the client is willing to accept,
/// optionally with quality values.
class TEHeader implements TypedHeader {
  /// The list of encodings with their quality values.
  final List<TeQuality> encodings;

  /// Constructs a [TEHeader] instance with the specified list of encodings.
  TEHeader({required this.encodings});

  /// Parses the TE header value and returns a [TEHeader] instance.
  ///
  /// This method processes the TE header and extracts the list of encodings
  /// with their quality values.
  factory TEHeader.parse(List<String> values) {
    var splitValues = values.splitTrimAndFilterUnique();

    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
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
      return TeQuality(encoding, quality);
    }).toList();

    return TEHeader(encodings: encodings);
  }

  /// Converts the [TEHeader] instance into a string representation
  /// suitable for HTTP headers.
  @override
  String toHeaderString() =>
      encodings.map((e) => e.toHeaderString()).join(', ');

  @override
  String toString() => 'TEHeader(encodings: $encodings)';
}

/// A class representing a transfer encoding with an optional quality value.
class TeQuality {
  /// The encoding value.
  final String encoding;

  /// The quality value (default is 1.0).
  final double? quality;

  /// Constructs an instance of [TeQuality].
  TeQuality(this.encoding, [double? quality]) : quality = quality ?? 1.0;

  /// Converts the [TeQuality] instance into a string representation suitable for HTTP headers.
  String toHeaderString() => quality == 1.0 ? encoding : '$encoding;q=$quality';

  @override
  String toString() => 'TeQuality(encoding: $encoding, quality: $quality)';
}
