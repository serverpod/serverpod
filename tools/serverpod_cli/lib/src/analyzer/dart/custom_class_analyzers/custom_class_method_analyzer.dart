import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

abstract class CustomClassMethodAnalyzer {
  /// Validates that the [InterfaceElement] Class implements the
  /// required methods for a Serverpod custom class.
  static List<SourceSpanSeverityException> validate(
    InterfaceElement element,
    TypeDefinition extraClass,
    LibraryElement library,
  ) {
    List<SourceSpanSeverityException> errors = [];

    var toJson = element.lookUpMethod(name: 'toJson', library: library);
    if (toJson == null) {
      errors.add(
        SourceSpanSeverityException(
          'Custom class "${extraClass.className}" is missing a "toJson()" method.',
          element.span,
          severity: SourceSpanSeverity.error,
        ),
      );
    } else {
      if (toJson.isStatic) {
        errors.add(
          SourceSpanSeverityException(
            'The "toJson()" method in "${extraClass.className}" must be an instance method.',
            toJson.span,
            severity: SourceSpanSeverity.error,
          ),
        );
      }

      var returnType = toJson.returnType;
      if (returnType.isDartAsyncFuture || returnType.isDartAsyncStream) {
        errors.add(
          SourceSpanSeverityException(
            'The "toJson()" method in "${extraClass.className}" must be synchronous.',
            toJson.span,
            severity: SourceSpanSeverity.error,
          ),
        );
      }

      try {
        var typeDef = TypeDefinition.fromDartType(returnType);

        if (typeDef.isVoidType) {
          errors.add(
            SourceSpanSeverityException(
              'The "toJson()" method in "${extraClass.className}" cannot return void.',
              toJson.span,
              severity: SourceSpanSeverity.error,
            ),
          );
        }
      } on FromDartTypeClassNameException catch (e) {
        errors.add(
          SourceSpanSeverityException(
            'The type "${e.type}" is not a supported "toJson()" return type.',
            toJson.span,
            severity: SourceSpanSeverity.error,
          ),
        );
      }
    }

    var fromJson =
        element.getNamedConstructor('fromJson') ??
        (element.getMethod('fromJson')?.isStatic == true
            ? element.getMethod('fromJson')
            : null);

    if (fromJson == null) {
      errors.add(
        SourceSpanSeverityException(
          'Custom class "${extraClass.className}" is missing a "fromJson" constructor or static method.',
          element.span,
          severity: SourceSpanSeverity.error,
        ),
      );
    }

    return errors;
  }
}
