import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definition_analyzers/method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definition_analyzers/parameter_analyzer.dart';
import 'package:path/path.dart' as p;

import 'definitions.dart';

/// Analyzes dart files for the protocol specification.
class EndpointsAnalyzer {
  final AnalysisContextCollection collection;

  /// Create a new [EndpointsAnalyzer], containing a
  /// [AnalysisContextCollection] that analyzes all dart files in the
  /// provided [endpointDirectory].
  EndpointsAnalyzer(Directory endpointDirectory)
      : collection = AnalysisContextCollection(
          includedPaths: [endpointDirectory.absolute.path],
          resourceProvider: PhysicalResourceProvider.INSTANCE,
        );

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

  /// Analyze all files in the [AnalysisContextCollection].
  /// Use [changedFiles] to mark files, that need reloading.
  Future<List<EndpointDefinition>> analyze({
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
                if (!MethodAnalyzer.isEndpointMethod(method)) {
                  continue;
                }

                var parameters =
                    ParameterAnalyzer.analyze(method.parameters, collector);

                if (parameters == null) {
                  continue;
                }

                var methodDefinition = MethodAnalyzer.analyze(
                  method,
                  parameters,
                  collector,
                );

                if (methodDefinition == null) {
                  continue;
                }

                methodDefs.add(methodDefinition);
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
}
