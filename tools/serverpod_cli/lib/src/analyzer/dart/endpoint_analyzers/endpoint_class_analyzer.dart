import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/annotation.dart';

abstract class EndpointClassAnalyzer {
  /// Parses an [ClassElement] into a [EndpointDefinition].
  /// Assumes that the [ClassElement] is a valid endpoint class.
  static EndpointDefinition parse(
    ClassElement element,
    List<MethodDefinition> methodDefinitions,
    String filePath,
  ) {
    var className = element.displayName;
    var endpointName = _formatEndpointName(className);
    var classDocumentationComment = element.documentationComment;
    var annotations = AnnotationAnalyzer.parseAnnotations(element);

    return EndpointDefinition(
      name: endpointName,
      documentationComment: classDocumentationComment,
      className: className,
      methods: methodDefinitions,
      filePath: filePath,
      annotations: annotations,
    );
  }

  /// Creates a namespace for the [ClassElement] based on the [filePath].
  static String elementNamespace(ClassElement element, String filePath) {
    return '{$filePath}_${element.name}';
  }

  /// Returns true if the [ClassElement] is an active endpoint class that should
  /// be validated and parsed.
  static bool isEndpointClass(ClassElement element) {
    if (!element.isConstructable) return false;

    if (element.markedAsIgnored) return false;

    return isEndpointInterface(element);
  }

  /// Returns `true` if the class extends the Serverpod `Endpoint` base class.
  ///
  /// The class itself might still need to be ignored as an endpoint, because
  /// it could be marked `abstract` or `@doNotGenerate`.
  ///
  /// To check whether and endpoint class should actually be implemented
  /// by the server use [isEndpointClass].
  static bool isEndpointInterface(ClassElement element) {
    return element.allSupertypes.any((s) => s.element.name == 'Endpoint');
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

    if (classElement.overridesRequireLogin &&
        classElement.markedAsUnauthenticated) {
      errors.add(
        SourceSpanSeverityException(
          'The endpoint class "${classElement.name}" overrides "requireLogin" '
          'getter and is annotated with @unauthenticatedClientCall. Be aware '
          'that this combination may lead to all endpoint calls failing due to '
          'client not sending a signed in user. To fix this, either remove the '
          'getter override or remove the @unauthenticatedClientCall annotation.',
          classElement.span,
          severity: SourceSpanSeverity.info,
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

extension EndpointClassExtensions on ClassElement {
  bool get overridesRequireLogin => getGetter('requireLogin') != null;
}
