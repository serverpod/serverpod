import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Accept-Language header.
///
/// This header specifies the natural languages that are preferred in the response.
class AcceptLanguageHeader implements TypedHeader {
  /// The list of languages that are accepted.
  final List<LanguageQuality>? languages;

  /// A boolean value indicating whether the Accept-Language header is a wildcard.
  final bool isWildcard;

  /// Constructs an instance of [AcceptLanguageHeader] with the given languages.
  const AcceptLanguageHeader.languages({required this.languages})
      : isWildcard = false;

  /// Constructs an instance of [AcceptLanguageHeader] with a wildcard language.
  const AcceptLanguageHeader.wildcard()
      : languages = null,
        isWildcard = true;

  /// Parses the Accept-Language header value and returns an [AcceptLanguageHeader] instance.
  factory AcceptLanguageHeader.parse(List<String> values) {
    var splitValues = values.splitTrimAndFilterUnique();

    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    if (splitValues.length == 1 && splitValues.first == '*') {
      return AcceptLanguageHeader.wildcard();
    }

    if (splitValues.length > 1 && splitValues.contains('*')) {
      throw FormatException('Wildcard (*) cannot be used with other values');
    }

    var languages = splitValues.map((value) {
      var languageParts = value.split(';q=');
      var language = languageParts[0].trim().toLowerCase();
      if (language.isEmpty) {
        throw FormatException('Invalid language');
      }
      double? quality;
      if (languageParts.length > 1) {
        var value = double.tryParse(languageParts[1].trim());
        if (value == null || value < 0 || value > 1) {
          throw FormatException('Invalid quality value');
        }
        quality = value;
      }
      return LanguageQuality(language, quality);
    }).toList();

    return AcceptLanguageHeader.languages(languages: languages);
  }

  /// Converts the [AcceptLanguageHeader] instance into a string representation suitable for HTTP headers.
  @override
  String toHeaderString() => isWildcard
      ? '*'
      : languages?.map((e) => e.toHeaderString()).join(', ') ?? '';

  @override
  String toString() => 'AcceptLanguageHeader(languages: $languages)';
}

/// A class representing a language with an optional quality value.
class LanguageQuality {
  /// The language value.
  final String language;

  /// The quality value (default is 1.0).
  final double? quality;

  /// Constructs an instance of [LanguageQuality].
  LanguageQuality(this.language, [double? quality]) : quality = quality ?? 1.0;

  /// Converts the [LanguageQuality] instance into a string representation suitable for HTTP headers.
  String toHeaderString() => quality == 1.0 ? language : '$language;q=$quality';

  @override
  String toString() =>
      'LanguageQuality(language: $language, quality: $quality)';
}
