import 'dart:collection';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definition_hash.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_parameter_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_retry_policy_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/model_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';
import 'package:serverpod_cli/src/util/unrendered_template_path.dart';

/// Cached analysis result for a single future call file.
class _CachedFutureCallFileResult {
  final List<FutureCallDefinition> definitions;
  final bool hadErrors;

  /// Hash of [definitions], taken once when the file is parsed.
  final int definitionsHash;

  _CachedFutureCallFileResult({
    required this.definitions,
    required this.hadErrors,
  }) : definitionsHash = futureCallDefinitionsHash(definitions);
}

/// A future call retry policy class found in a file.
class _CachedRetryPolicy {
  /// The type that refers to the class in the generated protocol.
  final TypeDefinition type;

  /// Whether the class passed validation and can be registered.
  final bool isValid;

  _CachedRetryPolicy({
    required this.type,
    required this.isValid,
  });
}

/// Analyzes dart files for [FutureCall]s.
///
/// The caller is responsible for calling [StatefulAnalyzer.validateAll] and
/// passing the validated models to [analyze] or [analyzeModels].
class FutureCallsAnalyzer {
  final AnalysisContextCollection collection;

  final String absoluteIncludedPaths;

  /// Absolute paths of the directories this project generates code into.
  ///
  /// The generated directories sit inside the analyzed `lib/`, so without
  /// this the analyzer treats every generated model file as a candidate
  /// future call file and resolves it looking for a class the generator never
  /// writes there.
  final Set<String> generatedDirPaths;

  List<SerializableModelDefinition>? _cachedAnalyzedModels;

  /// The names of the extra classes in the protocol, which future call retry
  /// policies must not share.
  final Set<String> _extraClassNames;

  /// Create a new [FutureCallsAnalyzer] for [directory].
  ///
  /// When [collection] is provided it is reused (e.g. shared with
  /// [EndpointsAnalyzer]). Otherwise a new one is created internally.
  ///
  /// Pass [generatedDirPaths] so generated output is not scanned for future
  /// calls.
  ///
  /// Pass the configured [extraClasses] so that future call retry policies
  /// with the same name as one of them are reported.
  FutureCallsAnalyzer({
    required Directory directory,
    AnalysisContextCollection? collection,
    Set<String>? generatedDirPaths,
    List<TypeDefinition>? extraClasses,
  }) : collection = collection ?? createAnalysisContextCollection(directory),
       generatedDirPaths = generatedDirPaths ?? const {},
       _extraClassNames = {
         for (var extraClass in extraClasses ?? const <TypeDefinition>[])
           extraClass.className,
       },
       absoluteIncludedPaths = directory.absolute.path;

  /// Cached per-file analysis results for future call files.
  /// Uses [SplayTreeMap] to keep keys sorted, ensuring deterministic
  /// iteration order when collecting definitions across runs.
  final _fileCache = SplayTreeMap<String, _CachedFutureCallFileResult>();

  /// The files the last analysis found future call declarations in, spelled as the
  /// analysis context spells them.
  ///
  /// The cache only holds files the analysis took up as future call files, so a
  /// file missing here declared no future call when it was last examined.
  Iterable<String> get futureCallFiles => _fileCache.keys;

  /// Future call retry policy classes found in the last analysis, by file.
  final _retryPolicyCache = SplayTreeMap<String, List<_CachedRetryPolicy>>();

  /// The future call retry policy classes found in the last analysis that
  /// passed validation.
  ///
  /// These have to be registered in the server protocol so that the policies
  /// can be saved with a future call and loaded again.
  List<TypeDefinition> get retryPolicies => [
    for (var cached in _retryPolicyCache.values.expand((e) => e))
      if (cached.isValid) cached.type,
  ];

  /// Identifies the future call retry policy classes found in the last
  /// analysis, whether or not they passed validation.
  String get _retryPolicySignature => [
    for (var cached in _retryPolicyCache.values.expand((e) => e))
      '${cached.type.url}:${cached.type.className}',
  ].join('\n');

  /// The future call files currently cached with errors.
  Set<String> get _erroredFiles => {
    for (final entry in _fileCache.entries)
      if (entry.value.hadErrors) entry.key,
  };

  /// The hash of each future call file's definitions as the last
  /// [updateFileContexts] found them. Before the first one, as the first
  /// [analyze] found them, and `null` before that.
  Map<String, int>? _definitionHashesAtLastUpdate;

  /// The hash of the definitions currently cached for each file.
  Map<String, int> get _definitionHashes => {
    for (final entry in _fileCache.entries)
      entry.key: entry.value.definitionsHash,
  };

  /// Inform the analyzer that the provided [filePaths] have been updated.
  ///
  /// Refreshes the Dart analysis context for the changed files and returns
  /// `true` if the analysis recognizes any of them as (or as having been)
  /// future call files, or if the change altered what a future call in another
  /// file declares, meaning code generation should run.
  Future<bool> updateFileContexts(Set<String> filePaths) async {
    // Only consider files within the tracked directory.
    final relevantPaths = filePaths
        .where((f) => p.isWithin(absoluteIncludedPaths, p.absolute(f)))
        .toSet();

    final erroredFilesBefore = _erroredFiles;
    final keysBefore = _fileCache.keys.toSet();
    final retryPoliciesBefore = _retryPolicySignature;
    // Read before analyzing, which records the hashes itself when there are
    // none yet.
    final previousHashes = _definitionHashesAtLastUpdate;

    await analyze(
      collector: CodeGenerationCollector(),
      changedFiles: relevantPaths,
    );

    final erroredFilesAfter = _erroredFiles;
    final keysAfter = _fileCache.keys.toSet();

    // Retry policy classes are registered in the protocol, so adding, removing
    // or renaming one means the protocol has to be generated again.
    if (_retryPolicySignature != retryPoliciesBefore) {
      return true;
    }

    // What a future call declares can change without its file changing, through
    // an alias, a base class or a type in a file it imports. Every cached file
    // was just analyzed again and hashed its definitions while it was parsed,
    // so the hashes show it. They are compared with the ones of the previous
    // update, which were parsed the same way, rather than with what generation
    // left in the cache, which validates against models and can differ from
    // this without anything having changed.
    final definitionHashes = _definitionHashes;
    _definitionHashesAtLastUpdate = definitionHashes;
    if (previousHashes != null &&
        definitionHashes.entries.any(
          (entry) => previousHashes[entry.key] != entry.value,
        )) {
      return true;
    }

    // Regenerate when the set of future call files changed, or when any
    // file's error state flipped (an error appearing or clearing changes the
    // parsed definitions). A persistently broken - or not yet fully analyzed
    // (see `hadErrors: !hasModels`) - file, by contrast, must not turn every
    // unrelated change - such as watcher echoes of freshly generated files -
    // into another generation, or generation loops forever while an error
    // exists anywhere in the project.
    if (keysBefore.length != keysAfter.length ||
        keysAfter.difference(keysBefore).isNotEmpty ||
        erroredFilesBefore.length != erroredFilesAfter.length ||
        erroredFilesAfter.difference(erroredFilesBefore).isNotEmpty) {
      return true;
    }

    // The cache only holds files the analysis recognized as future call files.
    // Canonicalized once into a set rather than compared pairwise, so this
    // stays linear in the number of changed files as the project's future
    // call count grows.
    final cachedFutureCallPaths = {
      for (final key in keysAfter) p.canonicalize(key),
    };
    return relevantPaths.any(
      (path) => cachedFutureCallPaths.contains(p.canonicalize(path)),
    );
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

    changedFiles = await refreshAnalysisContext(collection, changedFiles ?? {});

    // On the first run, mark every Dart file as changed so the single
    // code path handles both first and subsequent runs.
    if (_fileCache.isEmpty) {
      changedFiles.addAll(_allAnalyzedDartFiles);
    }

    // Analyze changed files + previously errored future call files
    // (fixing a dependency elsewhere might unblock them).
    //
    // Generated output is excluded here rather than from [changedFiles], which
    // the analysis context above still needs in full: a regenerated model
    // changes what the future calls importing it resolve to, but declares no
    // future call of its own.
    //
    // Files with retry policy classes are analyzed again too: whether a class
    // is a retry policy, and whether its name clashes, can change through
    // other files.
    final filesToAnalyze = <String>{
      ...changedFiles.where(
        (path) => !isWithinAnyDirectory(path, generatedDirPaths),
      ),
      ..._fileCache.keys,
      ..._retryPolicyCache.keys,
    };

    // Remove deleted files from cache.
    for (var path in filesToAnalyze) {
      if (!File(path).existsSync()) {
        _fileCache.remove(path);
        _retryPolicyCache.remove(path);
      }
    }

    // Resolve only the files that need re-analysis.
    List<(ResolvedLibraryResult, String)> validLibraries = [];
    List<String> erroredFiles = [];
    List<(ResolvedLibraryResult, String)> retryPolicyLibraries = [];

    for (var path in filesToAnalyze) {
      if (!path.endsWith('.dart') || path.endsWith('_test.dart')) continue;
      if (isUnrenderedTemplatePath(path)) continue;
      if (!File(path).existsSync()) continue;

      var library = await _resolveLibrary(path);
      if (library == null) continue;

      if (_getRetryPolicyClasses(library).isEmpty) {
        _retryPolicyCache.remove(path);
      } else {
        retryPolicyLibraries.add((library, path));
      }

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

    // Paths that were just re-analyzed, so the cached result for them is
    // superseded by the fresh one collected below. Materialized as a set
    // because it is consulted once per cached file.
    final reanalyzedPaths = {for (var (_, path) in validLibraries) path};

    // Build future call class map from ALL files for duplicate detection.
    // Errored files have empty definitions so they naturally don't contribute,
    // matching the original behavior.
    Map<String, int> futureCallClassMap = {};
    for (var entry in _fileCache.entries) {
      if (reanalyzedPaths.contains(entry.key)) continue;
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

    _analyzeRetryPolicies(
      retryPolicyLibraries,
      collector: collector,
      validate: hasModels,
    );

    // Phase 4: Collect all future call definitions from cache.
    // _fileCache is a SplayTreeMap so iteration is in sorted key order.
    var futureCallDefs = <FutureCallDefinition>[];
    for (var result in _fileCache.values) {
      futureCallDefs.addAll(result.definitions);
    }
    futureCallDefs.removeWhere((e) => e.filePath.startsWith('package:'));

    // An update compares the definitions with the ones of the update before
    // it. Analyzers that generate without having been updated have no such
    // update, so the first analysis stands in for it. Otherwise the first
    // change after that generation could alter what a future call in another
    // file declares without being noticed.
    _definitionHashesAtLastUpdate ??= _definitionHashes;

    return futureCallDefs;
  }

  /// Returns all Dart file paths known to the analysis context, sorted and
  /// excluding test files and this project's own generated output.
  Iterable<String> get _allAnalyzedDartFiles sync* {
    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      yield* analyzedFiles
          .where((path) => !isWithinAnyDirectory(path, generatedDirPaths))
          .where((path) => path.endsWith('.dart'))
          .where((path) => !path.endsWith('_test.dart'))
          .where((path) => !isUnrenderedTemplatePath(path));
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

  /// Caches the future call retry policy classes of [libraries], which are all
  /// the files with retry policy classes, and reports the ones that can't be
  /// registered in the protocol.
  ///
  /// When [validate] is `false` the classes are only recorded. Validation
  /// needs the models, to report retry policies that share a name with one.
  void _analyzeRetryPolicies(
    List<(ResolvedLibraryResult, String)> libraries, {
    required CodeAnalysisCollector collector,
    required bool validate,
  }) {
    var policyNameCounts = <String, int>{};
    for (var (library, _) in libraries) {
      for (var element in _getRetryPolicyClasses(library)) {
        policyNameCounts.update(
          element.displayName,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }

    var takenClassNames = {
      ..._extraClassNames,
      for (var model
          in _cachedAnalyzedModels ?? <SerializableModelDefinition>[])
        model.className,
      for (var entry in policyNameCounts.entries)
        if (entry.value > 1) entry.key,
    };

    for (var (library, path) in libraries) {
      _retryPolicyCache[path] = [
        for (var element in _getRetryPolicyClasses(library))
          _CachedRetryPolicy(
            type: FutureCallRetryPolicyAnalyzer.typeDefinition(element),
            isValid:
                !validate ||
                _isValidRetryPolicy(
                  element,
                  takenClassNames,
                  collector,
                ),
          ),
      ];
    }
  }

  bool _isValidRetryPolicy(
    ClassElement element,
    Set<String> takenClassNames,
    CodeAnalysisCollector collector,
  ) {
    var errors = FutureCallRetryPolicyAnalyzer.validate(
      element,
      takenClassNames,
    );
    collector.addErrors(errors);
    return errors.isEmpty;
  }

  Iterable<ClassElement> _getRetryPolicyClasses(ResolvedLibraryResult library) {
    return library.element.classes.where(
      FutureCallRetryPolicyAnalyzer.isRetryPolicyClass,
    );
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
