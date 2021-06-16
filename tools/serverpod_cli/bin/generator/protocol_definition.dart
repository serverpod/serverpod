import 'config.dart';

class ProtocolDefinition {
  final List<EndpointDefinition> endpoints;
  final List<String> filePaths;

  ProtocolDefinition({required this.endpoints, required this.filePaths,});
}

class EndpointDefinition {
  final String name;
  final String className;
  final List<MethodDefinition> methods;

  EndpointDefinition({required this.name, required this.methods, required this.className,});
}

class MethodDefinition {
  final String name;
  final TypeDefinition returnType;
  final List<ParameterDefinition> parameters;
  final List<ParameterDefinition> parametersPositional;
  final List<ParameterDefinition> parametersNamed;

  MethodDefinition({required this.name, required this.parameters, required this.parametersPositional, required this.parametersNamed, required this.returnType});
}

class ParameterDefinition {
  final String name;
  final TypeDefinition type;

  ParameterDefinition({required this.name, required this.type});
}

class TypeDefinition {
  late final bool nullable;
  late final bool isTypedList;
  late final TypeDefinition? listType;
  late final String typeNonNullable;
  late final String type;
  final String? package;

  String get typePrefix {
    var prefix = '';
    if (package != null && package != 'core' && package != config.serverPackage) {
      prefix = '${stripPackage(package!)}.';
    }
    return prefix;
  }

  TypeDefinition(String type, this.package, {bool stripFuture=false}) {
    // Remove all spaces
    var trimmed = type.replaceAll(' ', '');

    if (stripFuture) {
      if (!trimmed.startsWith('Future<') || ! trimmed.endsWith('>'))
        throw(FormatException('Expected type to be future'));
      trimmed = trimmed.substring(7, trimmed.length - 1);
    }

    // Check if it's a nullable type
    nullable = trimmed.endsWith('?');
    var withoutQuestion = nullable ? trimmed.substring(0, trimmed.length - 1) : trimmed;

    // Check if it's a list
    isTypedList = withoutQuestion.startsWith('List<') && withoutQuestion.endsWith('>');
    if (isTypedList) {
      var listTypeStr = withoutQuestion.substring(5, withoutQuestion.length - 1);
      listType = TypeDefinition(listTypeStr, package);
    }

    // Generate type strings
    if (isTypedList) {
      this.type = 'List<${listType!.type}>${nullable ? '?': ''}';
      typeNonNullable = 'List<${listType!.typeNonNullable}>';
    }
    else {
      this.type = '$withoutQuestion${nullable ? '?': ''}';
      typeNonNullable = withoutQuestion;
    }
  }

  String get databaseType {
    if (typeNonNullable == 'String')
      return 'text';
    if (typeNonNullable == 'bool')
      return 'boolean';
    if (typeNonNullable == 'int')
      return 'integer';
    if (typeNonNullable == 'double')
      return 'double precision';
    if (typeNonNullable == 'DateTime')
      return 'timestamp without time zone';
    if (typeNonNullable == 'ByteData')
      return 'bytea';

    return 'json';
  }

  @override
  String toString() {
    return type;
  }
}