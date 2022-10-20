import 'dart:convert';
import 'dart:typed_data';

// ignore: implementation_imports
import 'package:postgres/src/text_codec.dart';
import 'package:serverpod/serverpod.dart';

/// Overrides the [PostgresTextEncoder] to add support for [ByteData].
class ValueEncoder extends PostgresTextEncoder {
  @override
  String convert(value, {bool escapeStrings = true}) {
    if (value is ByteData || value is DateTime) {
      return super.convert(SerializationManager.serializeToJson(value),
          escapeStrings: escapeStrings);
    } else if (value is String &&
        value.startsWith('decode(\'') &&
        value.endsWith('\', \'base64\')')) {
      // TODO:
      // This is a bit of a hack to get ByteData working. Strings that starts
      // with `convert('` and ends with `', 'base64') will be incorrectly
      // encoded to base64. Best would be to find a better way to detect when we
      // are trying to store a ByteData.
      return value;
    } else if (value is List || value is Map || value is Set) {
      return super.convert(SerializationManager.serializeToJson(value),
          escapeStrings: escapeStrings);
    }
    try {
      return super.convert(value, escapeStrings: escapeStrings);
    } catch (e) {
      // super.convert failed, therefore value must be a json serializable type.
      return super.convert(SerializationManager.serializeToJson(value),
          escapeStrings: escapeStrings);
    }
  }
}
