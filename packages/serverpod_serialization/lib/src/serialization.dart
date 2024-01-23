// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// The constructor takes JSON structure and turns it into a decoded
/// [SerializableEntity].
typedef constructor<T> = T Function(
    dynamic jsonSerialization, SerializationManager serializationManager);

/// The [SerializableEntity] is the base class for all serializable objects in
/// Serverpod, except primitives.
abstract mixin class SerializableEntity {
  /// Returns a serialized JSON structure of the model, ready to be sent
  /// through the API. This does not include fields that are marked as
  /// database only.
  dynamic toJson();

  /// Returns a serialized JSON structure of the model which also includes
  /// fields used by the database.
  dynamic allToJson() => toJson();

  @override
  String toString() {
    return SerializationManager.encode(this);
  }
}

/// Get the type provided as an generic. Useful for getting a nullable type.
Type getType<T>() => T;

/// The [SerializationManager] is responsible for creating objects from a
/// serialization, but also for serializing objects. This class is typically
/// extended by generated code.
abstract class SerializationManager {
  /// Decodes the provided json [String] to an object of type [t] or [T].
  T decode<T>(String data, [Type? t]) {
    return deserialize<T>(jsonDecode(data), t);
  }

  /// Decodes the provided json [String] if it has been encoded with
  /// [encodeWithType].
  Object? decodeWithType(String data) {
    return deserializeByClassName(jsonDecode(data));
  }

  bool _isType<T1, T2>(Type t) => t == T1 || t == T2;

  bool _isNullableType<T>(Type t) => _isType<T, T?>(t);

  /// Deserialize the provided json [data] to an object of type [t] or [T].
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;

    //TODO: all the "dart native" types should be listed here
    if (_isNullableType<int>(t)) {
      return data;
    } else if (_isNullableType<double>(t)) {
      return (data as num?)?.toDouble() as T;
    } else if (_isNullableType<String>(t)) {
      return data;
    } else if (_isNullableType<bool>(t)) {
      return data;
    } else if (_isNullableType<DateTime>(t)) {
      if (data is DateTime) return data as T;
      if (data == null) return null as T;
      return DateTime.tryParse(data)?.toUtc() as T;
    } else if (_isNullableType<ByteData>(t)) {
      if (data is Uint8List) {
        var byteData = ByteData.view(
          data.buffer,
          data.offsetInBytes,
          data.lengthInBytes,
        );
        return byteData as T;
      } else {
        return (data as String?)?.base64DecodedByteData() as T;
      }
    } else if (_isNullableType<Duration>(t)) {
      return data == null ? data : Duration(milliseconds: (data as int)) as T;
    } else if (_isNullableType<UuidValue>(t)) {
      return (data == null ? null : UuidValue.fromString(data as String)) as T;
    }
    throw FormatException('No deserialization found for type $t');
  }

  /// Get the className for the provided object.
  String? getClassNameForObject(Object data) {
    if (data is int) {
      return 'int';
    } else if (data is double) {
      return 'double';
    } else if (data is String) {
      return 'String';
    } else if (data is bool) {
      return 'bool';
    } else if (data is DateTime) {
      return 'DateTime';
    } else if (data is ByteData) {
      return 'ByteData';
    } else if (data is Duration) {
      return 'Duration';
    } else if (data is UuidValue) {
      return 'UuidValue';
    }
    return null;
  }

  /// Deserialize the provided json [data] by using the className stored in the [data].
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var className = data['className'];
    switch (className) {
      case 'int':
        return deserialize<int>(data['data']);
      case 'double':
        return deserialize<double>(data['data']);
      case 'String':
        return deserialize<String>(data['data']);
      case 'bool':
        return deserialize<bool>(data['data']);
      case 'DateTime':
        return deserialize<DateTime>(data['data']);
      case 'ByteData':
        return deserialize<ByteData>(data['data']);
      case 'Duration':
        return deserialize<Duration>(data['data']);
      case 'UuidValue':
        return deserialize<UuidValue>(data['data']);
    }
    throw FormatException('No deserialization found for type named $className');
  }

  /// Wraps serialized data with its class name so that it can be deserialized
  /// with [deserializeByClassName].
  Map<String, dynamic> wrapWithClassName(Object data) {
    var className = getClassNameForObject(data);
    assert(
      className != null,
      'Could not find class name for ${data.runtimeType} in serialization.',
    );

    return {
      'className': className,
      'data': data,
    };
  }

  /// Encode the provided [object] to a Json-formatted [String].
  /// If [formatted] is true, the output will be formatted with two spaces
  /// indentation.
  static String encode(Object? object, {bool formatted = false}) {
    // This is the only time [jsonEncode] should be used in the project.
    return JsonEncoder.withIndent(
      formatted ? '  ' : null,
      (nonEncodable) {
        //TODO: Remove this in 2.0.0 as the extensions should be used instead.
        if (nonEncodable is DateTime) {
          return nonEncodable.toUtc().toIso8601String();
        } else if (nonEncodable is ByteData) {
          return nonEncodable.base64encodedString();
        } else if (nonEncodable is Duration) {
          return nonEncodable.inMilliseconds;
        } else if (nonEncodable is UuidValue) {
          return nonEncodable.uuid;
        } else if (nonEncodable is Map && nonEncodable.keyType != String) {
          return nonEncodable.entries
              .map((e) => {'k': e.key, 'v': e.value})
              .toList();
        } else {
          return (nonEncodable as dynamic)?.toJson();
        }
      },
    ).convert(
      object,
    );
  }

  /// Encode the provided [object] to a json-formatted [String], include class
  /// name so that it can be decoded even if th class is unknown.
  /// If [formatted] is true, the output will be formatted with two spaces
  /// indentation.
  String encodeWithType(Object object, {bool formatted = false}) {
    return encode(wrapWithClassName(object), formatted: formatted);
  }
}

/// All datatypes that are serialized by default.
/// Used internally in Serverpod code generation.
const autoSerializedTypes = ['int', 'bool', 'double', 'String'];

/// All datatypes that has extensions to support serialization.
/// Used internally in Serverpod code generation.
const extensionSerializedTypes = [
  'DateTime',
  'ByteData',
  'Duration',
  'UuidValue',
  'Map',
  'List',
];

extension<K, V> on Map<K, V> {
  Type get keyType => K;
}

/// Expose toJson on DateTime
extension DateTimeToJson on DateTime {
  /// Returns a serialized version of the [DateTime] in UTC.
  String toJson() => toUtc().toIso8601String();
}

/// Expose toJson on Duration
extension DurationToJson on Duration {
  /// Returns a serialized version of the [Duration] in milliseconds.
  int toJson() => inMilliseconds;
}

/// Expose toJson on UuidValue
extension UuidValueToJson on UuidValue {
  /// Returns a serialized version of the [UuidValue] as a [String].
  String toJson() => uuid;
}

/// Expose toJson on ByteData
extension ByteDataToJson on ByteData {
  /// Returns a serialized version of the [ByteData] as a base64 encoded
  /// [String].
  String toJson() => base64encodedString();
}

/// Expose toJson on Map
extension MapToJson<K, V> on Map<K, V> {
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
extension ListToJson<T> on List<T> {
  /// Returns a serialized version of the [List] with values serialized.
  List<dynamic> toJson({dynamic Function(T)? valueToJson}) {
    if (valueToJson == null) return this;

    return map<dynamic>(valueToJson).toList();
  }
}
