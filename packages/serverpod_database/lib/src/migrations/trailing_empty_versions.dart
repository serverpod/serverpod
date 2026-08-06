import 'dart:io';

import 'package:path/path.dart' as path;

/// Deletes the migration version directories at the end of [versions] that
/// contain no files or subdirectories, e.g. what is left behind when the
/// generated files of a migration are discarded.
///
/// Version directories are resolved as direct children of
/// [migrationsBaseDirectory], and the scan stops at the first trailing
/// directory that holds any entity. A version directory that still holds files
/// but is missing the required migration artifacts is left intact, so callers
/// keep reporting it as a corrupted migration.
///
/// [versions] is modified in place. Returns the removed versions in ascending
/// order, and reports them to [logWarning] if any was removed.
Future<List<String>> deleteTrailingEmptyMigrationVersionDirectories(
  List<String> versions, {
  required Directory migrationsBaseDirectory,
  void Function(String message)? logWarning,
}) async {
  var removed = <String>[];

  while (versions.isNotEmpty) {
    var versionDirectory = Directory(
      path.join(migrationsBaseDirectory.path, versions.last),
    );

    try {
      if (!await versionDirectory.list(followLinks: false).isEmpty) break;
      await versionDirectory.delete();
    } on FileSystemException catch (_) {
      // The directory is gone or cannot be deleted, e.g. because it is in use
      // by another process. Leave the remaining versions untouched.
      break;
    }

    removed.insert(0, versions.removeLast());
  }

  if (removed.isNotEmpty) {
    logWarning?.call(
      'Removed empty migration version '
      '${removed.length == 1 ? 'directory' : 'directories'} '
      'in "${migrationsBaseDirectory.path}": ${removed.join(', ')}.',
    );
  }

  return removed;
}
