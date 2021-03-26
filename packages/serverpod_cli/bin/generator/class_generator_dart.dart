//import 'package:recase/recase.dart';
import 'package:yaml/yaml.dart';

import 'class_generator.dart';

class ClassGeneratorDart extends ClassGenerator{
  final bool serverCode;

  String get outputExtension => '.dart';

  ClassGeneratorDart(String inputPath, String outputPath, bool verbose, this.serverCode) : super(inputPath, outputPath, verbose);

  String generateFile(String yamlStr, String outFileName, Set<ClassInfo> classInfos) {
    var doc = loadYaml(yamlStr);
    String out = '';

    // Handle enums
    try {
      if (doc['enum'] != null) {
        String enumName = doc['enum'];

        // Add enum info to set
        classInfos.add(
            ClassInfo(
              className: enumName,
              fileName: outFileName,
            )
        );

        // Header
        out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
        out += '/*   To generate run: "serverpod generate"    */\n';
        out += '\n';

        if (serverCode)
          out += 'import \'package:serverpod_serialization/serverpod_serialization.dart\';\n';
        else
          out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';

        out += 'class $enumName extends SerializableEntity {\n';
        out += '  String get className => \'$enumName\';\n';
        out += '\n';
        out += '  int _index;\n';
        out += '  int get index => _index;\n';
        out += '\n';

        // Internal constructor
        out += '  $enumName._internal(this._index); \n';
        out += '\n';

        // Serialization
        out += '  $enumName.fromSerialization(Map<String, dynamic> serialization) {\n';
        out += '    var data = unwrapSerializationData(serialization);\n';
        out += '    _index = data[\'index\'];\n';
        out += '  }\n';
        out += '\n';

        out += '  Map<String, dynamic> serialize() {\n';
        out += '    return wrapSerializationData({\n';
        out += '      \'index\': _index,\n';
        out += '    });\n';
        out += '  }\n';

        // Values
        int i = 0;
        for (String value in doc['values']) {
          out += '  static final $value = $enumName._internal($i);\n';
          i += 1;
        }

        out += '\n';

        out += '  int get hashCode => _index.hashCode;\n';
        out += '  bool operator == (other) => other._index == _index;\n';

        out += '\n';

        out += '  static final values = <$enumName>[\n';
        for (String value in doc['values']) {
          out += '    $value,\n';
        }
        out += '  ];\n';

        out += '\n';

        out += '  String get name {\n';
        for (String value in doc['values']) {
          out += '    if (this == $value) return \'$value\';\n';
        }
        out += '    return null;\n';
        out += '  }\n';

        out += '}\n';
        return out;
      }
    }
    catch(e) {
      print('Failed to parse $inputPath: $e');
      return null;
    }

    // Handle ordinary classes
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

      // Ignore camel case warnings
      out += '// ignore_for_file: non_constant_identifier_names\n';
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
      out += '    var _data = unwrapSerializationData(serialization);\n';
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

      // Serialization for database and everything
      if (serverCode) {
        out += '  Map<String, dynamic> serializeForDatabase() {\n';
        out += '    return wrapSerializationData({\n';

        for (var field in fields) {
          if (field.shouldSerializeFieldForDatabase(serverCode))
            out += '      \'${field.name}\': ${field.serialization},\n';
        }

        out += '    });\n';
        out += '  }\n';

        out += '\n';

        out += '  Map<String, dynamic> serializeAll() {\n';
        out += '    return wrapSerializationData({\n';

        for (var field in fields) {
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

        // Constructor
        out += '  ${className}Table() : super(tableName: \'$tableName\');\n';
        out += '\n';

        out += '  String tableName = \'$tableName\';\n';

        // Column descriptions
        for (var field in fields) {
          if (field.shouldSerializeFieldForDatabase(serverCode))
            out += '  final ${field.name} = ${field.columnType}(\'${field.name}\');\n';
        }
        out += '\n';

        // List of column values
        out += '  List<Column> get columns => [\n';
        for (var field in fields) {
          if (field.shouldSerializeFieldForDatabase(serverCode))
            out += '    ${field.name},\n';
        }
        out += '  ];\n';


        // End class
        out += '}\n';

        out += '\n';

        // Create instance of table
        out += '${className}Table t${className} = ${className}Table();\n';
      }
    }
    catch (e) {
      print('Failed to parse $inputPath: $e');
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

    // Export generated files
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

    out += '  Map<String, constructor> _constructors = {};\n';
    out += '  Map<String, constructor> get constructors => _constructors;\n';
    out += '  Map<String,String> _tableClassMapping = {};\n';
    out += '  Map<String,String> get tableClassMapping => _tableClassMapping;\n';
    out += '\n';

    // Constructor
    out += '  Protocol() {\n';

    for (ClassInfo classInfo in classInfos) {
      out += '    constructors[\'${classInfo.className}\'] = (Map<String, dynamic> serialization) => ${classInfo.className}.fromSerialization(serialization);\n';
    }

    if (serverCode) {
      out += '\n';
      for (ClassInfo classInfo in classInfos) {
        if (classInfo.tableName == null)
          continue;
        out += '    tableClassMapping[\'${classInfo.tableName}\'] = \'${classInfo.className}\';\n';
      }
    }

    out += '  }\n';
    out += '}\n';

    return out;
  }

//  String _endpointClassName(String endpointName) {
//    return '_Endpoint${ReCase(endpointName).pascalCase}';
//  }
}

enum _FieldScope {
  database,
  protocol,
  all,
}

class _FieldDefinition {
  String name;
  String type;

  String get columnType {
    if (type == 'int')
      return 'ColumnInt';
    if (type == 'double')
      return 'ColumnDouble';
    if (type == 'bool')
      return 'ColumnBool';
    if (type == 'String')
      return 'ColumnString';
    if (type == 'DateTime')
      return 'ColumnDateTime';
    return null;
  }

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
        return '_data[\'$name\']?.cast<$listType>()';
      }
      else {
        return '_data[\'$name\']?.map<$listType>((a) => $listType.fromSerialization(a))?.toList()';
      }
    }

    if (type == 'String' || type == 'int' || type == 'double' || type == 'bool') {
      return '_data[\'$name\']';
    }
    else if (type == 'DateTime') {
      return '_data[\'$name\'] != null ? DateTime.tryParse(_data[\'$name\']) : null';
    }
    else {
      return '_data[\'$name\'] != null ? $type.fromSerialization(_data[\'$name\']) : null';
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
