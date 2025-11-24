import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_analyzer.dart';

/// Analyzer for FutureCall classes.
abstract class FutureCallClassAnalyzer {
  /// Returns true if the [ClassElement] is a FutureCall class.
  static bool isFutureCallClass(ClassElement classElement) {
    if (classElement.isAbstract) return false;
    if (classElement.isPrivate) return false;

    var supertype = classElement.supertype;
    while (supertype != null) {
      if (supertype.element.name == 'FutureCall') {
        return true;
      }
      supertype = supertype.element.supertype;
    }
    return false;
  }

  /// Creates a namespace for the [ClassElement] based on the [filePath].
  static String elementNamespace(ClassElement classElement, String filePath) {
    return '$filePath#${classElement.name}';
  }

  /// Validates a FutureCall class and returns a list of errors.
  static List<SourceSpanSeverityException> validate(
    ClassElement classElement,
    Set<String> duplicatedClasses,
  ) {
    List<SourceSpanSeverityException> errors = [];

    if (duplicatedClasses.contains(classElement.name)) {
      errors.add(
        SourceSpanSeverityException(
          'Multiple FutureCall classes with the name "${classElement.name}" found. '
          'FutureCall class names must be unique.',
          classElement.span,
        ),
      );
    }

    return errors;
  }

  /// Parses a FutureCall class into a [FutureCallDefinition].
  static void parse(
    ClassElement classElement,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
    String filePath,
    List<FutureCallDefinition> futureCallDefinitions,
  ) {
    var methods = classElement.methods
        .where(FutureCallMethodAnalyzer.isFutureCallMethod)
        .toList();

    var methodDefinitions = <FutureCallMethodDefinition>[];
    for (var method in methods) {
      if (validationErrors.containsKey(
        FutureCallMethodAnalyzer.elementNamespace(
          classElement,
          method,
          filePath,
        ),
      )) {
        continue;
      }

      methodDefinitions.add(
        FutureCallMethodAnalyzer.parse(method),
      );
    }

    var className = classElement.name;
    if (className == null) return;

    futureCallDefinitions.add(
      FutureCallDefinition(
        name: _getFutureCallName(className),
        className: className,
        filePath: filePath,
        methods: methodDefinitions,
        documentationComment: classElement.documentationComment,
      ),
    );
  }

  /// Converts a class name to a future call name (camelCase).
  /// Example: ExampleFutureCall -> example
  static String _getFutureCallName(String className) {
    var name = className;
    // Remove 'FutureCall' suffix if present
    if (name.endsWith('FutureCall')) {
      name = name.substring(0, name.length - 'FutureCall'.length);
    }
    // Convert to camelCase
    if (name.isEmpty) return name;
    return name[0].toLowerCase() + name.substring(1);
  }
}

