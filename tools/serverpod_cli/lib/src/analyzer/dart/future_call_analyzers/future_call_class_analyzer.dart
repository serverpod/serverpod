import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/annotation.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_parameter_analyzer.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

abstract class FutureCallClassAnalyzer {
  /// Parses an [ClassElement] into a [FutureCallDefinition].
  ///
  /// Assumes that the [ClassElement] is a valid future call class. This method
  /// mutates the inputs [futureCallDefinitions] and [validationErrors]. If the
  /// [element] extends another future call class, that parent class is also parsed
  /// and added to the [futureCallDefinitions] list. [FutureCallDefinition]s that
  /// have already been parsed are not parsed again.
  ///
  /// For [FutureCallDefinition]s that are not part of this package, the field
  /// [FutureCallDefinition.filePath] will be set to the library uri.
  static void parse(
    ClassElement element,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
    String filePath,
    List<FutureCallDefinition> futureCallDefinitions, {
    required DartDocTemplateRegistry templateRegistry,
  }) {
    var className = element.displayName;
    var futureCallName = _formatFutureCallName(className);
    if (futureCallDefinitions.any(
      (e) => e.className == className && e.filePath == filePath,
    )) {
      return;
    }

    var classDocumentationComment = element.documentationComment;
    var annotations = AnnotationAnalyzer.parseAnnotations(element);

    var parentClass = element.supertype?.element;
    var parentClassName = parentClass?.name;
    FutureCallDefinition? parentFutureCallDefinition;

    if (parentClass is ClassElement &&
        !parentClass.markedAsIgnored &&
        parentClassName != null &&
        parentClassName != 'FutureCall') {
      var parentFilePath = parentClass.library == element.library
          ? filePath
          : parentClass.library.identifier;

      parse(
        parentClass,
        validationErrors,
        parentFilePath,
        futureCallDefinitions,
        templateRegistry: templateRegistry,
      );

      parentFutureCallDefinition = futureCallDefinitions.firstWhere(
        (e) => e.filePath == parentFilePath && e.className == parentClassName,
      );
    }

    futureCallDefinitions.add(
      FutureCallDefinition(
        name: futureCallName,
        documentationComment: stripDocumentationTemplateMarkers(
          classDocumentationComment,
          templateRegistry: templateRegistry,
        ),
        className: className,
        methods: _parseFutureCallMethods(
          element,
          validationErrors,
          filePath,
          templateRegistry: templateRegistry,
        ),
        filePath: filePath,
        annotations: annotations,
        isAbstract: element.isAbstract,
        extendsClass: parentFutureCallDefinition,
      ),
    );
  }

  static List<MethodDefinition> _parseFutureCallMethods(
    ClassElement classElement,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
    String filePath, {
    required DartDocTemplateRegistry templateRegistry,
  }) {
    var futureCallMethods = classElement.collectFutureCallMethods(
      validationErrors: validationErrors,
      filePath: filePath,
    );

    var methodDefs = <MethodDefinition>[];
    for (var method in futureCallMethods) {
      var parameters = FutureCallParameterAnalyzer.parse(
        method.formalParameters,
      );

      methodDefs.add(
        FutureCallMethodAnalyzer.parse(
          method,
          parameters,
          templateRegistry: templateRegistry,
        ),
      );
    }

    return methodDefs;
  }

  /// Creates a namespace for the [ClassElement] based on the [filePath].
  static String elementNamespace(ClassElement element, String filePath) {
    return '{$filePath}_${element.name}';
  }

  /// Returns true if the [ClassElement] is an active future call class that should
  /// be validated and parsed.
  static bool isFutureCallClass(ClassElement element) {
    // Allow abstract classes to be included in analysis for generation.
    if (!element.isConstructable && !element.isAbstract) return false;

    return isFutureCallInterface(element);
  }

  /// Returns `true` if the class extends the Serverpod `FutureCall` base class.
  ///
  /// The class itself might still need to be ignored as a future call, because
  /// it could be marked `abstract`.
  ///
  /// To check whether and future call class should actually be implemented
  /// by the server use [isFutureCallClass].
  static bool isFutureCallInterface(ClassElement element) {
    return element.allSupertypes.any((s) => s.element.name == 'FutureCall');
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
          'Multiple future call definitions for ${classElement.name} exists. '
          'Please provide a unique name for each future call class.',
          classElement.span,
          severity: SourceSpanSeverity.error,
        ),
      );
    }

    return errors;
  }

  static String _formatFutureCallName(String className) {
    const removeEnding = 'FutureCall';

    var futureCallName =
        '${className[0].toLowerCase()}${className.substring(1)}';
    if (futureCallName.endsWith(removeEnding)) {
      futureCallName = futureCallName.substring(
        0,
        futureCallName.length - removeEnding.length,
      );
    }

    return futureCallName;
  }
}

extension on ClassElement {
  /// Returns all future call methods from the class.
  ///
  /// Those defined directly on the class, as well as those inherited from the base classes.
  List<MethodElement> collectFutureCallMethods({
    required Map<String, List<SourceSpanSeverityException>> validationErrors,
    required String filePath,
  }) {
    var futureCallMethods = <MethodElement>[];
    var handledMethods = <String>{};

    for (final method in methods) {
      if (FutureCallMethodAnalyzer.isFutureCallMethod(method) &&
          !validationErrors.containsKey(
            FutureCallMethodAnalyzer.elementNamespace(this, method, filePath),
          )) {
        futureCallMethods.add(method);
      }

      handledMethods.add(method.name!);
    }

    var inheritedMethods = allSupertypes
        .map((s) => s.element)
        .whereType<ClassElement>()
        .where(FutureCallClassAnalyzer.isFutureCallInterface)
        .expand((s) => s.methods);

    for (var method in inheritedMethods) {
      if (handledMethods.contains(method.name)) {
        continue;
      }

      if (FutureCallMethodAnalyzer.isFutureCallMethod(method)) {
        futureCallMethods.add(method);
      }

      handledMethods.add(method.name!);
    }

    return futureCallMethods;
  }
}
