import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import '../../../serverpod_database.dart';

/// Encodes values for SQLite SQL literals.
///
/// Column-specific shaping is done through [coerceColumnValue] and encoding is
/// done through [convert]. Use [encodeColumnValue] to encode a model value for
/// a column.
class SqliteValueEncoder implements ValueEncoder {
  /// Creates a new [SqliteValueEncoder].
  const SqliteValueEncoder();

  @override
  String convert(
    dynamic input, {
    bool escapeStrings = true,
    bool hasDefaults = false,
  }) {
    if (input == null) {
      return hasDefaults ? 'DEFAULT' : 'NULL';
    } else if (input is bool) {
      return input ? '1' : '0';
    } else if (input is int) {
      return input.toString();
    } else if (input is double) {
      if (input.isNaN) return 'NULL';
      if (input.isInfinite) return input.isNegative ? '-1e999' : '1e999';
      return input.toString();
    } else if (input is ByteData) {
      // Store as BLOB literal so SQLite BLOB columns accept it (strict mode).
      final bytes = Uint8List.view(
        input.buffer,
        input.offsetInBytes,
        input.lengthInBytes,
      );
      final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      return "X'$hex'";
    } else if (input is DateTime) {
      return input.millisecondsSinceEpoch.toString();
    } else if (input is Duration) {
      return SerializationManager.encode(input).toString();
    } else if (input is UuidValue) {
      // Store as BLOB to be more efficient.
      final hex = input.uuid.replaceAll('-', '').toLowerCase();
      return "X'$hex'";
    } else if (input is Uri) {
      return "'${_escapeString(input.toString())}'";
    } else if (input is BigInt) {
      return "'${input.toString()}'";
    } else if (input is String) {
      if (input.startsWith('decode(\'') && input.endsWith('\', \'base64\')')) {
        // This is a bit of a hack to get ByteData working. Strings that starts
        // with `decode('` and ends with `', 'base64') will be incorrectly
        // encoded to base64. Best would be to find a better way to detect when
        // we are trying to store a ByteData.
        return input;
      }
      if (!escapeStrings) return input;
      return "'${_escapeString(input)}'";
    } else if (input is Vector ||
        input is HalfVector ||
        input is SparseVector ||
        input is Bit) {
      // Store pgvector types as text for SQLite (no native vector support).
      return '\'${input.toString().replaceAll(' ', '')}\'';
    } else if (input is SerializableModel && input is Enum) {
      // Enum.toJson() may return name (String) or index (int).
      return switch (input.toJson()) {
        String s => "'${_escapeString(s)}'",
        int i => i.toString(),
        dynamic v => throw Exception('Unexpected value from Enum.toJson(): $v'),
      };
    } else if (input is List || input is Map || input is Set) {
      return "'${_escapeString(SerializationManager.encode(input))}'";
    }

    try {
      return _convertScalar(input, escapeStrings: escapeStrings);
    } catch (_) {
      return "'${_escapeString(SerializationManager.encode(input))}'";
    }
  }

  String _convertScalar(dynamic input, {required bool escapeStrings}) {
    if (input is num) return input.toString();
    if (input is String) return "'${_escapeString(input)}'";
    return "'${_escapeString(SerializationManager.encode(input))}'";
  }

  /// Escapes text for SQLite **string literals** in `'...'` form.
  ///
  /// SQL only requires doubling single quotes (`'` -> `''`). Other characters
  /// (newlines, `%`, `\`, Unicode) are literal and must not be backslash-escaped.
  static String _escapeString(String s) {
    return s.replaceAll("'", "''");
  }

  @override
  String? tryConvert(Object? input, {bool escapeStrings = false}) {
    try {
      return convert(input, escapeStrings: escapeStrings);
    } catch (_) {
      return null;
    }
  }

  /// Converts driver shapes (e.g. int -> bool) and decodes serializable JSON.
  dynamic coerceColumnValue(
    Column column,
    dynamic value,
  ) {
    if (value == null) return null;
    return switch (column) {
      ColumnBool() => BoolJsonExtension.fromJson(value),
      ColumnDateTime() => DateTimeJsonExtension.fromJson(value),
      ColumnDuration() => DurationJsonExtension.fromJson(value),
      ColumnUuid() => UuidValueJsonExtension.fromJson(value),
      ColumnByteData() => ByteDataJsonExtension.fromJson(value),
      ColumnSerializable() => _decodeJsonValue(value),
      _ => value,
    };
  }

  /// Coerces [value] for [column] as a model value.
  String encodeColumnValue(
    Column column,
    dynamic value, {
    bool hasDefaults = false,
  }) {
    return convert(
      column is ColumnSerializable
          ? SerializationManager.encode(value)
          : coerceColumnValue(column, value),
      hasDefaults: hasDefaults,
    );
  }

  static dynamic _decodeJsonValue(dynamic value) {
    if (value is String) {
      try {
        return _normalizeDecodedJson(jsonDecode(value));
      } on FormatException {
        return value;
      }
    }
    if (value is Map || value is List) {
      return _normalizeDecodedJson(value);
    }
    return value;
  }

  static dynamic _normalizeDecodedJson(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(
        value.map(
          (key, nestedValue) => MapEntry(
            key is String ? key : key.toString(),
            _normalizeDecodedJson(nestedValue),
          ),
        ),
      );
    }
    if (value is List) {
      return value.map(_normalizeDecodedJson).toList();
    }
    return value;
  }
}
