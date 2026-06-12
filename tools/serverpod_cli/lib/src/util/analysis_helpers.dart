import 'dart:io';

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
  final context = collection.contexts.single; // current invariant
  for (final changedFile in changedFiles) {
    context.changeFile(p.normalize(File(changedFile).absolute.path));
  }
  await context.applyPendingFileChanges();
}

/// Creates an [AnalysisContextCollection] for the given [directory].
AnalysisContextCollection createAnalysisContextCollection(
  Directory directory,
) {
  return AnalysisContextCollection(
    includedPaths: [directory.absolute.path],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
    sdkPath: getSdkPath(),
  );
}
