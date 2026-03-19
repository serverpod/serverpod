import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_parameter_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/model_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/util/sdk_path.dart';
import 'package:serverpod_cli/src/util/string_manipulation.dart';

/// Analyzes dart files for [FutureCall]s.
///
/// The caller is responsible for calling [StatefulAnalyzer.validateAll] and
/// passing the validated models to [analyze] or [analyzeModels].
class FutureCallsAnalyzer {
  final AnalysisContextCollection collection;

  final String absoluteIncludedPaths;

  final List<SerializableModelDefinition> _cachedAnalyzedModels = [];

  /// Create a new [FutureCallsAnalyzer], containing a
  /// [AnalysisContextCollection] that analyzes all dart files in the
  /// provided [directory].
  FutureCallsAnalyzer({
    required Directory directory,
  }) : collection = AnalysisContextCollection(
         includedPaths: [directory.absolute.path],
         resourceProvider: PhysicalResourceProvider.INSTANCE,
         sdkPath: getSdkPath(),
       ),
       absoluteIncludedPaths = directory.absolute.path;

  /// Files that contained future call classes in the last full [analyze] run.
  final Set<String> _knownFutureCallFiles = {};

  /// Files that contained future call classes but had analysis errors.
  /// When this set is non-empty, any file change is treated as potentially
  /// relevant because fixing a dependency might unblock the errored file.
  final Set<String> _erroredFutureCallFiles = {};

  /// Inform the analyzer that the provided [filePaths] have been updated.
  ///
  /// Refreshes the Dart analysis context for the changed files and returns
  /// `true` if any of them are (or were) future call files, meaning code
  /// generation should run. The actual full analysis is deferred to the
  /// next [analyze] call.
  Future<bool> updateFileContexts(Set<String> filePaths) async {
    await _refreshContextForFiles(filePaths);

    // If there are errored future call files, any file change might fix them.
    if (_erroredFutureCallFiles.isNotEmpty) return true;

    for (var path in filePaths) {
      // File was previously known to contain future calls.
      if (_knownFutureCallFiles.contains(path)) return true;
      // File now appears to contain future calls.
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
    _cachedAnalyzedModels
      ..clear()
      ..addAll(analyzedModels);

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

  /// Analyze all files in the [AnalysisContextCollection].
  ///
  /// [analyzedModels] are the validated models from [StatefulAnalyzer.validateAll].
  /// When provided, they are used for parameter validation and cached for
  /// subsequent calls (e.g. [updateFileContexts]). When not provided, the
  /// cached models from a previous call are used.
  ///
  /// [changedFiles] is an optional list of files that should have their context
  /// refreshed before analysis. This is useful when only a subset of files have
  /// changed since [updateFileContexts] was last called.
  Future<List<FutureCallDefinition>> analyze({
    required CodeAnalysisCollector collector,
    required List<SerializableModelDefinition> analyzedModels,
    Set<String>? changedFiles,
  }) async {
    _cachedAnalyzedModels
      ..clear()
      ..addAll(analyzedModels);
    await _refreshContextForFiles(changedFiles);

    var futureCallDefs = <FutureCallDefinition>[];

    List<(ResolvedLibraryResult, String)> validLibraries = [];
    List<String> erroredFiles = [];
    Map<String, int> futureCallClassMap = {};

    final templateRegistry = DartDocTemplateRegistry();

    await for (var (library, filePath) in _libraries) {
      var futureCallClasses = _getFutureCallClasses(library);
      if (futureCallClasses.isEmpty) continue;

      var maybeDartErrors = await _getErrorsForFile(library.session, filePath);
      if (maybeDartErrors.isNotEmpty) {
        erroredFiles.add(filePath);
        collector.addError(
          SourceSpanSeverityException(
            'FutureCall analysis skipped due to invalid Dart syntax. Please '
            'review and correct the syntax errors.'
            '\nFile: $filePath',
            null,
            severity: SourceSpanSeverity.error,
          ),
        );

        continue;
      }

      for (var futureCallClass in futureCallClasses) {
        var className = futureCallClass.name!;
        futureCallClassMap.update(
          className,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      validLibraries.add((library, filePath));
    }

    var duplicateFutureCallClasses = futureCallClassMap.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toSet();

    for (var (library, filePath) in validLibraries) {
      var severityExceptions = _validateLibrary(
        library,
        filePath,
        duplicateFutureCallClasses,
        analyzedModels,
      );
      collector.addErrors(severityExceptions.values.expand((e) => e).toList());

      var failingExceptions = _filterNoFailExceptions(severityExceptions);

      futureCallDefs.addAll(
        _parseLibrary(
          library,
          filePath,
          failingExceptions,
          templateRegistry: templateRegistry,
        ),
      );
    }

    // After parsing all future calls, we must remove all that are not part of
    // this package to avoid generating them as well.
    futureCallDefs.removeWhere((e) => e.filePath.startsWith('package:'));

    // Track which files contain future calls for fast incremental checks.
    _knownFutureCallFiles
      ..clear()
      ..addAll(validLibraries.map((e) => e.$2));
    _erroredFutureCallFiles
      ..clear()
      ..addAll(erroredFiles);

    return futureCallDefs;
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

  bool _isFutureCallFile(File file) {
    if (!file.absolute.path.startsWith(absoluteIncludedPaths)) return false;
    if (!file.path.endsWith('.dart')) return false;
    if (!file.existsSync()) return false;

    var contents = file.readAsStringSync();
    if (!contents.contains('extends FutureCall')) return false;

    return true;
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
