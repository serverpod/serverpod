part of '../headers.dart';

/// A class representing the HTTP Content-Disposition header.
///
/// This class manages the disposition type, such as `inline` or `attachment`,
/// and optional attributes like `filename`. It provides functionality to parse
/// the header value and construct the appropriate header string.
class ContentDispositionHeader {
  /// The disposition type, usually "inline" or "attachment".
  final String type;

  /// The filename associated with the content, if present.
  final String? filename;

  /// Constructs a [ContentDispositionHeader] instance with the specified type and optional filename.
  const ContentDispositionHeader({
    required this.type,
    this.filename,
  });

  /// Parses the Content-Disposition header value and returns a [ContentDispositionHeader] instance.
  ///
  /// This method splits the header by `;` and processes the type and filename.
  factory ContentDispositionHeader.fromHeaderValue(String value) {
    final parts = value.split(';').map((part) => part.trim()).toList();
    final type = parts.first;
    String? filename;

    for (var part in parts.skip(1)) {
      if (part.startsWith('filename=')) {
        filename = part
            .substring(9)
            .replaceAll('"', ''); // Remove quotes around filename
      }
    }

    return ContentDispositionHeader(type: type, filename: filename);
  }

  /// Static method that attempts to parse the Content-Disposition header and returns `null` if the value is `null`.
  static ContentDispositionHeader? tryParse(String? value) {
    if (value == null) return null;
    return ContentDispositionHeader.fromHeaderValue(value);
  }

  /// Converts the [ContentDispositionHeader] instance into a string representation suitable for HTTP headers.
  @override
  String toString() {
    if (filename != null) {
      return '$type; filename="$filename"';
    }
    return type;
  }
}
