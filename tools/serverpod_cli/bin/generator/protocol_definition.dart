import 'config.dart';

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
  final List<MethodDefinition> methods;

  EndpointDefinition({
    required this.name,
    required this.documentationComment,
    required this.methods,
    required this.className,
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

  ParameterDefinition({required this.name, required this.type});
}

class TypeDefinition {
  late final bool nullable;
  late final bool isTypedList;
  late final bool isTypedMap;
  late final TypeDefinition? listType;
  late final TypeDefinition? mapType;
  late final String typeNonNullable;
  late final String type;
  final String? package;

  String get typePrefix {
    var prefix = '';
    if (package != null &&
        package != 'core' &&
        package != config.serverPackage) {
      prefix = '${stripPackage(package!)}.';
    }
    return prefix;
  }

  TypeDefinition(String type, this.package, {bool stripFuture = false}) {
    // Remove all spaces
    var trimmed = type.replaceAll(' ', '');

    if (stripFuture) {
      if (!trimmed.startsWith('Future<') || !trimmed.endsWith('>'))
        // ignore: curly_braces_in_flow_control_structures
        throw (const FormatException('Expected type to be future'));
      trimmed = trimmed.substring(7, trimmed.length - 1);
    }

    // Check if it's a nullable type
    nullable = trimmed.endsWith('?');
    var withoutQuestion =
        nullable ? trimmed.substring(0, trimmed.length - 1) : trimmed;

    // Check if it's a List
    isTypedList =
        withoutQuestion.startsWith('List<') && withoutQuestion.endsWith('>');
    if (isTypedList) {
      var listTypeStr =
          withoutQuestion.substring(5, withoutQuestion.length - 1);
      listType = TypeDefinition(listTypeStr, package);
    }

    // Check if it's a Map
    isTypedMap =
        withoutQuestion.startsWith('Map<') && withoutQuestion.endsWith('>');
    if (isTypedMap) {
      print('TypeDefinition type: $type package: $package');
      print(' - isTypedMap');
      var mapTypesStr =
          withoutQuestion.substring(4, withoutQuestion.length - 1);
      var mapComponents = mapTypesStr.split(',');
      if (mapComponents.length != 2) {
        throw const FormatException(
            'A Map requires a key type and a value type');
      }
      if (mapComponents[0].trim() != 'String') {
        throw const FormatException('Only String is allowed as Map keys');
      }
      print(' - mapComponents: $mapComponents');
      mapType = TypeDefinition(mapComponents[1], package);
      print(' - mapType: ${mapType?.type}');
    }

    // Generate type strings
    if (isTypedList) {
      this.type = 'List<${listType!.type}>${nullable ? '?' : ''}';
      typeNonNullable = 'List<${listType!.typeNonNullable}>';
    } else if (isTypedMap) {
      this.type = 'Map<String,${mapType!.type}>${nullable ? '?' : ''}';
      typeNonNullable = 'Map<String,${mapType!.typeNonNullable}>';
    } else {
      this.type = '$withoutQuestion${nullable ? '?' : ''}';
      typeNonNullable = withoutQuestion;
    }
  }

  String get databaseType {
    if (typeNonNullable == 'String') return 'text';
    if (typeNonNullable == 'bool') return 'boolean';
    if (typeNonNullable == 'int') return 'integer';
    if (typeNonNullable == 'double') return 'double precision';
    if (typeNonNullable == 'DateTime') return 'timestamp without time zone';
    if (typeNonNullable == 'ByteData') return 'bytea';

    return 'json';
  }

  @override
  String toString() {
    return type;
  }
}
