import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:yaml/yaml.dart';

typedef SerializableEntity constructor(Map<String, dynamic> serialization);

abstract class SerializableEntity {
  String get className;

  Map<String, dynamic> serialize();

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
  final _tableClassMapping = <String, String>{};
  Map<String, String> get tableClassMapping => _tableClassMapping;

  SerializationManager() {
    _loadSerializableClassDefinitions();
    print('tableClassMapping: $tableClassMapping');
  }

  bool _loadSerializableClassDefinitions() {
    // Parse yaml files for data
    var dir = Directory('bin/protocol');
    var list = dir.listSync();
    for (var entity in list) {
      if (entity is File && entity.path.endsWith('.yaml')) {
        _addDefinition(entity);
      }
    }
    return true;
  }

  void _addDefinition(File file) {
    String yamlStr = file.readAsStringSync();
    var doc = loadYaml(yamlStr);

    String name = doc['tableName'];
    String className = doc['class'];

    _tableClassMapping[name] = className;
  }

  SerializableEntity createEntityFromSerialization(Map<String, dynamic> serialization) {
    String className = serialization['class'];
    if (className == null)
      return null;
    if (constructors[className] != null)
      return constructors[className](serialization);
    return null;
  }
}
