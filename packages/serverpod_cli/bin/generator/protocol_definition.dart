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
  final String returnType;
  final List<ParameterDefinition> parameters;
  final List<ParameterDefinition> parametersPositional;
  final List<ParameterDefinition> parametersNamed;

  MethodDefinition({required this.name, required this.parameters, required this.parametersPositional, required this.parametersNamed, required this.returnType});
}

class ParameterDefinition {
  final String name;
  final TypeDefinition type;

  ParameterDefinition({required this.name, required this.type,});
}

class TypeDefinition {
  late final bool nullable;
  late final bool isTypedList;
  late final TypeDefinition? listType;
  late final String typeNonNullable;
  late final String type;

  TypeDefinition(String type) {
    // Remove all spaces
    var trimmed = type.replaceAll(' ', '');

    // Check if it's a nullable type
    nullable = trimmed.endsWith('?');
    String withoutQuestion = nullable ? trimmed.substring(0, trimmed.length - 1) : trimmed;

    // Check if it's a list
    isTypedList = withoutQuestion.startsWith('List<') && withoutQuestion.endsWith('>');
    if (isTypedList) {
      String listTypeStr = withoutQuestion.substring(5, withoutQuestion.length - 1);
      listType = TypeDefinition(listTypeStr);
    }

    // Generate type strings
    if (isTypedList) {
      this.type = 'List<${listType!.type}>${nullable ? '?': ''}';
      typeNonNullable = 'List<${listType!.typeNonNullable}>';
    }
    else {
      this.type = '$withoutQuestion${nullable ? '?': ''}';
      this.typeNonNullable = withoutQuestion;
    }
  }

  @override
  String toString() {
    return type;
  }
}