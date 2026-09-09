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

  /// Deletes the entity if it exists, and leaves it in place rather than
  /// throwing when it cannot be removed within [timeout].
  ///
  /// For scratch a caller owns and no longer needs: a temp directory a test
  /// laid out, a staging directory a build wrote into. Windows refuses to
  /// delete anything a process still holds open, and holds the handles of a
  /// process for a moment after it exits, so a caller that has just waited
  /// for a child out can still be too early. Retrying spans that moment; a
  /// path that survives it is worth less than the failure it would raise.
  Future<void> deleteBestEffort({
    bool recursive = false,
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (true) {
      try {
        return await deleteIfExists(recursive: recursive);
      } on FileSystemException {
        if (DateTime.now().isAfter(deadline)) return;
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
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
