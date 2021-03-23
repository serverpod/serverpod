class ProtocolDefinition {
  final List<EndpointDefinition> endpoints;

  ProtocolDefinition({this.endpoints});
}

class EndpointDefinition {
  final String name;
  final List<MethodDefinition> methods;

  EndpointDefinition({this.name, this.methods,});
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

  ParameterDefinition({this.name, this.type});
}