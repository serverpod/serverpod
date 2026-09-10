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
  final known = context.contextRoot.analyzedFiles().toList();
  final resolved = {
    for (final changedFile in changedFiles)
      known.firstWhere(
        (path) => p.equals(path, changedFile),
        orElse: () => p.normalize(File(changedFile).absolute.path),
      ),
  };
  for (final path in resolved) {
    context.changeFile(path);
  }
  await context.applyPendingFileChanges();
  return resolved;
}

/// Creates an [AnalysisContextCollection] for the given [directory].
///
/// Pass [resourceProvider] to back the collection with something other than
/// the physical file system (e.g. an overlay provider that shadows files
/// with in-memory content).
///
/// Pass [sdkPath] to analyse against a specific Dart SDK; defaults to the SDK
/// running this CLI. Callers that also compile the project must pass the
/// resolved SDK so analysis and compilation agree.
AnalysisContextCollection createAnalysisContextCollection(
  Directory directory, {
  ResourceProvider? resourceProvider,
  String? sdkPath,
}) {
  return AnalysisContextCollection(
    includedPaths: [directory.absolute.path],
    resourceProvider: resourceProvider ?? PhysicalResourceProvider.INSTANCE,
    sdkPath: sdkPath ?? getSdkPath(),
  );
}
