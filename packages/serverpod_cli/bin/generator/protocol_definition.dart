class ProtocolDefinition {
  final List<EndpointDefinition> endpoints;
  final List<String> filePaths;

  ProtocolDefinition({this.endpoints, this.filePaths,});
}

class EndpointDefinition {
  final String name;
  final String className;
  final List<MethodDefinition> methods;

  EndpointDefinition({this.name, this.methods, this.className,});
}

class MethodDefinition {
  final String name;
  final String returnType;
  final List<ParameterDefinition> parameters;
  final List<ParameterDefinition> parametersPositional;
  final List<ParameterDefinition> parametersNamed;

  MethodDefinition({this.name, this.parameters, this.parametersPositional, this.parametersNamed, this.returnType});
}

class ParameterDefinition {
  final String name;
  final String type;

  ParameterDefinition({this.name, this.type,});
}