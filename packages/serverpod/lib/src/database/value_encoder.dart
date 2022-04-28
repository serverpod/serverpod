import 'dart:convert';
import 'dart:typed_data';

// ignore: implementation_imports
import 'package:postgres/src/text_codec.dart';

/// Overrides the [PostgresTextEncoder] to add support for [ByteData].
class ValueEncoder extends PostgresTextEncoder {
  @override
  String convert(dynamic value, {bool escapeStrings = true}) {
    if (value is ByteData) {
      String encoded = base64Encode(value.buffer.asUint8List());
      return 'decode(\'$encoded\', \'base64\')';
    }
    return super.convert(value, escapeStrings: escapeStrings);
  }
}
