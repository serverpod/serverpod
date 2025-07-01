import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Expose toJson on DateTime
/// Expose static fromJson builder
extension DateTimeJsonExtension on DateTime {
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
extension DurationJsonExtension on Duration {
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
extension UuidValueJsonExtension on UuidValue {
  /// Returns a deserialized version of the [UuidValue].
  static UuidValue fromJson(dynamic value) {
    if (value is UuidValue) return value;
    return UuidValue.withValidation(value as String);
  }

  /// Returns a serialized version of the [UuidValue] as a [String].
  String toJson() => uuid;
}

/// Expose toJson on Uri
/// Expose static fromJson builder
extension UriJsonExtension on Uri {
  /// Returns a deserialized version of the [UuidValue].
  static Uri fromJson(dynamic value) {
    if (value is Uri) return value;
    return Uri.parse(value as String);
  }

  /// Returns a serialized version of the [Uri] as a [String].
  String toJson() => toString();
}

/// Expose toJson on BigInt
/// Expose static fromJson builder
extension BigIntJsonExtension on BigInt {
  /// Returns a deserialized version of the [BigInt].
  static BigInt fromJson(dynamic value) {
    if (value is BigInt) return value;
    return BigInt.parse(value as String);
  }

  /// Returns a serialized version of the [BigInt] as a [String].
  String toJson() => toString();
}

/// Expose toJson on ByteData
/// Expose static fromJson builder
extension ByteDataJsonExtension on ByteData {
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
extension MapJsonExtension<K, V> on Map<K, V> {
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
extension ListJsonExtension<T> on List<T> {
  /// Returns a serialized version of the [List] with values serialized.
  List<dynamic> toJson({dynamic Function(T)? valueToJson}) {
    if (valueToJson == null) return this;

    return map<dynamic>(valueToJson).toList();
  }
}

/// Expose toJson on Set
extension SetJsonExtension<T> on Set<T> {
  /// Returns a serialized version of the [Set] with values serialized.
  List<dynamic> toJson({dynamic Function(T)? valueToJson}) {
    if (valueToJson == null) return toList();

    return map<dynamic>(valueToJson).toList();
  }

  /// Returns a deserialized version of the [Set].
  static Set<T>? fromJson<T>(
    dynamic value, {
    required T Function(dynamic) itemFromJson,
  }) {
    if (value is Set<T>) return value;

    var set = (value as List?)?.map(itemFromJson).toSet();

    if (set != null && value!.length != set.length) {
      throw Exception(
          'Input list for Set contained duplicate items. List with length ${value.length} resulted in a set with only ${set.length} item(s).');
    }

    return set;
  }
}

/// Expose toJson on Vector
extension VectorJsonExtension on Vector {
  /// Returns a serialized version of the [Vector] with values serialized.
  static Vector fromJson(dynamic value) {
    if (value is Uint8List) return Vector.fromBinary(value);
    if (value is String) return _fromString(value);
    if (value is List) return Vector(value.cast<double>());
    if (value is Vector) return value;

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [Vector] as a [List<double>].
  List<double> toJson() => toList();

  static Vector _fromString(String value) {
    return Vector((json.decode(value) as List).cast<double>());
  }
}

/// Expose toJson on HalfVector
extension HalfVectorJsonExtension on HalfVector {
  /// Returns a deserialized version of the [HalfVector] from various formats.
  static HalfVector fromJson(dynamic value) {
    if (value is Uint8List) return HalfVector.fromBinary(value);
    if (value is String) return _fromString(value);
    if (value is List) return HalfVector(value.cast<double>());
    if (value is HalfVector) return value;

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [HalfVector] as a [List<double>].
  List<double> toJson() => toList();

  static HalfVector _fromString(String value) {
    return HalfVector((json.decode(value) as List).cast<double>());
  }
}

/// Expose toJson on SparseVector
extension SparseVectorJsonExtension on SparseVector {
  /// Returns a deserialized version of the [SparseVector] from various formats.
  static SparseVector fromJson(dynamic value) {
    if (value is Uint8List) return SparseVector.fromBinary(value);
    if (value is String) return _fromString(value);
    if (value is List) return SparseVector(value.cast<double>());
    if (value is SparseVector) return value;

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [SparseVector] as a [String].
  String toJson() => toString();

  static SparseVector _fromString(String value) {
    // Handle string format like "{1:1.0,3:2.0,5:3.0}/6"
    if (value.startsWith('{') && value.contains('}/')) {
      return SparseVector.fromString(value);
    }
    return SparseVector((json.decode(value) as List).cast<double>());
  }
}

/// Expose toJson on Bit
extension BitJsonExtension on Bit {
  /// Returns a deserialized version of the [Bit] from various formats.
  static Bit fromJson(dynamic value) {
    if (value is Uint8List) return Bit.fromBinary(value);
    if (value is String) return _fromString(value);
    if (value is List) return _fromList(value);
    if (value is Bit) return value;

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [Bit] as a [String].
  String toJson() => toString();

  static Bit _fromList(List<dynamic> value) {
    return Bit(value.map((v) => v == 1 || v == true).toList());
  }

  static Bit _fromString(String value) {
    return value.contains('0') || value.contains('1')
        ? Bit.fromString(value)
        : _fromList(json.decode(value) as List);
  }
}
