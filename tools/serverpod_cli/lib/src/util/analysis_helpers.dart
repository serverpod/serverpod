import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/file_system.dart' show ResourceProvider;
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_shared/process_io.dart';

/// Notifies the [collection] that the given [changedFiles] have been created or
/// modified on disk, so subsequent analysis calls resolve updated content.
///
/// Returns [changedFiles] spelled as the context spells them, so a path that
/// differs only in case (the file watcher lowercases paths on Windows) is not
/// treated as a second file.
Future<Set<String>> refreshAnalysisContext(
  AnalysisContextCollection collection,
  Iterable<String> changedFiles,
) async {
  final context = collection.contexts.single; // current invariant
  // Analysis passes that have nothing to invalidate still call this; indexing
  // the context's files for them would be the whole cost of the call.
  if (changedFiles.isEmpty) {
    await context.applyPendingFileChanges();
    return {};
  }

  // Indexed by canonical path instead of searched linearly: this runs for
  // every analysis pass, and a full generate hands it every source file, so a
  // pairwise comparison against every analyzed file is quadratic.
  final knownByCanonicalPath = <String, String>{};
  for (final path in context.contextRoot.analyzedFiles()) {
    knownByCanonicalPath.putIfAbsent(p.canonicalize(path), () => path);
  }
  final resolved = {
    for (final changedFile in changedFiles)
      knownByCanonicalPath[p.canonicalize(changedFile)] ??
          p.normalize(File(changedFile).absolute.path),
  };
  for (final path in resolved) {
    context.changeFile(path);
  }
  await context.applyPendingFileChanges();
  return resolved;
}

/// Whether [path] sits inside any of [directories].
///
/// Used to keep this project's own generated output out of the sets of files
/// scanned for endpoint and future call declarations. The generated code still
/// has to reach the analysis context, so that endpoints referencing it resolve
/// against current content; it just never declares what those scans look for.
bool isWithinAnyDirectory(String path, Set<String> directories) {
  if (directories.isEmpty) return false;
  final absolutePath = p.absolute(path);
  return directories.any((directory) => p.isWithin(directory, absolutePath));
}

/// Creates an [AnalysisContextCollection] for the given [directory].
///
/// Pass [resourceProvider] to back the collection with something other than
/// the physical file system (e.g. an overlay provider that shadows files
/// with in-memory content).
AnalysisContextCollection createAnalysisContextCollection(
  Directory directory, {
  ResourceProvider? resourceProvider,
}) {
  return AnalysisContextCollection(
    includedPaths: [directory.absolute.path],
    resourceProvider: resourceProvider ?? PhysicalResourceProvider.INSTANCE,
    sdkPath: getSdkPath(),
  );
}
