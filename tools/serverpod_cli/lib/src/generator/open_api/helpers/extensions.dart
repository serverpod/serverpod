import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';
import 'package:serverpod_cli/src/generator/types.dart';

/// Check whether [TypeDefinition] is dartCoreType or not.
extension CheckDartCoreType on TypeDefinition {
  bool get isDartCoreType =>
      (className == 'String') ||
      (className == 'int') ||
      (className == 'double') ||
      (className == 'bool') ||
      (className == 'List') ||
      (className == 'Map') ||
      (className == 'Set') ||
      (className == 'ByteData') ||
      (className == 'BigInt') ||
      (className == 'DateTime') ||
      (className == 'UuidValue') ||
      (className == 'Duration') ||
      (url == 'dart:core') ||
      (url == 'dart:async');
}

/// Check whether [TypeDefinition] is otherType or not.
extension CheckIsOtherType on TypeDefinition {
  bool get isOtherType => toSchemaObjectType == SchemaObjectType.other;
}

/// example
/// convert [dateTime] -> [date-time]
/// convert [string] -> [string]
///
extension ChangeFormat on SchemaObjectFormat {
  String get formattedName => name.paramCase;
}

/// Convert [TypeDefinition] to [SchemaObjetType].
extension TypeConvert on TypeDefinition {
  SchemaObjectType get toSchemaObjectType {
    if (className == 'int') return SchemaObjectType.integer;
    if (className == 'double') return SchemaObjectType.number;
    if (className == 'BigInt') return SchemaObjectType.number;
    if (className == 'bool') return SchemaObjectType.boolean;
    if (className == 'String') return SchemaObjectType.string;
    if (className == 'DateTime') return SchemaObjectType.string;
    if (className == 'ByteData') return SchemaObjectType.string;
    if (className == 'Duration') return SchemaObjectType.string;
    if (className == 'UuidValue') return SchemaObjectType.string;
    if (className == 'List' || isListType) return SchemaObjectType.array;
    if (className == 'Map' || isMapType) return SchemaObjectType.object;
    return SchemaObjectType.other;
  }
}

/// convert [TypeDefinition] className to [SchemaObjetFormat]
extension ConvertFormat on TypeDefinition {
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
