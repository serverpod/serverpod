// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';

class MethodDefinitionBuilder {
  String _name;
  String? _documentation;
  final List<ParameterDefinition> _params;
  final List<ParameterDefinition> _parametersPositional;
  final List<ParameterDefinition> _parametersNamed;
  TypeDefinition _returnType;

  MethodDefinitionBuilder()
      : _name = 'hello',
        _params = [],
        _parametersPositional = [],
        _parametersNamed = [],
        _returnType = TypeDefinitionBuilder().withClassName('String').build();

  MethodDefinition build() {
    return MethodDefinition(
        name: _name,
        documentationComment: _documentation,
        parameters: _params,
        parametersPositional: _parametersPositional,
        parametersNamed: _parametersNamed,
        returnType: _returnType);
  }

  MethodDefinitionBuilder withMethodName(String methodName) {
    _name = methodName;
    return this;
  }

  MethodDefinitionBuilder withReturnType(TypeDefinition returnType) {
    _returnType = returnType;
    return this;
  }

  MethodDefinitionBuilder withParameter(ParameterDefinition param) {
    _params.add(param);
    return this;
  }

  MethodDefinitionBuilder withPositionalParameter(ParameterDefinition param) {
    _parametersPositional.add(param);
    return this;
  }

  MethodDefinitionBuilder withNamedParameter(ParameterDefinition param) {
    _parametersNamed.add(param);
    return this;
  }

  MethodDefinitionBuilder withDocumentation(String documentation) {
    _documentation = documentation;
    return this;
  }
}
