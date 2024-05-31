// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Exception thrown when no deserialization type was found during
/// protocol deserialization
class DeserializationTypeNotFoundException implements Exception {
  /// The exception message that was thrown.
  final String message;

  /// The type that was not found.
  final Type? type;

  /// Creates a new [DeserializationTypeNotFoundException].
  DeserializationTypeNotFoundException({
    String? message,
    this.type,
  }) : message = message ?? 'No deserialization found for type $type';

  @override
  String toString() => message;
}

/// **DEPRECATED**: This class is deprecated and will be removed in version 2.1.
/// Please implement the [SerializableModel] interface instead for creating serializable
/// models.
///
/// **Migration Guide**:
/// - Replace `extends SerializableEntity` with `implements SerializableModel`
///   in your model classes.
///
/// ```dart
/// // Before:
/// class CustomClass extends SerializableEntity {
///   // Your code here
/// }
///
/// // After:
/// class CustomClass implements SerializableModel {
///   // Your code here
/// }
/// ```
///
/// For more details, refer to the
/// [migration documentation](https://docs.serverpod.dev/next/upgrading/upgrade-to-two)
@Deprecated(
  'This class is deprecated and will be removed in version 2.1. '
  'Please implement SerializableModel instead.',
)
abstract mixin class SerializableEntity implements SerializableModel {
  @override
  String toString() {
    return SerializationManager.encode(this);
  }
}

/// The [SerializableModel] is the base interface for all serializable objects in
/// Serverpod, except primitives.
abstract interface class SerializableModel {
  /// Returns a serialized JSON structure of the model which also includes
  /// fields used by the database.
  dynamic toJson();
}

/// The [ProtocolSerialization] defines a toJsonForProtocol method which makes it
/// possible to limit what fields are serialized
abstract interface class ProtocolSerialization {
  /// Returns a JSON structure of the model, optimized for Protocol communication.
  dynamic toJsonForProtocol();
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
      if (data == null) return null as T;
      return DateTimeJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<ByteData>(t)) {
      if (data == null) return null as T;
      return ByteDataJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<Duration>(t)) {
      if (data == null) return null as T;
      return DurationJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<UuidValue>(t)) {
      if (data == null) return null as T;
      return UuidValueJsonExtension.fromJson(data) as T;
    }

    throw DeserializationTypeNotFoundException(
      type: t,
    );
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
      'data': data is ProtocolSerialization ? data.toJsonForProtocol() : data,
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
    ).convert(object);
  }

  /// Encode the provided [object] to a Json-formatted [String].
  /// if object implements [ProtocolSerialization] interface then
  /// [toJsonForProtocol] it will be used instead of [toJson] method
  static String encodeForProtocol(
    Object? object, {
    bool formatted = false,
  }) {
    if (object is ProtocolSerialization) {
      return encode(object.toJsonForProtocol(), formatted: formatted);
    }

    return encode(object, formatted: formatted);
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
