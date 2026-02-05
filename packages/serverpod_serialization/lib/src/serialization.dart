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
    } else if (_isNullableType<Vector>(t)) {
      if (data == null) return null as T;
      return VectorJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<HalfVector>(t)) {
      if (data == null) return null as T;
      return HalfVectorJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<SparseVector>(t)) {
      if (data == null) return null as T;
      return SparseVectorJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<Bit>(t)) {
      if (data == null) return null as T;
      return BitJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<Uri>(t)) {
      if (data == null) return null as T;
      return Uri.parse(data) as T;
    } else if (_isNullableType<BigInt>(t)) {
      if (data == null) return null as T;
      return BigInt.parse(data) as T;
    }

    throw DeserializationTypeNotFoundException(
      type: t,
    );
  }

  /// Get the className for the provided object.
  String? getClassNameForObject(Object? data) {
    if (data == null) {
      return 'null';
    } else if (data is int) {
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
    } else if (data is Uri) {
      return 'Uri';
    } else if (data is BigInt) {
      return 'BigInt';
    } else if (data is Vector) {
      return 'Vector';
    } else if (data is HalfVector) {
      return 'HalfVector';
    } else if (data is SparseVector) {
      return 'SparseVector';
    } else if (data is Bit) {
      return 'Bit';
    }

    return null;
  }

  /// Deserialize the provided json [data] by using the className stored in the [data].
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var className = data['className'];
    switch (className) {
      case 'null':
        return null;
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
      case 'Uri':
        return deserialize<Uri>(data['data']);
      case 'BigInt':
        return deserialize<BigInt>(data['data']);
      case 'Vector':
        return deserialize<Vector>(data['data']);
      case 'HalfVector':
        return deserialize<HalfVector>(data['data']);
      case 'SparseVector':
        return deserialize<SparseVector>(data['data']);
      case 'Bit':
        return deserialize<Bit>(data['data']);
    }
    throw FormatException('No deserialization found for type named $className');
  }

  /// Wraps serialized data with its class name so that it can be deserialized
  /// with [deserializeByClassName].
  Map<String, dynamic> wrapWithClassName(Object? data) {
    var className = getClassNameForObject(data);
    if (className == null) {
      throw ArgumentError(
        'Could not find class name for ${data.runtimeType} in serialization.',
      );
    }

    return {
      'className': className,
      'data': data,
    };
  }

  /// Converts an object to a JSON-encodable format.
  /// This method is used by the JSON encoder to convert objects to JSON.
  static Object? toEncodable(Object? object) => _toEncodable(object, false);

  /// Converts the provided [object] to a format suitable for protocol serialization.
  /// If the object is a [ProtocolSerialization], it will be converted to JSON using
  /// the [toJsonForProtocol] method.
  static Object? toEncodableForProtocol(Object? object) =>
      _toEncodable(object, true);

  static Object? _toEncodable(Object? object, bool encodeForProtocol) =>
      switch (object) {
        null => null,
        bool() => object,
        num() => object,
        String() => object,
        List<dynamic> l => [
          for (final i in l) _toEncodable(i, encodeForProtocol),
        ],
        Map<String, dynamic> m => {
          for (final i in m.entries)
            i.key: _toEncodable(i.value, encodeForProtocol),
        },
        DateTime() => object.toUtc().toIso8601String(),
        ByteData() => object.base64encodedString(),
        Duration() => object.inMilliseconds,
        UuidValue() => object.uuid,
        Uri() => object.toString(),
        BigInt() => object.toString(),
        Vector() => object.toList(),
        HalfVector() => object.toList(),
        SparseVector() => object.toList(),
        Bit() => object.toList(),
        Set<dynamic> s => [
          for (final i in s) _toEncodable(i, encodeForProtocol),
        ],
        ProtocolSerialization() when encodeForProtocol =>
          object.toJsonForProtocol(),
        Map(keyType: != String) => [
          for (final e in object.entries)
            {
              'k': _toEncodable(e.key, encodeForProtocol),
              'v': _toEncodable(e.value, encodeForProtocol),
            },
        ],
        Record() => throw Exception(
          'Records are not supported. '
          'They must be converted beforehand via `Protocol.mapRecordToJson` '
          'or the enclosing `SerializableModel`.',
        ),
        SerializableModel() => object.toJson(),
        _ => object.safeToJson(),
      };

  /// Encode the provided [object] to a Json-formatted [String].
  /// If [formatted] is true, the output will be formatted with two spaces
  /// indentation.
  static String encode(
    Object? object, {
    bool formatted = false,
    bool encodeForProtocol = false,
  }) {
    final encoder = JsonEncoder.withIndent(
      formatted ? '  ' : null,
      encodeForProtocol ? toEncodableForProtocol : toEncodable,
    );
    return encoder.convert(object);
  }

  /// Encode the provided [object] to a Json-formatted [String].
  /// if object implements [ProtocolSerialization] interface then
  /// [toJsonForProtocol] it will be used instead of [toJson] method
  static String encodeForProtocol(
    Object? object, {
    bool formatted = false,
  }) {
    return encode(
      object,
      formatted: formatted,
      encodeForProtocol: true,
    );
  }

  /// Encode the provided [object] to a json-formatted [String], include class
  /// name so that it can be decoded even if the class is unknown.
  /// If [formatted] is true, the output will be formatted with two spaces
  /// indentation.
  String encodeWithType(
    Object? object, {
    bool formatted = false,
  }) {
    return encode(
      wrapWithClassName(object),
      formatted: formatted,
    );
  }

  /// Encode the provided [object] to a Json-formatted [String], including the
  /// class name so that it can be decoded even if the class is unknown.
  /// If [formatted] is true, the output will be formatted with two spaces
  /// indentation. If [object] implements [ProtocolSerialization] interface, then
  /// [toJsonForProtocol] will be used instead of the [toJson] method.
  String encodeWithTypeForProtocol(
    Object? object, {
    bool formatted = false,
  }) {
    return encode(
      wrapWithClassName(object),
      formatted: formatted,
      encodeForProtocol: true,
    );
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
  'Uri',
  'BigInt',
  'Vector',
  'HalfVector',
  'SparseVector',
  'Bit',
  'Map',
  'List',
  'Set',
];

extension<K, V> on Map<K, V> {
  Type get keyType => K;
}

extension on Object? {
  /// Returns a safe JSON representation of the object.
  /// If the object does not implement the [toJson] method,
  /// it will be returned as is.
  Object? safeToJson() {
    try {
      return (this as dynamic).toJson();
    } catch (_) {
      return this;
    }
  }
}
