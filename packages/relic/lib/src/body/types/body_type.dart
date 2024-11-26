import 'dart:convert';

import 'package:relic/src/body/types/mime_type.dart';

class BodyType {
  // Text

  static const plainText = BodyType(
    mimeType: MimeType.plainText,
    encoding: utf8,
  );

  static const html = BodyType(
    mimeType: MimeType.html,
    encoding: utf8,
  );

  static const css = BodyType(
    mimeType: MimeType.css,
    encoding: utf8,
  );

  static const csv = BodyType(
    mimeType: MimeType.csv,
    encoding: utf8,
  );

  static const javaScript = BodyType(
    mimeType: MimeType.javaScript,
    encoding: utf8,
  );

  static const json = BodyType(
    mimeType: MimeType.json,
    encoding: utf8,
  );

  static const xml = BodyType(
    mimeType: MimeType.xml,
    encoding: utf8,
  );

  // Binary

  static const binary = BodyType(
    mimeType: MimeType.binary,
  );

  static const pdf = BodyType(
    mimeType: MimeType.pdf,
  );

  static const rtf = BodyType(
    mimeType: MimeType.rtf,
  );

  final MimeType mimeType;
  final Encoding? encoding;

  const BodyType({
    required this.mimeType,
    this.encoding,
  });

  @override
  String toString() {
    if (encoding != null) {
      return '${mimeType.toString()}; charset=${encoding!.name}';
    } else {
      return mimeType.toString();
    }
  }
}
