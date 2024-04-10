import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Expose toJson on DateTime
/// Expose static fromJson builder
extension DateTimeExt on DateTime {
  /// Returns a deserialized version of the [DateTime].
  static DateTime fromJson(dynamic value) {
    if (value is DateTime) return value;
    return DateTime.parse(value as String);
  }

  /// Returns a serialized version of the [DateTime] in UTC.
  String toJson() => toUtc().toIso8601String();
}

/// Expose toJson on Duration
/// Expose static fromJson builder
extension DurationExt on Duration {
  /// Returns a deserialized version of the [Duration].
  static Duration fromJson<T>(dynamic value) {
    if (value is Duration) return value;
    return Duration(milliseconds: value as int);
  }

  /// Returns a serialized version of the [Duration] in milliseconds.
  int toJson() => inMilliseconds;
}

/// Expose toJson on UuidValue
/// Expose static fromJson builder
extension UuidValueExt on UuidValue {
  /// Returns a deserialized version of the [UuidValue].
  static UuidValue fromJson(dynamic value) {
    if (value is UuidValue) return value;
    return UuidValue.fromString(value as String);
  }

  /// Returns a serialized version of the [UuidValue] as a [String].
  String toJson() => uuid;
}

/// Expose toJson on ByteData
/// Expose static fromJson builder
extension ByteDataExt on ByteData {
  /// Returns a deserialized version of the [ByteData]
  static ByteData fromJson(dynamic value) {
    if (value is ByteData) return value;
    if (value is Uint8List) {
      return ByteData.view(
        value.buffer,
        value.offsetInBytes,
        value.lengthInBytes,
      );
    }

    return (value as String).base64DecodedNullSafeByteData();
  }

  /// Returns a serialized version of the [ByteData] as a base64 encoded
  /// [String].
  String toJson() => base64encodedString();
}

/// Expose toJson on Map
extension MapExt<K, V> on Map<K, V> {
  Type get _keyType => K;

  /// Returns a serialized version of the [Map] with keys and values serialized.
  dynamic toJson({
    dynamic Function(K)? keyToJson,
    dynamic Function(V)? valueToJson,
  }) {
    if (_keyType == String && keyToJson == null && valueToJson == null) {
      return this;
    }

    // This implementation is here to support the old decoder behavior
    // this should not be needed if the decoder is updated to not look for a nested
    // map with 'k' and 'v' keys. If that is done the return type can be changed
    // to Map<dynamic, dynamic>.
    if (_keyType != String) {
      return entries.map((e) {
        var serializedKey = keyToJson != null ? keyToJson(e.key) : e.key;
        var serializedValue =
            valueToJson != null ? valueToJson(e.value) : e.value;
        return {'k': serializedKey, 'v': serializedValue};
      }).toList();
    }

    return map((key, value) {
      var serializedKey = keyToJson != null ? keyToJson(key) : key;
      var serializedValue = valueToJson != null ? valueToJson(value) : value;
      return MapEntry(serializedKey, serializedValue);
    });
  }
}

/// Expose toJson on List
extension ListExt<T> on List<T> {
  /// Returns a serialized version of the [List] with values serialized.
  List<dynamic> toJson({dynamic Function(T)? valueToJson}) {
    if (valueToJson == null) return this;

    return map<dynamic>(valueToJson).toList();
  }
}
