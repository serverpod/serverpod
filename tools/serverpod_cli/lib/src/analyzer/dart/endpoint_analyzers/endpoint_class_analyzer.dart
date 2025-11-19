import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/annotation.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_parameter_analyzer.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

abstract class EndpointClassAnalyzer {
  /// Parses an [ClassElement] into a [EndpointDefinition].
  ///
  /// Assumes that the [ClassElement] is a valid endpoint class. This method
  /// mutates the inputs [endpointDefinitions] and [validationErrors]. If the
  /// [element] extends another endpoint class, that parent class is also parsed
  /// and added to the [endpointDefinitions] list. [EndpointDefinition]s that
  /// have already been parsed are not parsed again.
  ///
  /// For [EndpointDefinition]s that are not part of this package, the field
  /// [EndpointDefinition.filePath] will be set to the library uri.
  static void parse(
    ClassElement element,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
    String filePath,
    List<EndpointDefinition> endpointDefinitions,
  ) {
    var className = element.displayName;
    var endpointName = _formatEndpointName(className);
    if (endpointDefinitions.any(
      (e) => e.className == className && e.filePath == filePath,
    )) {
      return;
    }

    var classDocumentationComment = element.documentationComment;
    var annotations = AnnotationAnalyzer.parseAnnotations(element);

    var parentClass = element.supertype?.element;
    var parentClassName = parentClass?.name;
    EndpointDefinition? parentEndpointDefinition;

    if (parentClass is ClassElement &&
        !parentClass.markedAsIgnored &&
        parentClassName != null &&
        parentClassName != 'Endpoint') {
      var parentFilePath = parentClass.library == element.library
          ? filePath
          : parentClass.library.identifier;

      parse(
        parentClass,
        validationErrors,
        parentFilePath,
        endpointDefinitions,
      );

      parentEndpointDefinition = endpointDefinitions.firstWhere(
        (e) => e.filePath == parentFilePath && e.className == parentClassName,
      );
    }

    endpointDefinitions.add(
      EndpointDefinition(
        name: endpointName,
        documentationComment: stripDocumentationTemplateMarkers(
          classDocumentationComment,
        ),
        className: className,
        methods: _parseEndpointMethods(element, validationErrors, filePath),
        filePath: filePath,
        annotations: annotations,
        isAbstract: element.isAbstract,
        extendsClass: parentEndpointDefinition,
      ),
    );
  }

  static List<MethodDefinition> _parseEndpointMethods(
    ClassElement classElement,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
    String filePath,
  ) {
    var endpointMethods = classElement.collectEndpointMethods(
      validationErrors: validationErrors,
      filePath: filePath,
    );

    var methodDefs = <MethodDefinition>[];
    for (var method in endpointMethods) {
      var parameters = EndpointParameterAnalyzer.parse(method.formalParameters);

      methodDefs.add(
        EndpointMethodAnalyzer.parse(
          method,
          parameters,
        ),
      );
    }

    return methodDefs;
  }

  /// Creates a namespace for the [ClassElement] based on the [filePath].
  static String elementNamespace(ClassElement element, String filePath) {
    return '{$filePath}_${element.name}';
  }

  /// Returns true if the [ClassElement] is an active endpoint class that should
  /// be validated and parsed.
  static bool isEndpointClass(ClassElement element) {
    if (element.markedAsIgnored) return false;

    // Allow abstract classes to be included in analysis for client generation.
    if (!element.isConstructable && !element.isAbstract) return false;

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
      endpointName = endpointName.substring(
        0,
        endpointName.length - removeEnding.length,
      );
    }

    return endpointName;
  }
}

extension on ClassElement {
  /// Returns all endpoints methods from the class.
  ///
  /// Those defined directly on the class, as well as those inherited from the base classes.
  List<MethodElement> collectEndpointMethods({
    required Map<String, List<SourceSpanSeverityException>> validationErrors,
    required String filePath,
  }) {
    var endPointMethods = <MethodElement>[];
    var handledMethods = <String>{};

    for (final method in methods) {
      if (EndpointMethodAnalyzer.isEndpointMethod(method) &&
          !validationErrors.containsKey(
            EndpointMethodAnalyzer.elementNamespace(this, method, filePath),
          )) {
        endPointMethods.add(method);
      }

      handledMethods.add(method.name!);
    }

    var inheritedMethods = allSupertypes
        .map((s) => s.element)
        .whereType<ClassElement>()
        .where(EndpointClassAnalyzer.isEndpointInterface)
        .expand((s) => s.methods);

    for (var method in inheritedMethods) {
      if (handledMethods.contains(method.name)) {
        continue;
      }

      if (EndpointMethodAnalyzer.isEndpointMethod(method)) {
        endPointMethods.add(method);
      }

      handledMethods.add(method.name!);
    }

    return endPointMethods;
  }
}

extension EndpointClassExtensions on ClassElement {
  bool get overridesRequireLogin => getGetter('requireLogin') != null;
}
