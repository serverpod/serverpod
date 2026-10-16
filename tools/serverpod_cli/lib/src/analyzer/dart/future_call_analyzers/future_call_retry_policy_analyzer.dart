import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

/// The name of the base class of all future call retry policies.
const _retryPolicyBaseClassName = 'FutureCallRetryPolicy';

abstract class FutureCallRetryPolicyAnalyzer {
  /// Returns `true` if [element] is a future call retry policy that has to be
  /// registered in the protocol, so that it can be saved and loaded.
  ///
  /// Abstract and sealed classes are never instantiated, so they are never
  /// saved and are not registered.
  static bool isRetryPolicyClass(ClassElement element) {
    if (element.isAbstract || element.isSealed) return false;
    return element.allSupertypes.any(
      (type) => type.element.name == _retryPolicyBaseClassName,
    );
  }

  /// Validates that [element] can be registered in the protocol and loaded
  /// again, and returns the errors found.
  ///
  /// [takenClassNames] are the names of the other classes and models in the
  /// protocol. The protocol identifies classes by name, so a retry policy must
  /// not share its name with any of them.
  static List<SourceSpanSeverityException> validate(
    ClassElement element,
    Set<String> takenClassNames,
  ) {
    var className = element.displayName;
    var errors = <SourceSpanSeverityException>[];

    if (element.isPrivate) {
      errors.add(
        SourceSpanSeverityException(
          'The retry policy class $className must be public, so that the '
          'generated protocol can refer to it.',
          element.span,
          severity: SourceSpanSeverity.error,
        ),
      );
    }

    if (takenClassNames.contains(className)) {
      errors.add(
        SourceSpanSeverityException(
          'The retry policy class $className has the same name as another '
          'class or model in the protocol. The protocol identifies classes by '
          'name, so rename one of them.',
          element.span,
          severity: SourceSpanSeverity.error,
        ),
      );
    }

    var fromJsonError = _validateFromJson(element);
    if (fromJsonError != null) errors.add(fromJsonError);

    return errors;
  }

  /// Returns the type that refers to [element] in the generated protocol.
  static TypeDefinition typeDefinition(ClassElement element) {
    return parseType(
      '${element.library.uri}:${element.displayName}',
      extraClasses: null,
    );
  }

  static SourceSpanSeverityException? _validateFromJson(ClassElement element) {
    var className = element.displayName;
    var fromJson = element.constructors
        .where((constructor) => constructor.name == 'fromJson')
        .firstOrNull;

    if (fromJson == null) {
      return SourceSpanSeverityException(
        '$className extends $_retryPolicyBaseClassName but has no fromJson '
        'constructor. Add `factory $className.fromJson(Map<String, dynamic> '
        'json)` so the policy can be loaded when a retry is due.',
        element.span,
        severity: SourceSpanSeverity.error,
      );
    }

    var parameters = fromJson.formalParameters;
    var positional = parameters.where((p) => p.isPositional);
    var requiredNamed = parameters.where((p) => p.isRequiredNamed);

    String? problem;
    if (positional.isEmpty) {
      problem = 'has no positional parameter for the JSON map';
    } else if (positional.length > 1) {
      problem = 'has more than one positional parameter';
    } else if (positional.single.isOptional) {
      problem = 'takes the JSON map as an optional parameter';
    } else if (!_isJsonMapType(positional.single.type)) {
      problem =
          'takes a ${positional.single.type.getDisplayString()} instead of a '
          'Map<String, dynamic>';
    } else if (requiredNamed.isNotEmpty) {
      problem = 'has a required named parameter';
    }

    if (problem == null) return null;

    return SourceSpanSeverityException(
      'The fromJson constructor of $className $problem. It must take the '
      'JSON map as a Map<String, dynamic> in its only positional parameter, '
      'for example `factory $className.fromJson(Map<String, dynamic> json)`.',
      fromJson.span ?? element.span,
      severity: SourceSpanSeverity.error,
    );
  }

  /// Whether [type] is exactly `Map<String, dynamic>`.
  static bool _isJsonMapType(DartType type) {
    if (type is! InterfaceType || !type.isDartCoreMap) return false;
    if (type.nullabilitySuffix != NullabilitySuffix.none) return false;

    var [keyType, valueType] = type.typeArguments;
    return keyType.isDartCoreString &&
        keyType.nullabilitySuffix == NullabilitySuffix.none &&
        valueType is DynamicType;
  }
}
