import 'dart:io';

/// Convenience helpers added to every [FileSystemEntity] (files,
/// directories, links).
extension FileEx on FileSystemEntity {
  /// Deletes the file if it exists.
  Future<void> deleteIfExists({bool recursive = false}) async {
    try {
      if (await exists()) await delete(recursive: recursive);
    } on PathNotFoundException catch (_) {
      // File already deleted (race)
    }
  }
}

/// Convenience helpers added to [File].
extension FileWriteEx on File {
  /// Writes [contents], replacing the file in one step.
  ///
  /// A reader never sees the file part-written: the contents go to a sibling
  /// temp file that is then renamed over this one. [writeAsString] truncates
  /// first and writes after, and a reader in that gap sees an empty file.
  Future<void> writeAsStringAtomically(String contents) async {
    final tempFile = File(
      '$path.${DateTime.now().microsecondsSinceEpoch}.tmp',
    );
    await tempFile.writeAsString(contents, flush: true);
    try {
      await tempFile.rename(path);
    } catch (_) {
      await tempFile.deleteIfExists();
      rethrow;
    }
  }
}
