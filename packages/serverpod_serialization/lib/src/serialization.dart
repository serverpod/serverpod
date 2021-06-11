import 'dart:convert';
import 'dart:typed_data';
import 'bytedata_base64_ext.dart';

typedef constructor = SerializableEntity Function(Map<String, dynamic> serialization);

abstract class SerializableEntity {
  String get className;

  Map<String, dynamic> serialize();

  Map<String, dynamic> serializeAll() => serialize();

  Map<String, dynamic> wrapSerializationData(Map<String, dynamic> data) {
    return {
      'class': className,
      'data': data,
    };
  }

  Map<String, dynamic> unwrapSerializationData(Map<String, dynamic> serialization) {
    if (serialization['class'] != className)
      throw FormatException();
    if (serialization['data'] == null)
      throw FormatException();

    return serialization['data'];
  }

  @override
  String toString() {
    return jsonEncode(serialize());
  }
}

abstract class SerializationManager {
  Map<String, constructor> get constructors;
  Map<String,String> get tableClassMapping;

  SerializableEntity? createEntityFromSerialization(Map<String, dynamic>? serialization) {
    if (serialization == null)
      return null;
    String? className = serialization['class'];
    if (className == null)
      return null;
    if (constructors[className] != null)
      return constructors[className]!(serialization);
    return null;
  }

  String? serializeEntity(dynamic? entity) {
    if (entity == null)
      return null;
    else if (entity is String) // TODO: Breaks legacy code!
      return jsonEncode(entity);
    else if (entity is DateTime)
      return entity.toIso8601String();
    else if (entity is ByteData)
      return entity.base64encodedString();
    else if (entity is int || entity is bool || entity is double || entity is SerializableEntity)
      return '$entity';
    else {
      print('Unknown entity type ${entity.runtimeType}');
      throw FormatException();
    }
  }

  void merge(SerializationManager other) {
    _appendConstructors(other.constructors);
    _appendTableClassMapping(other.tableClassMapping);
  }

  void _appendConstructors(Map<String, constructor> map) {
    for (var className in map.keys) {
      constructors[className] = map[className]!;
    }
  }

  void _appendTableClassMapping(Map<String, String> map) {
    for (var tableName in map.keys) {
      tableClassMapping[tableName] = map[tableName]!;
    }
  }
}
