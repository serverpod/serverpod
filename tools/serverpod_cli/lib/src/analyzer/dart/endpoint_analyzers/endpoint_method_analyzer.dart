import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/annotation.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_parameter_analyzer.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

import 'extension/endpoint_parameters_extension.dart';

const _excludedMethodNameSet = {
  'streamOpened',
  'streamClosed',
  'handleStreamMessage',
  'sendStreamMessage',
  'setUserObject',
  'getUserObject',
};

abstract class EndpointMethodAnalyzer {
  /// Parses an [MethodElement] into a [MethodDefinition].
  /// Assumes that the [MethodElement] is a valid endpoint method.
  static MethodDefinition parse(
    MethodElement method,
    Parameters parameters,
  ) {
    var isStream =
        method.returnType.isDartAsyncStream || parameters._hasStream();

    if (isStream) {
      return MethodStreamDefinition(
        name: method.displayName,
        documentationComment: stripDocumentationTemplateMarkers(
          method.documentationComment,
        ),
        annotations: AnnotationAnalyzer.parseAnnotations(method),
        parameters: parameters.required,
        parametersNamed: parameters.named,
        parametersPositional: parameters.positional,
        returnType: TypeDefinition.fromDartType(method.returnType),
      );
    }

    return MethodCallDefinition(
      name: method.displayName,
      documentationComment: stripDocumentationTemplateMarkers(
        method.documentationComment,
      ),
      annotations: AnnotationAnalyzer.parseAnnotations(method),
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
    return '${EndpointClassAnalyzer.elementNamespace(
      classElement,
      filePath,
    )}_${methodElement.name}';
  }

  /// Returns true if the [MethodElement] is an endpoint method that should
  /// be validated and parsed.
  static bool isEndpointMethod(MethodElement method) {
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
        hasStreamParameter: method.formalParameters._hasStream(),
      ),
      _validateUnauthenticatedAnnotation(method, classElement),
    ];

    return errors.whereType<SourceSpanSeverityException>().toList();
  }

  static SourceSpanSeverityException? _validateReturnType({
    required DartType dartType,
    required Element dartElement,
    required bool hasStreamParameter,
  }) {
    if (!(dartType.isDartAsyncFuture || dartType.isDartAsyncStream)) {
      return SourceSpanSeverityException(
        'Return type must be a Future or a Stream.',
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

    if (innerType is VoidType && dartType.isDartAsyncStream) {
      return SourceSpanSeverityException(
        'The type "void" is not supported for streams.',
        dartElement.span,
      );
    }

    if (innerType is VoidType && dartType.isDartAsyncFuture) {
      return null;
    }

    if (innerType is DynamicType && !dartType.isDartAsyncStream) {
      return SourceSpanSeverityException(
        'Return generic must have a type defined. E.g. ${dartType.element.name}<String>.',
        dartElement.span,
      );
    }

    try {
      TypeDefinition.fromDartType(innerType);
    } on FromDartTypeClassNameException catch (e) {
      return SourceSpanSeverityException(
        'The type "${e.type}" is not a supported endpoint return type.',
        dartElement.span,
      );
    }

    return null;
  }

  static SourceSpanSeverityException? _validateUnauthenticatedAnnotation(
    MethodElement method,
    ClassElement classElement,
  ) {
    if (classElement.overridesRequireLogin && method.markedAsUnauthenticated) {
      return SourceSpanSeverityException(
        'Method "${method.name}" in endpoint class "${classElement.name}" is '
        'annotated with @unauthenticatedClientCall, but the class overrides '
        'the "requireLogin" getter. Be aware that this combination may lead to '
        'endpoint calls failing due to client not sending a signed in user. '
        'To fix this, either move this method to a separate endpoint class '
        'that does not override "requireLogin", remove the "requireLogin" '
        'getter override or remove the @unauthenticatedClientCall annotation.',
        method.span,
        severity: SourceSpanSeverity.info,
      );
    }
    return null;
  }
}

extension on List<FormalParameterElement> {
  bool _hasStream() {
    return any((element) => element.type.isDartAsyncStream);
  }
}

extension on Parameters {
  bool _hasStream() => [
    ...required,
    ...positional,
    ...named,
  ].any((element) => element.type.dartType?.isDartAsyncStream ?? false);
}
