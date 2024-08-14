import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_parameter_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

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
        name: method.name,
        documentationComment: method.documentationComment,
        annotations: _parseAnnotations(dartElement: method),
        // TODO: Move removal of session parameter to Parameter analyzer
        parameters: parameters.required.sublist(1), // Skip session parameter,
        parametersNamed: parameters.named,
        parametersPositional: parameters.positional,
        returnType: TypeDefinition.fromDartType(method.returnType),
      );
    }

    return MethodCallDefinition(
      name: method.name,
      documentationComment: method.documentationComment,
      annotations: _parseAnnotations(dartElement: method),
      // TODO: Move removal of session parameter to Parameter analyzer
      parameters: parameters.required.sublist(1), // Skip session parameter,
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

    if (_excludedMethodNameSet.contains(method.name)) return false;

    if (_missingSessionParameter(method.parameters)) return false;

    return true;
  }

  /// Validates the [MethodElement] and returns a list of
  /// [SourceSpanSeverityException].
  static List<SourceSpanSeverityException> validate(MethodElement method) {
    List<SourceSpanSeverityException?> errors = [
      _validateReturnType(
        dartType: method.returnType,
        dartElement: method,
        hasStreamParameter: method.parameters._hasStream(),
      )
    ];

    return errors.whereType<SourceSpanSeverityException>().toList();
  }

  static bool _missingSessionParameter(List<ParameterElement> parameters) {
    if (parameters.isEmpty) return true;
    return parameters.first.type.element?.displayName != 'Session';
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

  static List<String> _parseAnnotations({
    required Element dartElement,
  }) {
    final annotations = dartElement.metadata;
    final includedAnnotations = <String>[];
    for (final annotation in annotations) {
      var annotationName;
      if (annotation.element is ConstructorElement) {
        final constructorElement = annotation.element as ConstructorElement;
        annotationName = constructorElement.enclosingElement.name;
      }
      else {
        annotationName = annotation.element?.name;
      }
        switch (annotationName) {
          case 'Deprecated':
            final message = annotation
                .computeConstantValue()
                ?.getField('message')
                ?.toStringValue();
            if (message != null) {
              includedAnnotations.add(
                  "@${annotationName}('${message}')");
            }
            break;
          case 'deprecated':
            // @deprecated is a shorthand for @Deprecated(..)
            // see https://api.flutter.dev/flutter/dart-core/deprecated-constant.html
            includedAnnotations.add("@${annotationName}");
            break;
        }
    }
    return includedAnnotations;
  }
}

extension on List<ParameterElement> {
  bool _hasStream() {
    return any((element) => element.type.isDartAsyncStream);
  }
}

extension on Parameters {
  bool _hasStream() => [...required, ...positional, ...named]
      .any((element) => element.type.dartType?.isDartAsyncStream ?? false);
}
