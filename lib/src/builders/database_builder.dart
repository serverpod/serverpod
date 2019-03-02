import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

Builder databaseBuilder(_) => DatabaseBuilder();

class DatabaseBuilder implements Builder {
  const DatabaseBuilder();

  @override
  final buildExtensions = const {
    '.yaml': ['.dart']
  };

  @override
  Future build(BuildStep buildStep) async {
    String yamlStr = await buildStep.readAsString(buildStep.inputId);
    var doc = loadYaml(yamlStr);

    String out = '';

    try {
      String tableName = _expectString(doc, 'tableName');
      String className = _expectString(doc, 'class');
      Map docFields = _expectMap(doc, 'fields');
      var fields = <_FieldDefinition>[];

      for (var docFieldName in docFields.keys) {
        fields.add(_FieldDefinition(docFieldName, docFields[docFieldName]));
      }

      // Header
      out += '/*** AUTOMATICALLY GENERATED CODE DO NOT MODIFY ***/\n';
      out += '/* To generate run: "pub run build_runner build"  */\n';
      out += '\n';

      out += 'import \'package:serverpod/database.dart\';\n';
      out += '\n';

      // Row class definition
      out += 'class $className extends TableRow {\n';
      out += '  static const String db = \'$tableName\';\n';
      out += '  String get className => \'$className\';\n';
      out += '  String get tableName => \'$tableName\';\n';
      out += '\n';

      // Fields
      for (var field in fields) {
        out += '  ${field.type} ${field.name};\n';
      }
      out += '\n';

      // Default constructor
      out += '  $className({';
      for (var field in fields) {
        out += 'this.${field.name},';
      }
      out += '});\n';
      out += '\n';

      // Deserialization
      out += '  $className.fromSerialization(Map<String, dynamic> serialization) {\n';
      out += '    var data = unwrapSerializationData(serialization);\n';
      for (var field in fields) {
        out += '    ${field.name} = data[\'${field.name}\'];\n';
      }
      out += '  }\n';
      out += '\n';


      // Serialization
      out += '  Map<String, dynamic> serialize() {\n';
      out += '    return wrapSerializationData({\n';

      for (var field in fields) {
        out += '      \'${field.name}\': ${field.name},\n';
      }

      out += '    });\n';
      out += '  }\n';

      // End class
      out += '}\n';
      out += '\n';

      // Table class definition
      out += 'class ${className}Table extends Table {\n';
      out += '\n';

      out += '  static const String tableName = \'$tableName\';\n';

      // Column descriptions
      for (var column in fields) {
        out += '  static const ${column.name} = Column(\'${column.name}\', ${column.type});\n';
      }


      // End class
      out += '}\n';
    }
    catch (_) {
      return;
    }
    
    buildStep.writeAsString(buildStep.inputId.changeExtension('.dart'), out);

  }

  String _expectString(dynamic doc, String field) {
    String value = doc[field];
    if (value != null) {
      return value;
    }
    else {
      print('Missing field (String) "$field"');
      throw FormatException();
    }
  }

  Map _expectMap(dynamic doc, String field) {
    Map map = doc[field];
    if (map != null) {
      return map;
    }
    else {
      print('Missing field (Map) "$field"');
      throw FormatException();
    }
  }
}

class _FieldDefinition {
  String name;
  String type;

  _FieldDefinition(String name, String description) {
    this.name = name;
    type = description;
  }
}