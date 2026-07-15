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
    var absolutePath = p.canonicalize(File(changedFile).absolute.path);
    final context = tryContextFor(collection, absolutePath);
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
    includedPaths: includedPaths.map((path) => p.canonicalize(path)).toList(),
    resourceProvider: PhysicalResourceProvider.INSTANCE,
    sdkPath: getSdkPath(),
  );
}

/// Returns the [AnalysisContext] containing [path], or `null` if [path] is
/// not included in this collection.
AnalysisContext? tryContextFor(
  AnalysisContextCollection collection,
  String path,
) {
  try {
    return collection.contextFor(p.canonicalize(path));
  } on StateError {
    return null;
  }
}
