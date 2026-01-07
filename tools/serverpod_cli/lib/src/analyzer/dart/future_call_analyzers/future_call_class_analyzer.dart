import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/annotation.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_parameter_analyzer.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

abstract class FutureCallClassAnalyzer {
  /// Parses an [ClassElement] into a [FutureCallDefinition].
  ///
  /// Assumes that the [ClassElement] is a valid future call class. This method
  /// mutates the inputs [futureCallDefinitions] and [validationErrors].
  /// [FutureCallDefinition]s that have already been parsed are not parsed again.
  ///
  /// For [FutureCallDefinition]s that are not part of this package, the field
  /// [FutureCallDefinition.filePath] will be set to the library uri.
  static void parse(
    ClassElement element,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
    String filePath,
    List<FutureCallDefinition> futureCallDefinitions, {
    required DartDocTemplateRegistry templateRegistry,
    required FutureCallMethodParameterValidator parameterValidator,
  }) {
    var className = element.displayName;
    var futureCallName = _formatFutureCallName(className);
    if (futureCallDefinitions.any(
      (e) => e.className == className && e.filePath == filePath,
    )) {
      return;
    }

    var classDocumentationComment = element.documentationComment;
    var annotations = element.futureCallAnnotations;

    var parentClass = element.supertype?.element;
    var parentClassName = parentClass?.name;

    if (parentClass is ClassElement &&
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
        parameterValidator: parameterValidator,
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
          parameterValidator: parameterValidator,
        ),
        filePath: filePath,
        annotations: annotations,
        isAbstract: element.isAbstract,
      ),
    );
  }

  static List<FutureCallMethodDefinition> _parseFutureCallMethods(
    ClassElement classElement,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
    String filePath, {
    required DartDocTemplateRegistry templateRegistry,
    required FutureCallMethodParameterValidator parameterValidator,
  }) {
    var futureCallMethods = classElement.collectFutureCallMethods(
      validationErrors: validationErrors,
      filePath: filePath,
    );

    var methodDefs = <FutureCallMethodDefinition>[];
    for (var method in futureCallMethods) {
      var parameters = FutureCallParameterAnalyzer.parse(
        method.formalParameters,
      );

      methodDefs.add(
        FutureCallMethodAnalyzer.parse(
          method,
          parameters,
          templateRegistry: templateRegistry,
          className: classElement.displayName,
        ),
      );
    }

    return methodDefs;
  }

  /// Creates a namespace for the [ClassElement] based on the [filePath].
  static String elementNamespace(ClassElement element, String filePath) {
    return '{$filePath}_${element.name}';
  }

  /// Returns true if the [ClassElement] is a future call class that should
  /// be validated and parsed.
  static bool isFutureCallClass(ClassElement element) {
    if (!element.isConstructable && !element.isAbstract) return false;
    if (element.isExecutableFutureCall) return false;
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
    if (className.length < 2) return className;

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
  /// Returns all the methods from the [ClassElement] which are callable as FutureCall.
  /// This means only methods with parameter(s) and a return type
  /// of Future will be returned.
  /// Only returns methods that are defined directly on the class
  /// and not inherited ones.
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

  /// Whether the [ClassElement] represents a future call to be executed.
  ///
  /// A [FutureCall] declaration can either be a spec to generate a type-safe
  /// interface or an executable [FutureCall] to be directly invoked. Executable
  /// classes extends [FutureCall] directly and overrides only the invoke method.
  /// These will be generated from the spec classes, but can also be manually
  /// defined by users and we must not generate code for them.
  bool get isExecutableFutureCall {
    final extendsFutureCallDirectly = allSupertypes.any(
      (type) => type.element.name == 'FutureCall',
    );

    final onlyDeclaresInvokeMethod =
        methods.length == 1 && methods.first.name == 'invoke';

    return extendsFutureCallDirectly && onlyDeclaresInvokeMethod;
  }
}
