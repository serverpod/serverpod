import 'package:yaml/yaml.dart';

import 'generator.dart';

class DartGenerator extends Generator{
  final bool serverCode;

  String get outputExtension => '.dart';

  DartGenerator(String inputPath, String outputPath, String binaryPath, bool verbose, this.serverCode) : super(inputPath, outputPath, binaryPath, verbose);

  String generateFile(String yamlStr, String outFileName, Set<ClassInfo> classInfos) {
    var doc = loadYaml(yamlStr);
    String out = '';

    try {
      String tableName = _expectString(doc, 'tableName');
      String className = _expectString(doc, 'class');
      Map docFields = _expectMap(doc, 'fields');
      var fields = <_FieldDefinition>[];

      fields.add(_FieldDefinition('id', 'int'));
      for (var docFieldName in docFields.keys) {
        fields.add(_FieldDefinition(docFieldName, docFields[docFieldName]));
      }

      // Add class info to set
      classInfos.add(
        ClassInfo(
          className: className,
          tableName: tableName,
          fileName: outFileName,
        )
      );

      // Header
      out += '/*** AUTOMATICALLY GENERATED CODE DO NOT MODIFY ***/\n';
      out += '/* To generate run: "serverpod generate"  */\n';
      out += '\n';

      if (serverCode)
        out += 'import \'package:serverpod/database.dart\';\n';
      else
        out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
      out += '\n';

      // Row class definition
      if (serverCode)
        out += 'class $className extends TableRow {\n';
      else
        out += 'class $className extends SerializableEntity {\n';

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
      out += '  $className({\n';
      for (var field in fields) {
        out += '    this.${field.name},\n';
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

      if (serverCode) {
        // Table class definition
        out += 'class ${className}Table extends Table {\n';
        out += '\n';

        out += '  static const String tableName = \'$tableName\';\n';

        // Column descriptions
        for (var column in fields) {
          out +=
          '  static const ${column.name} = Column(\'${column.name}\', ${column
              .type});\n';
        }


        // End class
        out += '}\n';
      }
    }
    catch (_) {
      return null;
    }

    return out;
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

  String generateFactory(Set<ClassInfo> classInfos) {
    String out = '';

    // Header
    out += '/*** AUTOMATICALLY GENERATED CODE DO NOT MODIFY ***/\n';
    out += '/* To generate run: "serverpod generate"  */\n';
    out += '\n';
    
    out+= 'library protocol;\n';
    out += '\n';

    if (serverCode)
      out += 'import \'package:serverpod/serverpod.dart\';\n';
    else
      out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';

    out += '\n';
    
    // Import generated files
    for (ClassInfo classInfo in classInfos) {
      out += 'import \'${classInfo.fileName}\';\n';
    }
    out += '\n';

    // Import generated files
    for (ClassInfo classInfo in classInfos) {
      out += 'export \'${classInfo.fileName}\';\n';
    }
    if (!serverCode)
      out += 'export \'endpoints.dart\';\n';
    out += '\n';

    // Fields
    out += 'class Protocol extends SerializationManager {\n';
    out += '  Map<String, constructor> _constructors = <String, constructor>{};\n';
    out += '  Map<String, constructor> get constructors => _constructors;\n';

    // Constructor
    out += '  Protocol() {\n';

    for (ClassInfo classInfo in classInfos) {
      out += '    constructors[\'${classInfo.className}\'] = (Map<String, dynamic> serialization) => ${classInfo.className}.fromSerialization(serialization);\n';
    }
    out += '  }\n';

    out += '}\n';

    return out;
  }

  String generateEndpoints(String yamlStr) {
    Map doc = loadYaml(yamlStr);
    print('doc: $doc');

    String out = '';

    // Header
    out += '/*** AUTOMATICALLY GENERATED CODE DO NOT MODIFY ***/\n';
    out += '/* To generate run: "serverpod generate"  */\n';
    out += '\n';

    out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
    out += 'import \'protocol.dart\';\n';
    out += '\n';

    for (String endpointName in doc.keys) {
      Map endpointDef = doc[endpointName];
      List requiredParams = endpointDef['requiredParameters'];
      List optionalParams = endpointDef['optionalParameters'];

      print('endpointName: $endpointName');
      print('endpointDef: $endpointDef');
      print('requiredParams: $requiredParams');
      print('optionalParams: $optionalParams');

      // Function definition
      out += 'Future<Null> $endpointName(';

      if (requiredParams != null) {
        for (Map paramInfo in requiredParams) {
          String paramName = paramInfo.keys.first;
          String paramType = paramInfo.values.first;
          out += '$paramType $paramName,';
        }
      }

      if (optionalParams != null) {
        out += '[';

        for (Map paramInfo in optionalParams) {
          String paramName = paramInfo.keys.first;
          String paramType = paramInfo.values.first;
          out += '$paramType $paramName,';
        }

        out += ']';
      }

      out += ') async {\n';

      // Call to server endpoint
      out += '  return await callServerEndpoint(\'$endpointName\',[';

      if (requiredParams != null) {
        for (Map paramInfo in requiredParams) {
          String paramName = paramInfo.keys.first;
          out += '$paramName,';
        }
      }

      if (optionalParams != null) {
        for (Map paramInfo in optionalParams) {
          String paramName = paramInfo.keys.first;
          out += '$paramName,';
        }
      }

      out += ']);\n';
      out += '}\n';
      out += '\n';
    }

    return out;
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
