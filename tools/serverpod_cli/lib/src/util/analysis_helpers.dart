import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/file_system/file_system.dart' show ResourceProvider;
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;

import 'sdk_path.dart';

/// Notifies the [collection] that the given [files] have been created or
/// modified on disk, so subsequent analysis calls resolve updated content.
Future<void> refreshAnalysisContext(
  AnalysisContextCollection collection,
  Iterable<String> changedFiles,
) async {
  final context = collection.contexts.single; // current invariant
  for (final changedFile in changedFiles) {
    context.changeFile(p.normalize(File(changedFile).absolute.path));
  }
  await context.applyPendingFileChanges();
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
