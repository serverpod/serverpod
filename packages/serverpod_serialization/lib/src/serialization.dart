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
abstract class SerializableEntity {
  /// Returns a serialized JSON structure of the entity, ready to be sent
  /// through the API. This does not include fields that are marked as
  /// database only.
  dynamic toJson();

  /// Returns a serialized JSON structure of the entity which also includes
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

  bool _isAssignableToMaybeNullable<T1, T2>(dynamic data, Type t) =>
      t == T1 && data is T1 || t == T2 && data is T2;

  bool _isAssignableTo<T>(dynamic data, Type t) =>
      _isAssignableToMaybeNullable<T, T?>(data, t);

  bool _isConvertibleToMaybeNullable<TFrom, TFromNullable, TTo, TToNullable>(
          dynamic data, Type t) =>
      t == TTo && data is TFrom || t == TToNullable && data is TFromNullable;

  bool _isConvertibleTo<TFrom, TTo>(dynamic data, Type t) =>
      _isConvertibleToMaybeNullable<TFrom, TFrom?, TTo, TTo?>(data, t);

  /// Deserialize the provided json [data] to an object of type [t] or [T].
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;

    //TODO: all the "dart native" types should be listed here
    if (_isAssignableTo<int>(data, t)) {
      return data as T;
    } else if (_isAssignableTo<double>(data, t)) {
      return (data as num?)?.toDouble() as T;
    } else if (_isAssignableTo<String>(data, t)) {
      return data as T;
    } else if (_isAssignableTo<bool>(data, t)) {
      return data as T;
    } else if (_isAssignableTo<DateTime>(data, t)) {
      return data as T;
    } else if (_isConvertibleTo<String, DateTime>(data, t)) {
      return (data == null ? null : DateTime.parse(data as String).toUtc())
          as T;
    } else if (_isConvertibleTo<Uint8List, ByteData>(data, t)) {
      return (data == null ? null : (data as Uint8List).buffer.asByteData())
          as T;
    } else if (_isConvertibleTo<String, ByteData>(data, t)) {
      return (data == null ? null : (data as String).base64DecodedByteData())
          as T;
    } else if (_isConvertibleTo<int, Duration>(data, t)) {
      return (data == null ? null : Duration(milliseconds: (data as int))) as T;
    } else if (_isConvertibleTo<String, UuidValue>(data, t)) {
      return (data == null ? null : UuidValue(data as String)) as T;
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
  static String encode(Object? object) {
    // This is the only time [jsonEncode] should be used in the project.
    return jsonEncode(
      object,
      toEncodable: (nonEncodable) {
        //TODO: all the "dart native" types should be listed here
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
    );
  }

  /// Encode the provided [object] to a json-formatted [String], include class
  /// name so that it can be decoded even if th class is unknown.
  String encodeWithType(Object object) {
    return encode(wrapWithClassName(object));
  }
}

extension<K, V> on Map<K, V> {
  Type get keyType => K;
}
