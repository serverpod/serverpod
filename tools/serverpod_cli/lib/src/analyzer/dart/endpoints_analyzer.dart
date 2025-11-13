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
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';

import 'definitions.dart';

/// Analyzes dart files for the protocol specification.
class EndpointsAnalyzer {
  final AnalysisContextCollection collection;

  final String absoluteIncludedPaths;

  /// Create a new [EndpointsAnalyzer], containing a
  /// [AnalysisContextCollection] that analyzes all dart files in the
  /// provided [directory].
  EndpointsAnalyzer(Directory directory)
    : collection = AnalysisContextCollection(
        includedPaths: [directory.absolute.path],
        resourceProvider: PhysicalResourceProvider.INSTANCE,
      ),
      absoluteIncludedPaths = directory.absolute.path;

  Set<EndpointDefinition> _endpointDefinitions = {};

  /// Inform the analyzer that the provided [filePaths] have been updated.
  ///
  /// This will trigger a re-analysis of the files and return true if the
  /// updated files should trigger a code generation.
  Future<bool> updateFileContexts(Set<String> filePaths) async {
    await _refreshContextForFiles(filePaths);

    var oldDefinitionsLength = _endpointDefinitions.length;
    await analyze(collector: CodeGenerationCollector());

    if (_endpointDefinitions.length != oldDefinitionsLength) {
      return true;
    }

    return filePaths.any((e) => _isEndpointFile(File(e)));
  }

  /// Analyze all files in the [AnalysisContextCollection].
  ///
  /// [changedFiles] is an optional list of files that should have their context
  /// refreshed before analysis. This is useful when only a subset of files have
  /// changed since [updateFileContexts] was last called.
  Future<List<EndpointDefinition>> analyze({
    required CodeAnalysisCollector collector,
    Set<String>? changedFiles,
  }) async {
    await _refreshContextForFiles(changedFiles);

    var endpointDefs = <EndpointDefinition>[];

    List<(ResolvedLibraryResult, String)> validLibraries = [];
    Map<String, int> endpointClassMap = {};
    await for (var (library, filePath) in _libraries) {
      var endpointClasses = _getEndpointClasses(library);
      if (endpointClasses.isEmpty) {
        continue;
      }

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

      for (var endpointClass in endpointClasses) {
        var className = endpointClass.name!;
        endpointClassMap.update(
          className,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      validLibraries.add((library, filePath));
    }

    var duplicateEndpointClasses = endpointClassMap.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toSet();

    for (var (library, filePath) in validLibraries) {
      var severityExceptions = _validateLibrary(
        library,
        filePath,
        duplicateEndpointClasses,
      );
      collector.addErrors(severityExceptions.values.expand((e) => e).toList());

      var failingExceptions = _filterNoFailExceptions(severityExceptions);

      endpointDefs.addAll(
        _parseLibrary(
          library,
          filePath,
          failingExceptions,
        ),
      );
    }

    // After parsing all endpoints, we must remove all that are not part of
    // this package to avoid generating them as well.
    endpointDefs.removeWhere((e) => e.filePath.startsWith('package:'));

    _endpointDefinitions = endpointDefs.toSet();
    return endpointDefs;
  }

  Future<List<String>> _getErrorsForFile(
    AnalysisSession session,
    String filePath,
  ) async {
    var errorMessages = <String>[];

    var errors = await session.getErrors(filePath);
    if (errors is ErrorsResult) {
      errors.diagnostics
          .where((error) => error.severity == Severity.error)
          .forEach(
            (error) => errorMessages.add(
              '${error.problemMessage.filePath} Error: ${error.message}',
            ),
          );
    }

    return errorMessages;
  }

  List<EndpointDefinition> _parseLibrary(
    ResolvedLibraryResult library,
    String filePath,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
  ) {
    var endpointClasses = _getEndpointClasses(library).where(
      (element) => !validationErrors.containsKey(
        EndpointClassAnalyzer.elementNamespace(element, filePath),
      ),
    );

    var endpointDefinitions = <EndpointDefinition>[];
    for (var classElement in endpointClasses) {
      EndpointClassAnalyzer.parse(
        classElement,
        validationErrors,
        filePath,
        endpointDefinitions,
      );
    }

    return endpointDefinitions;
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

  bool _isEndpointFile(File file) {
    if (!file.absolute.path.startsWith(absoluteIncludedPaths)) return false;
    if (!file.path.endsWith('.dart')) return false;
    if (!file.existsSync()) return false;

    var contents = file.readAsStringSync();
    if (!contents.contains('extends Endpoint')) return false;

    return true;
  }

  Map<String, List<SourceSpanSeverityException>> _validateLibrary(
    ResolvedLibraryResult library,
    String filePath,
    Set<String> duplicatedClasses,
  ) {
    var endpointClasses = _getEndpointClasses(library);

    var validationErrors = <String, List<SourceSpanSeverityException>>{};
    for (var classElement in endpointClasses) {
      var errors = EndpointClassAnalyzer.validate(
        classElement,
        duplicatedClasses,
      );
      if (errors.isNotEmpty) {
        validationErrors[EndpointClassAnalyzer.elementNamespace(
              classElement,
              filePath,
            )] =
            errors;
      }

      var endpointMethods = classElement.methods.where(
        EndpointMethodAnalyzer.isEndpointMethod,
      );
      for (var method in endpointMethods) {
        errors = EndpointMethodAnalyzer.validate(method, classElement);
        errors.addAll(
          EndpointParameterAnalyzer.validate(method.formalParameters),
        );
        if (errors.isNotEmpty) {
          validationErrors[EndpointMethodAnalyzer.elementNamespace(
                classElement,
                method,
                filePath,
              )] =
              errors;
        }
      }
    }

    return validationErrors;
  }

  Stream<(ResolvedLibraryResult, String)> get _libraries async* {
    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      var analyzedDartFiles = analyzedFiles
          .where((path) => path.endsWith('.dart'))
          .where((path) => !path.endsWith('_test.dart'));
      for (var filePath in analyzedDartFiles) {
        var library = await context.currentSession.getResolvedLibrary(filePath);
        if (library is ResolvedLibraryResult) {
          yield (library, filePath);
        }
      }
    }
  }

  Iterable<ClassElement> _getEndpointClasses(ResolvedLibraryResult library) {
    return library.element.classes.where(EndpointClassAnalyzer.isEndpointClass);
  }

  Map<String, List<SourceSpanSeverityException>> _filterNoFailExceptions(
    Map<String, List<SourceSpanSeverityException>> validationErrors,
  ) {
    var noFailSeverities = [SourceSpanSeverity.hint, SourceSpanSeverity.info];

    var failingErrors = validationErrors.map((key, exceptions) {
      var failingExceptions = exceptions
          .where((exception) => !noFailSeverities.contains(exception.severity))
          .toList();

      return MapEntry(key, failingExceptions);
    });

    failingErrors.removeWhere((key, exceptions) => exceptions.isEmpty);

    return failingErrors;
  }
}
