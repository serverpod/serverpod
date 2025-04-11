import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/extension/element_ignore_endpoint_extension.dart';

abstract class EndpointClassAnalyzer {
  /// Parses an [ClassElement] into a [EndpointDefinition].
  /// Assumes that the [ClassElement] is a valid endpoint class.
  static EndpointDefinition parse(
    ClassElement element,
    List<MethodDefinition> methodDefinitions,
    String filePath,
  ) {
    var className = element.name;
    var endpointName = _formatEndpointName(className);
    var classDocumentationComment = element.documentationComment;

    return EndpointDefinition(
      name: endpointName,
      documentationComment: classDocumentationComment,
      className: className,
      methods: methodDefinitions,
      filePath: filePath,
    );
  }

  /// Creates a namespace for the [ClassElement] based on the [filePath].
  static String elementNamespace(ClassElement element, String filePath) {
    return '{$filePath}_${element.name}';
  }

  /// Returns true if the [ClassElement] is an endpoint class that should
  /// be validated and parsed.
  static bool isEndpointClass(
    ClassElement element, {
    bool respectIgnoreClassAnnotation = true,
  }) {
    if (element.allSupertypes.any((s) => s.element.name == 'Endpoint') !=
        true) {
      return false;
    }

    if (element.markedAsIgnored && respectIgnoreClassAnnotation) return false;

    return true;
  }

  /// Validates the [ClassElement] and returns a list of errors.
  static List<SourceSpanSeverityException> validate(
    ClassElement classElement,
    Set<String> duplicateClasses,
  ) {
    List<SourceSpanSeverityException> errors = [];

    if (duplicateClasses.contains(classElement.name)) {
      errors.add(
        SourceSpanSeverityException(
          'Multiple endpoint definitions for ${classElement.name} exists. '
          'Please provide a unique name for each endpoint class.',
          classElement.span,
          severity: SourceSpanSeverity.error,
        ),
      );
    }

    return errors;
  }

  static String _formatEndpointName(String className) {
    const removeEnding = 'Endpoint';

    var endpointName = '${className[0].toLowerCase()}${className.substring(1)}';
    if (endpointName.endsWith(removeEnding)) {
      endpointName =
          endpointName.substring(0, endpointName.length - removeEnding.length);
    }

    return endpointName;
  }
}
