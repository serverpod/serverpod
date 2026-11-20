import 'dart:io';

import 'package:path/path.dart' as p;

/// Copies a directory tree, excluding entries with names in [ignoreFileNames].
void copyDirectory(
  Directory source,
  Directory destination, {
  Set<String> ignoreFileNames = const {},
}) {
  destination.createSync(recursive: true);

  for (final entry in source.listSync(recursive: true)) {
    final relativePath = p.relative(entry.path, from: source.path);
    if (p.split(relativePath).any(ignoreFileNames.contains)) continue;

    final target = p.join(destination.path, relativePath);
    if (entry is Directory) {
      Directory(target).createSync(recursive: true);
    } else if (entry is File) {
      entry.copySync(target);
    }
  }
}
