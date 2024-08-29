import 'dart:convert';

import 'package:relic/src/headers/types/mime_type.dart';

class BodyType {
  // Text

  static const plainText = BodyType(
    mimeType: MimeType('text', 'plain'),
    encoding: utf8,
  );

  static const html = BodyType(
    mimeType: MimeType('text', 'html'),
    encoding: utf8,
  );

  static const css = BodyType(
    mimeType: MimeType('text', 'css'),
    encoding: utf8,
  );

  static const csv = BodyType(
    mimeType: MimeType('text', 'csv'),
    encoding: utf8,
  );

  static const javaScript = BodyType(
    mimeType: MimeType('text', 'javascript'),
    encoding: utf8,
  );

  static const json = BodyType(
    mimeType: MimeType('application', 'json'),
    encoding: utf8,
  );

  static const xml = BodyType(
    mimeType: MimeType('application', 'xml'),
    encoding: utf8,
  );

  // Binary

  static const binary = BodyType(
    mimeType: MimeType('application', 'octet-stream'),
  );

  static const pdf = BodyType(
    mimeType: MimeType('application', 'pdf'),
  );

  static const rtf = BodyType(
    mimeType: MimeType('application', 'rtf'),
  );

  final MimeType mimeType;
  final Encoding? encoding;

  const BodyType({
    required this.mimeType,
    this.encoding,
  });
}
