import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/extension/endpoint_parameters_extension.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_parameter_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_class_analyzer.dart';
import 'package:serverpod_cli/src/generator/types.dart';

/// Analyzer for FutureCall methods.
abstract class FutureCallMethodAnalyzer {
  /// Returns true if the method is a valid future call method.
  static bool isFutureCallMethod(MethodElement method) {
    if (method.isPrivate) return false;
    if (method.isStatic) return false;
    if (method.name == 'invoke') return false; // Skip the invoke method

    // Must have Session as first parameter
    if (!method.formalParameters.isFirstRequiredParameterSession) {
      return false;
    }

    // Must return a Future
    if (!method.returnType.isDartAsyncFuture) {
      return false;
    }

    return true;
  }

  /// Creates a namespace for the method.
  static String elementNamespace(
    ClassElement classElement,
    MethodElement methodElement,
    String filePath,
  ) {
    return '${FutureCallClassAnalyzer.elementNamespace(
      classElement,
      filePath,
    )}_${methodElement.name}';
  }

  /// Validates a future call method and returns a list of errors.
  static List<SourceSpanSeverityException> validate(
    MethodElement method,
    ClassElement classElement,
  ) {
    List<SourceSpanSeverityException> errors = [];

    // Validate return type
    var returnTypeError = _validateReturnType(
      dartType: method.returnType,
      dartElement: method,
    );
    if (returnTypeError != null) {
      errors.add(returnTypeError);
    }

    // Validate parameters (no streams allowed)
    for (var param in method.formalParameters) {
      if (param.type.isDartAsyncStream) {
        errors.add(
          SourceSpanSeverityException(
            'Stream parameters are not allowed in FutureCall methods.',
            param.span,
          ),
        );
      }
    }

    // Validate parameters are serializable
    var paramErrors = EndpointParameterAnalyzer.validate(method.formalParameters);
    errors.addAll(paramErrors);

    return errors;
  }

  /// Parses a method into a [FutureCallMethodDefinition].
  static FutureCallMethodDefinition parse(MethodElement method) {
    var parameters = EndpointParameterAnalyzer.parse(method.formalParameters);

    return FutureCallMethodDefinition(
      name: method.displayName,
      documentationComment: method.documentationComment,
      parameters: parameters.required,
      parametersPositional: parameters.positional,
      parametersNamed: parameters.named,
      returnType: TypeDefinition.fromDartType(method.returnType),
    );
  }

  static SourceSpanSeverityException? _validateReturnType({
    required DartType dartType,
    required Element dartElement,
  }) {
    if (!dartType.isDartAsyncFuture) {
      return SourceSpanSeverityException(
        'FutureCall methods must return a Future.',
        dartElement.span,
      );
    }

    if (dartType is! InterfaceType) {
      return SourceSpanSeverityException(
        'This type is not supported as return type.',
        dartElement.span,
      );
    }

    var typeArguments = dartType.typeArguments;
    if (typeArguments.length != 1) {
      return SourceSpanSeverityException(
        'Return generic must be type defined. E.g. Future<void>.',
        dartElement.span,
      );
    }

    var innerType = typeArguments[0];

    if (innerType is VoidType) {
      return null;
    }

    try {
      TypeDefinition.fromDartType(innerType);
    } on FromDartTypeClassNameException catch (e) {
      return SourceSpanSeverityException(
        'The type "${e.type}" is not a supported FutureCall return type.',
        dartElement.span,
      );
    }

    return null;
  }
}

