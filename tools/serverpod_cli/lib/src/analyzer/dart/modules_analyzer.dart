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
import 'package:serverpod_cli/src/analyzer/dart/module_analyzers/module_class_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';

/// Cached analysis result for a single module file.
class _CachedModuleFileResult {
  final List<ModuleDefinition> definitions;
  final bool hadErrors;

  _CachedModuleFileResult({
    required this.definitions,
    required this.hadErrors,
  });
}

/// Analyzes dart files for [Module] startup hook classes.
class ModulesAnalyzer {
  final AnalysisContextCollection collection;

  final String absoluteIncludedPaths;

  /// Create a new [ModulesAnalyzer] for [directory].
  ///
  /// When [collection] is provided it is reused (e.g. shared with
  /// [EndpointsAnalyzer]). Otherwise a new one is created internally.
  ModulesAnalyzer({
    required Directory directory,
    AnalysisContextCollection? collection,
  }) : collection = collection ?? createAnalysisContextCollection(directory),
       absoluteIncludedPaths = directory.absolute.path;

  /// Cached per-file analysis results for module files.
  /// Uses [SplayTreeMap] to keep keys sorted, ensuring deterministic
  /// iteration order when collecting definitions across runs.
  final _fileCache = SplayTreeMap<String, _CachedModuleFileResult>();

  /// The module files currently cached with errors.
  Set<String> get _erroredFiles => {
    for (final entry in _fileCache.entries)
      if (entry.value.hadErrors) entry.key,
  };

  /// Inform the analyzer that the provided [filePaths] have been updated.
  ///
  /// Refreshes the Dart analysis context for the changed files and returns
  /// `true` if any of them are (or were) module files, meaning code
  /// generation should run.
  Future<bool> updateFileContexts(Set<String> filePaths) async {
    final relevantPaths = filePaths
        .where((f) => p.isWithin(absoluteIncludedPaths, p.absolute(f)))
        .toSet();

    final erroredFilesBefore = _erroredFiles;
    final keysBefore = _fileCache.keys.toSet();

    await analyze(
      collector: CodeGenerationCollector(),
      changedFiles: relevantPaths,
    );

    final erroredFilesAfter = _erroredFiles;
    final keysAfter = _fileCache.keys.toSet();

    if (keysBefore.length != keysAfter.length ||
        keysAfter.difference(keysBefore).isNotEmpty ||
        erroredFilesBefore.length != erroredFilesAfter.length ||
        erroredFilesAfter.difference(erroredFilesBefore).isNotEmpty) {
      return true;
    }

    for (final path in relevantPaths) {
      if (!path.endsWith('.dart') || path.endsWith('_test.dart')) continue;
      if (_fileCache.containsKey(path)) return true;
      if (_isModuleFile(File(path))) return true;
    }

    return false;
  }

  /// Analyze files in the [AnalysisContextCollection].
  ///
  /// On the first call, analyzes every Dart file. On subsequent calls, only
  /// re-analyzes files listed in [changedFiles], reusing cached results for
  /// unchanged files.
  Future<List<ModuleDefinition>> analyze({
    required CodeAnalysisCollector collector,
    Set<String>? changedFiles,
  }) async {
    changedFiles ??= {};
    await refreshAnalysisContext(collection, changedFiles);

    if (_fileCache.isEmpty) {
      changedFiles.addAll(_allAnalyzedDartFiles);
    }

    final filesToAnalyze = <String>{
      ...changedFiles,
      ..._fileCache.keys,
    };

    for (var path in filesToAnalyze) {
      if (!File(path).existsSync()) {
        _fileCache.remove(path);
      }
    }

    List<(ResolvedLibraryResult, String)> validLibraries = [];

    for (var path in filesToAnalyze) {
      if (!path.endsWith('.dart') || path.endsWith('_test.dart')) continue;
      if (!File(path).existsSync()) continue;

      var library = await _resolveLibrary(path);
      if (library == null) continue;

      var moduleClasses = _getModuleClasses(library);
      if (moduleClasses.isEmpty) {
        _fileCache.remove(path);
        continue;
      }

      var maybeDartErrors = await _getErrorsForFile(library.session, path);
      if (maybeDartErrors.isNotEmpty) {
        collector.addError(
          SourceSpanSeverityException(
            'Module analysis skipped due to invalid Dart syntax. Please '
            'review and correct the syntax errors.'
            '\nFile: $path'
            '\n${maybeDartErrors.join('\n')}',
            null,
            severity: SourceSpanSeverity.error,
          ),
        );

        _fileCache[path] = _CachedModuleFileResult(
          definitions: [],
          hadErrors: true,
        );
        continue;
      }

      validLibraries.add((library, path));
    }

    // Count concrete Module classes that are default-constructable for the
    // at-most-one cardinality rule.
    var concreteCount = 0;
    for (var entry in _fileCache.entries) {
      if (validLibraries.any((lib) => lib.$2 == entry.key)) continue;
      for (var def in entry.value.definitions) {
        if (!def.isAbstract && !def.filePath.startsWith('package:')) {
          concreteCount++;
        }
      }
    }
    for (var (library, _) in validLibraries) {
      for (var cls in _getModuleClasses(library)) {
        if (!cls.isAbstract &&
            ModuleClassAnalyzer.hasPublicDefaultConstructor(cls)) {
          concreteCount++;
        }
      }
    }
    final exceedsCardinality = concreteCount > 1;

    for (var (library, filePath) in validLibraries) {
      var failingExceptions = <String, List<SourceSpanSeverityException>>{};

      var severityExceptions = _validateLibrary(
        library,
        filePath,
        exceedsCardinality: exceedsCardinality,
      );
      collector.addErrors(severityExceptions.values.expand((e) => e).toList());
      failingExceptions = _filterNoFailExceptions(severityExceptions);

      var defs = _parseLibrary(library, filePath, failingExceptions);

      _fileCache[filePath] = _CachedModuleFileResult(
        definitions: defs,
        hadErrors: false,
      );
    }

    var moduleDefs = <ModuleDefinition>[];
    for (var result in _fileCache.values) {
      moduleDefs.addAll(result.definitions);
    }
    moduleDefs.removeWhere((e) => e.filePath.startsWith('package:'));

    return moduleDefs;
  }

  /// Returns the single constructable concrete [ModuleDefinition], or null.
  ///
  /// Abstract definitions are ignored. Callers should only use this when
  /// analysis reported no severe cardinality / constructability errors.
  static ModuleDefinition? selectPackageModule(
    List<ModuleDefinition> definitions,
  ) {
    final concrete = definitions.where((d) => !d.isAbstract).toList();
    if (concrete.length != 1) return null;
    return concrete.single;
  }

  Iterable<String> get _allAnalyzedDartFiles sync* {
    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      yield* analyzedFiles
          .where((path) => path.endsWith('.dart'))
          .where((path) => !path.endsWith('_test.dart'));
    }
  }

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

  List<ModuleDefinition> _parseLibrary(
    ResolvedLibraryResult library,
    String filePath,
    Map<String, List<SourceSpanSeverityException>> validationErrors,
  ) {
    var moduleClasses = _getModuleClasses(library).where(
      (element) => !validationErrors.containsKey(
        ModuleClassAnalyzer.elementNamespace(element, filePath),
      ),
    );

    var moduleDefinitions = <ModuleDefinition>[];
    for (var classElement in moduleClasses) {
      // Skip classes that failed validation (e.g. not default-constructable).
      if (!classElement.isAbstract &&
          !ModuleClassAnalyzer.hasPublicDefaultConstructor(classElement)) {
        continue;
      }
      ModuleClassAnalyzer.parse(classElement, filePath, moduleDefinitions);
    }

    return moduleDefinitions;
  }

  bool _isModuleFile(File file) {
    if (!file.absolute.path.startsWith(absoluteIncludedPaths)) return false;
    if (!file.path.endsWith('.dart')) return false;
    if (!file.existsSync()) return false;
    return file.readAsStringSync().contains('extends Module');
  }

  Map<String, List<SourceSpanSeverityException>> _validateLibrary(
    ResolvedLibraryResult library,
    String filePath, {
    required bool exceedsCardinality,
  }) {
    var moduleClasses = _getModuleClasses(library);

    var validationErrors = <String, List<SourceSpanSeverityException>>{};
    for (var classElement in moduleClasses) {
      var errors = ModuleClassAnalyzer.validate(
        classElement,
        exceedsCardinality: exceedsCardinality,
      );

      if (errors.isNotEmpty) {
        validationErrors[ModuleClassAnalyzer.elementNamespace(
              classElement,
              filePath,
            )] =
            errors;
      }
    }

    return validationErrors;
  }

  Iterable<ClassElement> _getModuleClasses(ResolvedLibraryResult library) {
    return library.element.classes.where(ModuleClassAnalyzer.isModuleClass);
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
