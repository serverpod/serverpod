import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/annotation_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/keywords.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/parameters.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

abstract class FutureCallMethodAnalyzer {
  /// Parses an [MethodElement] into a [MethodDefinition].
  /// Assumes that the [MethodElement] is a valid future call method.
  static FutureCallMethodDefinition parse(
    MethodElement method,
    Parameters parameters, {
    required DartDocTemplateRegistry templateRegistry,
    required String className,
  }) {
    FutureCallParameterDefinition? futureCallMethodParameter;

    final allParametersWithoutSession =
        parameters.allParameters.withoutSessionParameter;
    final allParametersWithoutSessionLength =
        allParametersWithoutSession.length;

    // Generate futureCallMethodParameter if there is one or more
    // parameters apart from the Session type.
    // When there is only one parameter apart from the Session parameter,
    // only generate futureCallMethodParameter if the parameter type is supported
    // for serialization.
    // If the only parameter apart from the Session parameter
    // is a SerializableModel, it will be skipped since it would
    // have been defined with yaml for generation.
    final shouldGenerateSerializableModelDefinition =
        allParametersWithoutSessionLength == 1 &&
        allParametersWithoutSession.first.type.isSerializableDartType;

    if (shouldGenerateSerializableModelDefinition ||
        allParametersWithoutSessionLength > 1) {
      futureCallMethodParameter = FutureCallParameterDefinition(
        name: 'object',
        type: TypeDefinition(
          className:
              '${ReCase(className).pascalCase}${ReCase(method.displayName).pascalCase}Model',
          nullable: false,
          customClass: false,
        ),
        parameters: parameters.required.withoutSessionParameter,
        parametersPositional: parameters.positional,
        parametersNamed: parameters.named,
      );
    }

    return FutureCallMethodDefinition(
      name: method.displayName,
      documentationComment: stripDocumentationTemplateMarkers(
        method.documentationComment,
        templateRegistry: templateRegistry,
      ),
      annotations: AnnotationAnalyzer.parseFutureCallAnnotations(method),
      parameters: parameters.required,
      parametersNamed: parameters.named,
      parametersPositional: parameters.positional,
      returnType: TypeDefinition.fromDartType(method.returnType),
      futureCallMethodParameter: futureCallMethodParameter,
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
    if (method.isPrivate) return false;
    if (method.futureCallMarkedAsIgnored) return false;

    if (method.formalParameters.isEmpty) return false;

    return method.returnType.isDartAsyncFuture;
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
    if (!dartType.isDartAsyncFuture) {
      return SourceSpanSeverityException(
        'Return type must be a Future.',
        dartElement.span,
      );
    }

    if (dartType is! InterfaceType) {
      return SourceSpanSeverityException(
        'The type "$dartType" is not a supported future call return type.',
        dartElement.span,
      );
    }

    var typeArguments = dartType.typeArguments;

    if (typeArguments.length != 1) {
      // Interface type must always have a type argument so this is just for
      // safety.
      return SourceSpanSeverityException(
        'Return generic must be type defined. E.g. ${dartType.element.name}<void>.',
        dartElement.span,
      );
    }

    var innerType = typeArguments[0];

    if (innerType is DynamicType) {
      return SourceSpanSeverityException(
        'Return generic must have a type defined. E.g. ${dartType.element.name}<void>.',
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

extension _ParameterDefinitionExtension on List<ParameterDefinition> {
  /// Returns a list of parameters without the session parameter.
  List<ParameterDefinition> get withoutSessionParameter {
    return where(
      (parameter) => parameter.type.className != Keyword.sessionClassName,
    ).toList();
  }
}
