import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;

import 'sdk_path.dart';

/// Notifies the [collection] that the given [files] have been created or
/// modified on disk, so subsequent analysis calls resolve updated content.
Future<void> refreshAnalysisContext(
  AnalysisContextCollection collection,
  Iterable<String> changedFiles,
) async {
  for (final changedFile in changedFiles) {
    var absolutePath = p.normalize(File(changedFile).absolute.path);
    final context = findContextFor(collection, absolutePath);
    if (context != null) {
      context.changeFile(absolutePath);
    }
  }
  for (final context in collection.contexts) {
    await context.applyPendingFileChanges();
  }
}

/// Creates an [AnalysisContextCollection] for the given [directory].
AnalysisContextCollection createAnalysisContextCollection(
  Directory directory, {
  List<String>? additionalPaths,
}) {
  var includedPaths = <String>[
    directory.absolute.path,
    ...?additionalPaths,
  ];

  return AnalysisContextCollection(
    includedPaths: includedPaths.map((path) => p.normalize(path)).toList(),
    resourceProvider: PhysicalResourceProvider.INSTANCE,
    sdkPath: getSdkPath(),
  );
}

/// Returns the [AnalysisContext] containing [path], or `null` if [path] is
/// not included in this collection.
AnalysisContext? findContextFor(
  AnalysisContextCollection collection,
  String path,
) {
  final absolutePath = p.normalize(p.absolute(path));

  for (final context in collection.contexts) {
    final contextRoot = p.normalize(context.contextRoot.root.path);
    if (p.isWithin(contextRoot, absolutePath) ||
        p.equals(contextRoot, absolutePath)) {
      return context;
    }
  }
  return null;
}
