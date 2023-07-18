import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:source_span/source_span.dart';
import 'package:path/path.dart' as p;

import 'definitions.dart';

const _excludedMethodNameSet = {
  'streamOpened',
  'streamClosed',
  'handleStreamMessage',
  'sendStreamMessage',
  'setUserObject',
  'getUserObject',
};

/// Analyzes dart files for the protocol specification.
class EndpointsAnalyzer {
  late final Directory endpointDirectory;
  late final AnalysisContextCollection collection;

  /// Create a new [EndpointsAnalyzer], analyzing all dart files in the
  /// [endpointDirectory].
  // TODO: Make ProtocolDartFileAnalyzer testable
  EndpointsAnalyzer(GeneratorConfig config) {
    endpointDirectory = Directory(p.joinAll(config.endpointsSourcePathParts));
    collection = AnalysisContextCollection(
      includedPaths: [endpointDirectory.absolute.path],
      resourceProvider: PhysicalResourceProvider.INSTANCE,
    );
  }

  /// Get all errors in the analyzed files.
  Future<List<String>> getErrors() async {
    var errorMessages = <String>[];

    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles();
      for (var filePath in analyzedFiles) {
        var errors = await context.currentSession.getErrors(filePath);
        if (errors is ErrorsResult) {
          for (var error in errors.errors) {
            if (error.severity == Severity.error) {
              // TODO: Figure out how to include line number
              errorMessages.add(
                '${error.problemMessage.filePath} Error: ${error.message}',
              );
            }
          }
        }
      }
    }
    return errorMessages;
  }

  /// Analyze all files in the [endpointDirectory].
  /// Use [changedFiles] to mark files, that need reloading.
  Future<List<EndpointDefinition>> analyze({
    required bool verbose,
    required CodeAnalysisCollector collector,
    Set<String>? changedFiles,
  }) async {
    if (changedFiles != null) {
      // Make sure that the analyzer is up-to-date with recent changes.
      for (var context in collection.contexts) {
        for (var changedFile in changedFiles) {
          var file = File(changedFile);
          context.changeFile(p.normalize(file.absolute.path));
        }
        await context.applyPendingFileChanges();
      }
    }

    var endpointDefs = <EndpointDefinition>[];

    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      for (var filePath in analyzedFiles) {
        if (!filePath.endsWith('.dart')) {
          continue;
        }

        // Get the subdirectory of the filePath by removing the first elements
        // of the root path and the file path as long as they match.
        var rootPathParts = p.split(context.contextRoot.root.path);
        var fileDirPathParts = p.split(p.dirname(filePath));
        while (rootPathParts.isNotEmpty && fileDirPathParts.isNotEmpty) {
          if (rootPathParts.first == fileDirPathParts.first) {
            rootPathParts.removeAt(0);
            fileDirPathParts.removeAt(0);
          } else {
            break;
          }
        }
        var subdirectory = fileDirPathParts;

        var library = await context.currentSession.getResolvedLibrary(filePath);
        library as ResolvedLibraryResult;
        var element = library.element;
        var topElements = element.topLevelElements;

        for (var element in topElements) {
          if (element is ClassElement) {
            var className = element.name;
            var superclassName = element.supertype!.element.name;
            var endpointName = _formatEndpointName(className);

            if (superclassName == 'Endpoint') {
              var classDocumentationComment = element.documentationComment;

              var methodDefs = <MethodDefinition>[];
              var methods = element.methods;
              for (var method in methods) {
                // Skip private methods
                if (method.isPrivate) continue;
                // Skip overridden methods from the Endpoint class
                if (_excludedMethodNameSet.contains(method.name)) continue;

                var paramDefs = <ParameterDefinition>[];
                var paramPositionalDefs = <ParameterDefinition>[];
                var paramNamedDefs = <ParameterDefinition>[];
                var parameters = method.parameters;
                for (var param in parameters) {
                  var paramDef = ParameterDefinition(
                    name: param.name,
                    required: param.isRequiredPositional ||
                        param.isRequiredNamed ||
                        (param.isNamed &&
                            param.type.nullabilitySuffix ==
                                NullabilitySuffix.none),
                    type: TypeDefinition.fromDartType(param.type),
                    dartParameter: param,
                  );

                  if (param.isRequiredPositional) {
                    paramDefs.add(paramDef);
                  } else if (param.isOptionalPositional) {
                    paramPositionalDefs.add(paramDef);
                  } else if (param.isNamed) {
                    paramNamedDefs.add(paramDef);
                  }
                }

                if (_isEndpointMethod(paramDefs) &&
                    _isValidReturnType(
                      dartType: method.returnType,
                      dartElement: method,
                      collector: collector,
                    )) {
                  var methodDef = MethodDefinition(
                    name: method.name,
                    documentationComment: method.documentationComment,
                    parameters: paramDefs.sublist(1), // Skip session parameter
                    parametersNamed: paramNamedDefs,
                    parametersPositional: paramPositionalDefs,
                    returnType: TypeDefinition.fromDartType(method.returnType),
                  );
                  methodDefs.add(methodDef);
                }
              }

              var endpointDef = EndpointDefinition(
                name: endpointName,
                documentationComment: classDocumentationComment,
                className: className,
                methods: methodDefs,
                filePath: filePath,
                subDirParts: subdirectory,
              );
              endpointDefs.add(endpointDef);
            }
          }
        }
      }
    }

    return endpointDefs;
  }

  String _formatEndpointName(String className) {
    const removeEnding = 'Endpoint';

    var endpointName = '${className[0].toLowerCase()}${className.substring(1)}';
    if (endpointName.endsWith(removeEnding)) {
      endpointName =
          endpointName.substring(0, endpointName.length - removeEnding.length);
    }

    return endpointName;
  }

  bool _isEndpointMethod(List<ParameterDefinition> paramDefs) {
    return paramDefs.isNotEmpty && paramDefs[0].type.className == 'Session';
  }

  bool _isValidReturnType({
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
