import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/cache_analyzers/cache_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/util/analysis_helper.dart';

/// Analyzes dart files for Custom Caches.
class CacheAnalyzer {
  final AnalysisContextCollection collection;

  final String absoluteIncludedPaths;

  /// Create a new [CacheAnalyzer], containing a
  /// [AnalysisContextCollection] that analyzes all dart files in the
  /// provided [directory].
  CacheAnalyzer({
    required Directory directory,
  }) : collection = AnalysisContextCollection(
         includedPaths: [directory.absolute.path],
         resourceProvider: PhysicalResourceProvider.INSTANCE,
         sdkPath: findDartSdk(),
       ),
       absoluteIncludedPaths = directory.absolute.path;

  List<CacheDefinition> _cacheDefinitions = [];

  /// Inform the analyzer that the provided [filePaths] have been updated.
  ///
  /// This will trigger a re-analysis of the files and return true if the
  /// updated files should trigger a code generation.
  Future<bool> updateFileContexts(Set<String> filePaths) async {
    await _refreshContextForFiles(filePaths);

    var oldDefinitionsLength = _cacheDefinitions.length;
    await analyze();

    if (_cacheDefinitions.length != oldDefinitionsLength) {
      return true;
    }

    return filePaths.any((e) => _isCacheFile(File(e)));
  }

  /// Analyze all files in the [AnalysisContextCollection].
  ///
  /// [changedFiles] is an optional list of files that should have their context
  /// refreshed before analysis.
  Future<List<CacheDefinition>> analyze({
    CodeAnalysisCollector? collector,
    Set<String>? changedFiles,
  }) async {
    await _refreshContextForFiles(changedFiles);

    var cacheDefs = <CacheDefinition>[];

    await for (var (library, filePath) in _libraries) {
      var cacheClasses = _getCacheClasses(library);
      if (cacheClasses.isEmpty) continue;

      for (var classElement in cacheClasses) {
        CacheClassAnalyzer.parse(
          classElement,
          filePath,
          cacheDefs,
          collector: collector,
        );
      }
    }

    // Remove caches not part of this package (just in case)
    cacheDefs.removeWhere((e) => e.filePath.startsWith('package:'));

    _cacheDefinitions = cacheDefs;

    return cacheDefs;
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

  bool _isCacheFile(File file) {
    if (!file.absolute.path.startsWith(absoluteIncludedPaths)) return false;
    if (!file.path.endsWith('.dart')) return false;
    if (!file.existsSync()) return false;

    var contents = file.readAsStringSync();
    if (!contents.contains('extends Cache') &&
        !contents.contains('extends LocalCache') &&
        !contents.contains('extends DistributedCache')) {
      return false;
    }

    return true;
  }

  Stream<(ResolvedLibraryResult, String)> get _libraries async* {
    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      var analyzedDartFiles = analyzedFiles.where((path) {
        if (!path.endsWith('.dart')) return false;
        if (path.endsWith('_test.dart')) return false;
        if (p.basename(path).startsWith('test_')) return false;

        var pathParts = p.split(path);
        if (pathParts.contains('test')) return false;

        return true;
      });
      for (var filePath in analyzedDartFiles) {
        var library = await context.currentSession.getResolvedLibrary(filePath);
        if (library is ResolvedLibraryResult) {
          yield (library, filePath);
        }
      }
    }
  }

  Iterable<ClassElement> _getCacheClasses(ResolvedLibraryResult library) {
    return library.element.classes.where(
      CacheClassAnalyzer.isCacheClass,
    );
  }
}
