import 'dart:collection';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';

import '../../../analyzer.dart';
import 'custom_class_analyzers/custom_class_method_analyzer.dart';

/// Cached analysis result for a single custom class file.
class _CustomClassFileResult {
  /// Maps ClassName -> its analyzed serialization type.
  final Map<String, TypeDefinition?> serializationTypes;

  final bool hadErrors;

  _CustomClassFileResult({
    required this.serializationTypes,
    required this.hadErrors,
  });
}

/// Analyzes custom classes registered in [extraClasses] to determine their
/// underlying serialization types.
class CustomClassAnalyzer {
  final AnalysisContextCollection collection;

  CustomClassAnalyzer(
    Directory directory, {
    List<String>? customClassPackageRoots,
    AnalysisContextCollection? collection,
  }) : collection =
           collection ??
           createAnalysisContextCollection(
             directory,
             additionalPaths: customClassPackageRoots,
           );

  /// Cached analysis results keyed by absolute file path.
  final _fileCache = SplayTreeMap<String, _CustomClassFileResult>();

  /// Updates the analyzer context for the provided [affectedPaths].
  /// Returns [true] if any meaningful change was detected in an extra class.
  Future<bool> updateFileContexts(
    Set<String> affectedPaths,
    List<TypeDefinition> extraClasses,
  ) async {
    var extraPathsSet = extraClasses
        .map((e) => e.sourcePath)
        .whereType<String>()
        .map(p.canonicalize)
        .toSet();
    var relevantPaths = affectedPaths.map(p.canonicalize).toSet();

    final errorsBefore = _fileCache.values.any((r) => r.hadErrors);
    final keysBefore = _fileCache.keys.toSet();

    await analyze(
      collector: CodeGenerationCollector(),
      extraClasses: extraClasses,
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
      if (_fileCache.containsKey(path) || extraPathsSet.contains(path)) {
        return true;
      }
    }

    return false;
  }

  /// Analyzes the provided [extraClasses] and returns a map of their
  /// underlying serialization types keyed by class name.
  Future<Map<String, TypeDefinition?>> analyze({
    required CodeAnalysisCollector collector,
    required List<TypeDefinition> extraClasses,
    Set<String>? changedFiles,
  }) async {
    changedFiles ??= {};
    await refreshAnalysisContext(collection, changedFiles);

    //Group extra classes by their source path.
    var classesByPath = <String, List<TypeDefinition>>{};
    for (var extraClass in extraClasses) {
      if (extraClass.sourcePath != null) {
        classesByPath
            .putIfAbsent(p.canonicalize(extraClass.sourcePath!), () => [])
            .add(extraClass);
      }
    }

    // On the first run, mark every extra class file as dirty
    if (_fileCache.isEmpty) {
      changedFiles.addAll(classesByPath.keys);
    }

    final filesToAnalyze = <String>{
      ...changedFiles.where((path) => classesByPath.containsKey(path)),
      ..._fileCache.keys,
    };

    for (var path in filesToAnalyze) {
      if (!File(path).existsSync()) {
        _fileCache.remove(path);
        continue;
      }

      var classesInFile = classesByPath[path];
      if (classesInFile == null || classesInFile.isEmpty) {
        _fileCache.remove(path);
        continue;
      }

      var library = await _resolveLibrary(path);
      if (library == null) {
        _fileCache.remove(path);
        continue;
      }

      var serializationTypes = <String, TypeDefinition?>{};
      var dartErrors = await _getErrorsForFile(library.session, path);
      if (dartErrors.isNotEmpty) {
        collector.addError(
          SourceSpanSeverityException(
            'Extra class analysis skipped due to invalid Dart syntax. Please '
            'review and correct the syntax errors.'
            '\nFile: $path'
            '\n${dartErrors.join('\n')}',
            null,
            severity: SourceSpanSeverity.error,
          ),
        );

        _fileCache[path] = _CustomClassFileResult(
          serializationTypes: {},
          hadErrors: true,
        );
        continue;
      }

      for (var extraClass in classesInFile) {
        var validationErrors = _validateCustomClass(
          extraClass,
          library.element,
        );
        collector.addErrors(validationErrors);

        if (CodeAnalysisCollector.containsSevereErrors(validationErrors)) {
          continue;
        }

        var element = library.element.exportNamespace.get2(
          extraClass.className,
        );

        if (element is ClassElement) {
          var toJson = element.lookUpMethod(
            name: 'toJson',
            library: library.element,
          );
          if (toJson != null) {
            serializationTypes[extraClass.className] =
                TypeDefinition.fromDartType(toJson.returnType);
          }
        }
      }

      _fileCache[path] = _CustomClassFileResult(
        serializationTypes: serializationTypes,
        hadErrors: false,
      );
    }

    var allSerializationTypes = <String, TypeDefinition?>{};
    for (var result in _fileCache.values) {
      allSerializationTypes.addAll(result.serializationTypes);
    }

    return allSerializationTypes;
  }

  /// Applies the analyzed [serializationTypes] to the provided [extraClasses].
  static void applyResults(
    List<TypeDefinition> extraClasses,
    Map<String, TypeDefinition?> serializationTypes,
  ) {
    for (var extraClass in extraClasses) {
      extraClass.customClassSerializationType =
          serializationTypes[extraClass.className];
    }
  }

  /// Resolves a single file to a [ResolvedLibraryResult].
  Future<ResolvedLibraryResult?> _resolveLibrary(String filePath) async {
    final canonicalFilePath = p.canonicalize(filePath);
    final context = tryContextFor(collection, canonicalFilePath);
    if (context == null) return null;

    final result = await context.currentSession.getResolvedLibrary(
      canonicalFilePath,
    );

    if (result is ResolvedLibraryResult) {
      return result;
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

  List<SourceSpanSeverityException> _validateCustomClass(
    TypeDefinition extraClass,
    LibraryElement library,
  ) {
    final element = library.exportNamespace.get2(extraClass.className);

    if (element is! ClassElement) {
      return [
        SourceSpanSeverityException(
          'Custom class "${extraClass.className}" was not found in the library "${extraClass.sourcePath}".',
          null,
          severity: SourceSpanSeverity.error,
        ),
      ];
    }

    return CustomClassMethodAnalyzer.validate(
      element,
      extraClass,
      library,
    );
  }
}
