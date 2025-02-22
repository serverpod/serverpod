import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

class EndpointDefinitionBuilder {
  String _name = 'example';
  String? _documentationComment;
  String _className = 'ExampleEndpoint';
  String _filePath = 'example.dart';
  List<MethodDefinition> _methods = [];

  EndpointDefinitionBuilder();

  EndpointDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  EndpointDefinitionBuilder withDocumentationComment(
      String? documentationComment) {
    _documentationComment = documentationComment;
    return this;
  }

  EndpointDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  EndpointDefinitionBuilder withFilePath(String filePath) {
    _filePath = filePath;
    return this;
  }

  EndpointDefinitionBuilder withMethods(List<MethodDefinition> methods) {
    _methods = methods;
    return this;
  }

  EndpointDefinition build() {
    return EndpointDefinition(
      name: _name,
      documentationComment: _documentationComment,
      className: _className,
      filePath: _filePath,
      methods: _methods,
    );
  }
}
