import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';

class MethodDefinitionBuilder {
  String _name = 'example';
  String? _documentationComment;
  TypeDefinition _returnType =
      TypeDefinitionBuilder().withFutureOf('String').build();
  List<ParameterDefinition> _parameters = [];
  List<ParameterDefinition> _parametersPositional = [];
  List<ParameterDefinition> _parametersNamed = [];

  MethodDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  MethodDefinitionBuilder withDocumentationComment(
      String? documentationComment) {
    _documentationComment = documentationComment;
    return this;
  }

  MethodDefinitionBuilder withReturnType(TypeDefinition returnType) {
    _returnType = returnType;
    return this;
  }

  MethodDefinitionBuilder withParameters(List<ParameterDefinition> parameters) {
    _parameters = parameters;
    return this;
  }

  MethodDefinitionBuilder withParametersPositional(
      List<ParameterDefinition> parametersPositional) {
    _parametersPositional = parametersPositional;
    return this;
  }

  MethodDefinitionBuilder withParametersNamed(
      List<ParameterDefinition> parametersNamed) {
    _parametersNamed = parametersNamed;
    return this;
  }

  MethodDefinition build() {
    return MethodDefinition(
      name: _name,
      documentationComment: _documentationComment,
      returnType: _returnType,
      parameters: _parameters,
      parametersPositional: _parametersPositional,
      parametersNamed: _parametersNamed,
    );
  }
}
