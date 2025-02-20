import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/class_type_definition_builder.dart';

class MethodDefinitionBuilder {
  String _name = 'example';
  String? _documentationComment;
  List<AnnotationDefinition> _annotations = [];
  ClassTypeDefinition _returnType =
      ClassTypeDefinitionBuilder().withFutureOf('String').build();
  List<ParameterDefinition> _parameters = [];
  List<ParameterDefinition> _parametersPositional = [];
  List<ParameterDefinition> _parametersNamed = [];

  MethodDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  MethodDefinitionBuilder withDocumentationComment(
    String? documentationComment,
  ) {
    _documentationComment = documentationComment;
    return this;
  }

  MethodDefinitionBuilder withAnnotations(
    List<AnnotationDefinition> annotations,
  ) {
    _annotations = annotations;
    return this;
  }

  MethodDefinitionBuilder withReturnType(ClassTypeDefinition returnType) {
    _returnType = returnType;
    return this;
  }

  MethodDefinitionBuilder withParameters(List<ParameterDefinition> parameters) {
    _parameters = parameters;
    return this;
  }

  MethodDefinitionBuilder withParametersPositional(
    List<ParameterDefinition> parametersPositional,
  ) {
    _parametersPositional = parametersPositional;
    return this;
  }

  MethodDefinitionBuilder withParametersNamed(
    List<ParameterDefinition> parametersNamed,
  ) {
    _parametersNamed = parametersNamed;
    return this;
  }

  MethodCallDefinition buildMethodCallDefinition() {
    return MethodCallDefinition(
      name: _name,
      documentationComment: _documentationComment,
      annotations: _annotations,
      returnType: _returnType,
      parameters: _parameters,
      parametersPositional: _parametersPositional,
      parametersNamed: _parametersNamed,
    );
  }

  MethodStreamDefinition buildMethodStreamDefinition() {
    return MethodStreamDefinition(
      name: _name,
      documentationComment: _documentationComment,
      annotations: _annotations,
      returnType: _returnType,
      parameters: _parameters,
      parametersPositional: _parametersPositional,
      parametersNamed: _parametersNamed,
    );
  }
}
