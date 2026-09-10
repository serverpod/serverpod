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

  /// Deletes the entity if it exists, retrying until [timeout], never throwing.
  ///
  /// Windows briefly keeps an exited process's handles, which block deletion.
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
  /// Writes [contents] to a temp file and renames it over this one.
  ///
  /// Unlike [writeAsString], readers never see it empty or part-written.
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
