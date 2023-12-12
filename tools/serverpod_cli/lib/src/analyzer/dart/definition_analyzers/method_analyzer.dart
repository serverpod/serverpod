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
    if (!_hasValidReturnType(
      dartType: method.returnType,
      dartElement: method,
      collector: collector,
    )) {
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

  static bool _hasValidReturnType({
    required DartType dartType,
    required Element dartElement,
    required CodeAnalysisCollector collector,
  }) {
    if (!dartType.isDartAsyncFuture) {
      collector.addError(SourceSpanSeverityException(
        'Return type must be a Future.',
        dartElement.span,
      ));
      return false;
    }

    if (dartType is! InterfaceType) {
      collector.addError(SourceSpanSeverityException(
        'This type is not supported as return type.',
        dartElement.span,
      ));
      return false;
    }

    var typeArguments = dartType.typeArguments;
    if (typeArguments.length != 1) {
      collector.addError(SourceSpanSeverityException(
        'Future must have a type defined. E.g. Future<String>.',
        dartElement.span,
      ));
      return false;
    }
    var innerType = typeArguments[0];

    if (innerType is VoidType) {
      return true;
    }

    if (innerType is InvalidType) {
      collector.addError(SourceSpanSeverityException(
        'Future has an invalid return type.',
        dartElement.span,
      ));
      return false;
    }

    if (innerType is DynamicType) {
      collector.addError(SourceSpanSeverityException(
        'Future must have a type defined. E.g. Future<String>.',
        dartElement.span,
      ));
      return false;
    }

    return true;
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
