import 'package:recase/recase.dart';
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
      String tableName = doc['tableName'];
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
      out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
      out += '/*   To generate run: "serverpod generate"    */\n';
      out += '\n';

      if (serverCode) {
        if (tableName != null)
          out += 'import \'package:serverpod/database.dart\';\n';
        else
          out += 'import \'package:serverpod_serialization/serverpod_serialization.dart\';\n';
      }
      else {
        out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
      }

      out += '// ignore: unused_import\n';
      out += 'import \'protocol.dart\';\n';
      out += '\n';

      // Row class definition
      if (serverCode && tableName != null) {
        out += 'class $className extends TableRow {\n';
        out += '  String get className => \'$className\';\n';
        out += '  static const String db = \'$tableName\';\n';
        out += '  String get tableName => \'$tableName\';\n';
      }
      else {
        out += 'class $className extends SerializableEntity {\n';
        out += '  String get className => \'$className\';\n';
      }

      out += '\n';

      // Fields
      for (var field in fields) {
        if (field.shouldIncludeField(serverCode))
          out += '  ${field.type} ${field.name};\n';
      }
      out += '\n';

      // Default constructor
      out += '  $className({\n';
      for (var field in fields) {
        if (field.shouldIncludeField(serverCode))
          out += '    this.${field.name},\n';
      }
      out += '});\n';
      out += '\n';

      // Deserialization
      out += '  $className.fromSerialization(Map<String, dynamic> serialization) {\n';
      out += '    var data = unwrapSerializationData(serialization);\n';
      for (var field in fields) {
        if (field.shouldIncludeField(serverCode))
          out += '    ${field.name} = ${field.deserialization};\n';
      }
      out += '  }\n';
      out += '\n';


      // Serialization
      out += '  Map<String, dynamic> serialize() {\n';
      out += '    return wrapSerializationData({\n';

      for (var field in fields) {
        if (field.shouldSerializeField(serverCode))
          out += '      \'${field.name}\': ${field.serialization},\n';
      }

      out += '    });\n';
      out += '  }\n';

      // Serialization for database
      if (serverCode) {
        out += '  Map<String, dynamic> serializeForDatabase() {\n';
        out += '    return wrapSerializationData({\n';

        for (var field in fields) {
          if (field.shouldSerializeFieldForDatabase(serverCode))
            out += '      \'${field.name}\': ${field.serialization},\n';
        }

        out += '    });\n';
        out += '  }\n';
      }

      // End class
      out += '}\n';
      out += '\n';

      if (serverCode && tableName != null) {
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
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
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
      out += 'export \'client.dart\';\n';
    out += '\n';

    // Fields
    out += 'class Protocol extends SerializationManager {\n';
    out += '  static final Protocol instance = Protocol();\n';
    out += '\n';

    out += '  Map<String, constructor> _constructors = <String, constructor>{};\n';
    out += '  Map<String, constructor> get constructors => _constructors;\n';
    out += '\n';

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
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
    out += '\n';

    out += 'import \'dart:io\';\n';
    out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
    out += 'import \'protocol.dart\';\n';
    out += '\n';

    // Endpoints
    for (String endpointName in doc.keys) {
      Map endpointDef = doc[endpointName];

      String endpointClassName = _endpointClassName(endpointName);

      out += 'class $endpointClassName {\n';
      out += '  Client client;\n';

      out += '  $endpointClassName(this.client);\n';

      // Add methods
      for (String methodName in endpointDef.keys) {
        Map methodDef = endpointDef[methodName];

        List requiredParams = methodDef['requiredParameters'];
        List optionalParams = methodDef['optionalParameters'];
        String returnType = methodDef['returnType'];
        assert(returnType.startsWith('Future<'));
        assert(returnType.endsWith('>'));
        String returnTypeNoFuture = returnType.substring(7, returnType.length -1);

        // Method definition
        out += '\n';
        out += '  $returnType $methodName(';

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
        out += '    return await client.callServerEndpoint(\'$endpointName\', \'$methodName\', \'$returnTypeNoFuture\', {\n';

        if (requiredParams != null) {
          for (Map paramInfo in requiredParams) {
            String paramName = paramInfo.keys.first;
            out += '      \'$paramName\':$paramName,\n';
          }
        }

        if (optionalParams != null) {
          for (Map paramInfo in optionalParams) {
            String paramName = paramInfo.keys.first;
            out += '      \'$paramName\': $paramName,\n';
          }
        }

        out += '    });\n';
        out += '  }\n';
      }

      out += '}\n';
      out += '\n';
    }

    // Class definition
    out += 'class Client extends ServerpodClient {\n';

    for (String endpointName in doc.keys) {
      out += '  ${_endpointClassName(endpointName)} $endpointName;\n';
    }

    out += '\n';
    out += '  Client(host, {SecurityContext context, ServerpodClientErrorCallback errorHandler}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler) {\n';
    for (String endpointName in doc.keys) {
      out += '    $endpointName = ${_endpointClassName(endpointName)}(this);\n';
    }
    out += '  }\n';
    out += '\n';


    out += '}\n';


    return out;
  }

  String _endpointClassName(String endpointName) {
    return '_Endpoint${ReCase(endpointName).pascalCase}';
  }
}

enum _FieldScope {
  database,
  protocol,
  all,
}

class _FieldDefinition {
  String name;
  String type;
  _FieldScope scope = _FieldScope.all;

  bool isTypedList;
  String listType;

  _FieldDefinition(String name, String description) {
    this.name = name;

    var components = description.split(',').map((String s) { return s.trim(); }).toList();
    type = components[0];

    if (components.length == 2) {
      var scopeStr = components[1];
      if (scopeStr == 'database')
        scope = _FieldScope.database;
      else if (scopeStr == 'protocol')
        scope = _FieldScope.protocol;
    }

    isTypedList = type.startsWith('List<') && type.endsWith('>');
    if (isTypedList)
      listType = type.substring(5, type.length - 1);
  }

  String get serialization {
    if (isTypedList) {
      if (listType == 'String' || listType == 'int' || listType == 'double' || listType ==  'bool') {
        return name;
      }
      else {
        return '$name?.map(($listType a) => a.serialize())?.toList()';
      }
    }

    if (type == 'String' || type == 'int' || type == 'double' || type == 'bool') {
      return name;
    }
    else if (type == 'DateTime') {
      return '$name?.toUtc()?.toIso8601String()';
    }
    else {
      return '$name?.serialize()';
    }
  }

  String get deserialization {
    if (isTypedList) {
      if (listType == 'String' || listType == 'int' || listType == 'double' || listType == 'bool') {
        return 'data[\'$name\']';
      }
      else {
        return 'data[\'$name\'].map<$listType>((a) => $listType.fromSerialization(a)).toList()';
      }
    }

    if (type == 'String' || type == 'int' || type == 'double' || type == 'bool') {
      return 'data[\'$name\']';
    }
    else if (type == 'DateTime') {
      return 'data[\'$name\'] != null ? DateTime.tryParse(data[\'$name\']) : null';
    }
    else {
      return 'data[\'$name\'] != null ? $type.fromSerialization(data[\'$name\']) : null';
    }
  }

  bool shouldIncludeField(bool serverCode) {
    if (serverCode)
      return true;
    if (scope == _FieldScope.all || scope == _FieldScope.protocol)
      return true;
    return false;
  }

  bool shouldSerializeField(bool serverCode) {
    if (scope == _FieldScope.all || scope == _FieldScope.protocol)
      return true;
    return false;
  }

  bool shouldSerializeFieldForDatabase(bool serverCode) {
    assert(serverCode);
    if (scope == _FieldScope.all || scope == _FieldScope.database)
      return true;
    return false;
  }
}
