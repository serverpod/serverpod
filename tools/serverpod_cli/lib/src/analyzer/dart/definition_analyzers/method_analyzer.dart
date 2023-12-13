import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definition_analyzers/parameter_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:source_span/source_span.dart';

const _excludedMethodNameSet = {
  'streamOpened',
  'streamClosed',
  'handleStreamMessage',
  'sendStreamMessage',
  'setUserObject',
  'getUserObject',
};

abstract class MethodAnalyzer {
  static MethodDefinition? analyze(
    MethodElement method,
    Parameters parameters,
    CodeAnalysisCollector collector,
  ) {
    var returnTypeWarning = validateReturnType(
      dartType: method.returnType,
      dartElement: method,
    );

    if (returnTypeWarning != null) {
      collector.addError(returnTypeWarning);
      return null;
    }

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

  static bool isEndpointMethod(MethodElement method) {
    if (method.isPrivate) return false;

    if (_excludedMethodNameSet.contains(method.name)) return false;

    if (_missingSessionParameter(method.parameters)) return false;

    return true;
  }

  static SourceSpanSeverityException? validateReturnType({
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

    if (innerType is InvalidType) {
      return SourceSpanSeverityException(
        'Future has an invalid return type.',
        dartElement.span,
      );
    }

    if (innerType is DynamicType) {
      return SourceSpanSeverityException(
        'Future must have a type defined. E.g. Future<String>.',
        dartElement.span,
      );
    }

    return null;
  }

  static bool _missingSessionParameter(List<ParameterElement> parameters) {
    if (parameters.isEmpty) return true;
    return parameters.first.type.element?.displayName != 'Session';
  }
}

extension _DartElementSourceSpan on Element {
  SourceSpan? get span {
    var sourceData = source?.contents.data;
    var sourceUri = source?.uri;
    var offset = nameOffset;
    var length = nameLength;

    if (sourceData != null && offset != 0 && length != -1) {
      var sourceFile = SourceFile.fromString(
        sourceData,
        url: sourceUri,
      );
      return sourceFile.span(offset, offset + length);
    } else {
      return null;
    }
  }
}
