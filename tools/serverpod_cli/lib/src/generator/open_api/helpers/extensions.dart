import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';
import 'package:serverpod_cli/src/generator/types.dart';

/// Check whether [TypeDefinition] is dartCoreType or not.
extension TypeDefinitionExtension on TypeDefinition {
  bool get isCoreDartType =>
      className == 'String' ||
      className == 'int' ||
      className == 'double' ||
      className == 'bool' ||
      className == 'List' ||
      className == 'Map' ||
      className == 'Set' ||
      className == 'ByteData' ||
      className == 'BigInt' ||
      className == 'DateTime' ||
      className == 'UuidValue' ||
      className == 'Duration' ||
      url == 'dart:core' ||
      url == 'dart:async';

  /// Convert [TypeDefinition] to [SchemaObjetType].
  SchemaObjectType get toSchemaObjectType {
    switch (className) {
      case 'int':
        return SchemaObjectType.integer;
      case 'double':
        return SchemaObjectType.number;
      case 'BigInt':
        return SchemaObjectType.number;
      case 'bool':
        return SchemaObjectType.boolean;
      case 'String':
        return SchemaObjectType.string;
      case 'DateTime':
        return SchemaObjectType.string;
      case 'ByteData':
        return SchemaObjectType.string;
      case 'Duration':
        return SchemaObjectType.string;
      case 'UuidValue':
        return SchemaObjectType.string;
      case 'List':
        return SchemaObjectType.array;
      case 'Map':
        return SchemaObjectType.object;
      default:
        return SchemaObjectType.serializableObjects;
    }
  }

  /// Check whether [TypeDefinition] is UnknownSchemaType or not.
  bool get isUnknownSchemaType =>
      toSchemaObjectType == SchemaObjectType.serializableObjects;

  /// convert [TypeDefinition] className to [SchemaObjetFormat]
  SchemaObjectFormat? get toSchemaObjectFormat {
    if (className == 'int') return SchemaObjectFormat.int64;
    if (className == 'double') return SchemaObjectFormat.float;
    if (className == 'DateTime') return SchemaObjectFormat.dateTime;
    if (className == 'ByteData') return SchemaObjectFormat.byte;
    if (className == 'Duration') return SchemaObjectFormat.time;
    if (className == 'UuidValue') return SchemaObjectFormat.uuid;
    return null;
  }
}
