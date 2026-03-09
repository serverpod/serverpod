import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
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

  /// Analyze all files in the [AnalysisContextCollection].
  ///
  /// [changedFiles] is an optional list of files that should have their context
  /// refreshed before analysis.
  Future<List<CacheDefinition>> analyze({
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
        );
      }
    }

    // Remove caches not part of this package (just in case)
    cacheDefs.removeWhere((e) => e.filePath.startsWith('package:'));

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

  Iterable<ClassElement> _getCacheClasses(ResolvedLibraryResult library) {
    return library.element.classes.where(
      CacheClassAnalyzer.isCacheClass,
    );
  }
}
