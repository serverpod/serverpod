import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

import 'type_definition_builder.dart';

class FutureCallParameterDefinitionBuilder {
  String _name = 'example';
  TypeDefinition _type = TypeDefinitionBuilder().withFutureOf('void').build();
  List<ParameterDefinition> _parameters = [];
  List<ParameterDefinition> _parametersPositional = [];
  List<ParameterDefinition> _parametersNamed = [];

  FutureCallParameterDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  FutureCallParameterDefinitionBuilder withType(TypeDefinition type) {
    _type = type;
    return this;
  }

  FutureCallParameterDefinitionBuilder withParameters(
    List<ParameterDefinition> parameters,
  ) {
    _parameters = parameters;
    return this;
  }

  FutureCallParameterDefinitionBuilder withParametersPositional(
    List<ParameterDefinition> parametersPositional,
  ) {
    _parametersPositional = parametersPositional;
    return this;
  }

  FutureCallParameterDefinitionBuilder withParametersNamed(
    List<ParameterDefinition> parametersNamed,
  ) {
    _parametersNamed = parametersNamed;
    return this;
  }

  FutureCallParameterDefinition build() {
    return FutureCallParameterDefinition(
      name: _name,
      type: _type,
      parameters: _parameters,
      parametersPositional: _parametersPositional,
      parametersNamed: _parametersNamed,
    );
  }
}
