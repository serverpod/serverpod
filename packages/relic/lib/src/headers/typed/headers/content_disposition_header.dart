import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';

/// A class representing the HTTP Content-Disposition header.
///
/// This class manages the disposition type, such as `inline`, `attachment`,
/// or `form-data`, and optional attributes like `filename`, `name`, and
/// `filename*`. It provides functionality to parse the header value and
/// construct the appropriate header string.
class ContentDispositionHeader implements TypedHeader {
  /// The disposition type, usually "inline", "attachment", or "form-data".
  final String type;

  /// A list of parameters associated with the content disposition, such as
  /// filename or name.
  final List<ContentDispositionParameter> parameters;

  /// Constructs a [ContentDispositionHeader] instance with the specified type
  /// and parameters.
  const ContentDispositionHeader({
    required this.type,
    this.parameters = const [],
  });

  /// Parses the Content-Disposition header value and returns a
  /// [ContentDispositionHeader] instance.
  ///
  /// This method splits the header by `;` and processes the type and attributes.
  factory ContentDispositionHeader.parse(String value) {
    var splitValues = value.splitTrimAndFilterUnique(separator: ';');

    if (splitValues.isEmpty) {
      throw FormatException('Value cannot be empty');
    }

    var type = splitValues.first;
    if (type.isEmpty || type.contains('=')) {
      throw FormatException('Type cannot be empty or a parameter');
    }

    var parameters =
        splitValues.skip(1).map(ContentDispositionParameter.parse).toList();

    return ContentDispositionHeader(
      type: type,
      parameters: parameters,
    );
  }

  /// Converts the [ContentDispositionHeader] instance into a string
  /// representation suitable for HTTP headers.
  @override
  String toHeaderString() {
    List<String> parts = [type];
    parts.addAll(parameters.map((p) => p.toHeaderString()));
    return parts.join('; ');
  }

  @override
  String toString() {
    return 'ContentDispositionHeader(type: $type, parameters: $parameters)';
  }
}

/// A class representing a parameter for the Content-Disposition header.
class ContentDispositionParameter {
  /// The name of the parameter (e.g., `filename`, `name`).
  final String name;

  /// The value of the parameter.
  final String value;

  /// Whether the parameter uses extended encoding (e.g., `filename*`).
  final bool isExtended;

  /// The character encoding used, if specified (e.g., `UTF-8`).
  final String? encoding;

  /// The optional language tag, if specified (e.g., `en`).
  final String? language;

  /// Constructs a [ContentDispositionParameter] with the specified name, value,
  /// and whether it uses extended encoding.
  const ContentDispositionParameter({
    required this.name,
    required this.value,
    this.isExtended = false,
    this.encoding,
    this.language,
  });

  /// Parses a parameter string and returns a [ContentDispositionParameter]
  /// instance.
  factory ContentDispositionParameter.parse(String part) {
    var keyValue = part.split('=').map((e) => e.trim()).toList();

    if (keyValue.length != 2) {
      throw FormatException('Invalid parameter format');
    }

    var name = keyValue[0];
    var value = keyValue[1].replaceAll('"', '');
    bool isExtended = name.endsWith('*');
    String? encoding;
    String? language;

    if (isExtended) {
      var extendedRegex = RegExp(r"^([\w-]+)''?([\w-]*)'(.*)");
      var match = extendedRegex.firstMatch(value);
      if (match != null) {
        encoding = match.group(1);
        language = match.group(2)?.isNotEmpty != true ? null : match.group(2);
        value = Uri.decodeComponent(match.group(3)!);
      }
    }

    return ContentDispositionParameter(
      name: name.replaceAll('*', ''),
      value: value,
      isExtended: isExtended,
      encoding: encoding,
      language: language,
    );
  }

  /// Converts the [ContentDispositionParameter] instance into a string
  /// representation suitable for HTTP headers.
  String toHeaderString() {
    if (isExtended) {
      // If language is provided, format as encoding'language'filename
      if (language != null) {
        return '$name*=$encoding\'$language\'${Uri.encodeComponent(value)}';
      }
      // If no language, format as encoding''filename without adding extra quotes
      return '$name*=$encoding\'\'${Uri.encodeComponent(value)}';
    }
    return '$name="$value"';
  }

  @override
  String toString() {
    return 'ContentDispositionParameter(name: $name, value: $value, '
        'isExtended: $isExtended, encoding: $encoding, language: $language)';
  }
}
