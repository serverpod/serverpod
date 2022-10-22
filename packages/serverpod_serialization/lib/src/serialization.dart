// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'bytedata_base64_ext.dart';

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
    return SerializationManager.serializeToJson(this);
  }

  /// The unique className, used to wrap the serialization when sending
  /// through stream endpoint.
  String get className;
}

/// Get the type provided as an generic. Useful for getting a nullable type.
Type getType<T>() => T;

/// The [SerializationManager] is responsible for creating objects from a
/// serialization, but also for serializing objects. This class is typically
/// extended by generated code.
abstract class SerializationManager {
  /// Adds the "dart native" types to the constructors.
  SerializationManager() {
    _appendConstructors({
      //TODO: all the "dart native" types should be listed here
      int: (jsonSerialization, serializationManager) => jsonSerialization,
      getType<int?>(): (jsonSerialization, serializationManager) =>
          jsonSerialization,
      double: (jsonSerialization, serializationManager) => jsonSerialization,
      getType<double?>(): (jsonSerialization, serializationManager) =>
          jsonSerialization,
      String: (jsonSerialization, serializationManager) => jsonSerialization,
      getType<String?>(): (jsonSerialization, serializationManager) =>
          jsonSerialization,
      bool: (jsonSerialization, serializationManager) => jsonSerialization,
      getType<bool?>(): (jsonSerialization, serializationManager) =>
          jsonSerialization,
      //TODO: decide if default should be utc or local
      DateTime: (jsonSerialization, _) =>
          DateTime.parse(jsonSerialization).toUtc(),
      //TODO: decide if default should be utc or local
      getType<DateTime?>(): (jsonSerialization, _) =>
          DateTime.tryParse(jsonSerialization ?? '')?.toUtc(),
      ByteData: (jsonSerialization, _) =>
          (jsonSerialization as String).base64DecodedByteData()!,
      getType<ByteData?>(): (jsonSerialization, _) =>
          (jsonSerialization as String?)?.base64DecodedByteData(),
    });
  }

  /// Maps types of classes with constructors.
  Map<Type, constructor> get constructors;

  /// Maps classNames to [Type]s.
  Map<String, Type> get classNameTypeMapping;

  /// Deserialize the provided json [String] to an object of type [t] or [T].
  T deserializeJsonString<T>(String data, [Type? t]) {
    return deserializeJson<T>(jsonDecode(data), t);
  }

  /// Deserialize the provided json [data] to an object of type [t] or [T].
  T deserializeJson<T>(dynamic data, [Type? t]) {
    //TODO: handle missing constructor
    return constructors[t ?? T]?.call(data, this);
  }

  /// Deserialize the provided json [data] by using the className stored in the [data].
  SerializableEntity? deserializeJsonByClassName(Map<String, dynamic> data) {
    //TODO: handle missing type mapping
    return deserializeJson(data['data'], classNameTypeMapping['className']);
  }

  /// Serialize the provided [object] to an Json [String].
  static String serializeToJson(Object? object) {
    // This is the only time [jsonEncode] should be used in the project.
    return jsonEncode(
      object,
      toEncodable: (nonEncodable) {
        //TODO: all the "dart native" types should be listed here
        if (nonEncodable is DateTime) {
          return nonEncodable.toUtc().toIso8601String();
        } else if (nonEncodable is ByteData) {
          return nonEncodable.base64encodedString();
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

  // /// Creates an object from a serialization.
  // SerializableEntity? createEntityFromSerialization(
  //     Map<String, dynamic>? serialization) {
  //   if (serialization == null) return null;
  //   String? className = serialization['class'];
  //   if (className == null) return null;
  //   if (constructors[className] != null) {
  //     return constructors[className]!(serialization);
  //   }
  //   return null;
  // }

  // /// Serializes a [SerializableEntity].
  // String? serializeEntity(dynamic entity) {
  //   if (entity == null) {
  //     return null;
  //   } else if (entity is String) {
  //     return jsonEncode(entity);
  //   } else if (entity is DateTime) {
  //     return entity.toIso8601String();
  //   } else if (entity is ByteData) {
  //     return entity.base64encodedString();
  //   } else if (entity is int ||
  //       entity is bool ||
  //       entity is double ||
  //       entity is SerializableEntity) {
  //     return '$entity';
  //   } else if (entity is List<int> ||
  //       entity is List<int?> ||
  //       entity is List<double> ||
  //       entity is List<double?> ||
  //       entity is List<bool> ||
  //       entity is List<bool?> ||
  //       entity is List<String> ||
  //       entity is List<String?>) {
  //     return jsonEncode(entity);
  //   } else if (entity is List<DateTime> || entity is List<DateTime?>) {
  //     return jsonEncode(
  //       (entity as List)
  //           .map((e) => (e as DateTime?)?.toIso8601String())
  //           .toList(),
  //     );
  //   } else if (entity is List<ByteData> || entity is List<ByteData?>) {
  //     return jsonEncode(
  //       (entity as List)
  //           .map((e) => (e as ByteData?)?.base64encodedString())
  //           .toList(),
  //     );
  //   } else if (entity is List) {
  //     return jsonEncode(
  //       entity
  //           .cast<SerializableEntity?>()
  //           .map((e) => e == null ? null : '$e')
  //           .toList(),
  //     );
  //   } else if (entity is Map<String, int> ||
  //       entity is Map<String, int?> ||
  //       entity is Map<String, double> ||
  //       entity is Map<String, double?> ||
  //       entity is Map<String, bool> ||
  //       entity is Map<String, bool?> ||
  //       entity is Map<String, String> ||
  //       entity is Map<String, String?>) {
  //     return jsonEncode(entity);
  //   } else if (entity is Map<String, DateTime> ||
  //       entity is Map<String, DateTime?>) {
  //     return jsonEncode(
  //       (entity as Map).map(
  //         (k, v) => MapEntry(k, (v as DateTime?)?.toIso8601String()),
  //       ),
  //     );
  //   } else if (entity is Map<String, ByteData> ||
  //       entity is Map<String, ByteData?>) {
  //     return jsonEncode(
  //       (entity as Map).map(
  //         (k, v) => MapEntry(k, (v as ByteData?)?.base64encodedString()),
  //       ),
  //     );
  //   } else if (entity is Map) {
  //     return jsonEncode(entity.cast<String, SerializableEntity?>().map(
  //           (k, v) => MapEntry(k, v == null ? null : '$v'),
  //         ));
  //   } else {
  //     throw FormatException('Unknown entity type ${entity.runtimeType}');
  //   }
  // }

  /// Merges two serialization managers into one. This is useful if the
  /// managers are generated from different modules or packages. Typically,
  /// only used internally by Serverpod.
  void merge(SerializationManager other) {
    _appendConstructors(other.constructors);
    _appendClassNameTypeMappings(other.classNameTypeMapping);
  }

  void _appendConstructors(Map<Type, constructor> map) {
    for (var classType in map.keys) {
      constructors.putIfAbsent(classType, () => map[classType]!);
    }
  }

  void _appendClassNameTypeMappings(Map<String, Type> map) {
    for (var className in map.keys) {
      classNameTypeMapping.putIfAbsent(className, () => map[className]!);
    }
  }
}

extension<K, V> on Map<K, V> {
  Type get keyType => K;
}
