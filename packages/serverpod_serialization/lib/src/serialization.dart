// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:typed_data';

import 'bytedata_base64_ext.dart';

/// The constructor takes JSON structure and turns it into a decoded
/// [SerializableEntity].
typedef constructor = SerializableEntity Function(
    Map<String, dynamic> serialization);

/// The [SerializableEntity] is the base class for all serializable objects in
/// Serverpod, except primitives.
abstract class SerializableEntity {
  /// Returns the class name of this entity.
  String get className;

  /// Returns a serialized JSON structure of the entity, ready to be sent
  /// through the API. This does not include fields that are marked as
  /// database only.
  Map<String, dynamic> serialize();

  /// Returns a serialized JSON structure of the entity which also includes
  /// fields used by the database.
  Map<String, dynamic> serializeAll() => serialize();

  /// Wraps the serialized data to combine it with its class name, if the
  /// decoded type isn't known ahead of time.
  Map<String, dynamic> wrapSerializationData(Map<String, dynamic> data) {
    return {
      'class': className,
      'data': data,
    };
  }

  /// Unwraps class information, and only returns the data part.
  Map<String, dynamic> unwrapSerializationData(
      Map<String, dynamic> serialization) {
    if (serialization['class'] != className) throw const FormatException();
    if (serialization['data'] == null) throw const FormatException();

    return serialization['data'];
  }

  @override
  String toString() {
    return jsonEncode(serialize());
  }
}

/// The [SerializationManager] is responsible for creating objects from a
/// serialization, but also for serializing objects. This class is typically
/// overriden by generated code.
abstract class SerializationManager {
  /// Maps names of classes with constructors.
  Map<String, constructor> get constructors;

  /// Creates an object from a serialization.
  SerializableEntity? createEntityFromSerialization(
      Map<String, dynamic>? serialization) {
    if (serialization == null) return null;
    String? className = serialization['class'];
    if (className == null) return null;
    if (constructors[className] != null) {
      return constructors[className]!(serialization);
    }
    return null;
  }

  /// Serializes a [SerializableEntity].
  String? serializeEntity(dynamic entity) {
    if (entity == null) {
      return null;
    } else if (entity is String) {
      return jsonEncode(entity);
    } else if (entity is DateTime) {
      return entity.toIso8601String();
    } else if (entity is ByteData) {
      return entity.base64encodedString();
    } else if (entity is int ||
        entity is bool ||
        entity is double ||
        entity is SerializableEntity) {
      return '$entity';
    } else if (entity is List<SerializableEntity>) {
      // print('this is Seriziable List');
      return json.encode((entity).map((e) => e.serialize()).toList());
    } else {
      throw FormatException('Unknown entity type ${entity.runtimeType}');
    }
  }

  /// Merges two serialization managers into one. This is useful if the
  /// managers are generated from different modules or packages. Typically,
  /// only used internally by Serverpod.
  void merge(SerializationManager other) {
    _appendConstructors(other.constructors);
  }

  void _appendConstructors(Map<String, constructor> map) {
    for (var className in map.keys) {
      constructors[className] = map[className]!;
    }
  }
}
