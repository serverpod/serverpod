import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

class FutureCallDefinitionBuilder {
  String _name = 'example';
  String? _documentationComment;
  String _className = 'ExampleFutureCall';
  String _filePath = 'example.dart';
  List<MethodDefinition> _methods = [];
  List<AnnotationDefinition> _annotations = [];
  FutureCallDefinition? _extendsClass;
  bool _isAbstract = false;

  FutureCallDefinitionBuilder();

  FutureCallDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  FutureCallDefinitionBuilder withDocumentationComment(
    String? documentationComment,
  ) {
    _documentationComment = documentationComment;
    return this;
  }

  FutureCallDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  FutureCallDefinitionBuilder withFilePath(
    String filePath, {
    String? externalServerPackage,
  }) {
    _filePath = externalServerPackage != null
        ? 'package:$externalServerPackage/$filePath'
        : filePath;
    return this;
  }

  FutureCallDefinitionBuilder withMethods(List<MethodDefinition> methods) {
    _methods = methods;
    return this;
  }

  FutureCallDefinitionBuilder withAnnotations(
    List<AnnotationDefinition> annotations,
  ) {
    _annotations = annotations;
    return this;
  }

  FutureCallDefinitionBuilder withExtends(FutureCallDefinition parentClass) {
    _extendsClass = parentClass;
    return this;
  }

  FutureCallDefinitionBuilder withIsAbstract([bool isAbstract = true]) {
    _isAbstract = isAbstract;
    return this;
  }

  FutureCallDefinition build() {
    return FutureCallDefinition(
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
