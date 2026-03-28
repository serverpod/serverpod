import 'dart:collection';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_parameter_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/model_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

/// Cached analysis result for a single future call file.
class _CachedFutureCallFileResult {
  final List<FutureCallDefinition> definitions;
  final bool hadErrors;

  _CachedFutureCallFileResult({
    required this.definitions,
    required this.hadErrors,
  });
}

/// Analyzes dart files for [FutureCall]s.
///
/// The caller is responsible for calling [StatefulAnalyzer.validateAll] and
/// passing the validated models to [analyze] or [analyzeModels].
class FutureCallsAnalyzer {
  final AnalysisContextCollection collection;

  final String absoluteIncludedPaths;

  List<SerializableModelDefinition>? _cachedAnalyzedModels;

  /// Create a new [FutureCallsAnalyzer] for [directory].
  ///
  /// When [collection] is provided it is reused (e.g. shared with
  /// [EndpointsAnalyzer]). Otherwise a new one is created internally.
  FutureCallsAnalyzer({
    required Directory directory,
    AnalysisContextCollection? collection,
  }) : collection = collection ?? createAnalysisContextCollection(directory),
       absoluteIncludedPaths = directory.absolute.path;

  /// Cached per-file analysis results for future call files.
  /// Uses [SplayTreeMap] to keep keys sorted, ensuring deterministic
  /// iteration order when collecting definitions across runs.
  final _fileCache = SplayTreeMap<String, _CachedFutureCallFileResult>();

  /// Inform the analyzer that the provided [filePaths] have been updated.
  ///
  /// Refreshes the Dart analysis context for the changed files and returns
  /// `true` if any of them are (or were) future call files, meaning code
  /// generation should run.
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

    for (final path in relevantPaths) {
      if (!path.endsWith('.dart') || path.endsWith('_test.dart')) continue;
      if (_fileCache.containsKey(path)) return true;
      if (_isFutureCallFile(File(path))) return true;
    }

    return false;
  }

  /// Analyze all files in the [AnalysisContextCollection] for
  /// [FutureCallParameterDefinition] which need to be converted
  /// into [SerializableModelDefinition] for model generation.
  ///
  /// [analyzedModels] are the validated models from [StatefulAnalyzer.validateAll].
  Future<List<SerializableModelDefinition>> analyzeModels(
    CodeAnalysisCollector collector,
    List<SerializableModelDefinition> analyzedModels,
  ) async {
    final futureCalls = await analyze(
      collector: collector,
      analyzedModels: analyzedModels,
    );
    final models = <SerializableModelDefinition>[];

    for (final futureCall in futureCalls) {
      for (final method in futureCall.methods) {
        if (method.futureCallMethodParameter != null) {
          models.add(
            method.futureCallMethodParameter!.toSerializableModel(),
          );
        }
      }
    }

    SerializableModelAnalyzer.resolveModelDependencies([
      ...analyzedModels,
      ...models,
    ]);

    return models;
  }

  /// Analyze files in the [AnalysisContextCollection].
  ///
  /// On the first call, analyzes every Dart file. On subsequent calls, only
  /// re-analyzes files listed in [changedFiles], reusing cached results for
  /// unchanged files.
  ///
  /// [analyzedModels] are the validated models from [StatefulAnalyzer.validateAll].
  /// When provided, they are cached for subsequent calls. When omitted, the
  /// cached models from a previous call are used.
  ///
  /// [changedFiles] is the set of files that have changed since the last call.
  Future<List<FutureCallDefinition>> analyze({
    required CodeAnalysisCollector collector,
    List<SerializableModelDefinition>? analyzedModels,
    Set<String>? changedFiles,
  }) async {
    if (analyzedModels != null) {
      _cachedAnalyzedModels = analyzedModels;
    }

    changedFiles ??= {};
    await refreshAnalysisContext(collection, changedFiles);

    // On the first run, mark every Dart file as changed so the single
    // code path handles both first and subsequent runs.
    if (_fileCache.isEmpty) {
      changedFiles.addAll(_allAnalyzedDartFiles);
    }

    // Analyze changed files + previously errored future call files
    // (fixing a dependency elsewhere might unblock them).
    final filesToAnalyze = <String>{
      ...changedFiles,
      ..._fileCache.keys,
    };

    // Remove deleted files from cache.
    for (var path in filesToAnalyze) {
      if (!File(path).existsSync()) {
        _fileCache.remove(path);
      }
    }

    // Resolve only the files that need re-analysis.
    List<(ResolvedLibraryResult, String)> validLibraries = [];
    List<String> erroredFiles = [];

    for (var path in filesToAnalyze) {
      if (!path.endsWith('.dart') || path.endsWith('_test.dart')) continue;
      if (!File(path).existsSync()) continue;

      var library = await _resolveLibrary(path);
      if (library == null) continue;

      var futureCallClasses = _getFutureCallClasses(library);
      if (futureCallClasses.isEmpty) {
        _fileCache.remove(path);
        continue;
      }

      var maybeDartErrors = await _getErrorsForFile(library.session, path);
      if (maybeDartErrors.isNotEmpty) {
        erroredFiles.add(path);
        collector.addError(
          SourceSpanSeverityException(
            'FutureCall analysis skipped due to invalid Dart syntax. Please '
            'review and correct the syntax errors.'
            '\nFile: $path'
            '\n${maybeDartErrors.join('\n')}',
            null,
            severity: SourceSpanSeverity.error,
          ),
        );

        _fileCache[path] = _CachedFutureCallFileResult(
          definitions: [],
          hadErrors: true,
        );
        continue;
      }

      validLibraries.add((library, path));
    }

    // Build future call class map from ALL files for duplicate detection.
    // Errored files have empty definitions so they naturally don't contribute,
    // matching the original behavior.
    Map<String, int> futureCallClassMap = {};
    for (var entry in _fileCache.entries) {
      if (validLibraries.any((lib) => lib.$2 == entry.key)) continue;
      for (var def in entry.value.definitions) {
        futureCallClassMap.update(
          def.className,
          (v) => v + 1,
          ifAbsent: () => 1,
        );
      }
    }
    for (var (library, _) in validLibraries) {
      for (var cls in _getFutureCallClasses(library)) {
        futureCallClassMap.update(
          cls.name!,
          (v) => v + 1,
          ifAbsent: () => 1,
        );
      }
    }

    var duplicateFutureCallClasses = futureCallClassMap.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toSet();

    // Validate and parse re-analyzed files, update cache.
    //
    // Skip parameter validation when models aren't available yet (e.g. when
    // called from updateFileContexts before performGenerate provides models).
    // Validation will run on the next analyze() call with models.
    final hasModels = _cachedAnalyzedModels != null;
    final templateRegistry = DartDocTemplateRegistry();

    for (var (library, filePath) in validLibraries) {
      var failingExceptions = <String, List<SourceSpanSeverityException>>{};

      if (hasModels) {
        var severityExceptions = _validateLibrary(
          library,
          filePath,
          duplicateFutureCallClasses,
          _cachedAnalyzedModels!,
        );
        collector.addErrors(
          severityExceptions.values.expand((e) => e).toList(),
        );
        failingExceptions = _filterNoFailExceptions(severityExceptions);
      }

      var defs = _parseLibrary(
        library,
        filePath,
        failingExceptions,
        templateRegistry: templateRegistry,
      );

      _fileCache[filePath] = _CachedFutureCallFileResult(
        definitions: defs,
        hadErrors: !hasModels,
      );
    }

    // Phase 4: Collect all future call definitions from cache.
    // _fileCache is a SplayTreeMap so iteration is in sorted key order.
    var futureCallDefs = <FutureCallDefinition>[];
    for (var result in _fileCache.values) {
      futureCallDefs.addAll(result.definitions);
    }
    futureCallDefs.removeWhere((e) => e.filePath.startsWith('package:'));

    return futureCallDefs;
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
      var result = await context.currentSession.getResolvedLibrary(filePath);
      if (result is ResolvedLibraryResult) {
        return result;
      }
    }
    return null;
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

  List<FutureCallDefinition> _parseLibrary(
    ResolvedLibraryResult library,
    String filePath,
    Map<String, List<SourceSpanSeverityException>> validationErrors, {
    required DartDocTemplateRegistry templateRegistry,
  }) {
    var futureCallClasses = _getFutureCallClasses(library).where(
      (element) => !validationErrors.containsKey(
        FutureCallClassAnalyzer.elementNamespace(element, filePath),
      ),
    );

    var futureCallDefinitions = <FutureCallDefinition>[];
    for (var classElement in futureCallClasses) {
      FutureCallClassAnalyzer.parse(
        classElement,
        validationErrors,
        filePath,
        futureCallDefinitions,
        templateRegistry: templateRegistry,
      );
    }

    return futureCallDefinitions;
  }

  bool _isFutureCallFile(File file) {
    if (!file.absolute.path.startsWith(absoluteIncludedPaths)) return false;
    if (!file.path.endsWith('.dart')) return false;
    if (!file.existsSync()) return false;
    return file.readAsStringSync().contains('extends FutureCall');
  }

  Map<String, List<SourceSpanSeverityException>> _validateLibrary(
    ResolvedLibraryResult library,
    String filePath,
    Set<String> duplicatedClasses,
    List<SerializableModelDefinition> analyzedModels,
  ) {
    var futureCallClasses = _getFutureCallClasses(library);

    var validationErrors = <String, List<SourceSpanSeverityException>>{};
    for (var classElement in futureCallClasses) {
      var errors = FutureCallClassAnalyzer.validate(
        classElement,
        duplicatedClasses,
      );

      if (errors.isNotEmpty) {
        validationErrors[FutureCallClassAnalyzer.elementNamespace(
              classElement,
              filePath,
            )] =
            errors;
      }

      var futureCallMethods = classElement.methods.where(
        FutureCallMethodAnalyzer.isFutureCallMethod,
      );

      for (var method in futureCallMethods) {
        errors = FutureCallMethodAnalyzer.validate(method, classElement);
        errors.addAll(
          FutureCallParameterAnalyzer.validate(
            method.formalParameters,
            analyzedModels,
          ),
        );

        if (errors.isNotEmpty) {
          validationErrors[FutureCallMethodAnalyzer.elementNamespace(
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

  Iterable<ClassElement> _getFutureCallClasses(ResolvedLibraryResult library) {
    return library.element.classes.where(
      FutureCallClassAnalyzer.isFutureCallClass,
    );
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
