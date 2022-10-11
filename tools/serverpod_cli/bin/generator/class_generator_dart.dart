//import 'package:recase/recase.dart';

import 'dart:io';
import 'package:path/path.dart' as p;
import 'class_generator.dart';
import 'config.dart';
import 'protocol_definition.dart';

class ClassGeneratorDart extends ClassGenerator {
  @override
  String get outputExtension => '.dart';

  ClassGeneratorDart({
    required super.outputDirectoryPath,
    required super.verbose,
    required super.serverCode,
    required super.classDefinitions,
  });

  @override
  String generateFile(ProtocolFileDefinition protocolFileDefinition) {
    if (protocolFileDefinition is ClassDefinition) {
      return _generateClassFile(protocolFileDefinition);
    }
    if (protocolFileDefinition is EnumDefinition) {
      return _generateEnumFile(protocolFileDefinition);
    }

    throw Exception('Unsupported protocol file type.');
  }

  // Handle ordinary classes
  String _generateClassFile(ClassDefinition classDefinition) {
    var out = '';

    String? tableName = classDefinition.tableName;
    var className = classDefinition.className;
    var fields = classDefinition.fields;

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
    out += '// ignore_for_file: unnecessary_import\n';
    out += '// ignore_for_file: overridden_fields\n';
    out += '// ignore_for_file: no_leading_underscores_for_local_identifiers\n';
    out += '// ignore_for_file: depend_on_referenced_packages\n';
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
    var sDir = classDefinition.subDir?.split(Platform.pathSeparator) ?? [];
    sDir = sDir.map((e) => '..').toList();
    out += 'import \'${sDir.isEmpty ? '.' : p.joinAll(sDir)}/protocol.dart\';\n';
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
        out += '    return session.db.insert(row, transaction: transaction);\n';
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

    return out;
  }

  // Handle enums.
  String _generateEnumFile(EnumDefinition enumDefinition) {
    var out = '';

    String enumName = enumDefinition.className;

    // Header
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
    out += '\n';
    out += '// ignore_for_file: public_member_api_docs\n';
    out += '// ignore_for_file: unnecessary_import\n';
    out += '// ignore_for_file: no_leading_underscores_for_local_identifiers\n';
    out += '// ignore_for_file: depend_on_referenced_packages\n';
    out += '\n';

    if (serverCode) {
      out +=
          'import \'package:serverpod_serialization/serverpod_serialization.dart\';\n';
    } else {
      out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
    }

    out += 'enum $enumName with SerializableEntity {\n';
    for (var value in enumDefinition.values) {
      out += '  $value,\n';
    }
    out += ';\n';

    out += '  static String get _className => \'$enumName\';\n';
    out += '\n';
    out += '  @override\n';
    out += '  String get className => _className;\n';
    out += '\n';

    // Serialization
    out +=
        '  factory $enumName.fromSerialization(Map<String, dynamic> serialization) {\n';
    out +=
        '    var data = SerializableEntity.unwrapSerializationDataForClassName(_className, serialization);\n';
    out += '    switch (data[\'index\']) {\n';
    var i = 0;
    for (var value in enumDefinition.values) {
      out += '      case $i:\n';
      out += '        return $enumName.$value;\n';
      i += 1;
    }
    out += '      default:\n';
    out +=
        '        throw Exception(\'Invalid \$_className index \$data[\\\'index\\\']\');\n';
    out += '    }\n';
    out += '  }\n';
    out += '\n';

    out += '  @override\n';
    out += '  Map<String, dynamic> serialize() {\n';
    out += '    return wrapSerializationData({\n';
    out += '      \'index\': index,\n';
    out += '    });\n';
    out += '  }\n';

    out += '}\n';
    return out;
  }

  @override
  String generateFactory(List<ProtocolFileDefinition> classInfos) {
    var out = '';

    // Header
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
    out += '\n';
    out += '// ignore_for_file: public_member_api_docs\n';
    out += '// ignore_for_file: unnecessary_import\n';
    out += '// ignore_for_file: no_leading_underscores_for_local_identifiers\n';
    out += '// ignore_for_file: library_private_types_in_public_api\n';
    out += '// ignore_for_file: depend_on_referenced_packages\n';
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
      out +=
          'import \'${classInfo.subDir ?? '.'}/${classInfo.fileName}.dart\';\n';
    }
    out += '\n';

    // Export generated files
    for (var classInfo in classInfos) {
      out +=
          'export \'${classInfo.subDir ?? '.'}/${classInfo.fileName}.dart\';\n';
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
        if (classInfo is! ClassDefinition || classInfo.tableName == null) {
          continue;
        }
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
}

enum FieldScope {
  database,
  api,
  all,
}

class FieldDefinition {
  String name;
  late TypeDefinition type;

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
  String? parentTable;

  FieldDefinition(this.name, String description) {
    var components = description.split(',').map((s) => s.trim()).toList();
    var typeStr = components[0];

    // Fix for handling Maps where the type contains a comma (which is also used
    // to separate the options).
    if (typeStr.startsWith('Map<') && components.length >= 2) {
      typeStr = '$typeStr,${components[1]}';
      components.removeAt(1);
    }

    if (components.length >= 2) {
      _parseOptions(components.sublist(1));
    }

    // TODO: Fix package?
    type = TypeDefinition(typeStr, null, null);
  }

  void _parseOptions(List<String> options) {
    for (var option in options) {
      if (option == 'database') {
        scope = FieldScope.database;
      } else if (option == 'api') {
        scope = FieldScope.api;
      } else if (option.startsWith('parent')) {
        var components = option.split('=').map((s) => s.trim()).toList();
        if (components.length == 2 && components[0] == 'parent') {
          parentTable = components[1];
        }
      }
    }
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

    if (type.isTypedMap) {
      if (type.mapType!.typeNonNullable == 'String' ||
          type.mapType!.typeNonNullable == 'int' ||
          type.mapType!.typeNonNullable == 'double' ||
          type.mapType!.typeNonNullable == 'bool') {
        return name;
      } else if (type.mapType!.typeNonNullable == 'DateTime') {
        if (type.mapType!.nullable) {
          return '$name${type.nullable ? '?' : ''}.map<String,String?>((key, value) => MapEntry(key, value?.toIso8601String()))';
        } else {
          return '$name${type.nullable ? '?' : ''}.map<String,String?>((key, value) => MapEntry(key, value.toIso8601String()))';
        }
      } else if (type.mapType!.typeNonNullable == 'ByteData') {
        if (type.mapType!.nullable) {
          return '$name${type.nullable ? '?' : ''}.map<String,String?>((key, value) => MapEntry(key, value?.base64encodedString()))';
        } else {
          return '$name${type.nullable ? '?' : ''}.map<String,String>((key, value) => MapEntry(key, value.base64encodedString()))';
        }
      } else {
        return '$name${type.nullable ? '?' : ''}.map<String, Map<String, dynamic>${type.mapType!.nullable ? '?' : ''}>((String key, ${type.mapType!.type} value) => MapEntry(key, value${type.mapType!.nullable ? '?' : ''}.serialize()))';
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

    if (type.isTypedMap) {
      if (type.mapType!.typeNonNullable == 'String' ||
          type.mapType!.typeNonNullable == 'int' ||
          type.mapType!.typeNonNullable == 'double' ||
          type.mapType!.typeNonNullable == 'bool') {
        return '_data[\'$name\']${type.nullable ? '?' : '!'}.cast<String, ${type.mapType!.type}>()';
      } else if (type.mapType!.typeNonNullable == 'DateTime') {
        if (type.mapType!.nullable) {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, DateTime?>((String key, dynamic value) => MapEntry(key, value == null ? null : DateTime.tryParse(value as String)))';
        } else {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, DateTime>((String key, dynamic value) => MapEntry(key, DateTime.tryParse(value as String)!))';
        }
      } else if (type.mapType!.typeNonNullable == 'ByteData') {
        if (type.mapType!.nullable) {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, ByteData?>((String key, dynamic value) => MapEntry(key, (value as String?)?.base64DecodedByteData()))';
        } else {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, ByteData>((String key, dynamic value) => MapEntry(key, (value as String).base64DecodedByteData()!))';
        }
      } else {
        if (type.mapType!.nullable) {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, ${type.mapType!.type}>((String key, dynamic value) => MapEntry(key, value != null ? ${type.mapType!.type}.fromSerialization(value) : null))';
        } else {
          return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, ${type.mapType!.type}>((String key, dynamic value) => MapEntry(key, ${type.mapType!.type}.fromSerialization(value)))';
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
