//import 'package:recase/recase.dart';
import 'package:yaml/yaml.dart';

import 'class_generator.dart';
import 'config.dart';
import 'protocol_definition.dart';

class ClassGeneratorDart extends ClassGenerator {
  final bool serverCode;

  @override
  String get outputExtension => '.dart';

  ClassGeneratorDart(
      String inputPath, String outputPath, bool verbose, this.serverCode)
      : super(inputPath, outputPath, verbose);

  @override
  String? generateFile(
      String yamlStr, String outFileName, Set<ClassInfo> classInfos) {
    var doc = loadYaml(yamlStr);
    var out = '';

    // Handle enums
    try {
      if (doc['enum'] != null) {
        String enumName = doc['enum'];

        // Add enum info to set
        classInfos.add(ClassInfo(
          className: enumName,
          fileName: outFileName,
          fields: [],
        ));

        // Header
        out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
        out += '/*   To generate run: "serverpod generate"    */\n';
        out += '\n';
        out += '// ignore_for_file: public_member_api_docs\n';
        out += '\n';

        if (serverCode) {
          out +=
              'import \'package:serverpod_serialization/serverpod_serialization.dart\';\n';
        } else {
          out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
        }

        out += 'class $enumName extends SerializableEntity {\n';
        out += '  @override\n';
        out += '  String get className => \'$enumName\';\n';
        out += '\n';
        out += '  late final int _index;\n';
        out += '  int get index => _index;\n';
        out += '\n';

        // Internal constructor
        out += '  $enumName._internal(this._index); \n';
        out += '\n';

        // Serialization
        out +=
            '  $enumName.fromSerialization(Map<String, dynamic> serialization) {\n';
        out += '    var data = unwrapSerializationData(serialization);\n';
        out += '    _index = data[\'index\'];\n';
        out += '  }\n';
        out += '\n';

        out += '  @override\n';
        out += '  Map<String, dynamic> serialize() {\n';
        out += '    return wrapSerializationData({\n';
        out += '      \'index\': _index,\n';
        out += '    });\n';
        out += '  }\n';

        // Values
        var i = 0;
        for (String value in doc['values']) {
          out += '  static final $value = $enumName._internal($i);\n';
          i += 1;
        }

        out += '\n';

        out += '  @override\n';
        out += '  int get hashCode => _index.hashCode;\n';
        out += '  @override\n';
        out +=
            '  bool operator == (other) => other is $enumName && other._index == _index;\n';

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
        out += '    throw const FormatException();\n';
        out += '  }\n';

        out += '}\n';
        return out;
      }
    } catch (e) {
      print('Failed to parse $inputPath: $e');
      return null;
    }

    // Handle ordinary classes
    try {
      String? tableName = doc['table'];
      var className = _expectString(doc, 'class');
      var docFields = _expectMap(doc, 'fields');
      var fields = <FieldDefinition>[];

      fields.add(FieldDefinition('id', 'int?'));
      for (var docFieldName in docFields.keys) {
        fields.add(FieldDefinition(docFieldName, docFields[docFieldName]));
      }

      List<IndexDefinition>? indexes;

      if (doc['indexes'] != null) {
        indexes = [];
        var docIndexes = _expectMap(doc, 'indexes');
        for (var indexName in docIndexes.keys) {
          indexes.add(IndexDefinition(indexName, docIndexes[indexName]));
        }
      }

      // Add class info to set
      classInfos.add(ClassInfo(
        className: className,
        tableName: tableName,
        fileName: outFileName,
        fields: fields,
        indexes: indexes,
      ));

      // Find dependencies on other modules
      var moduleDependencies = <String>{};
      for (var field in fields) {
        if (field.type.type.contains('.')) {
          var nameComponents = field.type.type.split('.');
          var moduleName = nameComponents[0];
          moduleDependencies.add(moduleName);
        }
      }

      // Header
      out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
      out += '/*   To generate run: "serverpod generate"    */\n';
      out += '\n';

      // Ignore camel case warnings
      out += '// ignore_for_file: non_constant_identifier_names\n';
      out += '// ignore_for_file: public_member_api_docs\n';
      out += '// ignore_for_file: unused_import\n';
      out += '// ignore_for_file: overridden_fields\n';
      out += '\n';

      if (serverCode) {
        if (tableName != null) {
          out += 'import \'package:serverpod/serverpod.dart\';\n';
          out +=
              'import \'package:serverpod_serialization/serverpod_serialization.dart\';\n';
        } else {
          out +=
              'import \'package:serverpod_serialization/serverpod_serialization.dart\';\n';
        }
        for (var dependencyName in moduleDependencies) {
          out +=
              'import \'package:${dependencyName}_server/module.dart\' as $dependencyName;\n';
        }
      } else {
        out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
        for (var dependencyName in moduleDependencies) {
          out +=
              'import \'package:${dependencyName}_client/module.dart\' as $dependencyName;\n';
        }
      }

      out += 'import \'dart:typed_data\';\n';
      out += 'import \'protocol.dart\';\n';
      out += '\n';

      // Row class definition
      if (serverCode && tableName != null) {
        out += 'class $className extends TableRow {\n';
        out += '  @override\n';
        out += '  String get className => \'$classPrefix$className\';\n';
        out += '  @override\n';
        out += '  String get tableName => \'$tableName\';\n';
        out += '\n';
        out += '  static final t = ${className}Table();\n';
      } else {
        out += 'class $className extends SerializableEntity {\n';
        out += '  @override\n';
        out += '  String get className => \'$classPrefix$className\';\n';
      }

      out += '\n';

      // Fields
      for (var field in fields) {
        if (field.shouldIncludeField(serverCode)) {
          if (field.name == 'id' && serverCode && tableName != null) {
            out += '  @override\n';
          }
          out +=
              '  ${field.type.nullable ? '' : 'late '}${field.type.type} ${field.name};\n';
        }
      }
      out += '\n';

      // Default constructor
      out += '  $className({\n';
      for (var field in fields) {
        if (field.shouldIncludeField(serverCode)) {
          out +=
              '    ${field.type.nullable ? '' : 'required '}this.${field.name},\n';
        }
      }
      out += '});\n';
      out += '\n';

      // Deserialization
      out +=
          '  $className.fromSerialization(Map<String, dynamic> serialization) {\n';
      out += '    var _data = unwrapSerializationData(serialization);\n';
      for (var field in fields) {
        if (field.shouldIncludeField(serverCode)) {
          out += '    ${field.name} = ${field.deserialization};\n';
        }
      }
      out += '  }\n';
      out += '\n';

      // Serialization
      out += '  @override\n';
      out += '  Map<String, dynamic> serialize() {\n';
      out += '    return wrapSerializationData({\n';

      for (var field in fields) {
        if (field.shouldSerializeField(serverCode)) {
          out += '      \'${field.name}\': ${field.serialization},\n';
        }
      }

      out += '    });\n';
      out += '  }\n';

      // Serialization for database and everything
      if (serverCode) {
        if (tableName != null) {
          out += '\n';
          out += '  @override\n';
          out += '  Map<String, dynamic> serializeForDatabase() {\n';
          out += '    return wrapSerializationData({\n';

          for (var field in fields) {
            if (field.shouldSerializeFieldForDatabase(serverCode)) {
              out += '      \'${field.name}\': ${field.serialization},\n';
            }
          }

          out += '    });\n';
          out += '  }\n';
        }

        out += '\n';
        out += '  @override\n';
        out += '  Map<String, dynamic> serializeAll() {\n';
        out += '    return wrapSerializationData({\n';

        for (var field in fields) {
          out += '      \'${field.name}\': ${field.serialization},\n';
        }

        out += '    });\n';
        out += '  }\n';

        if (tableName != null) {
          // Column setter
          out += '\n';
          out += '  @override\n';
          out += '  void setColumn(String columnName, value) {\n';
          out += '    switch (columnName) {\n';

          for (var field in fields) {
            if (field.shouldSerializeFieldForDatabase(serverCode)) {
              out += '      case \'${field.name}\':\n';
              out += '        ${field.name} = value;\n';
              out += '        return;\n';
            }
          }

          out += '      default:\n';
          out += '        throw UnimplementedError();\n';
          out += '    }\n';
          out += '  }\n';

          // find
          out += '\n';
          out +=
              '  static Future<List<$className>> find(Session session, {${className}ExpressionBuilder? where, int? limit, int? offset, Column? orderBy, List<Order>? orderByList, bool orderDescending = false, bool useCache = true, Transaction? transaction,}) async {\n';
          out +=
              '    return session.db.find<$className>(where: where != null ? where($className.t) : null, limit: limit, offset: offset, orderBy: orderBy, orderByList: orderByList, orderDescending: orderDescending, useCache: useCache, transaction: transaction,);\n';
          out += '  }\n';

          // find single row
          out += '\n';
          out +=
              '  static Future<$className?> findSingleRow(Session session, {${className}ExpressionBuilder? where, int? offset, Column? orderBy, bool orderDescending = false, bool useCache = true, Transaction? transaction,}) async {\n';
          out +=
              '    return session.db.findSingleRow<$className>(where: where != null ? where($className.t) : null, offset: offset, orderBy: orderBy, orderDescending: orderDescending, useCache: useCache, transaction: transaction,);\n';
          out += '  }\n';

          // findById
          out += '\n';
          out +=
              '  static Future<$className?> findById(Session session, int id) async {\n';
          out += '    return session.db.findById<$className>(id);\n';
          out += '  }\n';

          // delete
          out += '\n';
          out +=
              '  static Future<int> delete(Session session, {required ${className}ExpressionBuilder where, Transaction? transaction,}) async {\n';
          out +=
              '    return session.db.delete<$className>(where: where($className.t), transaction: transaction,);\n';
          out += '  }\n';

          // deleteRow
          out += '\n';
          out +=
              '  static Future<bool> deleteRow(Session session, $className row, {Transaction? transaction,}) async {\n';
          out +=
              '    return session.db.deleteRow(row, transaction: transaction,);\n';
          out += '  }\n';

          // update
          out += '\n';
          out +=
              '  static Future<bool> update(Session session, $className row, {Transaction? transaction,}) async {\n';
          out +=
              '    return session.db.update(row, transaction: transaction,);\n';
          out += '  }\n';

          // insert
          out += '\n';
          out +=
              '  static Future<void> insert(Session session, $className row, {Transaction? transaction,}) async {\n';
          out +=
              '    return session.db.insert(row, transaction: transaction);\n';
          out += '  }\n';

          // count
          out += '\n';
          out +=
              '  static Future<int> count(Session session, {${className}ExpressionBuilder? where, int? limit, bool useCache = true, Transaction? transaction,}) async {\n';
          out +=
              '    return session.db.count<$className>(where: where != null ? where($className.t) : null, limit: limit, useCache: useCache, transaction: transaction,);\n';
          out += '  }\n';
        }
      }

      // End class
      out += '}\n';
      out += '\n';

      if (serverCode && tableName != null) {
        // Expression builder
        out +=
            'typedef ${className}ExpressionBuilder = Expression Function(${className}Table t);\n';
        out += '\n';

        // Table class definition
        out += 'class ${className}Table extends Table {\n';

        // Constructor
        out += '  ${className}Table() : super(tableName: \'$tableName\');\n';
        out += '\n';

        out += '  @override\n';
        out += '  String tableName = \'$tableName\';\n';

        // Column descriptions
        for (var field in fields) {
          if (field.shouldSerializeFieldForDatabase(serverCode)) {
            out +=
                '  final ${field.name} = ${field.columnType}(\'${field.name}\');\n';
          }
        }
        out += '\n';

        // List of column values
        out += '  @override\n';
        out += '  List<Column> get columns => [\n';
        for (var field in fields) {
          if (field.shouldSerializeFieldForDatabase(serverCode)) {
            out += '    ${field.name},\n';
          }
        }
        out += '  ];\n';

        // End class
        out += '}\n';

        out += '\n';

        // Create instance of table
        out += '@Deprecated(\'Use ${className}Table.t instead.\')\n';
        out += '${className}Table t$className = ${className}Table();\n';
      }
    } catch (e) {
      print('Failed to parse $inputPath: $e');
      return null;
    }

    return out;
  }

  String _expectString(dynamic doc, String field) {
    String? value = doc[field];
    if (value != null) {
      return value;
    } else {
      print('Missing field (String) "$field"');
      throw FormatException('Missing field (String) "$field"');
    }
  }

  Map _expectMap(dynamic doc, String field) {
    Map? map = doc[field];
    if (map != null) {
      return map;
    } else {
      print('Missing field (Map) "$field"');
      throw FormatException('Missing field (Map) "$field"');
    }
  }

  @override
  String generateFactory(Set<ClassInfo> classInfos) {
    var out = '';

    // Header
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
    out += '\n';
    out += '// ignore_for_file: public_member_api_docs\n';
    out += '\n';

    out += 'library protocol;\n';
    out += '\n';

    out += '// ignore: unused_import\n';
    out += 'import \'dart:typed_data\';\n';
    if (serverCode) {
      out += 'import \'package:serverpod/serverpod.dart\';\n';
    } else {
      out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
    }

    out += '\n';

    // Import generated files
    for (var classInfo in classInfos) {
      out += 'import \'${classInfo.fileName}\';\n';
    }
    out += '\n';

    // Export generated files
    for (var classInfo in classInfos) {
      out += 'export \'${classInfo.fileName}\';\n';
    }
    if (!serverCode) out += 'export \'client.dart\';\n';
    out += '\n';

    // Fields
    var extendedClass =
        serverCode ? 'SerializationManagerServer' : 'SerializationManager';

    out += 'class Protocol extends $extendedClass {\n';
    out += '  static final Protocol instance = Protocol();\n';
    out += '\n';

    out += '  final Map<String, constructor> _constructors = {};\n';
    out += '  @override\n';
    out += '  Map<String, constructor> get constructors => _constructors;\n';
    out += '\n';
    if (serverCode) {
      out += '  final Map<String,String> _tableClassMapping = {};\n';
      out += '  @override\n';
      out +=
          '  Map<String,String> get tableClassMapping => _tableClassMapping;\n';
      out += '\n';
      out += '  final Map<Type, Table> _typeTableMapping = {};\n';
      out += '  @override\n';
      out += '  Map<Type, Table> get typeTableMapping => _typeTableMapping;\n';
      out += '\n';
    }

    // Constructor
    out += '  Protocol() {\n';

    for (var classInfo in classInfos) {
      out +=
          '    constructors[\'$classPrefix${classInfo.className}\'] = (Map<String, dynamic> serialization) => ${classInfo.className}.fromSerialization(serialization);\n';
    }

    if (serverCode) {
      out += '\n';
      for (var classInfo in classInfos) {
        if (classInfo.tableName == null) continue;
        out +=
            '    tableClassMapping[\'${classInfo.tableName}\'] = \'$classPrefix${classInfo.className}\';\n';
        out +=
            '    typeTableMapping[${classInfo.className}] = ${classInfo.className}.t;\n';
      }
    }

    out += '  }\n';
    out += '}\n';

    return out;
  }

  String get classPrefix {
    if (config.type == PackageType.server) {
      return '';
    } else {
      return '${config.serverPackage}.';
    }
  }

//  String _endpointClassName(String endpointName) {
//    return '_Endpoint${ReCase(endpointName).pascalCase}';
//  }
}

enum FieldScope {
  database,
  api,
  all,
}

class FieldDefinition {
  String name;
  late TypeDefinition type;
  // bool nullable = true;

  String? get columnType {
    if (type.typeNonNullable == 'int') return 'ColumnInt';
    if (type.typeNonNullable == 'double') return 'ColumnDouble';
    if (type.typeNonNullable == 'bool') return 'ColumnBool';
    if (type.typeNonNullable == 'String') return 'ColumnString';
    if (type.typeNonNullable == 'DateTime') return 'ColumnDateTime';
    if (type.typeNonNullable == 'ByteData') return 'ColumnByteData';
    return 'ColumnSerializable';
  }

  FieldScope scope = FieldScope.all;

  FieldDefinition(this.name, String description) {
    var components = description.split(',').map((String s) {
      return s.trim();
    }).toList();
    var typeStr = components[0];

    if (components.length == 2) {
      var scopeStr = components[1];
      if (scopeStr == 'database') {
        scope = FieldScope.database;
      } else if (scopeStr == 'api') {
        scope = FieldScope.api;
      }
    }

    // TODO: Fix package?
    type = TypeDefinition(typeStr, null);
  }

  String get serialization {
    if (type.isTypedList) {
      if (type.listType!.typeNonNullable == 'String' ||
          type.listType!.typeNonNullable == 'int' ||
          type.listType!.typeNonNullable == 'double' ||
          type.listType!.typeNonNullable == 'bool') {
        return name;
      } else if (type.listType!.typeNonNullable == 'DateTime') {
        if (type.listType!.nullable) {
          return '$name${type.nullable ? '?' : ''}.map<String?>((a) => a?.toIso8601String()).toList()';
        } else {
          return '$name${type.nullable ? '?' : ''}.map<String>((a) => a.toIso8601String()).toList()';
        }
      } else if (type.listType!.typeNonNullable == 'ByteData') {
        if (type.listType!.nullable) {
          return '$name${type.nullable ? '?' : ''}.map<String?>((a) => a?.base64encodedString()).toList()';
        } else {
          return '$name${type.nullable ? '?' : ''}.map<String>((a) => a.base64encodedString()).toList()';
        }
      } else {
        return '$name${type.nullable ? '?' : ''}.map((${type.listType!.type} a) => a${type.listType!.nullable ? '?' : ''}.serialize()).toList()';
      }
    }

    if (type.typeNonNullable == 'String' ||
        type.typeNonNullable == 'int' ||
        type.typeNonNullable == 'double' ||
        type.typeNonNullable == 'bool') {
      return name;
    } else if (type.typeNonNullable == 'DateTime') {
      return '$name${type.nullable ? '?' : ''}.toUtc().toIso8601String()';
    } else if (type.typeNonNullable == 'ByteData') {
      return '$name${type.nullable ? '?' : ''}.base64encodedString()';
    } else {
      return '$name${type.nullable ? '?' : ''}.serialize()';
    }
  }

  String get deserialization {
    if (type.isTypedList) {
      if (type.listType!.typeNonNullable == 'String' ||
          type.listType!.typeNonNullable == 'int' ||
          type.listType!.typeNonNullable == 'double' ||
          type.listType!.typeNonNullable == 'bool') {
        return '_data[\'$name\']${type.nullable ? '?' : '!'}.cast<${type.listType!.type}>()';
      } else if (type.listType!.typeNonNullable == 'DateTime') {
        if (type.listType!.nullable) {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<DateTime?>((a) => a != null ? DateTime.tryParse(a) : null).toList()';
        } else {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<DateTime>((a) => DateTime.tryParse(a)!).toList()';
        }
      } else if (type.listType!.typeNonNullable == 'ByteData') {
        if (type.listType!.nullable) {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<ByteData?>((a) => (a as String?)?.base64DecodedByteData()).toList()';
        } else {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<ByteData>((a) => (a as String).base64DecodedByteData()!).toList()';
        }
      } else {
        if (type.listType!.nullable) {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<${type.listType!.type}>((a) => a != null ? ${type.listType!.type}.fromSerialization(a) : null)?.toList()';
        } else {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<${type.listType!.type}>((a) => ${type.listType!.type}.fromSerialization(a))?.toList()';
        }
      }
    }

    if (type.typeNonNullable == 'String' ||
        type.typeNonNullable == 'int' ||
        type.typeNonNullable == 'double' ||
        type.typeNonNullable == 'bool') {
      return '_data[\'$name\']${type.nullable ? '' : '!'}';
    } else if (type.typeNonNullable == 'DateTime') {
      if (type.nullable) {
        return '_data[\'$name\'] != null ? DateTime.tryParse(_data[\'$name\']) : null';
      } else {
        return 'DateTime.tryParse(_data[\'$name\'])!';
      }
    } else if (type.typeNonNullable == 'ByteData') {
      if (type.nullable) {
        return '_data[\'$name\'] == null ? null : (_data[\'$name\'] is String ? (_data[\'$name\'] as String).base64DecodedByteData() : ByteData.view((_data[\'$name\'] as Uint8List).buffer))';
      } else {
        return '_data[\'$name\'] is String ? (_data[\'$name\'] as String).base64DecodedByteData()! : ByteData.view((_data[\'$name\'] as Uint8List).buffer)';
      }
      // return '(_data[\'$name\'] as String?)!.base64DecodedByteData()!';
    } else {
      if (type.nullable) {
        return '_data[\'$name\'] != null ? $type.fromSerialization(_data[\'$name\']) : null';
      } else {
        return '$type.fromSerialization(_data[\'$name\'])';
      }
    }
  }

  bool shouldIncludeField(bool serverCode) {
    if (serverCode) return true;
    if (scope == FieldScope.all || scope == FieldScope.api) return true;
    return false;
  }

  bool shouldSerializeField(bool serverCode) {
    if (scope == FieldScope.all || scope == FieldScope.api) return true;
    return false;
  }

  bool shouldSerializeFieldForDatabase(bool serverCode) {
    assert(serverCode);
    if (scope == FieldScope.all || scope == FieldScope.database) return true;
    return false;
  }
}
