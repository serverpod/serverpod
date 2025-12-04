import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/annotation.dart';
import 'package:serverpod_cli/src/analyzer/dart/extension/endpoint_parameters_extension.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/annotation.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/parameters.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

// TODO: Is it necessary to exclude any method in FutureCall?
const _excludedMethodNameSet = {''};

abstract class FutureCallMethodAnalyzer {
  /// Parses an [MethodElement] into a [MethodDefinition].
  /// Assumes that the [MethodElement] is a valid future call method.
  static MethodDefinition parse(
    MethodElement method,
    Parameters parameters, {
    required DartDocTemplateRegistry templateRegistry,
  }) {
    return MethodCallDefinition(
      name: method.displayName,
      documentationComment: stripDocumentationTemplateMarkers(
        method.documentationComment,
        templateRegistry: templateRegistry,
      ),
      annotations: FutureCallAnnotationAnalyzer.parseAnnotations(method),
      parameters: parameters.required,
      parametersNamed: parameters.named,
      parametersPositional: parameters.positional,
      returnType: TypeDefinition.fromDartType(method.returnType),
    );
  }

  /// Creates a namespace for the [MethodElement] based on the [ClassElement]
  /// and the [filePath].
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

  /// Returns true if the [MethodElement] is a future call method that should
  /// be validated and parsed.
  static bool isFutureCallMethod(MethodElement method) {
    print(method);
    if (method.isPrivate) return false;
    if (method.markedAsIgnored) return false;

    if (_excludedMethodNameSet.contains(method.name)) return false;

    return method.formalParameters.isFirstRequiredParameterSession;
  }

  /// Validates the [MethodElement] and returns a list of
  /// [SourceSpanSeverityException].
  static List<SourceSpanSeverityException> validate(
    MethodElement method,
    ClassElement classElement,
  ) {
    List<SourceSpanSeverityException?> errors = [
      _validateReturnType(
        dartType: method.returnType,
        dartElement: method,
      ),
    ];

    return errors.whereType<SourceSpanSeverityException>().toList();
  }

  static SourceSpanSeverityException? _validateReturnType({
    required DartType dartType,
    required Element dartElement,
  }) {
    if (!(dartType.isDartAsyncFuture)) {
      return SourceSpanSeverityException(
        'Return type must be a Future',
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
      // Interface type must always have a type argument so this is just for
      // safety.
      return SourceSpanSeverityException(
        'Return generic must be type defined. E.g. ${dartType.element.name}<String>.',
        dartElement.span,
      );
    }

    var innerType = typeArguments[0];

    if (innerType is VoidType && dartType.isDartAsyncFuture) {
      return null;
    }

    //TODO: Is it really necessary to enforce a return type for future calls

    if (innerType is DynamicType) {
      return SourceSpanSeverityException(
        'Return generic must have a type defined. E.g. ${dartType.element.name}<String>.',
        dartElement.span,
      );
    }

    try {
      TypeDefinition.fromDartType(innerType);
    } on FromDartTypeClassNameException catch (e) {
      return SourceSpanSeverityException(
        'The type "${e.type}" is not a supported future call return type.',
        dartElement.span,
      );
    }

    return null;
  }
}
