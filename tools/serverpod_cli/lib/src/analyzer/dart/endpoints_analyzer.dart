import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definition_analyzers/class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definition_analyzers/method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definition_analyzers/parameter_analyzer.dart';

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

  /// Analyze all files in the [AnalysisContextCollection].
  /// Use [changedFiles] to mark files, that need reloading.
  Future<List<EndpointDefinition>> analyze({
    required CodeAnalysisCollector collector,
    Set<String>? changedFiles,
  }) async {
    await _refreshContextForFiles(changedFiles);

    var endpointDefs = <EndpointDefinition>[];
    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      var analyzedDartFiles = analyzedFiles
          .where((path) => path.endsWith('.dart'))
          .where((path) => !path.endsWith('_test.dart'));

      for (var filePath in analyzedDartFiles) {
        var library = await context.currentSession.getResolvedLibrary(filePath);
        if (library is! ResolvedLibraryResult) {
          continue;
        }

        var maybeDartErrors =
            await _getErrorsForFile(context.currentSession, filePath);
        if (maybeDartErrors.isNotEmpty) {
          collector.addError(
            SourceSpanSeverityException(
              'Endpoint analysis skipped due to invalid Dart syntax. Please '
              'review and correct the syntax errors.'
              '\nFile: $filePath',
              null,
              severity: SourceSpanSeverity.error,
            ),
          );

          continue;
        }

        endpointDefs.addAll(
          _analyzeLibrary(
            library,
            collector,
            filePath,
            context.contextRoot.root.path,
          ),
        );
      }
    }

    return endpointDefs;
  }

  /// Get all errors in the analyzed files.
  Future<List<String>> getErrors() async {
    var errorMessages = <String>[];

    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles();
      for (var filePath in analyzedFiles) {
        var fileErrors =
            await _getErrorsForFile(context.currentSession, filePath);
        errorMessages.addAll(fileErrors);
      }
    }
    return errorMessages;
  }

  Future<List<String>> _getErrorsForFile(
    AnalysisSession session,
    String filePath,
  ) async {
    var errorMessages = <String>[];

    var errors = await session.getErrors(filePath);
    if (errors is ErrorsResult) {
      errors.errors
          .where((error) => error.severity == Severity.error)
          .forEach((error) => errorMessages.add(
                '${error.problemMessage.filePath} Error: ${error.message}',
              ));
    }

    return errorMessages;
  }

  List<EndpointDefinition> _analyzeLibrary(
    ResolvedLibraryResult library,
    CodeAnalysisCollector collector,
    String filePath,
    String rootPath,
  ) {
    var topElements = library.element.topLevelElements;
    var classElements = topElements.whereType<ClassElement>();
    var endpointClasses = classElements.where(ClassAnalyzer.isEndpointClass);

    var endpointDefs = <EndpointDefinition>[];
    for (var element in endpointClasses) {
      var endpointMethods =
          element.methods.where(MethodAnalyzer.isEndpointMethod);

      var methodDefs = <MethodDefinition>[];
      for (var method in endpointMethods) {
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

      var endpointDefinition = ClassAnalyzer.analyze(
        element,
        methodDefs,
        collector,
        filePath,
        rootPath,
      );

      if (endpointDefinition == null) {
        continue;
      }

      endpointDefs.add(endpointDefinition);
    }

    return endpointDefs;
  }

  Future<void> _refreshContextForFiles(Set<String>? changedFiles) async {
    if (changedFiles == null) return;

    for (var context in collection.contexts) {
      for (var changedFile in changedFiles) {
        var file = File(changedFile);
        context.changeFile(p.normalize(file.absolute.path));
      }
      await context.applyPendingFileChanges();
    }
  }
}
