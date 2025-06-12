import 'dart:typed_data';

// ignore: implementation_imports
import 'package:postgres/src/types/text_codec.dart';
import 'package:serverpod/serverpod.dart';

/// Overrides the [PostgresTextEncoder] to add support for [ByteData].
class ValueEncoder extends PostgresTextEncoder {
  @override
  String convert(
    dynamic input, {
    bool escapeStrings = true,
    bool hasDefaults = false,
  }) {
    if (input == null) {
      return hasDefaults ? 'DEFAULT' : 'NULL';
    } else if (input is ByteData) {
      return input.base64encodedString();
    } else if (input is DateTime) {
      return super.convert(
        SerializationManager.encode(input),
        escapeStrings: escapeStrings,
      );
    } else if (input is Duration) {
      return super.convert(
        SerializationManager.encode(input),
        escapeStrings: escapeStrings,
      );
    } else if (input is UuidValue) {
      return "'${input.uuid}'";
    } else if (input is Uri) {
      return "'${input.toString()}'";
    } else if (input is BigInt) {
      return '\'${input.toString()}\'';
    } else if (input is String &&
        input.startsWith('decode(\'') &&
        input.endsWith('\', \'base64\')')) {
      // TODO:
      // This is a bit of a hack to get ByteData working. Strings that starts
      // with `convert('` and ends with `', 'base64') will be incorrectly
      // encoded to base64. Best would be to find a better way to detect when we
      // are trying to store a ByteData.
      return input;
    } else if (input is Vector) {
      return '\'${input.toString().replaceAll(' ', '')}\'';
    } else if (input is HalfVector) {
      return '\'${input.toString().replaceAll(' ', '')}\'';
    } else if (input is SparseVector) {
      return '\'${input.toString()}\'';
    } else if (input is Bit) {
      return '\'${input.toString()}\'';
    } else if (input is SerializableModel && input is Enum) {
      return super.convert(
        input.toJson(),
        escapeStrings: escapeStrings,
      );
    } else if (input is List || input is Map || input is Set) {
      return super.convert(
        SerializationManager.encode(input),
        escapeStrings: escapeStrings,
      );
    }

    try {
      return super.convert(input, escapeStrings: escapeStrings);
    } catch (e) {
      // super.convert failed, therefore value must be a json serializable type.
      return super.convert(SerializationManager.encode(input),
          escapeStrings: escapeStrings);
    }
  }
}
