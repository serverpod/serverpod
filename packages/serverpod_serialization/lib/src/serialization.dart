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
}

/// Get the type provided as an generic. Useful for getting a nullable type.
Type getType<T>() => T;

/// The [SerializationManager] is responsible for creating objects from a
/// serialization, but also for serializing objects. This class is typically
/// extended by generated code.
abstract class SerializationManager {
  // /// Maps classNames to [Type]s.
  // Map<String, Type> classNameTypeMapping;

  /// Deserialize the provided json [String] to an object of type [t] or [T].
  T deserializeJsonString<T>(String data, [Type? t]) {
    return deserializeJson<T>(jsonDecode(data), t);
  }

  /// Deserialize the provided json [data] to an object of type [t] or [T].
  T deserializeJson<T>(dynamic data, [Type? t]) {
    t ??= T;

    //TODO: all the "dart native" types should be listed here
    if (t == int || t == getType<int?>()) {
      return data;
    } else if (t == double || t == getType<double?>()) {
      return data;
    } else if (t == String || t == getType<String?>()) {
      return data;
    } else if (t == bool || t == getType<bool?>()) {
      return data;
    } else if (t == DateTime) {
      //TODO: decide if DateTime should be deserialized to utc on the server side
      return DateTime.parse(data).toLocal() as T;
    } else if (t == getType<DateTime?>()) {
      //TODO: decide if DateTime should be deserialized to utc on the server side
      return DateTime.tryParse(data ?? '')?.toLocal() as T;
    } else if (t == ByteData) {
      return (data as String).base64DecodedByteData()! as T;
    } else if (t == getType<ByteData?>()) {
      return (data as String?)?.base64DecodedByteData() as T;
    }

    //TODO: handle missing constructor
    throw 'Unknown Type $t';
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
    }
    return null;
  }

  /// Deserialize the provided json [data] by using the className stored in the [data].
  dynamic deserializeJsonByClassName(Map<String, dynamic> data) {
    switch (data['className']) {
      case 'int':
        return deserializeJson<int>(data['data']);
      case 'double':
        return deserializeJson<double>(data['data']);
      case 'String':
        return deserializeJson<String>(data['data']);
      case 'bool':
        return deserializeJson<bool>(data['data']);
      case 'DateTime':
        return deserializeJson<DateTime>(data['data']);
      case 'ByteData':
        return deserializeJson<ByteData>(data['data']);
    }
    //TODO: handle missing type mapping
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

  // /// Merges two serialization managers into one. This is useful if the
  // /// managers are generated from different modules or packages. Typically,
  // /// only used internally by Serverpod.
  // void merge(SerializationManager other, String classNamePrefix) {
  //   _appendConstructors(other.constructors);
  //   _appendClassNameTypeMappings(other.classNameTypeMapping, classNamePrefix);
  // }

  // void _appendConstructors(Map<Type, constructor> map) {
  //   for (var classType in map.keys) {
  //     constructors.putIfAbsent(classType, () => map[classType]!);
  //   }
  // }

  // void _appendClassNameTypeMappings(
  //     Map<String, Type> map, String classNamePrefix) {
  //   for (var className in map.keys) {
  //     classNameTypeMapping.putIfAbsent(
  //         '$classNamePrefix$className', () => map[className]!);
  //   }
  // }
}

extension<K, V> on Map<K, V> {
  Type get keyType => K;
}
