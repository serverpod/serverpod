import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_parameter_analyzer.dart';

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
    await for (var (library, filePath, rootPath) in _libraries) {
      var maybeDartErrors = await _getErrorsForFile(library.session, filePath);
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

      var validationErrors = _validateLibrary(library, filePath);
      collector.addErrors(validationErrors.values.expand((e) => e).toList());

      endpointDefs.addAll(
        _parseLibrary(
          library,
          collector,
          filePath,
          rootPath,
          validationErrors,
        ),
      );
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

  List<EndpointDefinition> _parseLibrary(
    ResolvedLibraryResult library,
    CodeAnalysisCollector collector,
    String filePath,
    String rootPath,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
  ) {
    var topElements = library.element.topLevelElements;
    var classElements = topElements.whereType<ClassElement>();
    var endpointClasses = classElements
        .where(EndpointClassAnalyzer.isEndpointClass)
        .where((element) => !validationErrors.containsKey(
              EndpointClassAnalyzer.elementNamespace(element, filePath),
            ));

    var endpointDefs = <EndpointDefinition>[];
    for (var classElement in endpointClasses) {
      var endpointMethods = classElement.methods
          .where(EndpointMethodAnalyzer.isEndpointMethod)
          .where((methodElement) => !validationErrors.containsKey(
                EndpointMethodAnalyzer.elementNamespace(
                    classElement, methodElement, filePath),
              ));

      var methodDefs = <MethodDefinition>[];
      for (var method in endpointMethods) {
        var parameters = EndpointParameterAnalyzer.parse(method.parameters);

        methodDefs.add(EndpointMethodAnalyzer.parse(
          method,
          parameters,
        ));
      }

      var endpointDefinition = EndpointClassAnalyzer.parse(
        classElement,
        methodDefs,
        filePath,
        rootPath,
      );

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

  Map<String, List<SourceSpanSeverityException>> _validateLibrary(
    ResolvedLibraryResult library,
    String filePath,
  ) {
    var topElements = library.element.topLevelElements;
    var classElements = topElements.whereType<ClassElement>();
    var endpointClasses =
        classElements.where(EndpointClassAnalyzer.isEndpointClass);

    var validationErrors = <String, List<SourceSpanSeverityException>>{};
    for (var classElement in endpointClasses) {
      var errors = EndpointClassAnalyzer.validate(classElement);
      if (errors.isNotEmpty) {
        validationErrors[EndpointClassAnalyzer.elementNamespace(
          classElement,
          filePath,
        )] = errors;
      }

      var endpointMethods =
          classElement.methods.where(EndpointMethodAnalyzer.isEndpointMethod);
      for (var method in endpointMethods) {
        errors = EndpointMethodAnalyzer.validate(method);
        errors.addAll(EndpointParameterAnalyzer.validate(method.parameters));
        if (errors.isNotEmpty) {
          validationErrors[EndpointMethodAnalyzer.elementNamespace(
            classElement,
            method,
            filePath,
          )] = errors;
        }
      }
    }

    return validationErrors;
  }

  Stream<(ResolvedLibraryResult, String, String)> get _libraries async* {
    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      var analyzedDartFiles = analyzedFiles
          .where((path) => path.endsWith('.dart'))
          .where((path) => !path.endsWith('_test.dart'));
      for (var filePath in analyzedDartFiles) {
        var library = await context.currentSession.getResolvedLibrary(filePath);
        if (library is ResolvedLibraryResult) {
          yield (library, filePath, context.contextRoot.root.path);
        }
      }
    }
  }
}
