import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Content-Language header.
///
/// This class manages the language codes specified in the Content-Language header.
class ContentLanguageHeader implements TypedHeader {
  /// The list of language codes specified in the header.
  final List<String> languages;

  /// Constructs a [ContentLanguageHeader] instance with the specified language codes.
  const ContentLanguageHeader({required this.languages});

  /// Parses the Content-Language header value and returns a [ContentLanguageHeader] instance.
  ///
  /// This method splits the header value by commas and trims each language code.
  factory ContentLanguageHeader.parse(List<String> values) {
    final splitValues = values.splitTrimAndFilterUnique();
    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    var languages = splitValues.map((language) {
      if (!language.isValidLanguageCode()) {
        throw FormatException('Invalid language code');
      }
      return language;
    }).toList();

    return ContentLanguageHeader(languages: languages);
  }

  /// Converts the [ContentLanguageHeader] instance into a string representation
  /// suitable for HTTP headers.
  @override
  String toHeaderString() => languages.join(', ');

  @override
  String toString() {
    return 'ContentLanguageHeader(languages: $languages)';
  }
}
