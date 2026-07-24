import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

import '../../../util/type_validators.dart';

abstract class CustomClassMethodAnalyzer {
  /// Validates that the [InterfaceElement] Class implements the
  /// required methods for a Serverpod custom class.
  static List<SourceSpanSeverityException> validate(
    InterfaceElement element,
    TypeDefinition extraClass,
    LibraryElement library,
  ) {
    final errors = <SourceSpanSeverityException?>[
      _validateToJson(element, extraClass, library),
      _validateFromJson(element, extraClass),
    ];

    return errors.whereType<SourceSpanSeverityException>().toList();
  }

  static SourceSpanSeverityException? _validateToJson(
    InterfaceElement element,
    TypeDefinition extraClass,
    LibraryElement library,
  ) {
    final toJson = element.lookUpMethod(name: 'toJson', library: library);

    if (toJson == null) {
      return SourceSpanSeverityException(
        'Custom class "${extraClass.className}" is missing a "toJson()" method.',
        element.span,
        severity: SourceSpanSeverity.error,
      );
    }

    if (toJson.isStatic) {
      return SourceSpanSeverityException(
        'The "toJson()" method in "${extraClass.className}" must be an instance method.',
        toJson.span,
        severity: SourceSpanSeverity.error,
      );
    }

    final returnType = toJson.returnType;

    if (returnType.isDartAsyncFuture || returnType.isDartAsyncStream) {
      return SourceSpanSeverityException(
        'The "toJson()" method in "${extraClass.className}" must be synchronous.',
        toJson.span,
        severity: SourceSpanSeverity.error,
      );
    }

    final TypeDefinition typeDefinition;
    try {
      typeDefinition = TypeDefinition.fromDartType(returnType);
    } on FromDartTypeClassNameException catch (e) {
      return SourceSpanSeverityException(
        'The type "${e.type}" is not a supported "toJson()" return type.',
        toJson.span,
        severity: SourceSpanSeverity.error,
      );
    }

    if (typeDefinition.isVoidType) {
      return SourceSpanSeverityException(
        'The "toJson()" method in "${extraClass.className}" cannot return void.',
        toJson.span,
        severity: SourceSpanSeverity.error,
      );
    }

    if (!TypeValidators.isValidType(
      typeDefinition,
      const TypeValidationOptions(
        allowSerializableGenerics: true,
      ),
    )) {
      return SourceSpanSeverityException(
        'The type "${typeDefinition.className}" is not a supported '
        '"toJson()" return type.',
        toJson.span,
        severity: SourceSpanSeverity.error,
      );
    }

    return null;
  }

  static SourceSpanSeverityException? _validateFromJson(
    InterfaceElement element,
    TypeDefinition extraClass,
  ) {
    final fromJson =
        element.getNamedConstructor('fromJson') ??
        (element.getMethod('fromJson')?.isStatic == true
            ? element.getMethod('fromJson')
            : null);

    if (fromJson == null) {
      return SourceSpanSeverityException(
        'Custom class "${extraClass.className}" is missing a "fromJson" constructor or static method.',
        element.span,
        severity: SourceSpanSeverity.error,
      );
    }

    return null;
  }
}
