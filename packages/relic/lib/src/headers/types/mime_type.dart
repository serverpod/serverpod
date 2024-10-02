import 'dart:io';

class MimeType {
  static const plainText = MimeType('text', 'plain');

  static const html = MimeType('text', 'html');

  static const css = MimeType('text', 'css');

  static const csv = MimeType('text', 'csv');

  static const javaScript = MimeType('text', 'javascript');

  static const json = MimeType('application', 'json');

  static const xml = MimeType('application', 'xml');

  // Binary

  static const binary = MimeType('application', 'octet-stream');

  static const pdf = MimeType('application', 'pdf');

  static const rtf = MimeType('application', 'rtf');

  final String primaryType;
  final String subType;

  const MimeType(this.primaryType, this.subType);

  factory MimeType.parse(String type) {
    var parts = type.split('/');
    if (parts.length != 2) {
      throw FormatException('Invalid mime type $type');
    }

    var primaryType = parts[0];
    var subType = parts[1];

    if (primaryType.isEmpty || subType.isEmpty) {
      throw FormatException('Invalid mime type $type');
    }
    return MimeType(primaryType, subType);
  }

  static MimeType? byContentType(ContentType? type) {
    if (type == null) return null;
    return MimeType(
      type.primaryType,
      type.subType,
    );
  }

  static MimeType? tryParse(String? value) {
    if (value == null) return null;
    return MimeType.parse(value);
  }

  @override
  String toString() => '$primaryType/$subType';
}
