import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

import 'type_definition_builder.dart';

class FutureCallMethodDefinitionBuilder {
  String _name = 'example';
  String? _documentationComment;
  List<AnnotationDefinition> _annotations = [];
  TypeDefinition _returnType = TypeDefinitionBuilder()
      .withFutureOf('void')
      .build();
  List<ParameterDefinition> _parameters = [];
  List<ParameterDefinition> _parametersPositional = [];
  List<ParameterDefinition> _parametersNamed = [];

  FutureCallMethodDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  FutureCallMethodDefinitionBuilder withDocumentationComment(
    String? documentationComment,
  ) {
    _documentationComment = documentationComment;
    return this;
  }

  FutureCallMethodDefinitionBuilder withAnnotations(
    List<AnnotationDefinition> annotations,
  ) {
    _annotations = annotations;
    return this;
  }

  FutureCallMethodDefinitionBuilder withReturnType(TypeDefinition returnType) {
    _returnType = returnType;
    return this;
  }

  FutureCallMethodDefinitionBuilder withParameters(
    List<ParameterDefinition> parameters,
  ) {
    _parameters = parameters;
    return this;
  }

  FutureCallMethodDefinitionBuilder withParametersPositional(
    List<ParameterDefinition> parametersPositional,
  ) {
    _parametersPositional = parametersPositional;
    return this;
  }

  FutureCallMethodDefinitionBuilder withParametersNamed(
    List<ParameterDefinition> parametersNamed,
  ) {
    _parametersNamed = parametersNamed;
    return this;
  }

  FutureCallMethodDefinition buildMethodCallDefinition() {
    return FutureCallMethodDefinition(
      name: _name,
      documentationComment: _documentationComment,
      annotations: _annotations,
      returnType: _returnType,
      parameters: _parameters,
      parametersPositional: _parametersPositional,
      parametersNamed: _parametersNamed,
      futureCallMethodParameter: null,
    );
  }
}
