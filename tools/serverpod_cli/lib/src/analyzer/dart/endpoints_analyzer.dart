import 'dart:collection';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_parameter_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

import 'definitions.dart';

/// Cached analysis result for a single endpoint file.
class _CachedFileResult {
  final List<EndpointDefinition> definitions;
  final DartDocTemplateRegistry templates;
  final bool hadErrors;

  _CachedFileResult({
    required this.definitions,
    required this.templates,
    required this.hadErrors,
  });
}

/// Analyzes dart files for the protocol specification.
class EndpointsAnalyzer {
  final AnalysisContextCollection collection;

  final String absoluteIncludedPaths;

  /// Create a new [EndpointsAnalyzer] for [directory].
  ///
  /// When [collection] is provided it is reused (e.g. shared with
  /// [FutureCallsAnalyzer]). Otherwise a new one is created internally.
  EndpointsAnalyzer(
    Directory directory, {
    AnalysisContextCollection? collection,
  }) : collection = collection ?? createAnalysisContextCollection(directory),
       absoluteIncludedPaths = directory.absolute.path;

  /// Cached per-file analysis results for endpoint files.
  /// Uses [SplayTreeMap] to keep keys sorted, ensuring deterministic
  /// iteration order when collecting definitions across runs.
  final _fileCache = SplayTreeMap<String, _CachedFileResult>();

  /// Cached template entries for files that don't contain endpoints.
  /// These are tracked separately since they don't appear in [_fileCache].
  final Map<String, DartDocTemplateRegistry> _nonEndpointTemplateCache = {};

  /// Inform the analyzer that the provided [filePaths] have been updated.
  ///
  /// Refreshes the Dart analysis context for the changed files and returns
  /// `true` if any of them are (or were) endpoint files, meaning code
  /// generation should run. The actual full analysis is deferred to the
  /// next [analyze] call.
  Future<bool> updateFileContexts(Set<String> filePaths) async {
    // Only consider files within the tracked directory.
    final relevantPaths = filePaths
        .where((f) => p.isWithin(absoluteIncludedPaths, p.absolute(f)))
        .toSet();

    final errorsBefore = _fileCache.values.any((r) => r.hadErrors);
    final keysBefore = _fileCache.keys.toSet();

    await analyze(
      collector: CodeGenerationCollector(),
      changedFiles: relevantPaths,
    );

    final errorsAfter = _fileCache.values.any((r) => r.hadErrors);
    final keysAfter = _fileCache.keys.toSet();

    if (errorsBefore ||
        errorsAfter ||
        keysBefore.length != keysAfter.length ||
        keysAfter.difference(keysBefore).isNotEmpty) {
      return true;
    }

    // Editing methods on an existing endpoint does not add/remove cache keys,
    // but generated protocol must still be refreshed (otherwise stale
    // generated Dart can break analysis/compile before the next generate).
    for (final path in relevantPaths) {
      if (!path.endsWith('.dart') || path.endsWith('_test.dart')) continue;
      if (_fileCache.containsKey(path)) return true;
      if (_isEndpointFile(File(path))) return true;
    }

    return false;
  }

  /// Analyze files in the [AnalysisContextCollection].
  ///
  /// On the first call, analyzes every Dart file. On subsequent calls, only
  /// re-analyzes files that changed since the last run (tracked via
  /// [updateFileContexts] and [changedFiles]), reusing cached results for
  /// unchanged files.
  ///
  /// [changedFiles] is an optional set of files that should have their context
  /// refreshed before analysis. This is useful when only a subset of files have
  /// changed since [updateFileContexts] was last called (e.g. generated model
  /// files).
  Future<List<EndpointDefinition>> analyze({
    required CodeAnalysisCollector collector,
    Set<String>? changedFiles,
  }) async {
    changedFiles ??= {};
    await refreshAnalysisContext(collection, changedFiles);

    // On the first run, mark every Dart file as dirty so the single
    // code path handles both first and subsequent runs.
    if (_fileCache.isEmpty && _nonEndpointTemplateCache.isEmpty) {
      changedFiles.addAll(_allAnalyzedDartFiles);
    }

    // Files to analyze: dirty files + previously errored endpoint files
    // (fixing a dependency elsewhere might unblock them).
    final filesToAnalyze = <String>{
      ...changedFiles,
      ..._fileCache.keys,
    };

    // Remove deleted files from caches.
    for (var path in filesToAnalyze) {
      if (!File(path).existsSync()) {
        _fileCache.remove(path);
        _nonEndpointTemplateCache.remove(path);
      }
    }

    // Phase 1: Resolve only the files that need re-analysis.
    List<(ResolvedLibraryResult, String, DartDocTemplateRegistry)>
    validLibraries = [];
    List<String> erroredFiles = [];

    for (var path in filesToAnalyze) {
      if (!path.endsWith('.dart') || path.endsWith('_test.dart')) continue;
      if (!File(path).existsSync()) continue;

      var library = await _resolveLibrary(path);
      if (library == null) continue;

      var fileTemplates = _extractTemplatesFromLibrary(
        library,
        path,
        collector,
      );

      var endpointClasses = _getEndpointClasses(library);
      if (endpointClasses.isEmpty) {
        // Not (or no longer) an endpoint file - cache templates only.
        _fileCache.remove(path);
        _nonEndpointTemplateCache[path] = fileTemplates;
        continue;
      }

      // It is an endpoint file, not a plain file.
      _nonEndpointTemplateCache.remove(path);

      var maybeDartErrors = await _getErrorsForFile(library.session, path);
      if (maybeDartErrors.isNotEmpty) {
        erroredFiles.add(path);
        collector.addError(
          SourceSpanSeverityException(
            'Endpoint analysis skipped due to invalid Dart syntax. Please '
            'review and correct the syntax errors.'
            '\nFile: $path'
            '\n${maybeDartErrors.join('\n')}',
            null,
            severity: SourceSpanSeverity.error,
          ),
        );

        _fileCache[path] = _CachedFileResult(
          definitions: [],
          templates: fileTemplates,
          hadErrors: true,
        );
        continue;
      }

      validLibraries.add((library, path, fileTemplates));
    }

    // Phase 2: Build endpoint class map from ALL files for duplicate detection.
    // Errored files have empty definitions so they naturally don't contribute,
    // matching the original behavior.
    Map<String, int> endpointClassMap = {};
    for (var entry in _fileCache.entries) {
      if (validLibraries.any((lib) => lib.$2 == entry.key)) continue;
      for (var def in entry.value.definitions) {
        endpointClassMap.update(
          def.className,
          (v) => v + 1,
          ifAbsent: () => 1,
        );
      }
    }
    for (var (library, _, _) in validLibraries) {
      for (var cls in _getEndpointClasses(library)) {
        endpointClassMap.update(cls.name!, (v) => v + 1, ifAbsent: () => 1);
      }
    }

    var duplicateEndpointClasses = endpointClassMap.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toSet();

    // Phase 3: Build full template registry from all caches + fresh results.
    final templateRegistry = DartDocTemplateRegistry();
    for (var entry in _fileCache.entries) {
      if (validLibraries.any((lib) => lib.$2 == entry.key)) continue;
      templateRegistry.addAll(entry.value.templates);
    }
    for (var templates in _nonEndpointTemplateCache.values) {
      templateRegistry.addAll(templates);
    }

    // Phase 4: Validate and parse re-analyzed files, update cache.
    for (var (library, filePath, fileTemplates) in validLibraries) {
      templateRegistry.addAll(fileTemplates);

      var severityExceptions = _validateLibrary(
        library,
        filePath,
        duplicateEndpointClasses,
      );
      collector.addErrors(severityExceptions.values.expand((e) => e).toList());

      var failingExceptions = _filterNoFailExceptions(severityExceptions);

      var defs = _parseLibrary(
        library,
        filePath,
        failingExceptions,
        templateRegistry: templateRegistry,
      );

      _fileCache[filePath] = _CachedFileResult(
        definitions: defs,
        templates: fileTemplates,
        hadErrors: false,
      );
    }

    // Phase 5: Collect all endpoint definitions from cache.
    // _fileCache is a SplayTreeMap so iteration is in sorted key order.
    var endpointDefs = <EndpointDefinition>[];
    for (var result in _fileCache.values) {
      endpointDefs.addAll(result.definitions);
    }
    endpointDefs.removeWhere((e) => e.filePath.startsWith('package:'));

    return endpointDefs;
  }

  /// Returns all Dart file paths known to the analysis context, sorted and
  /// excluding test files.
  Iterable<String> get _allAnalyzedDartFiles sync* {
    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      yield* analyzedFiles
          .where((path) => path.endsWith('.dart'))
          .where((path) => !path.endsWith('_test.dart'));
    }
  }

  /// Resolves a single file to a [ResolvedLibraryResult].
  Future<ResolvedLibraryResult?> _resolveLibrary(String filePath) async {
    for (var context in collection.contexts) {
      var result = await context.currentSession.getResolvedLibrary(
        p.normalize(filePath),
      );
      if (result is ResolvedLibraryResult) {
        return result;
      }
    }

    return null;
  }

  /// Extracts all {@template}...{@endtemplate} definitions from all classes
  /// and methods in the library.
  DartDocTemplateRegistry _extractTemplatesFromLibrary(
    ResolvedLibraryResult library,
    String filePath,
    CodeAnalysisCollector collector,
  ) {
    final registry = DartDocTemplateRegistry();

    for (var classElement in library.element.classes) {
      registry.addAll(
        _extractTemplatesFromElement(classElement, filePath, collector),
      );

      for (var method in classElement.methods) {
        registry.addAll(
          _extractTemplatesFromElement(method, filePath, collector),
        );
      }
    }

    return registry;
  }

  DartDocTemplateRegistry _extractTemplatesFromElement(
    Element element,
    String filePath,
    CodeAnalysisCollector collector,
  ) {
    try {
      return extractDartDocTemplates(element.documentationComment);
    } on FormatException catch (e) {
      collector.addError(
        SourceSpanSeverityException(
          'Error extracting templates from $filePath: ${e.message}',
          null,
          severity: SourceSpanSeverity.warning,
        ),
      );
      return DartDocTemplateRegistry();
    }
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
    Map<String, List<SourceSpanSeverityException>> validationErrors, {
    required DartDocTemplateRegistry templateRegistry,
  }) {
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
        templateRegistry: templateRegistry,
      );
    }

    return endpointDefinitions;
  }

  /// Returns `true` if [file] appears to define an Endpoint subclass.
  ///
  /// Quick content check (no full analysis). Used with [_fileCache] so saves
  /// to newly added endpoint files still trigger generation when the cache
  /// has not yet been updated for other reasons.
  bool _isEndpointFile(File file) {
    if (!file.absolute.path.startsWith(absoluteIncludedPaths)) return false;
    if (!file.path.endsWith('.dart')) return false;
    if (!file.existsSync()) return false;
    return file.readAsStringSync().contains('extends Endpoint');
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
        errors = EndpointMethodAnalyzer.validate(method, classElement, library);
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
