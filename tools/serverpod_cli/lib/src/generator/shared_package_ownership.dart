import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/config.dart';

/// A shared package that is already owned by a project other than the project
/// attempting to generate it.
typedef SharedPackageOwnershipConflict = ({
  String packageName,
  String existingOwner,
  String attemptedOwner,
  String protocolPath,
});

final _moduleNamePattern = RegExp(
  r'''String\s+getModuleName\s*\(\s*\)\s*=>\s*['"]([^'"]+)['"]\s*;''',
);

/// Finds shared packages whose generated protocol records a different owner.
///
/// Ownership is checked before generation writes any files. A missing protocol
/// means the package has not been generated yet and can be claimed by the
/// current project.
Future<List<SharedPackageOwnershipConflict>>
findSharedPackageOwnershipConflicts(GeneratorConfig config) async {
  final conflicts = <SharedPackageOwnershipConflict>[];

  for (final entry in config.sharedModelsSourcePathsParts.entries) {
    final protocolPath = p.joinAll([
      ...config.serverPackageDirectoryPathParts,
      ...entry.value,
      'lib',
      ...config.generatedServeModelPackagePathParts,
      'protocol.dart',
    ]);
    final protocolFile = File(protocolPath);
    if (!await protocolFile.exists()) continue;

    final contents = await protocolFile.readAsString();
    final existingOwner = _moduleNamePattern.firstMatch(contents)?.group(1);
    if (existingOwner == null || existingOwner == config.name) continue;

    conflicts.add((
      packageName: entry.key,
      existingOwner: existingOwner,
      attemptedOwner: config.name,
      protocolPath: protocolPath,
    ));
  }

  return conflicts;
}
