import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

class AnnotationDefinitionBuilder {
  String _name = 'ExampleAnnotationType';
  List<String>? _arguments;
  String? _methodCallAnalyzerIgnoreRule;

  AnnotationDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  AnnotationDefinitionBuilder withArguments(List<String> arguments) {
    _arguments = arguments;
    return this;
  }

  AnnotationDefinitionBuilder withMethodCallAnalyzerIgnoreRule(String rule) {
    _methodCallAnalyzerIgnoreRule = rule;
    return this;
  }

  AnnotationDefinition build() {
    return AnnotationDefinition(
      name: _name,
      arguments: _arguments,
      methodCallAnalyzerIgnoreRule: _methodCallAnalyzerIgnoreRule,
    );
  }
}
