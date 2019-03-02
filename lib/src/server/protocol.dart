import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:yaml/yaml.dart';

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
    if (serialization['data'] != null)
      throw FormatException();

    return serialization['data'];
  }

  @override
  String toString() {
    return jsonEncode(serialize());
  }
}

class SerializationManager {
  final _tableClassMapping = <String, String>{};
  Map<String, String> get tableClassMapping => _tableClassMapping;

  final _serializableClassMirrors = <String, ClassMirror>{};
  Map<String, ClassMirror> get serializableClassMirrors => _serializableClassMirrors;


  Future<bool> loadSerializableClassDefinitions() async {
    // Parse yaml files for data
    var dir = Directory('bin/database');
    var list = dir.listSync();
    for (var entity in list) {
      if (entity is File && entity.path.endsWith('.yaml')) {
        _addDefinition(entity);
      }
    }

    // Find mirrors for generated table classes
    for (var libName in currentMirrorSystem().libraries.keys) {
      if (libName.toString().contains('bin/database/')) {
        // Look for table classes in each matching library
        for (String tableName in _tableClassMapping.keys) {
          String className = _tableClassMapping[tableName];

          LibraryMirror libraryMirror = currentMirrorSystem().libraries[libName];
          ClassMirror classMirror = libraryMirror.declarations[Symbol(className)];

          if (classMirror != null)
            _serializableClassMirrors[className] = classMirror;
        }
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
}