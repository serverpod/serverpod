import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

typedef _MethodBuilder = MethodDefinition Function();

class EndpointDefinitionBuilder {
  String _name;
  String _className;
  List<String> _subDirParts;
  String _filePath;
  List<_MethodBuilder> _methods;
  String? _documentation;

  EndpointDefinitionBuilder()
      : _name = 'Example',
        _className = 'ExampleEndpoint',
        _subDirParts = [],
        _filePath = 'example_endpoint.dart',
        _methods = [];
  EndpointDefinition build() {
    return EndpointDefinition(
      name: _name,
      documentationComment: _documentation,
      methods: _methods.map((m) => m()).toList(),
      className: _className,
      filePath: _filePath,
      subDirParts: _subDirParts,
    );
  }

  EndpointDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  EndpointDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  EndpointDefinitionBuilder withSubDirParts(List<String> subDirParts) {
    _subDirParts = subDirParts;
    return this;
  }

  EndpointDefinitionBuilder withFilePath(String filePath) {
    _filePath = filePath;
    return this;
  }

  EndpointDefinitionBuilder withDocumentation(String documentation) {
    _documentation = documentation;
    return this;
  }

  EndpointDefinitionBuilder withMethod(MethodDefinition method) {
    _methods.add(() => method);
    return this;
  }

  EndpointDefinitionBuilder withMethods(List<MethodDefinition> methods) {
    _methods = methods.map((e) => () => e).toList();
    return this;
  }
}
