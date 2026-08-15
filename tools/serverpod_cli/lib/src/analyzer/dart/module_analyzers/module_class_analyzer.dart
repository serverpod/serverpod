import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';

/// Parses and validates classes that extend Serverpod's [Module] base class.
abstract class ModuleClassAnalyzer {
  /// Parses an [ClassElement] into a [ModuleDefinition].
  ///
  /// Assumes that the [ClassElement] is a valid module class. Definitions that
  /// have already been parsed are not parsed again.
  static void parse(
    ClassElement element,
    String filePath,
    List<ModuleDefinition> moduleDefinitions,
  ) {
    var className = element.displayName;
    if (moduleDefinitions.any(
      (e) => e.className == className && e.filePath == filePath,
    )) {
      return;
    }

    var parentClass = element.supertype?.element;
    var parentClassName = parentClass?.name;

    if (parentClass is ClassElement &&
        parentClassName != null &&
        parentClassName != 'Module') {
      var parentFilePath = parentClass.library == element.library
          ? filePath
          : parentClass.library.identifier;

      parse(parentClass, parentFilePath, moduleDefinitions);
    }

    moduleDefinitions.add(
      ModuleDefinition(
        className: className,
        filePath: filePath,
        isAbstract: element.isAbstract,
      ),
    );
  }

  /// Creates a namespace for the [ClassElement] based on the [filePath].
  static String elementNamespace(ClassElement element, String filePath) {
    return '{$filePath}_${element.name}';
  }

  /// Returns true if the [ClassElement] is a module class that should be
  /// validated and parsed.
  ///
  /// Non-constructable concrete classes are included so validation can emit
  /// an error; they are not selected for [ProtocolDefinition.module].
  static bool isModuleClass(ClassElement element) {
    return isModuleInterface(element);
  }

  /// Returns `true` if the class extends the Serverpod `Module` base class.
  static bool isModuleInterface(ClassElement element) {
    return element.allSupertypes.any((s) {
      final superElement = s.element;
      if (superElement.name != 'Module') return false;
      // Require Serverpod's Module, not an unrelated class with the same name.
      return superElement.library.identifier.contains('serverpod');
    });
  }

  /// Validates the [ClassElement] and returns a list of errors.
  static List<SourceSpanSeverityException> validate(
    ClassElement classElement, {
    required bool exceedsCardinality,
  }) {
    List<SourceSpanSeverityException> errors = [];

    if (!classElement.isAbstract &&
        !_hasPublicDefaultConstructor(classElement)) {
      errors.add(
        SourceSpanSeverityException(
          'Module class ${classElement.name} must be default-constructable. '
          'Provide an unnamed constructor with no required parameters.',
          classElement.span,
          severity: SourceSpanSeverity.error,
        ),
      );
    }

    if (exceedsCardinality &&
        !classElement.isAbstract &&
        _hasPublicDefaultConstructor(classElement)) {
      errors.add(
        SourceSpanSeverityException(
          'A package may define at most one Module class.',
          classElement.span,
          severity: SourceSpanSeverity.error,
        ),
      );
    }

    return errors;
  }

  /// Whether [classElement] can be instantiated with `ClassName()`.
  static bool hasPublicDefaultConstructor(ClassElement classElement) {
    return _hasPublicDefaultConstructor(classElement);
  }

  static bool _hasPublicDefaultConstructor(ClassElement classElement) {
    if (!classElement.isConstructable) return false;

    for (final constructor in classElement.constructors) {
      if (constructor.isFactory) continue;
      // Unnamed constructors report as name 'new' or null/empty.
      final name = constructor.name;
      if (name != null && name != 'new' && name.isNotEmpty) continue;
      if (constructor.isPrivate) continue;
      if (constructor.formalParameters.any((p) => p.isRequired)) return false;
      return true;
    }
    return false;
  }
}
