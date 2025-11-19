import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

class EndpointDefinitionBuilder {
  String _name = 'example';
  String? _documentationComment;
  String _className = 'ExampleEndpoint';
  String _filePath = 'example.dart';
  List<MethodDefinition> _methods = [];
  List<AnnotationDefinition> _annotations = [];
  EndpointDefinition? _extendsClass;
  bool _isAbstract = false;

  EndpointDefinitionBuilder();

  EndpointDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  EndpointDefinitionBuilder withDocumentationComment(
    String? documentationComment,
  ) {
    _documentationComment = documentationComment;
    return this;
  }

  EndpointDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  EndpointDefinitionBuilder withFilePath(
    String filePath, {
    String? externalServerPackage,
  }) {
    _filePath = externalServerPackage != null
        ? 'package:$externalServerPackage/$filePath'
        : filePath;
    return this;
  }

  EndpointDefinitionBuilder withMethods(List<MethodDefinition> methods) {
    _methods = methods;
    return this;
  }

  EndpointDefinitionBuilder withAnnotations(
    List<AnnotationDefinition> annotations,
  ) {
    _annotations = annotations;
    return this;
  }

  EndpointDefinitionBuilder withExtends(EndpointDefinition parentClass) {
    _extendsClass = parentClass;
    return this;
  }

  EndpointDefinitionBuilder withIsAbstract([bool isAbstract = true]) {
    _isAbstract = isAbstract;
    return this;
  }

  EndpointDefinition build() {
    return EndpointDefinition(
      name: _name,
      documentationComment: _documentationComment,
      className: _className,
      filePath: _filePath,
      methods: _methods,
      annotations: _annotations,
      isAbstract: _isAbstract,
      extendsClass: _extendsClass,
    );
  }
}
