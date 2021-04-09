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
  final String type;

  ParameterDefinition({required this.name, required this.type,});
}