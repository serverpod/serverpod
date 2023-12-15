import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definition_analyzers/class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definition_analyzers/parameter_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';

const _excludedMethodNameSet = {
  'streamOpened',
  'streamClosed',
  'handleStreamMessage',
  'sendStreamMessage',
  'setUserObject',
  'getUserObject',
};

abstract class MethodAnalyzer {
  /// Parses an [MethodElement] into a [MethodDefinition].
  /// Assumes that the [MethodElement] is a valid endpoint method.
  static MethodDefinition parse(
    MethodElement method,
    Parameters parameters,
  ) {
    var definition = MethodDefinition(
      name: method.name,
      documentationComment: method.documentationComment,
      // TODO: Move removal of session parameter to Parameter analyzer
      parameters: parameters.required.sublist(1), // Skip session parameter,
      parametersNamed: parameters.named,
      parametersPositional: parameters.positional,
      returnType: TypeDefinition.fromDartType(method.returnType),
    );

    return definition;
  }

  /// Creates a namespace for the [MethodElement] based on the [ClassElement]
  /// and the [filePath].
  static String elementNamespace(
    ClassElement classElement,
    MethodElement methodElement,
    String filePath,
  ) {
    return '${ClassAnalyzer.elementNamespace(
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
  }) {
    if (!dartType.isDartAsyncFuture) {
      return SourceSpanSeverityException(
        'Return type must be a Future.',
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
        'Future must have a type defined. E.g. Future<String>.',
        dartElement.span,
      );
    }
    var innerType = typeArguments[0];

    if (innerType is VoidType) {
      return null;
    }

    if (innerType is DynamicType) {
      return SourceSpanSeverityException(
        'Future must have a type defined. E.g. Future<String>.',
        dartElement.span,
      );
    }

    return null;
  }
}
