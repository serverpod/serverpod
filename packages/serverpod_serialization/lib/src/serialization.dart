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
  /// The name of the module that defines the serialization.
  ///
  /// This method will be implemented by the generated code.
  String getModuleName() {
    throw UnimplementedError('This protocol does not have a module name.');
  }

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
      if (data == null) return null as T;
      return BoolJsonExtension.fromJson(data) as T;
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
    } else if (_isNullableType<GeographyPoint>(t)) {
      if (data == null) return null as T;
      return GeographyPointJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<GeographyLineString>(t)) {
      if (data == null) return null as T;
      return GeographyLineStringJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<GeographyPolygon>(t)) {
      if (data == null) return null as T;
      return GeographyPolygonJsonExtension.fromJson(data) as T;
    } else if (_isNullableType<GeographyGeometryCollection>(t)) {
      if (data == null) return null as T;
      return GeographyGeometryCollectionJsonExtension.fromJson(data) as T;
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
    } else if (data is GeographyPoint) {
      return 'GeographyPoint';
    } else if (data is GeographyLineString) {
      return 'GeographyLineString';
    } else if (data is GeographyPolygon) {
      return 'GeographyPolygon';
    } else if (data is GeographyGeometryCollection) {
      return 'GeographyGeometryCollection';
    }

    return null;
  }

  /// Deserialize the provided json [data] by using the className stored in the [data].
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var className = data['className'];
    var raw = data['data'];
    switch (className) {
      case 'null':
        return null;
      case 'int':
        return deserialize<int>(raw);
      case 'double':
        return deserialize<double>(raw);
      case 'String':
        return deserialize<String>(raw);
      case 'bool':
        return deserialize<bool>(raw);
      case 'DateTime':
        return deserialize<DateTime>(raw);
      case 'ByteData':
        return deserialize<ByteData>(raw);
      case 'Duration':
        return deserialize<Duration>(raw);
      case 'UuidValue':
        return deserialize<UuidValue>(raw);
      case 'Uri':
        return deserialize<Uri>(raw);
      case 'BigInt':
        return deserialize<BigInt>(raw);
      case 'Vector':
        return deserialize<Vector>(raw);
      case 'HalfVector':
        return deserialize<HalfVector>(raw);
      case 'SparseVector':
        return deserialize<SparseVector>(raw);
      case 'Bit':
        return deserialize<Bit>(raw);
      case 'GeographyPoint':
        return deserialize<GeographyPoint>(raw);
      case 'GeographyLineString':
        return deserialize<GeographyLineString>(raw);
      case 'GeographyPolygon':
        return deserialize<GeographyPolygon>(raw);
      case 'GeographyGeometryCollection':
        return deserialize<GeographyGeometryCollection>(raw);
      case 'List' when raw is List:
        return raw.map(deserializeDynamicFieldValue).toList();
      case 'Set' when raw is List:
        return raw.map(deserializeDynamicFieldValue).toSet();
      case 'Map' when raw is Map<String, dynamic>:
        return raw.map((k, v) => MapEntry(k, deserializeDynamicFieldValue(v)));
      case 'Map' when raw is List:
        return Map<dynamic, dynamic>.fromEntries(
          raw.cast<Map<String, dynamic>>().map(
            (e) => MapEntry(
              deserializeDynamicFieldValue(e['k']),
              deserializeDynamicFieldValue(e['v']),
            ),
          ),
        );
    }
    throw FormatException('No deserialization found for type named $className');
  }

  /// Decodes a value for a `dynamic` model field: a JSON object ([Map]) with
  /// `className` and `data` (see [dynamicFieldToJson]).
  dynamic deserializeDynamicFieldValue(Object? value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return deserializeByClassName(value);
    throw FormatException(
      'Dynamic fields are encoded as a Map with className and data, but got '
      '${value.runtimeType} instead.',
    );
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

  /// Returns a JSON-encodable structure for a `dynamic` model field.
  ///
  /// Recursively encodes [List], [Set], and [Map] children so each element
  /// keeps type information via `className` / `data` wrappers.
  ///
  /// When [forProtocol] is true, nested [ProtocolSerialization] values use
  /// [ProtocolSerialization.toJsonForProtocol].
  ///
  /// Module and shared package protocols override this method to resolve host
  /// project types via registered host protocols.
  Object? dynamicFieldToJson(
    Object? object, {
    bool forProtocol = false,
  }) {
    return switch (object) {
      List() => {
        'className': 'List',
        'data': [
          for (final e in object)
            dynamicFieldToJson(e, forProtocol: forProtocol),
        ],
      },
      Set() => {
        'className': 'Set',
        'data': [
          for (final e in object)
            dynamicFieldToJson(e, forProtocol: forProtocol),
        ],
      },
      Map()
          when object is Map<String, dynamic> ||
              object.keys.every((k) => k is String) =>
        {
          'className': 'Map',
          'data': {
            for (final e in object.entries)
              e.key as String: dynamicFieldToJson(
                e.value,
                forProtocol: forProtocol,
              ),
          },
        },
      Map() => {
        'className': 'Map',
        'data': [
          for (final e in object.entries)
            {
              'k': dynamicFieldToJson(e.key, forProtocol: forProtocol),
              'v': dynamicFieldToJson(e.value, forProtocol: forProtocol),
            },
        ],
      },
      _ => _toEncodable(wrapWithClassName(object), forProtocol),
    };
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
  'GeographyPoint',
  'GeographyLineString',
  'GeographyPolygon',
  'GeographyGeometryCollection',
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
