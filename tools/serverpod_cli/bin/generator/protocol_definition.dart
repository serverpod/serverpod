import 'package:analyzer/dart/element/element.dart';

import 'class_generator_dart.dart';
import 'types.dart';

class ProtocolDefinition {
  final List<EndpointDefinition> endpoints;
  final List<String> filePaths;

  ProtocolDefinition({
    required this.endpoints,
    required this.filePaths,
  });
}

class EndpointDefinition {
  final String name;
  final String? documentationComment;
  final String className;
  final String fileName;
  final List<MethodDefinition> methods;

  EndpointDefinition({
    required this.name,
    required this.documentationComment,
    required this.methods,
    required this.className,
    required this.fileName,
  });
}

class MethodDefinition {
  final String name;
  final String? documentationComment;
  final TypeDefinition returnType;
  final List<ParameterDefinition> parameters;
  final List<ParameterDefinition> parametersPositional;
  final List<ParameterDefinition> parametersNamed;

  MethodDefinition(
      {required this.name,
      required this.documentationComment,
      required this.parameters,
      required this.parametersPositional,
      required this.parametersNamed,
      required this.returnType});
}

class ParameterDefinition {
  final String name;
  final TypeDefinition type;
  final bool required;
  final ParameterElement? dartParameter;

  ParameterDefinition({
    required this.name,
    required this.type,
    required this.required,
    this.dartParameter,
  });
}

// abstract class ParsedType {
//   const ParsedType();

//   factory ParsedType.parse(String type) {
//     if (type.startsWith('List<')) {
//       return ParsedListType.parse(type);
//     } else if (type.startsWith('Map<')) {
//       return ParsedMapType.parse(type);
//     } else if (type.startsWith('Set<')) {
//       return ParsedSetType.parse(type);
//     } else {
//       return ParsedLiteralType(type);
//     }
//   }

//   String get type;
//   bool get nullable => type.endsWith('?');
//   String get typeNonNullable =>
//       nullable ? type.substring(0, type.length - 1) : type;
// }

// class ParsedLiteralType extends ParsedType {
//   @override
//   final String type;

//   ParsedLiteralType(this.type);
// }

// class _TypeParseResult {
//   final dynamic type;
//   final int parsePosition;

//   _TypeParseResult(this.type, this.parsePosition);

//   static _TypeParseResult parseGenerics(String input) {
//     String type = "";
//     for (var i = 0; i < input.length; i++) {
//       switch (input[i]) {
//         case ",":
//         case ">":
//           print('${input[i]} with type $type');
//           return _TypeParseResult(type, i);
//         case "<":
//           final generics = [];
//           while (true) {
//             final result = parse(input.substring(i + 1));
//             generics.add(result.type);
//             i = i + 1 + result.parsePosition;
//             if (input[i] != ",") {
//               break;
//             }
//           }
//           return _TypeParseResult(MapEntry(type, generics), i);
//         default:
//           type += input[i];
//       }
//     }
//     return _TypeParseResult(type, input.length - 1);
//   }
// }

// class ParsedListType extends ParsedType {
//   final ParsedType listType;
//   final bool _nullable;

//   const ParsedListType(this.listType, bool nullable) : _nullable = nullable;
//   factory ParsedListType.parse(String type) {
//     if (!type.startsWith('List<') ||
//         !(type.endsWith('>') || type.endsWith('>?'))) {
//       throw (FormatException('$type is no valid List definition.'));
//     }
//     bool nullable = type.endsWith('?');
//     String listType = type.substring(5, type.length - (nullable ? 3 : 2));
//     return ParsedListType(ParsedType.parse(listType), nullable);
//   }

//   @override
//   String get type => 'List<${listType.type}>';
// }

// class ParsedSetType extends ParsedListType {
//   @override
//   String get type => 'Set<${listType.type}>';
// }

// class ParsedMapType extends ParsedType {
//   final ParsedType keyType;
//   final ParsedType valueType;

//   @override
//   String get type => 'Map<${keyType.type},${valueType.type}>';
// }

// class ListTypeDefinition extends TypeDefinition {
//   final bool isSet;
//   final TypeDefinition elementsType;
// }

// class MapTypeDefinition extends TypeDefinition {
//   final TypeDefinition keysType;
//   final TypeDefinition valuesType;
// }

// class ClassTypeDefinition extends TypeDefinition {
//   final String type;
// }

// abstract class TypeDefinition {
//   final bool nullable;

//   String typeStringNonNullable([bool withPrefix = false]) =>
//       typeString(withPrefix) + (nullable ? '?' : '');
//   String typeString([bool withPrefix = false]);

//   final String? package;
//   final String? innerPackage;
//   final DartType? dartType;

//   String get typePrefix {
//     var prefix = '';
//     if (package != null &&
//         package != 'core' &&
//         package != config.serverPackage) {
//       prefix = '${stripPackage(package!)}.';
//     }
//     return prefix;
//   }

//   String get typeNonNullableWithPrefix {
//     if (isTypedList) {
//       return 'List<${listType!.typeWithPrefix}>';
//     } else if (isTypedMap) {
//       return 'Map<String, ${mapType!.typeWithPrefix}>';
//     } else {
//       return '$typePrefix$typeNonNullable';
//     }
//   }

//   String get typeWithPrefix {
//     return '$typeNonNullableWithPrefix${nullable ? '?' : ''}';
//   }

//   TypeDefinition(
//     String type,
//     this.package,
//     this.innerPackage, {
//     bool stripFuture = false,
//     this.dartType,
//   }) {
//     // Remove all spaces
//     var trimmed = type.replaceAll(' ', '');

//     if (stripFuture) {
//       if (!trimmed.startsWith('Future<') || !trimmed.endsWith('>'))
//         // ignore: curly_braces_in_flow_control_structures
//         throw (const FormatException('Expected type to be future'));
//       trimmed = trimmed.substring(7, trimmed.length - 1);
//     }

//     // Check if it's a nullable type
//     nullable = trimmed.endsWith('?');
//     var withoutQuestion =
//         nullable ? trimmed.substring(0, trimmed.length - 1) : trimmed;

//     // Check if it's a List
//     isTypedList =
//         withoutQuestion.startsWith('List<') && withoutQuestion.endsWith('>');
//     if (isTypedList) {
//       var listTypeStr =
//           withoutQuestion.substring(5, withoutQuestion.length - 1);
//       listType = TypeDefinition(listTypeStr, innerPackage, null);
//     }

//     // Check if it's a Map
//     isTypedMap =
//         withoutQuestion.startsWith('Map<') && withoutQuestion.endsWith('>');
//     if (isTypedMap) {
//       var mapTypesStr =
//           withoutQuestion.substring(4, withoutQuestion.length - 1);
//       var mapComponents = mapTypesStr.split(',');
//       if (mapComponents.length != 2) {
//         throw const FormatException(
//             'A Map requires a key type and a value type');
//       }
//       // if (mapComponents[0].trim() != 'String') {
//       //   throw const FormatException('Only String is allowed as Map keys');
//       // }
//       mapType = TypeDefinition(mapComponents[1], innerPackage, null);
//     }

//     // Generate type strings
//     if (isTypedList) {
//       this.type = 'List<${listType!.type}>${nullable ? '?' : ''}';
//       typeNonNullable = 'List<${listType!.type}>';
//     } else if (isTypedMap) {
//       this.type = 'Map<String,${mapType!.type}>${nullable ? '?' : ''}';
//       typeNonNullable = 'Map<String,${mapType!.type}>';
//     } else {
//       this.type = '$withoutQuestion${nullable ? '?' : ''}';
//       typeNonNullable = withoutQuestion;
//     }
//   }

//   String get databaseType {
//     if (typeNonNullable == 'String') return 'text';
//     if (typeNonNullable == 'bool') return 'boolean';
//     if (typeNonNullable == 'int') return 'integer';
//     if (typeNonNullable == 'double') return 'double precision';
//     if (typeNonNullable == 'DateTime') return 'timestamp without time zone';
//     if (typeNonNullable == 'ByteData') return 'bytea';

//     return 'json';
//   }

//   @override
//   String toString() {
//     return type;
//   }
// }

class IndexDefinition {
  final String name;
  late final List<String> fields;
  late final String type;
  late final bool unique;

  IndexDefinition(this.name, Map doc) {
    String fieldsStr = doc['fields'];
    fields = fieldsStr.split(',').map((String str) => str.trim()).toList();
    type = doc['type'] ?? 'btree';
    unique = (doc['unique'] ?? 'false') != 'false';
  }

  IndexDefinition.parsed({
    required this.name,
    required this.type,
    required this.unique,
    required this.fields,
  });
}

abstract class ProtocolFileDefinition {
  final String fileName;
  final String className;

  ProtocolFileDefinition({
    required this.fileName,
    required this.className,
  });
}

class ClassDefinition extends ProtocolFileDefinition {
  final String? tableName;
  final List<FieldDefinition> fields;
  final List<IndexDefinition>? indexes;

  ClassDefinition({
    required super.fileName,
    required super.className,
    required this.fields,
    this.tableName,
    this.indexes,
  });
}

class EnumDefinition extends ProtocolFileDefinition {
  List<String> values;

  EnumDefinition({
    required super.fileName,
    required super.className,
    required this.values,
  });
}
